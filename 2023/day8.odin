package aoc2023

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"


FILENAME_SAMPLE_A :: "inputs/sample8a.txt"
FILENAME_SAMPLE_B :: "inputs/sample8b.txt"
FILENAME_SAMPLE_C :: "inputs/sample8c.txt"
FILENAME_INPUT :: "inputs/input8.txt"

Map :: struct {
	instructions: string,
	steps: map[string][2]string
}

parse_data :: proc(data_str: string) -> (result: Map) {
	instructions, _, steps := strings.partition(data_str, "\n\n")
	result.instructions = instructions

	for line in strings.split_lines_iterator(&steps) {
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

get_amount_of_steps :: proc(state: string, data: Map) -> (result: int) {
	state := state
	i, lr_idx := 0, 0

	for state[2] != 'Z' {
		lr_idx = data.instructions[i] == 'L' ? 0 : 1
		state = data.steps[state][lr_idx]

		if i += 1; i == len(data.instructions) do i = 0
		result += 1
	}

	return
}

part2 :: proc(data: Map) -> int {
	states: [dynamic]string
	defer delete(states)

	{
		keys, _ := slice.map_keys(data.steps)
		defer delete(keys)

		// get all starting states
		for key in keys {
			if key[2] == 'A' do append(&states, key)
		}
	}

	periods := make([]int, len(states))
	defer delete(periods)

	// get length of the periodical cycles
	for state, i in states {
		periods[i] = get_amount_of_steps(state, data)
	}

	// find lowest common multiple to find out when all states end with 'Z'
	for i in 1..<len(periods) {
		periods[i] = math.lcm(periods[i-1], periods[i])
	}

	return slice.last(periods)
}

main :: proc() {
	data_sample_a := parse_data(#load(FILENAME_SAMPLE_A)); defer delete(data_sample_a.steps)
	data_sample_b := parse_data(#load(FILENAME_SAMPLE_B)); defer delete(data_sample_b.steps)
	data_sample_c := parse_data(#load(FILENAME_SAMPLE_C)); defer delete(data_sample_c.steps)
	data_input := parse_data(#load(FILENAME_INPUT)); defer delete(data_input.steps)

	fmt.printf("part 1 sample A (2): %d\n", part1(data_sample_a))
	fmt.printf("part 1 sample B (6): %d\n", part1(data_sample_b))
	fmt.printf("part 1 input: %d\n", part1(data_input))  // 20221
	fmt.printf("part 2 sample C (6): %d\n", part2(data_sample_c))
	fmt.printf("part 2 input: %d\n", part2(data_input))  // 14616363770447
}

