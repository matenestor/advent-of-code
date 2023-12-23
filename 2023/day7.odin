package aoc2023

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"


FILENAME_SAMPLE :: "inputs/sample7.txt"
FILENAME_INPUT :: "inputs/input7.txt"

HandType :: enum {
	Empty,
	HighCard,		// 1
	OnePair,		// 2
	TwoPair,		// 2, 2
	ThreeOfAKind,	// 3
	FullHouse,		// 3, 2
	FourOfAKind,	// 4
	FiveOfAKind,	// 5
}

Hand :: struct {
	cards: string,
	bid: int,
	// 2, 3, 4, 5, 6, 7, 8, 9, T, J, Q, K, A
	cards_amounts: [13]int,
	hand_type: HandType
}

JokerIdx :: 9

parse_data :: proc(data_str: string) -> []Hand {
	// redefine, other Odin can't take a pointer for the iterator
	data_str := data_str

	size := strings.count(data_str, "\n")
	result := make([]Hand, size)

	/*
	 * In order to use an enumerated iterator, implement it yourself:
	 *
	 * LineIter :: struct {
	 * 	data: string,
	 * 	idx: int,
	 * }
	 *
	 * iterate :: proc(iter: ^LineIter) -> (line: string, line_no: int, ok: bool)
	 *
	 * it := LineIter{data}
	 * for line, line_no in iterate(&it) {}
	 */

	i := 0
	for line in strings.split_lines_iterator(&data_str) {
		line_split, _ := strings.split(line, " ")
		bid, _ := strconv.parse_int(line_split[1])
		result[i] = Hand{line_split[0], bid, {}, HandType.Empty}
		i += 1

		delete(line_split)
	}
	return result
}

// TODO count_cards_amounts :: proc(cards: string, cards_amounts: [13]int) {
count_cards_amounts :: proc(hand: ^Hand) {
	for card in hand^.cards {
		switch card {
			case '2'..='9': hand^.cards_amounts[card - '2'] += 1
			case 'T': hand^.cards_amounts[8] += 1
			case 'J': hand^.cards_amounts[9] += 1
			case 'Q': hand^.cards_amounts[10] += 1
			case 'K': hand^.cards_amounts[11] += 1
			case 'A': hand^.cards_amounts[12] += 1
			case: panic("Unreachable")
		}
	}
}

// ===== PART 1 ===============================================================

init_hand_type :: proc(hand: ^Hand) {
	// TODO how to use array in slice module procs?
	cards_amounts := hand^.cards_amounts[:]

	if slice.contains(cards_amounts, 5) {
		hand^.hand_type = HandType.FiveOfAKind
	}
	else if slice.contains(cards_amounts, 4) {
		hand^.hand_type = HandType.FourOfAKind
	}
	else if slice.contains(cards_amounts, 3) && slice.contains(cards_amounts, 2) {
		hand^.hand_type = HandType.FullHouse
	}
	else if slice.contains(cards_amounts, 3) {
		hand^.hand_type = HandType.ThreeOfAKind
	}
	else if slice.contains(cards_amounts, 2) && slice.count(cards_amounts, 2) == 2 {
		hand^.hand_type = HandType.TwoPair
	}
	else if slice.contains(cards_amounts, 2)  {
		hand^.hand_type = HandType.OnePair
	}
	else {
		hand^.hand_type = HandType.HighCard
	}
}

/*
The ASCII value of T J Q K A are not in order, so this will add/subtract a
necessary amount, so the cards (even though invalid now) will fit into a
sequence and it will be possible to compare the chars easily.

The original becomes:

	2 50     2    50
	3 51     3    51
	4 52     4    52
	5 53     5    53
	6 54     6    54
	7 55     7    55
	8 56     8    56
	9 57     9    57
	T 84     T->I 73
	J 74     J    74
	Q 81     Q    81
	K 75     K->R 82
	A 65     A->S 83
*/
normalize_card :: proc(c: u8) -> u8 {
	switch c {
		case 'T': return 'I'
		case 'K': return 'R'
		case 'A': return 'S'
		case: return c
	}
}

sort_cards :: proc(a, b: Hand) -> bool {
	if a.hand_type != b.hand_type do return a.hand_type < b.hand_type

	a_card: u8 = '0'
	b_card: u8 = '0'
	for i in 0..<5 {
		if a.cards[i] == b.cards[i] do continue

		a_card = normalize_card(a.cards[i])
		b_card = normalize_card(b.cards[i])
		break
	}

	return a_card < b_card
}

