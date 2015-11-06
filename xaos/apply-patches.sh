
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
### Fedora
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/xaos-3.6-fix-conflicting-register-types.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/xaos-3.6-format-security.patch

set +e +o pipefail
