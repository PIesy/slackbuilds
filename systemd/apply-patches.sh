
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

unset PATCH_VERBOSE_OPT
[ "${PATCH_VERBOSE}" = "YES" ] && PATCH_VERBOSE_OPT="--verbose"
[ "${PATCH_SVERBOSE}" = "YES" ] && set -o xtrace

PATCHCOM="patch -p1 -s -F1 --backup ${PATCH_VERBOSE_OPT}"

ApplyPatch() {
  local patch=$1
  shift
  if [ ! -f ${SB_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  echo "Applying ${patch}"
  case "${patch}" in
  *.bz2) bzcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *.gz) zcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *) ${PATCHCOM} ${1+"$@"} -i "${SB_PATCHDIR}/${patch}" ;;
  esac
}

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
ApplyPatch udev-microsoft-3000-keymap.patch -p0
# From Slackware
ApplyPatch 60-cdrom_id.rules.diff -p0

# Upstream
( SB_PATCHDIR=backports
  [ -f ${CWD}/${PSRCARCHIVES} ] || exit 0
  mkdir -p backports
  cp ${DOWNDIR}/* backports/
  cat ${CWD}/${PSRCARCHIVES} | while IFS= read -r source ;do
    commit="$(echo "${source}" | awk '{print $1}')"
    ApplyPatch ${commit}.patch
  done
)

### Fedora

### Arch

### Debian
ApplyPatch Don-t-enable-audit-by-default.patch

# Set to YES if autogen is needed
SB_AUTOGEN=NO

set +e +o pipefail
