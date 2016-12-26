
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
# The wonderful extended version of the font so generously
# opened up for free modification and distribution by one
# for the previously proprietary font founderies, and that
# Stepan Roh did such a marvelous job on getting the ball
# rolling with should clearly (IMHO) be the default font:
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/fontconfig.dejavu.diff

# Hardcode the default font search path rather than having
# fontconfig figure it out (and possibly follow symlinks, or
# index ugly bitmapped fonts):
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/fontconfig.font.dir.list.diff

### Fedora
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/fontconfig-2.8.0-sleep-less.patch

# Set to YES if autogen is needed
SB_AUTOGEN=YES

set +e +o pipefail
