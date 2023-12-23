package aoc2023

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"


FILENAME_SAMPLE :: "inputs/sample6.txt"
FILENAME_INPUT :: "inputs/input6.txt"

Race :: struct {
	time, distance: int
}


@(require_results)
parse_ints :: proc(s: string) -> (result: [dynamic]int) {
	ints_strs := strings.split(s, " ")

	for i in 0..<len(ints_strs) {
		if ints_strs[i] == "" do continue
		num, _ := strconv.parse_int(ints_strs[i])
		// PERF do not use append
		append(&result, num)
	}

	delete(ints_strs)
	return
}

parse_data :: proc(data_str: string) -> (result: [dynamic]Race) {
	lines, _ := strings.split_lines(data_str)
	time_str, _ := strings.split(lines[0], ":")
	distance_str, _ := strings.split(lines[1], ":")
	defer delete(lines)
	defer delete(time_str)
	defer delete(distance_str)

	time := parse_ints(time_str[1])
	distance := parse_ints(distance_str[1])
	defer delete(time)
	defer delete(distance)

	for i in 0..<len(time) {
		race := Race{time[i], distance[i]}
		append(&result, race)
	}

	return
}

part1 :: proc(data: [dynamic]Race) -> (result: int = 1) {
	for race, i in data {
		ways_to_win := 0

		for secs_held in 1..<race.time {
			distance := secs_held * (race.time - secs_held)
			if distance > race.distance do ways_to_win += 1
		}

		result *= ways_to_win
	}

	return
}

part2 :: proc(data: [dynamic]Race) -> (result: int) {
	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample (288): %d\n", part1(data_sample))
	fmt.printf("part 1 input: %d\n", part1(data_input))
	//fmt.printf("part 2 sample (): %d\n", part2(data_sample))
	//fmt.printf("part 2 input: %d\n", part2(data_input))

	delete(data_sample)
}

