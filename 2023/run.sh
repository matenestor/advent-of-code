#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo -e "Day number required!\nUsage: ./run.sh <day-number>"
	exit 1
fi

clear; odin run "day$1.odin" -out:main -file

