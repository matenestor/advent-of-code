package aoc2023

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:strings"
import "core:strconv"


FILENAME_SAMPLE :: "inputs/sample2.txt"
FILENAME_INPUT :: "inputs/input2.txt"


Game :: struct {
	red: int,
	green: int,
	blue: int,
}

open_and_parse :: proc(filename: string) -> (result: [dynamic]Game) {
	data, ok := os.read_entire_file_from_filename(filename)
	if !ok {
		fmt.printf("Unable to open file [%s]!\n", filename)
		return
	}

	split_lines := strings.split_lines(strings.trim(string(data), "\n"))
	for line in split_lines {
		splits := []string{": ", ", ", "; "}
		// [5:] to cut out "Game "
		sets := strings.split_multi(line[5:], splits)

		game := Game{}

		// [1:] to cut omit the remaing number after "Game <number>:"
		for set_str in sets[1:] {
			set := strings.split(set_str, " ")
			amount, _ := strconv.parse_int(set[0])
			color: string = set[1]

			switch {
				case color == "red":   game.red += amount
				case color == "green": game.green += amount
				case color == "blue":  game.blue += amount
				case: panic("Unreachable: unknown colow")
			}
		}

		append(&result, game)
	}

	return
}

part1 :: proc(data: [dynamic]Game) -> (result: int) {
	for game, index in data {
		if game.red <= 12 && game.green <= 13 && game.blue <= 14 {
			//fmt.printf("%d %v\n", index+1, game)
			result += index + 1
		}
	}
	return
}

part2 :: proc(data: [dynamic]Game) -> (result: int) {
	return
}

main :: proc() {
	data_sample := open_and_parse(FILENAME_SAMPLE)
	data_input := open_and_parse(FILENAME_INPUT)

	fmt.printf("part 1 sample (8): %d\n", part1(data_sample))
    fmt.printf("part 1 input: %d\n", part1(data_input))
	//fmt.printf("part 2 sample (): %d\n", part2(data_sample))
	//fmt.printf("part 2 input: %d\n", part2(data_input))
}

