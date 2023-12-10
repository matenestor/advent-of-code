#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo -e "Day number required!\nUsage: ./new_day.sh <day-number> [sample-result] [input-datatype]"
	exit 1
fi

DAY="$1"

touch "inputs/sample$DAY.txt"
echo  "inputs/sample$DAY.txt"
touch "inputs/input$DAY.txt"
echo  "inputs/input$DAY.txt"


if [ -z "$2" ]; then
	SAMPLE_RESULT=""
else
	SAMPLE_RESULT="$2"
fi

if [ -z "$3" ]; then
	INPUT_TYPE="any /*#TODO*/"
else
	INPUT_TYPE="$3"
fi


TEMPLATE="package aoc2023

import \"core:fmt\"
import \"core:strings\"


FILENAME_SAMPLE :: \"inputs/sample$DAY.txt\"
FILENAME_INPUT :: \"inputs/input$DAY.txt\"


parse_data :: proc(data_str: string) -> (result: $INPUT_TYPE) {
	for line in strings.split_lines(strings.trim(string(data_str), \"\\n\")) {
	}
	return
}

part1 :: proc(data: $INPUT_TYPE) -> (result: int) {
	return
}

part2 :: proc(data: $INPUT_TYPE) -> (result: int) {
	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	//data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf(\"part 1 sample ($SAMPLE_RESULT): %d\\n\", part1(data_sample))
	//fmt.printf(\"part 1 input: %d\\n\", part1(data_input))
	//fmt.printf(\"part 2 sample (): %d\\n\", part2(data_sample))
	//fmt.printf(\"part 2 input: %d\\n\", part2(data_input))
}
"
echo "$TEMPLATE" > "day$DAY.odin"
echo "day$DAY.odin"

