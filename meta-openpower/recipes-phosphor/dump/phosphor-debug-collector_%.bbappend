FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEBUG_COLLECTOR_PKGS += "${PN}-opdreport"

RDEPENDS:${PN}-opdreport += " bash gzip "

FILES:${PN}-opdreport += "${bindir}/opdreport"

install_openpower_plugins() {
    install ${S}/tools/dreport.d/openpower.d/plugins.d/* ${D}${dreport_plugin_dir}
}

#Link the plugins so that dreport can run them based on dump type
python link_openpower_plugins() {
    source = d.getVar('S', True)
    source_path = os.path.join(source, "tools", "dreport.d", "openpower.d", "plugins.d")
    op_plugins = os.listdir(source_path)
    for op_plugin in op_plugins:
        op_plugin_name = os.path.join(source_path, op_plugin)
        install_dreport_user_script(op_plugin_name, d)
}

install_openpower_dump_script() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/tools/dreport.d/openpower.d/opdreport \
                    ${D}${bindir}/opdreport
}

DEBUG_COLLECTOR_INSTALL_POSTFUNCS ?= ""
DEBUG_COLLECTOR_INSTALL_POSTFUNCS:df-openpower ?= " \
    install_openpower_plugins \
    link_openpower_plugins \
    install_openpower_dump_script \
"

do_install[postfuncs] += "${DEBUG_COLLECTOR_INSTALL_POSTFUNCS}"
