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

touch "samples/sample$1.txt"
echo "samples/sample$1.txt"

touch "inputs/input$1.txt"
echo "inputs/input$1.txt"


echo -e "import std/[\n"\
"    algorithm,    # sorted\n"\
"    math,         # sum\n"\
"    sequtils,     # map\n"\
"    sets,         # intersection, toHashSet\n"\
"    setutils,     # toSet\n"\
"    strformat,    # echo &\"{}\"\n"\
"    strscans,     # scanf\n"\
"    strutils,     # split\n"\
"    sugar,        # collect, =>\n"\
"    tables,       # toTable\n"\
"]\n\n\n"\
\
"proc part1(data: string): int =\n"\
"    return 0\n\n\n"\
\
"proc part2(data: string): int =\n"\
"    return 0\n\n\n"\
\
"when isMainModule:\n"\
"    let dataSample: string = readFile(\"samples/sample$1.txt\").strip()\n"\
"    let dataInput: string = readFile(\"inputs/input$1.txt\").strip()\n\n"\
""\
"    echo &\"Part 1 sample: {part1(dataSample)}\"\n"\
"    #echo &\"Part 1 input:  {part1(dataInput)}\"\n"\
"    #echo &\"Part 2 sample: {part2(dataSample)}\"\n"\
"    #echo &\"Part 2 input:  {part2(dataInput)}\"\n"\
> "day$1.nim"
echo "day$1.nim"

