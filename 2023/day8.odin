package aoc2023

import "core:fmt"
import "core:strings"


FILENAME_SAMPLE_A :: "inputs/sample8a.txt"
FILENAME_SAMPLE_B :: "inputs/sample8b.txt"
FILENAME_INPUT :: "inputs/input8.txt"

Map :: struct {
	instructions: string,
	steps: map[string][2]string
}

parse_data :: proc(data_str: string) -> (result: Map) {
	// redefine, otherwise Odin can't take a pointer for the iterator
	data_str := data_str

	first_line, _ := strings.split_iterator(&data_str, "\n\n")
	result.instructions = first_line

	for line in strings.split_lines_iterator(&data_str) {
		state, left, right := line[:3], line[7:10], line[12:15]
		result.steps[state] = {left, right}
	}

	return
}

part1 :: proc(data: Map) -> (result: int) {
	state := "AAA"
	i, lr_idx := 0, 0

	for state != "ZZZ" {
		lr_idx = data.instructions[i] == 'L' ? 0 : 1
		state = data.steps[state][lr_idx]

		if i += 1; i == len(data.instructions) do i = 0
		result += 1
	}

	return
}

part2 :: proc(data: Map) -> (result: int) {
	return
}

main :: proc() {
	data_sample_a := parse_data(#load(FILENAME_SAMPLE_A))
	data_sample_b := parse_data(#load(FILENAME_SAMPLE_B))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample A (2): %d\n", part1(data_sample_a))
	fmt.printf("part 1 sample B (6): %d\n", part1(data_sample_b))
	fmt.printf("part 1 input: %d\n", part1(data_input))
	//fmt.printf("part 2 sample (): %d\n", part2(data_sample))
	//fmt.printf("part 2 input: %d\n", part2(data_input))

	delete(data_sample_a.steps)
	delete(data_sample_b.steps)
	delete(data_input.steps)
}

