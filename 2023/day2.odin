package aoc2023

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:strings"
import "core:strconv"


FILENAME_SAMPLE :: "inputs/sample2.txt"
FILENAME_INPUT :: "inputs/input2.txt"

Set :: struct {
	red: int,
	green: int,
	blue: int,
}

Games :: [dynamic][dynamic]Set


parse_set :: proc(set: string) -> (result: Set) {
	for item_str in strings.split(strings.trim(set, " "), ", ") {
		item := strings.split(item_str, " ")
		amount, _ := strconv.parse_int(item[0])
		color: string = item[1]

		switch {
			case color == "red":   result.red = amount
			case color == "green": result.green = amount
			case color == "blue":  result.blue = amount
			case: fmt.panicf("Unknown color [%s]", color)
		}
	}
	return
}

open_and_parse :: proc(filename: string) -> (result: Games) {
	data, ok := os.read_entire_file_from_filename(filename)
	if !ok {
		fmt.printf("Unable to open file [%s]!\n", filename)
		return
	}

	split_lines := strings.split_lines(strings.trim(string(data), "\n"))

	for line, index in split_lines {
		game := strings.split(line, ":")[1]
		append(&result, cast([dynamic]Set) {})

		for set_str in strings.split(game, ";") {
			set := parse_set(set_str)
			append(&result[index], set)
		}
	}

	return
}

part1 :: proc(data: Games) -> (result: int) {
	loop: for game, index in data {
		for set in game {
			if set.red > 12 || set.green > 13 || set.blue > 14 {
				// impossible game
				continue loop
			}
		}

		result += index + 1
	}
	return
}

part2 :: proc(data: Games) -> (result: int) {
	for game in data {
		red, green, blue := 0, 0, 0

		for set in game {
			if set.red   > red   { red = set.red }
			if set.green > green { green = set.green }
			if set.blue  > blue  { blue = set.blue }
		}

		result += red * green * blue
	}
	return
}

main :: proc() {
	data_sample := open_and_parse(FILENAME_SAMPLE)
	data_input := open_and_parse(FILENAME_INPUT)

	//fmt.printf("part 1 sample (8): %d\n", part1(data_sample))
    fmt.printf("part 1 input: %d\n", part1(data_input))
	//fmt.printf("part 2 sample (2286): %d\n", part2(data_sample))
	fmt.printf("part 2 input: %d\n", part2(data_input))
}

