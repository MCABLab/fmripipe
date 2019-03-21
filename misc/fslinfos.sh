#!/bin/bash
#
# Script:  fslinfos.sh
# Purpose: Run fslinfo on multiple files, giving tabular output
# Author:  Tom Nichols
# Version: $Id: fslinfos.sh,v 1.5 2012/11/07 12:58:57 nichols Exp $
#


###############################################################################
#
# Environment set up
#
###############################################################################

shopt -s nullglob # No-match globbing expands to null
TmpDir=/tmp
Tmp=$TmpDir/`basename $0`-${$}-
trap CleanUp INT

###############################################################################
#
# Functions
#
###############################################################################

Usage() {
cat <<EOF
Usage: `basename $0` [options] img1 [img2 ...]

Gives the information in fslinfo for 1 or more files in 'report format', one line per file output.

Options
   -csv   Produces comma-spearated-value format.
   -nl    Adds newline after filename; easier to read when filenames vary in length.
_________________________________________________________________________
\$Id: fslinfos.sh,v 1.5 2012/11/07 12:58:57 nichols Exp $
EOF
exit
}

CleanUp () {
    exit 0
}


###############################################################################
#
# Parse arguments
#
###############################################################################

while (( $# > 1 )) ; do
    case "$1" in
        "-help")
            Usage
            ;;
        "-csv")
	    CSV=1
	    shift
            ;;
        "-nl")
	    NewLineAfterFilename=1
	    shift
            ;;
        *)
            break
            ;;
    esac
done

if (( $# < 1 )) ; then
    Usage
fi

###############################################################################
#
# Script Body
#
###############################################################################

if [ "$CSV" == 1 ] ; then
    Sep=","
else
    Sep="	"
fi

((i=1))
for f in "$@" ; do
    fslinfo "$f" | grep -v '^filename' > $Tmp 
    if [ $? != 0 ] ; then
	if [ "$NewLineAfterFilename" != "" ] ; then
	    echo "${f}"; echo "${Sep}ERROR!"
	else
	    echo "${f}${Sep}ERROR!"
	fi

    else
	if ((i==1)) ; then
	    echo -n "filename"
	    if [ "$NewLineAfterFilename" != "" ] ; then
		echo ""
	    fi
	    awk '{printf("%c%s","'"$Sep"'",$1)};END{print ""}' $Tmp
	fi
	echo -n "$f"
	if [ "$NewLineAfterFilename" != "" ] ; then
	    echo ""
	fi
	awk '{printf("%c%s","'"$Sep"'",$2)};END{print ""}' $Tmp
    fi
    ((i++))
done

###############################################################################
#
# Exit & Clean up
#
###############################################################################

CleanUp

