#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

PS1="$"
log_info "Rebuilding patches from current state..."
function savePatches {
	what=$1
	cd $basedir/$what/

	mkdir -p $basedir/patches/$2
	if [ -d ".git/rebase-apply" ]; then
		# in middle of a rebase, be smarter
		echo "REBASE DETECTED - PARTIAL SAVE"
		last=$(cat ".git/rebase-apply/last")
		next=$(cat ".git/rebase-apply/next")
		for i in $(seq -f "%04g" 1 1 $last)
		do
			if [ $i -lt $next ]; then
				rm $basedir/patches/$2/${i}-*.patch
			fi
		done
	else
		rm $basedir/patches/$2/*.patch
	fi

	git format-patch --quiet --no-stat -N -o $basedir/patches/$2 upstream/upstream
	cd $basedir
	git add -A $basedir/patches/$2
	cleanupPatches $basedir/patches/$2/
	echo "  Patches saved for $what to patches/$2"
}

savePatches ArcadePaper-API api
savePatches ArcadePaper-Server server

log_info "Patches successfully rebuilt"