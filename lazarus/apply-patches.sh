
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
zcat ${SB_PATCHDIR}/Makefile_patch.diff.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/Desktop_patch.diff.gz | patch -p1 -E --backup --verbose

set +e +o pipefail
