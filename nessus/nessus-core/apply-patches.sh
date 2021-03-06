
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
zcat ${SB_PATCHDIR}/${PNAME}-Makefile.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.config.h.in.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.configure.in.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.configure.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.gd.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.nessus-adduser.in.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.nessus-mkcert.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.nessus-rmuser.in.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.nessus.tmpl.in.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.pid.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-2.2.4.pki.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/${PNAME}-open.patch.gz | patch -p1 -E --backup --verbose

set +e +o pipefail
