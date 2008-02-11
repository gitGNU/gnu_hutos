#!/bin/sh
#
# hurd-toolchain.sh - Script for setting up Hurd toolchain builds
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

TOPDIR=`pwd`
DOWNLOADS=${TOPDIR}/downloads
ROOT=${TOPDIR}/root
PATCHES=${TOPDIR}/patches
SRC=${ROOT}/src
GLIBC_DIR=${SRC}/glibc
GCC_DIR=${SRC}/gcc
CROSS_GNU_URL=http://www.shakthimaan.com/downloads/hurd/toolchain
TARBALLS=${TOPDIR}/tarballs

all() {
    . ./patch.sh
    create_dir 
    get_sources 
    build_all
}

## Create directories
create_dir() {
	cd ${TOPDIR}
	mkdir -p ${DOWNLOADS}
	mkdir -p ${SRC}
}

get_sources() { 
    get_cross_gnu 
    get_binutils 
    get_gcc 
    get_gnumach 
    get_mig 
    get_hurd 
    get_glibc
}

get_cross_gnu() {
	echo "  ___ _ __ ___  ___ ___        __ _ _ __  _   _ "
	echo " / __| '__/ _ \/ __/ __|_____ / _\` | '_ \| | | |"
	echo "| (__| | | (_) \__ \__ \_____| (_| | | | | |_| |"
	echo " \___|_|  \___/|___/___/      \__, |_| |_|\__,_|"
	echo "                              |___/             "
	cd ${DOWNLOADS}
	if [ -f ${TARBALLS}/cross-gnu ] ; then
	    echo "Local copy of cross-gnu found..."
	    cp ${TARBALLS}/cross-gnu .
	else
		wget ${CROSS_GNU_URL}/cross-gnu -O cross-gnu
	fi
	echo "  ___ _ __ ___  ___ ___        __ _ _ __  _   _        ___ _ ____   __" 
	echo " / __| '__/ _ \/ __/ __|_____ / _\` | '_ \| | | |_____ / _ \ '_ \ \ / /"
	echo "| (__| | | (_) \__ \__ \_____| (_| | | | | |_| |_____|  __/ | | \ V / " 
	echo " \___|_|  \___/|___/___/      \__, |_| |_|\__,_|      \___|_| |_|\_/  " 
	echo "                              |___/                                   " 
	cd ${DOWNLOADS}
	if [ -f ${TARBALLS}/cross-gnu-env ] ; then
	    echo "Local copy of cross-gnu-env found..."
	    cp ${TARBALLS}/cross-gnu-env .
	else
	    wget ${CROSS_GNU_URL}/cross-gnu-env -O cross-gnu-env
	fi
	chmod +x cross-gnu
	chmod +x cross-gnu-env
}

get_binutils() {
	echo " _     _             _   _ _     "
	echo "| |__ (_)_ __  _   _| |_(_) |___ "
	echo "| '_ \| | '_ \| | | | __| | / __|"
	echo "| |_) | | | | | |_| | |_| | \__ \\"
	echo "|_.__/|_|_| |_|\__,_|\__|_|_|___/"
	cd ${SRC} 
	if test -d binutils; then
	    echo "Deleting existing sources for sanity. If you don't want this behaviour, "
	    echo "consider creating a tarball of the sources. Refer README for more"
	    echo "...."
	    rm -rf binutils
	fi
	if [ -f ${BINUTILS_TARBALL} ] ; then
	    echo "Local copy of BINUTILS tarball found. Extracting..."
	    tar xjvf ${BINUTILS_TARBALL}
	else
	    cvs -d:pserver:anoncvs@sources.redhat.com:/cvs/src co -r ${BINUTILS} binutils
	    mv src binutils
	fi
}

get_gcc() {
	echo "  __ _  ___ ___ "
	echo " / _\` |/ __/ __|"
	echo "| (_| | (_| (__ "
	echo " \__, |\___\___|"
	echo " |___/          "
	cd ${SRC}
    	if test -d gcc; then
	    echo "Deleting existing sources for sanity. If you don't want this behaviour, "
	    echo "consider creating a tarball of the sources. Refer README for more"
	    echo "...."	   
	    rm -rf gcc
	fi
	if [ -f ${GCC_TARBALL} ] ; then
	    echo "Local copy of gcc tarball found. Extracting..."
	    tar xjvf ${GCC_TARBALL}
	else
	    svn co svn://gcc.gnu.org/svn/gcc/branches/${GCC}
	    mv ${GCC} gcc
	fi
	apply_gcc_patches
	cd gcc/ && contrib/gcc_update --touch
}

