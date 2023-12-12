package aoc2023

import "core:fmt"
import "core:strconv"
import "core:strings"


FILENAME_SAMPLE :: "inputs/sample5.txt"
FILENAME_INPUT :: "inputs/input5.txt"

MAP_KEYS :: []string{
	"seed-to-soil",
	"soil-to-fertilizer",
	"fertilizer-to-water",
	"water-to-light",
	"light-to-temperature",
	"temperature-to-humidity",
	"humidity-to-location",
}

Instruction :: struct {
	destination, source, range: int
}

AlmanacMaps :: map[string][dynamic]Instruction

Almanac :: struct{
	seeds: []int,
	instruction_maps: AlmanacMaps
}


@(require_results)
parse_ints :: proc(s: string) -> []int {
	ints_strs := strings.split(s, " ")
	ints := make([]int, len(ints_strs))

	for i in 0..<len(ints_strs) {
		ints[i], _ = strconv.parse_int(ints_strs[i])
	}

	delete(ints_strs)
	return ints
}

parse_map_instructions :: proc(inst_str: ^string, inst_array: ^[dynamic]Instruction) {
	for {
		numbers_str, _ := strings.split_iterator(inst_str, "\n");
		if numbers_str == "" do break

		numbers := parse_ints(numbers_str)
		defer delete(numbers)

		instruction := Instruction{
			destination = numbers[0],
			source = numbers[1],
			range = numbers[2],
		}
		// FIXME this leaks memory
		append(inst_array, instruction)
	}
}

parse_data :: proc(data_str: string) -> (result: Almanac) {
	// initialize all map keys
	for map_key in MAP_KEYS do result.instruction_maps[map_key] = {}

	// parse seed numbers
	s := strings.trim(string(data_str), "\n")
	first_line, _ := strings.split_iterator(&s, "\n\n")
	result.seeds = parse_ints(first_line[7:])

	// parse map instructions
	for line in strings.split_iterator(&s, "\n") {
		map_key := strings.split(line, " ")
		defer delete(map_key)

		parse_map_instructions(&s, &result.instruction_maps[map_key[0]])
	}

	return
}

// ----------------------------------------------------------------------------

transform_input :: proc(input, dst, src, range: int) -> (int, bool) {
	if src <= input && input < src + range {
		return input - src + dst, true
	}
	else {
		return -1, false
	}
}

get_seed_location :: proc(seed: int, almanac_maps: AlmanacMaps) -> int {
	input := seed

	for map_key in MAP_KEYS {
		for inst in almanac_maps[map_key] {
			next_input, ok := transform_input(
				input, inst.destination, inst.source, inst.range
			)
			if ok {
				input = next_input
				break
			}
		}
	}

	return input
}

part1 :: proc(data: Almanac) -> (result: int = 4294967296 /* max uint32 */) {
	for seed in data.seeds {
		location := get_seed_location(seed, data.instruction_maps)
		if location < result do result = location
	}

	return
}

part2 :: proc(data: Almanac) -> (result: int = 4294967296 /* max uint32 */) {
	for i := 0; i < len(data.seeds); i += 2 {
		for seed in data.seeds[i]..<data.seeds[i] + data.seeds[i+1] {

			if seed % 1048576 == 0 do fmt.printf("%d %d %d\n", i, seed, result)

			location := get_seed_location(seed, data.instruction_maps)
			if location < result do result = location
		}
	}

	return
}

main :: proc() {
	//data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	//fmt.printf("part 1 sample (35): %d\n", part1(data_sample))
	//fmt.printf("part 1 input: %d\n", part1(data_input))
	//fmt.printf("part 2 sample (46): %d\n", part2(data_sample))
	fmt.printf("part 2 input: %d\n", part2(data_input))

	//delete(data_sample.seeds)
	//delete(data_sample.instruction_maps)
	delete(data_input.seeds)
	delete(data_input.instruction_maps)
}

