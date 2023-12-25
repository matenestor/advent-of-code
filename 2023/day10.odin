package aoc2023

import "core:fmt"
import "core:slice"
import "core:strings"

VISUALIZE :: false

FILENAME_SAMPLE_A :: "inputs/sample10a.txt"
FILENAME_SAMPLE_B :: "inputs/sample10b.txt"
FILENAME_INPUT :: "inputs/input10.txt"

Direction :: enum { Top, Right, Down, Left }
PipeTypes :: bit_set['-'..='|']
Vector2 :: struct { x, y: int }

// what pipes it is possible to move *from*
DirMoveFromC :: [Direction]PipeTypes {
	.Top   = {'|', 'L', 'J'},
	.Right = {'-', 'L', 'F'},
	.Down  = {'|', 'F', '7'},
	.Left  = {'-', 'J', '7'},
}
// what pipes it is possible to move *into*
DirMoveIntoC :: [Direction]PipeTypes {
	.Top   = {'|', 'F', '7'},
	.Right = {'-', '7', 'J'},
	.Down  = {'|', 'L', 'J'},
	.Left  = {'-', 'F', 'L'},
}
DirVectorC :: [Direction]Vector2 {
	.Top   = {  0, -1 },
	.Right = { +1,  0 },
	.Down  = {  0, +1 },
	.Left  = { -1,  0 },
}
DirOppositeC :: [Direction]Direction {
	.Top   = .Down,
	.Right = .Left,
	.Down  = .Top,
	.Left  = .Right,
}

/*
A message from the Odin compiler:

	Cannot index a constant 'Dir*'
	Suggestion: store the constant into a variable
	in order to index it with a variable index

It is not possible to index the constant enumerated arrays
with a loop variable (a variable index).

*/
DirMoveFrom := DirMoveFromC
DirMoveInto := DirMoveIntoC
DirVector := DirVectorC
DirOpposite := DirOppositeC

parse_data :: proc(data_str: string) -> []string {
	return strings.split_lines(strings.trim(data_str, "\n"))
}

is_within_map :: proc(x, y, w, h: int) -> bool {
	return (0 <= x && x < w) && (0 <= y && y < h)
}

is_valid_field :: proc(current_field, next_field: rune, dir: Direction) -> bool {
	can_move_from := current_field in DirMoveFrom[dir] || current_field == 'S'
	can_move_into := next_field in DirMoveInto[dir] || next_field == 'S'

	// the current and the next pipes are connected
	return can_move_from && can_move_into
}

make_step :: proc(x, y: ^int, back_dir: ^Direction, data: []string) -> (moved: bool) {
	for dir in Direction {
		if dir == back_dir^ do continue

		nx := x^ + DirVector[dir].x
		ny := y^ + DirVector[dir].y

		if !is_within_map(nx, ny, len(data), len(data[0])) do continue

		cf := rune(data[y^][x^])
		nf := rune(data[ny][nx])

		if is_valid_field(cf, nf, dir) {
			x^ += DirVector[dir].x
			y^ += DirVector[dir].y
			back_dir^ = DirOpposite[dir]
			moved = true
			break
		}
	}

	return
}

visualize :: proc(visited: [][2]int, data: []string) {
	normal := "\033[0m"
	red    := "\033[0;31m"
	green  := "\033[0;32m"

	for i in 0..<len(data) {
		for j in 0..<len(data[i]) {
			if slice.contains(visited, [2]int{j, i}) {
				if data[i][j] == 'S' {
					fmt.printf("%sS%s", green, normal)
				}
				else {
					fmt.printf("%s%c%s", red, data[i][j], normal)
				}
			}
			else {
				fmt.print(rune(data[i][j]))
			}
		}
		fmt.println()
	}
}

part1 :: proc(data: []string) -> int {
	// find the Starting position
	sx, sy := -1, -1
	for sx == -1 {
		sy += 1
		sx = strings.index(data[sy], "S")
	}

	x, y := sx, sy
	back_dir: Direction
	traveled := 1

	when VISUALIZE {
		visited := [dynamic][2]int{ {x, y} }
		// "The statements within a branch do not create a new scope",
		// so this is defered until the end of the proc's scope.
		// https://odin-lang.org/docs/overview/#when-statement
		defer delete(visited)
	}

	make_step(&x, &y, &back_dir, data)
	when VISUALIZE do append(&visited, [2]int{x, y})
	// while not at the Starting position again
	for !(x == sx && y == sy) {
		make_step(&x, &y, &back_dir, data)
		when VISUALIZE do append(&visited, [2]int{x, y})
		traveled += 1
	}

	when VISUALIZE do visualize(visited[:], data)

	return traveled / 2
}

part2 :: proc(data: []string) -> (result: int) {
	return
}

main :: proc() {
	data_sample_a := parse_data(#load(FILENAME_SAMPLE_A))
	data_sample_b := parse_data(#load(FILENAME_SAMPLE_B))
	data_input := parse_data(#load(FILENAME_INPUT))

	fmt.printf("part 1 sample A (4): %d\n", part1(data_sample_a))
	fmt.printf("part 1 sample B (8): %d\n", part1(data_sample_b))
	fmt.printf("part 1 input: %d\n", part1(data_input))  // 6812
	//fmt.printf("part 2 sample (): %d\n", part2(data_sample))
	//fmt.printf("part 2 input: %d\n", part2(data_input))

	delete(data_sample_a)
	delete(data_sample_b)
	delete(data_input)
}

