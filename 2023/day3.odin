package aoc2023

import "core:bytes"
import "core:fmt"
import "core:strconv"
import "core:strings"


FILENAME_SAMPLE :: "inputs/sample3.txt"
FILENAME_INPUT :: "inputs/input3.txt"

Coords :: struct {
	x, y, width: int,
	number: int
}

EngineSchema :: map[string][dynamic]Coords


parse_number_width :: proc(s: string) -> (width: int) {
	char := s[width]
	for char >= '0' && char <= '9' {
		width += 1
		if width == len(s) {
			break
		}
		char = s[width]
	}
	return
}

parse_data :: proc(data_str: string) -> (result: EngineSchema) {
	result = {
		"symbols" = {},
		"numbers" = {},
	}
	symbols: bit_set['#'..='@'] = {'#', '$', '%', '&', '*', '+', '-', '/', '=', '@'}

	for line, y in strings.split_lines(data_str) {
		for x := 0; x < len(line); {
			char := line[x]

			if char == '.' {
				x += 1
				continue
			}

			if char >= '0' && char <= '9' {
				width := parse_number_width(line[x:])
				value, _ := strconv.parse_int(line[x:x + width])
				append(&result["numbers"], Coords{x, y, width, value})
				x += width
			}

			if rune(char) in symbols {
				append(&result["symbols"], Coords{x, y, 1, int(char)})
				x += 1
			}
		}
	}

	return
}

part1 :: proc(data: EngineSchema) -> (result: int) {
	for symbol in data["symbols"] {
		for number in data["numbers"] {
			// not the same or adjacent row
			if abs(symbol.y - number.y) > 1 {
				continue
			}
			// a number is to far right
			if symbol.x < number.x && abs(symbol.x - number.x) > 1 {
				continue
			}
			// a number is to far left
			// NOTE additional problems would occur with number.width > 3 in the puzzle input
			if (abs(symbol.x - (number.x + number.width - 1)) > 1
				&& abs(symbol.x - number.x) > 1) {
				continue
			}

			result += number.number
		}
	}

	return
}

part2 :: proc(data: EngineSchema) -> (result: int) {
	for symbol in data["symbols"] {
		if symbol.number != '*' {
			continue
		}

		gear_ratio, nums_found := 1, 0

		for number in data["numbers"] {
			// not the same or adjacent row
			if abs(symbol.y - number.y) > 1 {
				continue
			}
			// a number is to far right
			if symbol.x < number.x && abs(symbol.x - number.x) > 1 {
				continue
			}
			// a number is to far left
			// NOTE additional problems would occur with number.width > 3 in the puzzle input
			if (abs(symbol.x - (number.x + number.width - 1)) > 1
				&& abs(symbol.x - number.x) > 1) {
				continue
			}

			gear_ratio *= number.number
			nums_found += 1
		}

		if nums_found >= 2 {
			result += gear_ratio
		}
	}

	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample (4361): %d\n", part1(data_sample))
	fmt.printf("part 1 input: %d\n", part1(data_input))
	fmt.printf("part 2 sample (467835): %d\n", part2(data_sample))
	fmt.printf("part 2 input: %d\n", part2(data_input))
}

