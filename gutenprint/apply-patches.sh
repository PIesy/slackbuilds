
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
zcat ${SB_PATCHDIR}/${NAME}-menu.patch.gz | patch -p1 -E --backup --verbose
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-postscriptdriver.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-device-ids.patch

set +e +o pipefail
