
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -d gfx/cairo/cairo -i ${SB_PATCHDIR}/01_fix_slowness.patch
patch -p1 -E --backup -z .vpx --verbose -i ${SB_PATCHDIR}/${NAME}-vpx-define.patch

# build patches
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/xulrunner-install-dir.patch
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/firefox-build.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/firefox-build-prbool.patch
case "${ARCH}" in
  i[3-6]86|s390)
    patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/firefox-baseline-disable.patch
    ;;
esac

# Fedora specific patches
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-193-pkgconfig.patch
# Unable to install addons from https pages
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/rhbz-966424.patch

# Gentoo

# OpenSUSE
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/toolkit-download-folder.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-nongnome-proxies.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-prefer_plugin_pref.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-icu-strncat.patch

# Upstream patches
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-858919.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-858919-2.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-858919-3.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/mozilla-1042889.patch

# OpenSuse kde integration support
if [ "${SB_KDE}" = "YES" ] ;then
  patch -p1 -E --backup -z .moz-kde --verbose -i ${SB_PATCHDIR}/mozilla-kde.patch
fi

set +e +o pipefail
