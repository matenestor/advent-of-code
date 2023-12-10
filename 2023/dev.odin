package aoc2023

import "core:bytes"
import "core:fmt"
import "core:strings"

EngineSchema :: map[string][]int

main :: proc() {
	es: EngineSchema = {
		"x" = {1,2,3},
		"y" = {10,20,30},
	}
	es2: []int = make({1,2,3})

	//fmt.println(es)
	//append(&es["x"], 4)
	//fmt.println(es)

	fmt.println(es2)
	append(&es2["x"], 4)
	fmt.println(es2)

}

