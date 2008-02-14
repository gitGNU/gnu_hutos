#!/bin/sh
#
# patch.sh 
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

get_apply_patches() {
    package_dir=$1   # $1 = package directory, ${GLIBC_DIR}
    patch_level=$2   # $2 = patch-level, p0/p1;
    patch_URL=$3     # $3 = patch directory/URL
    patches_array=$4 # $4 = list (array) of patches; 0 for all patches

    # TODO: do exception handling for above arguments?
    echo $1
    # create patch directory
    mkdir -p ${package_dir}/${patch_level}

    # starts with a . or /, means patches are in a directory
    first_char=`expr "$patch_URL" : '\(.\)'`

    # get patches
    case $first_char in
	.|/)if [ ! -z ${patches_array} ]; then # if 0, copy all patches
		for file in `ls ${patch_URL}/`; do
		    cp ${patch_URL}/$file ${package_dir}/${patch_level}
		done
	    fi ;;
	*)# default, a URL
	    if [ ! -z ${patches_array} ]; then # if 0, copy all patches
		    wget -r -np -nd -P ${package_dir}/${patch_level} ${patch_URL}/*
	    else # copy listed patches only
		index=0
		while [ $index -lt ${#patches_array[@]} ]; do
		    wget -r -np -nd -P ${package_dir}/${patch_level} ${patch_URL}/${patches_array[index]}
		    let "index = $index + 1"
		done
	    fi
    esac

    #apply patches
    index=0
    cd ${package_dir}

    if [ ! -z ${patches_array} ]; then # if 0, all patches to be applied
	for file in `ls ${patch_URL}/`; do
	    patch -${patch_level} -N < ${package_dir}/${patch_level}/${file}
	done
    else # only selected patches from array
	while [ $index -lt ${#patches_array[@]} ]; do
	    patch -${patch_level} -N < ${package_dir}/${patch_level}/${patches_array[index]}
	    let "index = $index + 1"
	done
    fi
}
