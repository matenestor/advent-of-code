package aoc2023

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:slice"
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
			// NOTE: string.index_any(str, "123456789") can be used instead
			if left < 0 && unicode.is_digit(rune(str[i])) {
				left = int(str[i]) - '0'
			}
			i += 1

			// NOTE: string.last_index_any(str, "123456789") can be used instead
			if right < 0 && unicode.is_digit(rune(str[j])) {
				right = int(str[j]) - '0'
			}
			j -= 1
		}

		/* two-pass solution
		for char in str {
			if unicode.is_digit(char) {
				left = int(char) - '0'
				break
			}
		}
		#reverse for char in str {
			if unicode.is_digit(char) {
				right = int(char) - '0'
				break
			}
		}
		*/

		result += left * 10 + right
	}

	return
}

last_index_multi :: proc(s: string, substrs: []string) -> (idx: int = -1, width: int) {
	for substr in substrs {
		idx_ := strings.last_index(s, substr);
		if idx_ > idx {
			idx = idx_
			width = len(substr)
		}
	}
	return
}

part2 :: proc(data: [dynamic]string) -> (result: int) {
	digits_words := []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

	for str in data {
		left, right := 0, 0

		ldi := strings.index_any(str, "123456789")
		lwi, width_left := strings.index_multi(str, digits_words)

		if (lwi < ldi && lwi != -1) || ldi == -1 {
			// there is a word and it comes EARLIER, or there is no digit
			// then parse a word
			left, _ = slice.linear_search(digits_words, str[lwi:lwi + width_left])
			left += 1
		}
		else if (ldi < lwi && ldi != -1) || lwi == -1 {
			// there is a digit and it comes EARLIER, or there is no word
			// then parse a digit
			left = int(str[ldi]) - '0'
		}
		else {
			panic("unreachable: left")
		}

		rdi := strings.last_index_any(str, "123456789")
		rwi, width_right := last_index_multi(str, digits_words)

		if rwi > rdi || rdi == -1 {
			// there is a word and it comes LATER, or there is no digit
			// then parse a word
			right, _ = slice.linear_search(digits_words, str[rwi:rwi + width_right])
			right += 1
		}
		else if rdi > rwi || rwi == -1 {
			// there is a digit and it comes LATER, or there is no word
			// then parse a digit
			right = int(str[rdi]) - '0'
		}
		else {
			panic("unreachable: right")
		}

		result += left * 10 + right
	}

	return
}

main :: proc() {
	data_sample_a := open_and_parse(FILENAME_SAMPLE_A)
	data_sample_b := open_and_parse(FILENAME_SAMPLE_B)
	data_input := open_and_parse(FILENAME_INPUT)

	fmt.printf("part 1 sample (142): %d\n", part1(data_sample_a))
	fmt.printf("part 1 input: %d\n", part1(data_input))
	fmt.printf("part 2 sample (281): %d\n", part2(data_sample_b))
	fmt.printf("part 2 input: %d\n", part2(data_input))
}

