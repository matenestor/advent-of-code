#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo -e "Day number required!\nUsage: ./new_day.sh <day-number>"
	exit 1
fi

#if [ -z "$2" ]; then
#	input_type="Any"
#else
#	input_type="$2"
#fi

touch "samples/sample_$1.txt"
echo "samples/sample_$1.txt"

touch "inputs/input_$1.txt"
echo "inputs/input_$1.txt"


echo -e "import algorithm    # sorted\n"\
"import math         # sum\n"\
"import sequtils     # map\n"\
"import strformat    # echo &\"{}\"\n"\
"import strutils     # split\n"\
"import sugar        # collect, =>\n\n\n"\
\
"proc part1(data: string): int =\n"\
"    return 0\n\n\n"\
\
"proc part2(data: string): int =\n"\
"    return 0\n\n\n"\
\
"when isMainModule:\n"\
"    let data_sample: string = readFile(\"samples/sample_$1.txt\").strip()\n"\
"    let data_input: string = readFile(\"inputs/input_$1.txt\").strip()\n\n"\
""\
"    echo &\"Part 1 sample: {part1(data_sample)}\"\n"\
"    #echo &\"Part 1 input:  {part1(data_input)}\"\n"\
"    #echo &\"Part 2 sample: {part2(data_sample)}\"\n"\
"    #echo &\"Part 2 input:  {part2(data_input)}\"\n"\
> "day$1.nim"
echo "day$1.nim"

