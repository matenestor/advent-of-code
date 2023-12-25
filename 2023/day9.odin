package aoc2023

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"


FILENAME_SAMPLE :: "inputs/sample9.txt"
FILENAME_INPUT :: "inputs/input9.txt"

// a proc from day 5
@(require_results)
parse_ints :: proc(s: string) -> []int {
	ints_strs := strings.split(s, " ")
	ints := make([]int, len(ints_strs))

	for i in 0..<len(ints) {
		ints[i], _ = strconv.parse_int(ints_strs[i])
	}

	delete(ints_strs)
	return ints
}

parse_data :: proc(data_str: string) -> [][]int {
	// redefine, otherwise Odin can't take a pointer for the iterator
	data_str := data_str

	result := make([][]int, strings.count(data_str, "\n"))

	i := 0
	for line in strings.split_lines_iterator(&data_str) {
		result[i] = parse_ints(line)
		i += 1
	}

	return result
}

part1 :: proc(data: [][]int) -> (result: int) {
	// 1 3 6 10 15 21 | 28
	// 0 2 3  4  5  6 |  7
	// 0 0 1  1  1  1 |  1
	// 0 0 0  0  0  0 |  0

	history := make([]int, len(data[0]))
	defer delete(history)

	for row in data {
		// copy the current row so it can be transformed
		copy(history, row)
		prediction := slice.last(history)
		threshold := 0

		for !slice.all_of(history, 0) {
			// find a difference between each pair of numbers
			for i := len(history) - 1; i > threshold; i -= 1 {
				history[i] -= history[i - 1]
			}
			// and clear the remainder in the beginning
			history[threshold] = 0

			prediction += slice.last(history)
			threshold += 1
		}

		result += prediction
	}

	return
}

part2 :: proc(data: [][]int) -> (result: int) {
	/*
	The sign changes with every new row, because the numbers to subtract with
	are being added as follows:

	0 | 1 3 6 10 15 21       5 | 10 13 16 21 30 45
	1 | 2 3 4  5  6  0       5 |  3  3  5  9 15  0
	1 | 1 1 1  1  0  0      -2 |  0  2  4  6  0  0
	0 | 0 0 0  0  0  0       2 |  2  2  2  0  0  0
                             0 |  0  0  0  0  0  0
	1 - x1
	1 - (2 - x2)            10 - x1
	1 - (2 - (1 - x3))      10 - (3 - x2)
	1 - (2 - (1 - 0))       10 - (3 - (0 - x3))
                            10 - (3 - (0 - (2 - x4)))
	1 - (2 -  1 + 0 )       10 - (3 - (0 - (2 - 0)))
	1 -  2 +  1 - 0
                            10 - (3 - (0 -  2 + 0 ))
	                        10 - (3 -  0 +  2 - 0  )
	                        10 -  3 +  0 -  2 + 0
	*/

	history := make([]int, len(data[0]))
	defer delete(history)

	for row in data {
		// copy the current row so it can be transformed
		copy(history, row)
		prediction := history[0]
		threshold := len(history) - 1
		// see the star-comment above for the 'sign' explanation
		sign := -1

		for !slice.all_of(history, 0) {
			// find a difference between each pair of numbers
			for i in 0..<threshold {
				// NOTE I had a bug here. Do: big-number minus small-number.
				history[i] = history[i + 1] - history[i]
			}
			// and clear the remainder in the end
			history[threshold] = 0

			prediction += sign * history[0]
			threshold -= 1
			sign *= -1
		}

		result += prediction
	}

	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample (114): %d\n", part1(data_sample))
	fmt.printf("part 1 input: %d\n", part1(data_input))  // 2175229206
	fmt.printf("part 2 sample (2): %d\n", part2(data_sample))
	fmt.printf("part 2 input: %d\n", part2(data_input))  // 942

	for line in data_sample do delete(line)
	delete(data_sample)
	for line in data_input do delete(line)
	delete(data_input)
}

