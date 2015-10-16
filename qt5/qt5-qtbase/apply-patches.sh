
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# Set to test (some patches require others, so, is not 100%)
PATCH_DRYRUN=${PATCH_DRYRUN:-NO}

unset PATCH_DRYRUN_OPT PATCH_VERBOSE_OPT

[ "${PATCH_DRYRUN}" = "YES" ] && PATCH_DRYRUN_OPT="--dry-run"
[ "${PATCH_VERBOSE}" = "YES" ] && PATCH_VERBOSE_OPT="--verbose"
[ "${PATCH_SVERBOSE}" = "YES" ] && set -o xtrace

PATCHCOM="patch ${PATCH_DRYRUN_OPT} -p1 -F1 -s ${PATCH_VERBOSE_OPT}"

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

# support multilib optflags
ApplyPatch qtbase-multilib_optflags.patch -z .multilib-optflags
rm -fv mkspecs/linux-g++*/qmake.conf.multilib-optflags

# upstreamable patches
# fix QTBUG-35459 (too low entityCharacterLimit=1024 for CVE-2013-4549)
ApplyPatch qtbase-opensource-src-5.3.2-QTBUG-35459.patch

# unconditionally enable freetype lcdfilter support
ApplyPatch qtbase-opensource-src-5.2.0-enable_ft_lcdfilter.patch

# hack out largely useless (to users) warnings about qdbusconnection
# (often in kde apps), keep an eye on https://git.reviewboard.kde.org/r/103699/
ApplyPatch qtbase-opensource-src-5.5.1-qdbusconnection_no_debug.patch

# Qt5 application crashes when connecting/disconnecting displays
# https://bugzilla.redhat.com/show_bug.cgi?id=1083664
ApplyPatch qtbase-opensource-src-5.5-disconnect_displays.patch

##upstream patches

set +e +o pipefail
