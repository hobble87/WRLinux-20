FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://04-eth.network \
    file://08-wlan1.network \
    file://08-wlan0.network \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/network/04-eth.network \
    ${sysconfdir}/systemd/network/08-wlan1.network \
    ${sysconfdir}/systemd/network/08-wlan0.network \
"

do_install_append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/04-eth.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/08-wlan1.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/08-wlan0.network ${D}${sysconfdir}/systemd/network
}
