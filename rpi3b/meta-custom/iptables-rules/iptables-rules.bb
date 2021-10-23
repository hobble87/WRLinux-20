DESCRIPTION = "iptables custom rules & persistent"
LICENSE = "CLOSED"
PR="r0"

# No information for SRC_URI yet (only an external source tree was specified)
SRC_URI = " \
	file://ipv4.rules        \
        file://iptables-rulesipv4.service \
	"

RDEPENDS_${PN} = " iptables"

inherit systemd

SYSTEMD_SERVICE_${PN} = "iptables-rulesipv4.service"


do_install() {
        install -d ${D}${sysconfdir}/iptables
	install -m 0644 ${WORKDIR}/ipv4.rules ${D}${sysconfdir}/iptables/

	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/iptables-rulesipv4.service  ${D}${systemd_unitdir}/system
}

