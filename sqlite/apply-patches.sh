
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
# Fix build with --enable-load-extension, upstream ticket #3137
zcat ${SB_PATCHDIR}/sqlite-3.6.6.2-libdl.patch.gz | patch -p1 -E --backup --verbose
# Avoid insecure sprintf(), use a system path for lempar.c, patch from Debian
zcat ${SB_PATCHDIR}/sqlite-3.6.23-lemon-system-template.patch.gz | patch -p1 -E --backup --verbose
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/sqlite-3.6.22-interix-fixes.patch

set +e +o pipefail
