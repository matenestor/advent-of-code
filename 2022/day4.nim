import sequtils     # map
import strformat    # echo &"{}"
import strutils     # split
import sugar        # collect, =>


func `in`(a, b: HSlice[int, int]): bool =
    ## Check if a range is a subrange of other range.
    ## E.g.:
    ##   2..3 in 1..4 == true
    ##   5..6 in 1..4 == false
    ##   4..5 in 1..4 == false
    a.a >= b.a and a.b <= b.b


func `@`(a, b: HSlice[int, int]): bool =
    ## Check if a range overlaps with other range.
    ## E.g.:
    ##   2..3 @ 1..4 == true
    ##   5..6 @ 1..4 == false
    ##   4..5 @ 1..4 == true
    a.b >= b.a and a.a <= b.b


func section_ids(line: string): (HSlice[int, int], HSlice[int, int]) =
    let section_ids: seq[int] = line.split({',', '-'}).map(i => parseInt(i))
    return (
        section_ids[0]..section_ids[1],
        section_ids[2]..section_ids[3]
    )


proc part1(data: string): int =
    let overlaps: seq[bool] = collect:
        for line in data.split():
           let (section1, section2) = section_ids(line)
           section1 in section2 or section2 in section1

    # count how many sections are contained in other section
    return overlaps.count(true)


proc part2(data: string): int =
    let overlaps: seq[bool] = collect:
        for line in data.split():
            let (section1, section2) = section_ids(line)
            section1 @ section2

    # count how many sections overlap with other section
    return overlaps.count(true)


when isMainModule:
    let data_sample: string = readFile("samples/sample_4.txt").strip()
    let data_input: string = readFile("inputs/input_4.txt").strip()

    echo &"Part 1 sample: {part1(data_sample)}"
    echo &"Part 1 input:  {part1(data_input)}"
    echo &"Part 2 sample: {part2(data_sample)}"
    echo &"Part 2 input:  {part2(data_input)}"
