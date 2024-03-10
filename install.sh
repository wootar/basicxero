#!/bin/sh
set -e
cd $(dirname "$0") || exit 1
title="BasicXero"
if [ -z "$DESTDIR" ]; then
	echo "No DESTDIR, defaulting to $HOME"
	DESTDIR="$HOME"
fi

ZENITYFLAGS=""

copy() {
	if [ -z "$1" ]; then
		return 1
	fi
	if [ -z "$2" ]; then
		return 1
	fi
	num=`find $1/* | wc -l`
	a=0
	cp -rv $1/* "$2" | while read g; do
		a=$(($a+1))
		echo "$(($a*100/$num))"
	done 
	echo "exit" # "100"
}

question() {
	zenity --question --title="$title" $ZENITYFLAGS --text="Do you want to install the theme?" || exit 1
	return $?
}
progress() {
	zenity --progress --time-remaining --no-cancel --auto-close $ZENITYFLAGS --title="$title" --text="$1"
}
info() {
	zenity --info --title="$title" --text="$1"
}

question || exit 1
mkdir -p $DESTDIR/.icons
mkdir -p $DESTDIR/.themes
mkdir -p $DESTDIR/.config
mkdir -p $DESTDIR/.fonts
copy icons "$DESTDIR/.icons" | progress "Installing icons"
copy themes "$DESTDIR/.themes" | progress "Installing themes"
copy config "$DESTDIR/.config" | progress "Installing configuration files"
copy fonts "$DESTDIR/.fonts" | progress "Installing fonts"
info "Successfully installed $title! A relogin is recommended."
