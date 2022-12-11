import std/[
    sequtils,     # map
    strformat,    # echo &"{}"
    strutils,     # split
    sugar,        # collect, =>
    tables,       # toTable
]


type
    # head, tail
    Position = tuple[x, y: int]
    # U, D, R, L from the puzzle input
    Direction = enum
        up, down, right, left

    # a rope direction and the amount of positions the rope moved
    # parsed from the puzzle input
    MoveInstruction = tuple[dirc: Direction, amount: int]
    # the solve input type
    RopeMoves = seq[MoveInstruction]


const
    # mapping for XY coordinates update
    move_dirc = {
        Direction.up:    (0, 1),
        Direction.down:  (0, -1),
        Direction.right: (1, 0),
        Direction.left:  (-1, 0),
    }.toTable


proc `$`(m: MoveInstruction): string =
    &"{$typeof(m)}: {m.amount}x {capitalizeAscii($m.dirc)}"


proc preprocess(data: string): RopeMoves =
    collect:
        for move in data.splitlines().map(x => x.split()):
            case move[0]:
            of "U":
                (Direction.up, parseInt(move[1]))
            of "D":
                (Direction.down, parseInt(move[1]))
            of "R":
                (Direction.right, parseInt(move[1]))
            of "L":
                (Direction.left, parseInt(move[1]))


func isTouching(head: Position, tail: Position): bool =
    abs(head.x - tail.x) <= 1 and abs(head.y - tail.y) <= 1


proc simulate(move, head, tail: Position): (Position, Position) =
    var (newHead, newTail) = (head, tail)

    # inc or dec head according to the instruction
    newHead.x += move.x
    newHead.y += move.y

    if not isTouching(newHead, tail):
        # tail always follows path of the head
        # TODO does not support diagonal movement for part 2
        newTail.x = head.x
        newTail.y = head.y

    return (newHead, newTail)


proc part1(data: RopeMoves): int =
    var head, tail: Position
    var positions: seq[Position] = @[tail]

    for (dirc, amount) in data:
        for _ in 0..<amount:
            (head, tail) = simulate(move_dirc[dirc], head, tail)

            if tail notin positions:
                positions.add(tail)

    return len(positions)


proc part2(data: string): int =
    return 0


when isMainModule:
    let dataSample: RopeMoves = preprocess(readFile("samples/sample9.txt").strip())
    let dataInput: RopeMoves = preprocess(readFile("inputs/input9.txt").strip())

    echo &"Part 1 sample: {part1(dataSample)} (13)"
    echo &"Part 1 input:  {part1(dataInput)}"
    #echo &"Part 2 sample: {part2(dataSample)}"
    #echo &"Part 2 input:  {part2(dataInput)}"
