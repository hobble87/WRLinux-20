# WRLinux-20: Raspberry Pi 3B Wi-Fi access point layer

A custom BitBake layer (`meta-custom`) for **Wind River Linux LTS 20** that turns a **Raspberry Pi 3 Model B** into a Wi-Fi access point which shares an upstream public hotspot (BT Wi-Fi) with local devices over NAT.

Networking is done entirely with **systemd-networkd**; the legacy `ifupdown` / `dhcpcd` / `rsyslog` stack is removed from the image.

## Topology

```
┌──────────────┐  open SSID    ┌──────────────────────────┐   WPA2 "RPI-AP"  ┌────────────────────┐
│ BT Wi-Fi     │ ◀───────────▶ │ wlan0 (on-board)         │                  │ TV, phone, laptop  │
│ hotspot      │   DHCP client │   Raspberry Pi 3B        │ ◀──────────────▶ │ ...                │
└──────────────┘               │ wlan1 (USB) 192.168.1.1  │  DHCP server     └────────────────────┘
                               │ eth0        192.168.0.1  │  DHCP server (wired clients)
                               │ NAT: MASQUERADE -o wlan0 │
                               └──────────────────────────┘
```

## What the layer contains

All recipes live in `rpi3b/meta-custom/` (`LAYERSERIES_COMPAT = "hardknott wrl"`).

| Recipe / append | What it does |
|---|---|
| `systemd-conf/systemd_%.bbappend` | Enables `networkd` and `resolved` in systemd's PACKAGECONFIG |
| `systemd-conf/systemd-conf_%.bbappend` | Installs `.network` units: `08-wlan0` (upstream client), `08-wlan1` (AP, 192.168.1.1/24 + DHCP server), `04-eth` (192.168.0.1/24 + DHCP server) |
| `wpa_supplicant-conf/wpa-supplicant_%.bbappend` | Installs `wpa_supplicant-wlan0.conf` to join the open `BTWi-fi` SSID on wlan0 |
| `hostapd-conf/hostapd_%.bbappend` | Installs `hostapd.conf`: WPA2-PSK AP `RPI-AP` on wlan1, 2.4 GHz channel 7 |
| `iptables-rules/iptables-rules.bb` | Installs `/etc/iptables/ipv4.rules` (NAT MASQUERADE out of wlan0) and a systemd unit to restore them at boot |
| `system-conf/procps_%.bbappend` | Ships `/etc/sysctl.conf` with `net.ipv4.ip_forward=1` plus basic hardening (SYN cookies, no redirects/source routing) |
| `btlogin/btlogin.bb` | Installs `BTLogin.sh` and `btlogin.service`, which perform the hotspot captive-portal login |
| `packagegroup-appends/*.bbappend` | Removes `rsyslog`, `ifupdown` and `dhcpcd` from the Wind River base package groups |

## Design

- **systemd-networkd over ifupdown/dhcpcd.** One declarative config per interface, DHCP server built in, no extra daemons. Removing the legacy packages avoids two network managers fighting over the same interfaces.
- **Persistent NAT via a oneshot unit.** Rules are kept as an `iptables-save` file and restored by systemd instead of being scripted ad hoc.
- **Config as recipes.** Every runtime config file is delivered by a `.bbappend`, so the image is fully defined by the layer and rebuilds identically.
- **U-Boot as bootloader.** Chosen to leave room for A/B or OTA updates later. The build configuration that enables it isn't committed yet (see roadmap).

## Build

Requirements: an x86_64 Ubuntu 20.04 build host with a Wind River Linux LTS 20 platform project set up for the Raspberry Pi 3B, plus the [`meta-raspberrypi`](https://git.yoctoproject.org/meta-raspberrypi) BSP layer.

```bash
# from your initialised WRLinux 20 build directory
bitbake-layers add-layer /path/to/WRLinux-20/rpi3b/meta-custom

# conf/local.conf: pull the custom packages into the image
IMAGE_INSTALL_append = " btlogin iptables-rules hostapd wpa-supplicant"

bitbake wrlinux-image-std
```

> Note: the layer uses the pre-Honister override syntax (`_append`, `_prepend`, `_${PN}`) used by WRLinux 20. Yocto Honister (3.4) and later need the `:append` style.

Then write the SD card image from `tmp/deploy/images/<machine>/` to a microSD card (e.g. with `bmaptool` or `dd`).

**Before you build:** change `wpa_passphrase` in `hostapd-conf/files/hostapd.conf`, and set the hotspot credentials in `BTLogin.sh` locally; never commit them.

## Status / roadmap

Proof of concept from 2021, not actively maintained.

- [x] AP on wlan1 with DHCP via systemd-networkd
- [x] NAT to the hotspot uplink with persistent iptables rules
- [x] Legacy networking packages removed from the image
- [ ] Ship `local.conf` / `bblayers.conf` templates (`TEMPLATECONF`) so the build is reproducible from this repo alone
- [ ] Rework `BTLogin.sh` for systemd: it currently re-sends the login on every run. It should be a timer- or networkd-dispatcher-triggered check that only logs in when the portal blocks traffic
- [ ] Commit the U-Boot configuration and evaluate an OTA update mechanism (e.g. SWUpdate or RAUC)
- [ ] Port the layer to the current Yocto override syntax
- [ ] Remove `hostapd.conf.bak` and replace the layer's template `README`
