import math         # sum
import sets         # intersection, toHashSet
import strformat    # echo &"{}"
import strutils     # split
import sugar        # collect, =>


func item_priority(common_item: char): int =
    if isLowerAscii(common_item):
        return ord(common_item) - ord('a') + 1
    else:
        return ord(common_item) - ord('A') + 27


proc part1(data: string): int =
    let items_priorities: seq[int] = collect:
        for line in data.split():
            # rucksack compartments
            let c1: string = line[0..<len(line) div 2]
            let c2: string = line[len(line) div 2..<len(line)]
            # var, other it would not be possible to pop the element
            # the '*' is an alias for 'intersection' proc
            var common_item: HashSet[char] = toHashSet(c1) * toHashSet(c2)

            item_priority(pop(common_item))

    return sum(items_priorities)


proc part2(data: string): int =
    let rucksacks: seq[string] = data.split()

    let items_priorities: seq[int] = collect:
        # take the rucksacks by three at once
        for i in countup(0, len(rucksacks) - 1, 3):
            # multiline expression has to end with an operator/keyword in Nim
            var badge: HashSet[char] =
                toHashSet(rucksacks[i]) *
                toHashSet(rucksacks[i + 1]) *
                toHashSet(rucksacks[i + 2])

            item_priority(pop(badge))

    return sum(items_priorities)


when isMainModule:
    let data_sample: string = readFile("samples/sample_3.txt").strip()
    let data_input: string = readFile("inputs/input_3.txt").strip()

    echo &"Part 1 sample: {part1(data_sample)}"
    echo &"Part 1 input:  {part1(data_input)}"
    echo &"Part 2 sample: {part2(data_sample)}"
    echo &"Part 2 input:  {part2(data_input)}"
