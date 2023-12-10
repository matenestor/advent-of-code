package aoc2023

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"


FILENAME_SAMPLE :: "inputs/sample4.txt"
FILENAME_INPUT :: "inputs/input4.txt"

Card :: struct {
	winning, mine: [dynamic]int
}


parse_data :: proc(data_str: string) -> (result: [dynamic]Card) {
	for line in strings.split_lines(strings.trim(string(data_str), "\n")) {
		numbers := strings.split_multi(line, {":", "|"})

		winning := strings.split(strings.trim(numbers[1], " "), " ")
		mine := strings.split(strings.trim(numbers[2], " "), " ")

		card := Card{{}, {}}

		for n_str in winning {
			if n_str == "" do continue
			n, _ := strconv.parse_int(n_str)
			append(&card.winning, n)
		}
		for n_str in mine {
			if n_str == "" do continue
			n, _ := strconv.parse_int(n_str)
			append(&card.mine, n)
		}

		append(&result, card)
	}
	return
}

part1 :: proc(data: [dynamic]Card) -> (result: int) {
	for card in data {
		score := 0

		for winning_number in card.winning {
			if slice.contains(card.mine[:], winning_number) {
				score = score == 0 ? 1 : score * 2
			}
		}

		result += score

		// with exp: (define 'matches := 0' above and increment on match_
		//result += int(math.pow2_f32(matches - 1))
	}
	return
}

part2 :: proc(data: [dynamic]Card) -> (result: int) {
	// total amounts of all cards, both original and copied
	cards_amounts := make([]int, len(data))
	defer delete(cards_amounts)
	for i in 0..<len(cards_amounts) do cards_amounts[i] = 1

	for card, idx in data {
		// find the amount of card's winning numbers
		matches := 0
		for winning_number in card.winning {
			if slice.contains(card.mine[:], winning_number) {
				matches += 1
			}
		}

		// increment the amount of cards (=copy them) below the current card
		for i in idx..<(idx + matches) {
			// '+ cards_amounts[idx]' so the copied cards are included as well
			cards_amounts[i + 1] += cards_amounts[idx]
		}

		result += cards_amounts[idx]
	}
	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample (13): %d\n", part1(data_sample))
	fmt.printf("part 1 input: %d\n", part1(data_input))
	fmt.printf("part 2 sample (30): %d\n", part2(data_sample))
	fmt.printf("part 2 input: %d\n", part2(data_input))
}

