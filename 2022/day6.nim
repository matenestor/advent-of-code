import std/[
    setutils,     # toSet
    strformat,    # echo &"{}"
    strutils,     # split
]

const
    # amount of chars denoting the beginnig of a message in the protocol
    START_OF_PACKET: int = 4
    START_OF_MESSAGE: int = 14


proc solve(data: string, start_position: int): int =
    # could be optimized with jumping after the first repeated character
    for i in 0..len(data) - start_position:
        if len(toSet(data[i..<i + start_position])) == start_position:
            result = i + start_position
            break


when isMainModule:
    let data_sample: string = readFile("samples/sample_6.txt").strip()
    let data_input: string = readFile("inputs/input_6.txt").strip()

    echo &"Part 1 sample: {solve(data_sample, START_OF_PACKET)} (7)"
    echo &"Part 1 input:  {solve(data_input,  START_OF_PACKET)}"
    echo &"Part 2 sample: {solve(data_sample, START_OF_MESSAGE)} (19)"
    echo &"Part 2 input:  {solve(data_input,  START_OF_MESSAGE)}"
