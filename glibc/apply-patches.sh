
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

# Use old-style locale directories rather than a single (and strangely
# formatted) /usr/lib/locale/locale-archive file:
ApplyPatch glibc.locale.no-archive.diff
# The is_IS locale is causing a strange error about the "echn" command
# not existing.  This patch reverts is_IS to the version shipped in
# glibc-2.5:
ApplyPatch is_IS.diff.gz
# Fix NIS netgroups:
ApplyPatch glibc.nis-netgroups.diff
# Support ru_RU.CP1251 locale:
ApplyPatch glibc.ru_RU.CP1251.diff.gz
# http://sources.redhat.com/bugzilla/show_bug.cgi?id=411
# http://sourceware.org/ml/libc-alpha/2009-07/msg00072.html
ApplyPatch glibc-__i686.patch

if [ "${SB_BOOTSTRP}" = "YES" ] ;then
  # Multilib - Disable check for forced unwind (Patch from eglibc) since we
  # do not have a multilib glibc yet to link to;
  ApplyPatch glibc.pthread-disable-forced-unwind-check.diff
fi

### Gentoo
( SB_PATCHDIR=patches

  ApplyPatch 00_all_0001-Updated-translations-for-2.23.patch
  ApplyPatch 00_all_0002-Regenerate-libc.pot-for-2.23.patch
  ApplyPatch 00_all_0003-Regenerated-configure-scripts.patch
  ApplyPatch 00_all_0004-disable-ldconfig-during-install.patch
  ApplyPatch 00_all_0005-reload-etc-resolv.conf-when-it-has-changed.patch
  ApplyPatch 00_all_0006-nptl-support-thread-stacks-that-grow-up.patch
  ApplyPatch 00_all_0007-rtld-do-not-ignore-arch-specific-CFLAGS.patch
  ApplyPatch 00_all_0008-gentoo-support-running-tests-under-sandbox.patch
  ApplyPatch 00_all_0009-sys-types.h-drop-sys-sysmacros.h-include.patch
  ApplyPatch 00_all_0010-x86_64-Set-DL_RUNTIME_UNALIGNED_VEC_SIZE-to-8.patch
  ApplyPatch 00_all_0011-Don-t-use-long-double-math-functions-if-NO_LONG_DOUB.patch
  ApplyPatch 00_all_0012-sln-use-stat64.patch
  ApplyPatch 00_all_0013-Add-sys-auxv.h-wrapper-to-include-sys.patch
  ApplyPatch 00_all_0014-mips-terminate-the-FDE-before-the-return-trampoline-.patch
  ApplyPatch 00_all_0015-Use-HAS_ARCH_FEATURE-with-Fast_Rep_String.patch
  ApplyPatch 00_all_0016-Define-_HAVE_STRING_ARCH_mempcpy-to-1-for-x86.patch
  ApplyPatch 00_all_0017-Or-bit_Prefer_MAP_32BIT_EXEC-in-EXTRA_LD_ENVVARS.patch
  ApplyPatch 00_all_0018-Fix-resource-leak-in-resolver-bug-19257.patch
  ApplyPatch 00_all_0019-resolv-Always-set-resplen2-out-parameter-in-send_dg-.patch
)

## Fedora
# Needs to be sent upstream
ApplyPatch glibc-fedora-include-bits-ldbl.patch

ApplyPatch glibc-fedora-linux-tcsetattr.patch
ApplyPatch glibc-fedora-nptl-linklibc.patch
ApplyPatch glibc-fedora-i386-tls-direct-seg-refs.patch
ApplyPatch glibc-fedora-nis-rh188246.patch
ApplyPatch glibc-fedora-locarchive.patch
ApplyPatch glibc-fedora-streams-rh436349.patch
ApplyPatch glibc-fedora-localedata-rh61908.patch
ApplyPatch glibc-fedora-uname-getrlimit.patch
ApplyPatch glibc-fedora-__libc_multiple_libcs.patch
ApplyPatch glibc-fedora-elf-ORIGIN.patch
ApplyPatch glibc-fedora-elf-init-hidden_undef.patch

# Support mangling and demangling null pointers.
ApplyPatch glibc-rh952799.patch

# Allow applications to call pthread_atfork without libpthread.so.
ApplyPatch glibc-rh1013801.patch

ApplyPatch glibc-nscd-sysconfig.patch
sed -i -e 's|/sysconfig/|/default/|g' nscd/nscd.service

# Fix -Warray-bounds warning for GCC5, likely PR/59124 or PR/66422.
#ApplyPatch glibc-res-hconf-gcc5.patch
ApplyPatch glibc-ld-ctype-gcc5.patch
ApplyPatch glibc-gethnamaddr-gcc5.patch
ApplyPatch glibc-dns-host-gcc5.patch
ApplyPatch glibc-bug-regex-gcc5.patch

# Add C.UTF-8 locale into /usr/lib/locale/
ApplyPatch glibc-c-utf8-locale.patch

# http://sourceware.org/ml/libc-alpha/2012-12/msg00103.html
ApplyPatch glibc-rh697421.patch
ApplyPatch glibc-rh741105.patch
# Upstream BZ 14247
ApplyPatch glibc-rh827510.patch
# Upstream BZ 14185
ApplyPatch glibc-rh819430.patch
# Fix nscd to use permission names not constants.
ApplyPatch glibc-rh1070416.patch
ApplyPatch glibc-aarch64-tls-fixes.patch
ApplyPatch glibc-aarch64-workaround-nzcv-clobber-in-tlsdesc.patch

# Group Merge Patch:
ApplyPatch glibc-nsswitch-Add-group-merging-support.patch

ApplyPatch glibc-gcc-PR69537.patch

ApplyPatch glibc-rh1321372.patch
ApplyPatch glibc-rh1204521.patch
ApplyPatch glibc-rh1282011.patch

## Mandriva
ApplyPatch glibc-2.11.1-localedef-archive-follow-symlinks.patch 
ApplyPatch glibc-2.9-ldd-non-exec.patch.gz
ApplyPatch glibc-2.17-nss-upgrade.patch
ApplyPatch glibc-2.19-compat-EUR-currencies.patch
ApplyPatch glibc-2.9-nscd-no-host-cache.patch.gz
ApplyPatch glibc-2.10.1-biarch-cpp-defines.patch.gz
ApplyPatch glibc-2.22-nice_fix.patch
ApplyPatch glibc-2.3.5-biarch-utils.patch.gz
ApplyPatch glibc-2.22-multiarch.patch
ApplyPatch glibc-2.22-pt_BR-i18nfixes.patch

### Arch


### master


set +e +o pipefail
