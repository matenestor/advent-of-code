package aoc2023

import "core:fmt"
import "core:math"
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
	for race in data {
		ways_to_win := 0

		for secs_held in 1..<race.time {
			distance := secs_held * (race.time - secs_held)
			if distance > race.distance do ways_to_win += 1
		}

		result *= ways_to_win
	}

	return
}

number_length :: proc(number: int) -> f32 {
	num_len := int(math.log10(f32(number)) + 1)
	return f32(num_len)
}

get_actual_values :: proc(data: [dynamic]Race) -> (int, int) {
	// convert input numbers from all races to a single number
	// (I am not writing another parsing for that..)

	actual_time, actual_distance := data[0].time, data[0].distance

	for i in 1..<len(data) {
		shift := int(math.pow10_f32(number_length(data[i].time)))
		actual_time *= shift
		actual_time += data[i].time

		shift = int(math.pow10_f32(number_length(data[i].distance)))
		actual_distance *= shift
		actual_distance += data[i].distance
	}

	return actual_time, actual_distance
}

part2 :: proc(data: [dynamic]Race) -> (result: int) {
	actual_time, actual_distance := get_actual_values(data)

	// 1. brute force
	//for secs_held in 1..<actual_time {
	//	distance := secs_held * (actual_time - secs_held)
	//	if distance > actual_distance do result += 1
	//}

	// 2. go from sides only until intersection
	distance, i := 0, 1
	for distance < actual_distance {
		distance = i * (actual_time - i)
		i += 1
	}
	result -= (i - 1)

	distance, i = 0, actual_time
	for distance < actual_distance {
		distance = i * (actual_time - i)
		i -= 1
	}
	result += (i + 1)

	// plus one, because the range is inclusive
	result += 1

	// 3. I could also solve the quadratic formula equation,
	//    but this runs fast enough..

	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample (288): %d\n", part1(data_sample))
	fmt.printf("part 1 input: %d\n", part1(data_input))  // 252000
	fmt.printf("part 2 sample (71503): %d\n", part2(data_sample))
	fmt.printf("part 2 input: %d\n", part2(data_input))  // 36992486

	delete(data_sample)
	delete(data_input)
}

