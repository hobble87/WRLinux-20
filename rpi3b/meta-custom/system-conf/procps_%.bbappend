FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://sysctl.conf \
"

FILES_${PN} += " \
    ${sysconfdir}/sysctl.conf \
"

do_install_append() {
    install -d ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/sysctl.conf ${D}${sysconfdir}/
}
