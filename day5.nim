import sequtils     # map
import strformat    # echo &"{}"
import strscans     # scanf
import strutils     # split
import sugar        # collect, =>
import tables       # toTable


type
    Crates = OrderedTable[int, seq[char]]
    Move = tuple[amount, loc_from, loc_to: int]
    Moves = seq[Move]


func char2int(a: char): int =
    int(a) - 48


func transform_data(data: string): (Crates, Moves) =
    let data_split = data.split("\n\n")
    var crates: Crates = initOrderedTable[int, seq[char]]()
    var moves: Moves = @[]

    block transform_moves:
        for line in data_split[1].splitlines():
            var amount, loc_from, loc_to: int
            discard scanf(
                line, "move $i from $i to $i", amount, loc_from, loc_to
            )
            moves.add((amount, loc_from, loc_to))

    block transform_crates:
        let crates_lines = data_split[0].splitlines()

        # -- init table indexes
        for i in crates_lines[^1]:
            if i != ' ':
                crates[char2int(i)] = @[]

        # -- init table values
        # the 'crates' table is indexed from 1
        # as it is in the puzzle input
        var table_idx: int = 1
        # go from the bottom crates to the top ones
        for i in countdown(len(crates_lines) - 2, 0):
            # crate chars are 4 indexes from each other
            # and first one is at index 1
            for j in countup(1, len(crates_lines[^1]), 4):
                # check if there is enough crates in the row
                # and if there is a crate in a column
                if j < len(crates_lines[i]) and crates_lines[i][j] != ' ':
                    crates[table_idx].add(crates_lines[i][j])
                table_idx += 1

            # another row of crates
            table_idx = 1

    return (crates, moves)


proc part1(crates_orig: Crates, moves: Moves): string =
    var crates: Crates = crates_orig

    for move in moves.items:
        for step in 0..<move.amount:
            crates[move.loc_to].add(crates[move.loc_from].pop())

    return crates.values.toSeq.map(x => x[^1]).foldl(a & b, "")


proc part2(crates_orig: Crates, moves: Moves): string =
    var crates: Crates = crates_orig
    var crane_handle: seq[char]

    for move in moves.items:
        # pick up the amount of crates
        for step in 0..<move.amount:
            crane_handle.add(crates[move.loc_from].pop())
        # and put them them elsewhere at once to keep the order
        for step in 0..<move.amount:
            crates[move.loc_to].add(crane_handle.pop())

    return crates.values.toSeq.map(x => x[^1]).foldl(a & b, "")


when isMainModule:
    # strip only the end, because of how the crates are formatted on top
    let data_sample: string = readFile("samples/sample_5.txt").strip(leading=false)
    let data_input: string = readFile("inputs/input_5.txt").strip(leading=false)

    let (crates_sample, moves_sample) = transform_data(data_sample)
    let (crates_input, moves_input) = transform_data(data_input)

    echo &"Part 1 sample: {part1(crates_sample, moves_sample)} (CMZ)"
    echo &"Part 1 input:  {part1(crates_input, moves_input)}"
    echo &"Part 2 sample: {part2(crates_sample, moves_sample)} (MCD)"
    echo &"Part 2 input:  {part2(crates_input, moves_input)}"
