
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/firefox-build-prbool.patch
# Unable to install addons from https pages
patch -p2 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/rhbz-966424.patch
patch -p2 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/rhbz-1173156.patch
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/seamonkey-2.35-enable-addons.patch
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/seamonkey-2.32-installdir.patch
#patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/seamonkey-2.25-elfhack.patch

# Upstream patches
patch -p1 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/seamonkey-2.35-blocklist.patch

# Gentoo
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-2.30-pulseaudio_configure_switch_fix.patch

# OpenSUSE
patch -p1 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/mozilla-nongnome-proxies.patch
patch -p1 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/mozilla-no-stdcxx-check.patch
patch -p1 -E --backup --verbose -d mozilla -i ${SB_PATCHDIR}/mozilla-libproxy.patch

set +e +o pipefail
