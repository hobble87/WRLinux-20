FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI += "file://wpa_supplicant-wlan0.conf"

do_install_append() {
    install -d ${D}${sysconfdir}/wpa_supplicant/
    install -m 0644 ${WORKDIR}/wpa_supplicant-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-wlan0.conf
}

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} += " wpa_supplicant@wlan0.service"
SYSTEMD_AUTO_ENABLE = "enable"

## may need to use 
#install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
#ln -s ../../../../lib/systemd/system/wpa_supplicant@wlan0.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