get_gnumach() {
	echo "                                        _     "
	echo "  __ _ _ __  _   _ _ __ ___   __ _  ___| |__  "
	echo " / _\` | '_ \| | | | '_ \` _ \ / _\` |/ __| '_ \ "
	echo "| (_| | | | | |_| | | | | | | (_| | (__| | | |"
	echo " \__, |_| |_|\__,_|_| |_| |_|\__,_|\___|_| |_|"
	echo " |___/                                        "
	cd ${SRC}
	if test -d gnumach; then
	    echo "Deleting existing sources for sanity. If you don't want this behaviour, "
	    echo "consider creating a tarball of the sources. Refer README for more"
	    echo "...."	   
	    rm -rf gnumach
	fi
	if [ -f ${GNUMACH_TARBALL} ] ; then
	    echo "Local copy of GNU MACH tarball found. Extracting..."
	    tar xjvf ${GNUMACH_TARBALL}
	else
	    cvs -d:pserver:anoncvs@cvs.gnu.org:/cvsroot/hurd co -r ${GNUMACH} gnumach
	fi
	cd gnumach/ && autoreconf -vfi
}

get_mig() {
	echo "           _       "
	echo " _ __ ___ (_) __ _ "
	echo "| '_ \` _ \| |/ _\` |"
	echo "| | | | | | | (_| |"
	echo "|_| |_| |_|_|\__, |"
	echo "             |___/ "
	cd ${SRC}
	if test -d mig; then
	    echo "Deleting existing sources for sanity. If you don't want this behaviour, "
	    echo "consider creating a tarball of the sources. Refer README for more"
	    echo "...."	   
	    rm -rf mig
	fi
	if [ -f ${MIG_TARBALL} ] ; then
	    echo "Local copy of MIG tarball found. Extracting..."
	    tar xjvf ${MIG_TARBALL}
	else
	    cvs -d:pserver:anoncvs@cvs.gnu.org:/cvsroot/hurd co ${MIG}
	fi
	cd mig/ && autoreconf -vfi
}

get_hurd() {
	echo " _                   _ "
	echo "| |__  _   _ _ __ __| |"
	echo "| '_ \| | | | '__/ _\` |"
	echo "| | | | |_| | | | (_| |"
	echo "|_| |_|\__,_|_|  \__,_|"
	cd ${SRC}
	if test -d hurd; then
	    echo "Deleting existing sources for sanity. If you don't want this behaviour, "
	    echo "consider creating a tarball of the sources. Refer README for more"
	    echo "...."	   
	    rm -rf hurd
	fi
	if [ -f ${HURD_TARBALL} ] ; then
	    echo "Local copy of HURD tarball found. Extracting..."
	    tar xjvf ${HURD_TARBALL}
	else
	    cvs -d:pserver:anoncvs@cvs.gnu.org:/cvsroot/hurd co ${HURD}
	fi
}

get_glibc() {
	echo "       _ _ _          "
	echo "  __ _| (_) |__   ___ "
	echo " / _\` | | | '_ \ / __|"
	echo "| (_| | | | |_) | (__ "
	echo " \__, |_|_|_.__/ \___|"
	echo " |___/                "
	cd ${SRC}
	if test -d glibc; then
	    echo "Deleting existing sources for sanity. If you don't want this behaviour, "
	    echo "consider creating a tarball of the sources. Refer README for more"
	    echo "...."	   
	    rm -rf glibc
	fi
	if [ -f ${GLIBC_TARBALL} ] ; then
	    echo "Local copy of glibc tarball found. Extracting..."
	    tar xjvf ${GLIBC_TARBALL}
	else
	    cvs -d:pserver:anoncvs@sources.redhat.com:/cvs/glibc co -r ${GLIBC} glibc
	    mv libc glibc
	fi
	apply_glibc_patches
}

build_all() {
	ROOT=${TOPDIR}/root
	export PATH="$PATH:${DOWNLOADS}"
	. ${DOWNLOADS}/cross-gnu-env
	${DOWNLOADS}/cross-gnu
}

clean() {
	rm -rf downloads root *~
}

## Execute
. ./setenv
all
