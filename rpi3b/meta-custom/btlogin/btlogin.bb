DESCRIPTION = "btlogin script for raspberry pi"
LICENSE = "CLOSED"
PR="r0"

SRC_URI = "file://BTLogin.sh \
	   file://btlogin.service \
"
inherit systemd

SYSTEMD_SERVICE_${PN} = "btlogin.service"


do_install() {
	install -d ${D}${bindir}
	install -m 0644 ${WORKDIR}/BTLogin.sh ${D}${bindir}
	
	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/btlogin.service  ${D}${systemd_unitdir}/system
}