part1 :: proc(data: []Hand) -> (result: int) {
	// classify hands and cards
	// TODO how to address an iterable variable, so a pointer can be sent to a proc?
	//      e.g. 'hand' in 'for hand in data'
	for i in 0..<len(data) {
		// TODO how to do this without copying?
		hand := data[i]
		count_cards_amounts(&hand)
		init_hand_type(&hand)
		data[i] = hand
	}

	// sort by hand type and card values
	slice.sort_by(data, sort_cards)

	for i in 0..<len(data) {
		result += (i+1) * data[i].bid
	}

	// data had been cloned in here
	delete(data)
	return
}

// ===== PART 2 ===============================================================

init_hand_type_with_jokers :: proc(hand: ^Hand) {
	// TODO how to use array in slice module procs?
	cards_amounts := hand^.cards_amounts[:]

	switch {
	case slice.contains(cards_amounts, 5):
		hand^.hand_type = HandType.FiveOfAKind

	case slice.contains(cards_amounts, 4):
		jokers_amount := hand^.cards_amounts[JokerIdx]

		// either four, or one joker card; in both cases it is a five of a kind
		if jokers_amount == 4 || jokers_amount == 1 {
			hand^.hand_type = HandType.FiveOfAKind
		}
		else {
			hand^.hand_type = HandType.FourOfAKind
		}

	case slice.contains(cards_amounts, 3):
		// 3J and 2:	5oK
		// 3J (and 1):	4oK
		// 2J and 3:	5oK
		// 1J and 3:	4oK
		// 3 and 2:		FH
		// _:			3oK

		jokers_amount := hand^.cards_amounts[JokerIdx]

		if (jokers_amount == 3 && slice.contains(cards_amounts, 2)) || jokers_amount == 2 {
			hand^.hand_type = HandType.FiveOfAKind
		}
		else if jokers_amount == 3 || jokers_amount == 1 {
			hand^.hand_type = HandType.FourOfAKind
		}
		else if slice.contains(cards_amounts, 2) {
			hand^.hand_type = HandType.FullHouse
		}
		else {
			hand^.hand_type = HandType.ThreeOfAKind
		}

	case slice.contains(cards_amounts, 2) && slice.count(cards_amounts, 2) == 2:
		jokers_amount := hand^.cards_amounts[JokerIdx]

		if jokers_amount == 2 {
			hand^.hand_type = HandType.FourOfAKind
		}
		else if jokers_amount == 1 {
			// one joker and two pairs of other cards is a full house
			hand^.hand_type = HandType.FullHouse
		}
		else {
			hand^.hand_type = HandType.TwoPair
		}

	case slice.contains(cards_amounts, 2):
		jokers_amount := hand^.cards_amounts[JokerIdx]

		// either two, or one joker card; in both cases it is a three of a kind
		if jokers_amount == 2 || jokers_amount == 1 {
			hand^.hand_type = HandType.ThreeOfAKind
		}
		else {
			hand^.hand_type = HandType.OnePair
		}

	case:
		if hand^.cards_amounts[JokerIdx] == 1 {
			hand^.hand_type = HandType.OnePair
		}
		else {
			hand^.hand_type = HandType.HighCard
		}
	}
}

// see doc string at 'normalize_card'
normalize_card_with_jokers :: proc(c: u8) -> u8 {
	switch c {
		case 'J': return '0'  // J is the weakest card as a joker
		case 'T': return 'I'
		case 'K': return 'R'
		case 'A': return 'S'
		case: return c
	}
}

sort_cards_with_jokers :: proc(a, b: Hand) -> bool {
	if a.hand_type != b.hand_type do return a.hand_type < b.hand_type

	a_card: u8 = '0'
	b_card: u8 = '0'
	for i in 0..<5 {
		if a.cards[i] == b.cards[i] do continue

		a_card = normalize_card_with_jokers(a.cards[i])
		b_card = normalize_card_with_jokers(b.cards[i])
		break
	}

	return a_card < b_card
}

part2 :: proc(data: []Hand) -> (result: int) {
	for i in 0..<len(data) {
		hand := data[i]
		count_cards_amounts(&hand)
		init_hand_type_with_jokers(&hand)
		data[i] = hand
	}

	slice.sort_by(data, sort_cards_with_jokers)

	for i in 0..<len(data) {
		result += (i+1) * data[i].bid
	}

	// data had been cloned in here
	delete(data)
	return
}

main :: proc() {
	data_sample := parse_data(#load(FILENAME_SAMPLE))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample (6440): %d\n", part1(slice.clone(data_sample)))
	fmt.printf("part 1 input: %d\n", part1(slice.clone(data_input)))  // 253866470
	fmt.printf("part 2 sample (5905): %d\n", part2(slice.clone(data_sample)))
	fmt.printf("part 2 input: %d\n", part2(slice.clone(data_input)))  // 254494947

	delete(data_sample)
	delete(data_input)
}

