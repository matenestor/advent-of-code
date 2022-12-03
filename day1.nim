import algorithm    # sorted
import math         # sum
import sequtils     # map
import strformat    # echo &"{}"
import strutils     # split
import sugar        # collect, =>


proc part1_imperative(data: string): int =
    var calories: seq[int]
    var calorie_chunk: int = 0

    for line in data.split():
        if line != "":
            calorie_chunk += parseInt(line)
        else:
            calories.add(calorie_chunk)
            calorie_chunk = 0
    # without the last empty line, the last chunk sum
    # would not get appended
    calories.add(calorie_chunk)

    return calories.sorted(SortOrder.Descending)[0]


proc part1_comprehension(data: string): int =
    # the collect' is a macro from std/sugar module
    let calories: seq[int] = collect:
        for chunk in data.split("\n\n"):
            # single chunk sums
            let chunk_sum: seq[int] = collect:
                for line in chunk.split():
                    parseInt(line)
            chunk_sum.sum()

    return calories.sorted(SortOrder.Descending)[0]


proc part1_functional(data: string): int =
    return data
        .split("\n\n")
        .map(proc(x: string): seq[string] = x.split())
        .map(proc(x: seq[string]): seq[int] =
            x.map(proc(x2: string): int = parseInt(x2))
        )
        .map(proc(x: seq[int]): int = sum(x))
        .sorted(SortOrder.Descending)[0]


proc part1_sugar(data: string): int =
    # the '=>' is a macro from std/sugar module
    return data
        .split("\n\n")
        .map(x => x.split())
        .map(x => x.map(x2 => parseInt(x2)))
        .map(x => sum(x))
        .sorted(SortOrder.Descending)[0]


proc part2(data: string): int =
    return data
        .split("\n\n")
        .map(x => x.split())
        .map(x => x.map(x2 => parseInt(x2)))
        .map(x => sum(x))
        .sorted(SortOrder.Descending)[0..2]
        .sum()


when isMainModule:
    let data_sample: string = readFile("samples/sample_1.txt").strip()
    let data_input: string = readFile("inputs/input_1.txt").strip()

    echo &"Part 1 sample impr: {part1_imperative(data_sample)}"
    echo &"Part 1 sample cmpr: {part1_comprehension(data_sample)}"
    echo &"Part 1 sample func: {part1_functional(data_sample)}"
    echo &"Part 1 sample sugr: {part1_sugar(data_sample)}"
    echo &"Part 1 input impr:  {part1_imperative(data_input)}"
    echo &"Part 1 input cmpr:  {part1_comprehension(data_input)}"
    echo &"Part 1 input func:  {part1_functional(data_input)}"
    echo &"Part 1 input sugr:  {part1_sugar(data_input)}"
    echo ""
    echo &"Part 2 sample: {part2(data_sample)}"
    echo &"Part 2 input:  {part2(data_input)}"
