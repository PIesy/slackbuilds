
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

# patch -p0 --verbose -i ${SB_PATCHDIR}/${NAME}.patch
ApplyPatch x11.startwithblackscreen.diff

### Fedora
# Various fixes pending upstream
ApplyPatch 0004-glamor-restore-vfunc-handlers-on-init-failure.patch
ApplyPatch 0005-xfree86-Remove-redundant-ServerIsNotSeat0-check-from.patch
ApplyPatch 0006-xfree86-Make-adding-unclaimed-devices-as-GPU-devices.patch
ApplyPatch 0007-xfree86-Try-harder-to-find-atleast-1-non-GPU-Screen.patch
ApplyPatch 0001-Fix-segfault-if-xorg.conf.d-is-absent.patch
ApplyPatch 0001-xwayland-Fix-use-after-free-of-cursors.patch
ApplyPatch 0001-randr-rrCheckPixmapBounding-Do-not-substract-crtc-no.patch
ApplyPatch 0002-randr-rrCheckPixmapBounding-do-not-shrink-the-screen.patch

# Patches for better integration with the nvidia driver, pending upstream
ApplyPatch 0001-xfree86-Free-devlist-returned-by-xf86MatchDevice.patch
ApplyPatch 0002-xfree86-Make-OutputClassMatches-take-a-xf86_platform.patch
ApplyPatch 0003-xfree86-Add-options-support-for-OutputClass-Options.patch
ApplyPatch 0004-xfree86-xf86platformProbe-split-finding-pci-info-and.patch
ApplyPatch 0005-xfree86-Allow-overriding-primary-GPU-detection-from-.patch
ApplyPatch 0006-xfree86-Add-ModulePath-support-for-OutputClass-confi.patch
ApplyPatch 0001-glamor-glamor_egl_get_display-Return-NULL-if-eglGetP.patch

# https://bugzilla.redhat.com/show_bug.cgi?id=1389886
ApplyPatch 0001-Revert-damage-Make-damageRegionProcessPending-take-a.patch

#zcat ${SB_PATCHDIR}/xserver-1.6.99-hush-prerelease-warning.patch.gz | patch -p1 --verbose

ApplyPatch 0001-Always-install-vbe-and-int10-sdk-headers.patch

# Submitted upstream, but not going anywhere
ApplyPatch xserver-autobind-hotplug.patch

# https://bugzilla.redhat.com/show_bug.cgi?id=1384432
ApplyPatch 0001-Xi-when-creating-a-new-master-device-update-barries-.patch

# because the display-managers are not ready yet, do not upstream
ApplyPatch 0001-Fedora-hack-Make-the-suid-root-wrapper-always-start-.patch

# misc
ApplyPatch 0001-Fix-segfault-when-killing-X-with-ctrl-alt-backspace.patch

# https://bugs.freedesktop.org/show_bug.cgi?id=94235
ApplyPatch ${NAME}.glibc223.patch

ApplyPatch xserver-force-hal-disable.patch

# Set to YES if autogen is needed
SB_AUTOGEN=YES

set +e +o pipefail
