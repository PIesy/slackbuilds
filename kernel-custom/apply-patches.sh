#!/bin/sh

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

ApplyOptionalPatch() {
  local patch=$1
  shift
  if [ ! -f ${SB_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  case "${patch}" in
  *.bz2) local C=$(bzcat ${SB_PATCHDIR}/${patch} | wc -l | awk '{print $1}') ;;
  *.gz) local C=$(zcat ${SB_PATCHDIR}/${patch} | wc -l | awk '{print $1}') ;;
  *) local C=$(wc -l ${SB_PATCHDIR}/${patch} | awk '{print $1}') ;;
  esac
  if [ "${C}" -gt 9 ]; then
    ApplyPatch ${patch} ${1+"$@"}
  fi
}

# Most patches are retrieved from Fedora git repository

ApplyPatch kbuild-AFTER_LINK.patch

#
# misc small stuff to make things compile
#
ApplyOptionalPatch compile-fixes.patch.gz

# revert patches from upstream that conflict or that we get via other means
ApplyOptionalPatch upstream-reverts.patch -R

ApplyOptionalPatch hotfixes.patch

# vm patches
### openSUSE patches.suse
# Patches to export btrfs anonymous devices (VFS portion)
ApplyPatch vfs-add-super_operations-get_inode_dev.patch
  
# mm patches

# Architecture patches
# x86(-64)
# Add additional cpu gcc optimization support
# https://github.com/graysky2/kernel_gcc_patch (20160728)
ApplyPatch enable_additional_cpu_optimizations_for_gcc_v4.9+_kernel_v3.15+.patch

### openSUSE patches.arch
#ApplyPatch x86_64-hpet-64bit-timer.patch

ApplyPatch lib-cpumask-Make-CPUMASK_OFFSTACK-usable-without-deb.patch

#
# Intel IOMMU
#

#
# bugfixes to drivers and filesystems
#

# reisefs

# ext4

# ext3

# xfs

# btrfs
### openSUSE patches.suse
ApplyPatch btrfs-provide-super_operations-get_inode_dev.patch
ApplyPatch revert-btrfs-fix-lockdep-warning-on-deadlock-against-an-inode-s-log-mutex.patch
ApplyPatch revert-btrfs-improve-performance-on-fsync-against-new-inode-after-rename-unlink.patch
  
# cifs

# NFSv4

# USB

# WMI

# ACPI

# cpufreq
### openSUSE patches.arch
ApplyPatch perf_timechart_fix_zero_timestamps.patch

#
# PCI
#

#
# SCSI / block Bits.
#

# BFQ disk scheduler - http://algo.ing.unimo.it/people/paolo/disk_sched/
mkdir -p bfq_patches
for file in ${BFQSRCARCHIVES} ;do
  cp ${BFQDOWNDIR}/${file} bfq_patches/
done

( SB_PATCHDIR=bfq_patches
  for file in ${BFQSRCARCHIVES} ;do
    ApplyPatch ${file}
  done
)

ApplyPatch make-bfq-the-default-io-scheduler.patch

# ALSA

# block/bio
#

# Networking

# Misc fixes
# The input layer spews crap no-one cares about.
ApplyPatch input-kill-stupid-messages.patch

# stop floppy.ko from autoloading during udev...
ApplyPatch die-floppy-die.patch

ApplyPatch no-pcspkr-modalias.patch

# Make fbcon not show the penguins with 'quiet'
ApplyPatch silence-fbcon-logo.patch

# Changes to upstream defaults.

# libata

#
# VM related fixes.
#

# /dev/crash driver.
ApplyPatch crash-driver.patch

# crypto/

# DRM core

# Nouveau DRM

# Intel DRM
ApplyPatch drm-i915-hush-check-crtc-state.patch

# Patches headed upstream
ApplyPatch disable-i8042-check-on-apple-mac.patch

ApplyPatch lis3-improve-handling-of-null-rate.patch

# Disable watchdog on virtual machines.
ApplyPatch watchdog-Disable-watchdog-on-virtual-machines.patch

#rhbz 754518
ApplyPatch scsi-sd_revalidate_disk-prevent-NULL-ptr-deref.patch

# https://fedoraproject.org/wiki/Features/Checkpoint_Restore
ApplyPatch criu-no-expert.patch

#CVE-2015-2150 rhbz 1196266 1200397
ApplyPatch xen-pciback-Don-t-disable-PCI_COMMAND-on-PCI-device-.patch

#rhbz 1212230
ApplyPatch Input-synaptics-pin-3-touches-when-the-firmware-repo.patch

#rhbz 1133378
ApplyPatch firmware-Drop-WARN-from-usermodehelper_read_trylock-.patch

#rhbz 1226743
#ApplyPatch drm-i915-turn-off-wc-mmaps.patch

#CVE-2016-3134 rhbz 1317383 1317384
ApplyPatch netfilter-x_tables-deal-with-bogus-nextoffset-values.patch

#rhbz 1360688
ApplyPatch rc-core-fix-repeat-events.patch

#rhbz 1374212
ApplyPatch 0001-cpupower-Correct-return-type-of-cpu_power_is_cpu_onl.patch

#ongoing complaint, full discussion delayed until ksummit/plumbers
ApplyPatch 0001-iio-Use-event-header-from-kernel-tree.patch

#CVE-2016-7425 rhbz 1377330 1377331
ApplyPatch arcmsr-buffer-overflow-in-archmsr_iop_message_xfer.patch

#rhbz 1366842
ApplyPatch drm-virtio-reinstate-drm_virtio_set_busid.patch

# Fix memory corruption caused by p8_ghash
ApplyPatch 0001-crypto-ghash-generic-move-common-definitions-to-a-ne.patch
ApplyPatch 0001-crypto-vmx-Fix-memory-corruption-caused-by-p8_ghash.patch

#rhbz 1384606
ApplyPatch 0001-Make-__xfs_xattr_put_listen-preperly-report-errors.patch

unset DRYRUN DRYRUN_OPT VERBOSE VERBOSE_OPT SVERBOSE

set +e +o pipefail +o xtrace
