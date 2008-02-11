#!/bin/sh
#
# gcc-4.1-glibc-2.7.sh 
#
# Copyright (C) 2007 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any later
# version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# Written by Shakthi Kannan <shakthi.kannan@qvantel.com>.

## SOURCES
BINUTILS=binutils-2_17-branch
GCC=gcc-4_1-branch
GNUMACH=gnumach-1-branch
GLIBC=glibc-2_7-branch
MIG=mig
HURD=hurd

GCC_TARBALL=${TARBALLS}/${GCC}.tar.bz2
BINUTILS_TARBALL=${TARBALLS}/${BINUTILS}.tar.bz2
GNUMACH_TARBALL=${TARBALLS}/${GNUMACH}.tar.bz2
GLIBC_TARBALL=${TARBALLS}/${GLIBC}.tar.bz2
MIG_TARBALL=${TARBALLS}/${MIG}.tar.bz2
HURD_TARBALL=${TARBALLS}/${HURD}.tar.bz2

# $1 = package directory, ${GLIBC_DIR}
# $2 = patch-level, p0/p1;
# $3 = patch directory/URL
# $4 = list (array) of patches; 0 for all patches

apply_glibc_patches() {
    get_apply_patches ${GLIBC_DIR} p0 "${PATCHES}/${GLIBC}/p0" 0
    get_apply_patches ${GLIBC_DIR} p1 "${PATCHES}/${GLIBC}/p1" 0 
}

#apply_gcc_patches() {
## Nothing for gcc-4.1
#}