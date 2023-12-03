package aoc2023

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode"


FILENAME_SAMPLE_A :: "inputs/sample1a.txt"
FILENAME_SAMPLE_B :: "inputs/sample1b.txt"
FILENAME_INPUT :: "inputs/input1.txt"


open_and_parse :: proc(filename: string) -> (result: [dynamic]string) {
	data, ok := os.read_entire_file_from_filename(filename)
	if !ok {
		fmt.printf("Unable to open file [%s]!\n", filename)
		return
	}

	append_elems(&result, ..strings.split_lines(strings.trim(string(data), "\n")))

	return
}

part1 :: proc(data: [dynamic]string) -> (result: int) {
	for str in data {
		i, j := 0, len(str) - 1
		left, right := -1, -1

		/* one-pass solution */
		for left < 0 || right < 0 {
			if left < 0 && unicode.is_digit(rune(str[i])) {
				left = int(str[i]) - '0'
			}
			i += 1

			if right < 0 && unicode.is_digit(rune(str[j])) {
				right = int(str[j]) - '0'
			}
			j -= 1
		}

		/* two-pass solution
		for char in str {
			if unicode.is_digit(char) {
				left = int(char) - 48
				break
			}
		}
		#reverse for char in str {
			if unicode.is_digit(char) {
				right = int(char) - 48
				break
			}
		}
		*/

		result += left * 10 + right
	}

	return
}

main :: proc() {
	data_sample_a := open_and_parse(FILENAME_SAMPLE_A)
	//data_sample_b := open_and_parse(FILENAME_SAMPLE_B)
	data_input := open_and_parse(FILENAME_INPUT)

	fmt.printf("part 1 sample: %d\n", part1(data_sample_a))  // 142
	fmt.printf("part 1 input:  %d\n", part1(data_input))
	//fmt.printf("part 2 sample: %d\n", part2(data_sample_b))  // 281
	//fmt.printf("part 2 input:  %d\n", part2(data_input))
}

