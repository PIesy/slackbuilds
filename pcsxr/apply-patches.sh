
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
sed -e "s|_LIB_|${LIBDIRSUFFIX}|g" ${SB_PATCHDIR}/${NAME}-scanplugins.patch \
  | patch -p0 -E --backup --verbose

set +e +o pipefail
