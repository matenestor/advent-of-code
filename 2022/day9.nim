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
    Rope = seq[Position]


const
    # rope length
    N = 10
    # mapping for XY coordinates update
    directionsMap = {
        Direction.up:    (0, 1),
        Direction.down:  (0, -1),
        Direction.right: (1, 0),
        Direction.left:  (-1, 0),
    }.toTable


proc `$`(m: MoveInstruction): string =
    &"{$typeof(m)}: {m.amount}x {capitalizeAscii($m.dirc)}"


proc `$`(rope: Rope): string =
    ## debugging the rope movement

    const (cols, rows) = (6, 5)
    var grid = @[repeat(".", cols)].cycle(rows)
    var linkNumber: int = len(rope) - 1

    # countdown so the head is on top
    for i in countdown(len(rope) - 1, 0):
        grid[rope[i].y][rope[i].x] = char(linkNumber + int('0'))
        dec linkNumber

    # countdown so the grid is displayed the same way
    # like in the puzzle assignment
    for i in countdown(len(grid) - 1, 0):
        for c in grid[i]:
            result &= c
        result &= "\n"


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


# PUZZLE SOLVING -------------------------------------------


func isTouching(head: Position, tail: Position): bool =
    abs(head.x - tail.x) <= 1 and abs(head.y - tail.y) <= 1


func isOrthogonal(head: Position, tail: Position): bool =
    head.x == tail.x or head.y == tail.y


proc moveOrthogonal(head, tail, move: Position): Position =
    ((if head.x == tail.x: 0 else: move.x),
     (if head.y == tail.y: 0 else: move.y))


func moveDiagonal(head, tail: Position): Position =
    ((if head.x - tail.x > 0: 1 else: -1),
     (if head.y - tail.y > 0: 1 else: -1))


proc simulatePart1(move, head, tail: Position): (Position, Position) =
    var (newHead, newTail) = (head, tail)

    # inc or dec head according to the instruction
    newHead.x += move.x
    newHead.y += move.y

    if not isTouching(newHead, tail):
        # NOTE: does not support diagonal movement for part 2
        # tail always follows path of the head
        newTail.x = head.x
        newTail.y = head.y

    return (newHead, newTail)


proc simulatePart2(firstMove: Position, rope: var Rope) =
    var move = firstMove

    for i in 0..<len(rope) - 1:
        # NOTE: can't be like this, because the tuple is copied
        # head = rope[i]
        # tail = rope[i + 1]

        # move a rope link
        rope[i].x += move.x
        rope[i].y += move.y

        if not isTouching(rope[i], rope[i+1]):
            if isOrthogonal(rope[i], rope[i+1]):
                # Two links can end up orthogonal when the move was diagonal,
                # which can happen when a previous link is cathing up with head,
                # thus making a diagonal movement,
                # so this step can't be just `move = move`.
                # The `move` variable needs to be send there, so one of the
                # directions (X or Y) can be used for a correct move.
                move = moveOrthogonal(rope[i], rope[i+1], move)
            else:
                move = moveDiagonal(rope[i], rope[i+1])

            if i == len(rope) - 2:
                # during the last cycle, there would be the last move for the
                # last link only prepared, but never made, so do it now
                rope[i+1].x += move.x
                rope[i+1].y += move.y
        else:
            # no more movement
            break


proc part1(data: RopeMoves): int =
    var head, tail: Position
    var positions: seq[Position] = @[tail]

    for (dirc, amount) in data:
        for _ in 0..<amount:
            (head, tail) = simulatePart1(directionsMap[dirc], head, tail)

            if tail notin positions:
                positions.add(tail)

    return len(positions)


proc part2(data: RopeMoves): int =
    var rope: Rope = repeat((0, 0), N)
    var positions: seq[Position] = @[rope[^1]]

    for (dirc, amount) in data:
        for _ in 0..<amount:
            simulatePart2(directionsMap[dirc], rope)

            if rope[^1] notin positions:
                positions.add(rope[^1])

    return len(positions)


when isMainModule:
    let dataSample: RopeMoves = preprocess(readFile("samples/sample9.txt").strip())
    let dataSample2: RopeMoves = preprocess(readFile("samples/sample9-2.txt").strip())
    let dataInput: RopeMoves = preprocess(readFile("inputs/input9.txt").strip())

    echo &"Part 1 sample: {part1(dataSample)} (13)"
    echo &"Part 1 input:  {part1(dataInput)}"
    echo &"Part 2 sample: {part2(dataSample)} (1)"
    echo &"Part 2 sample 2: {part2(dataSample2)} (36)"
    echo &"Part 2 input:  {part2(dataInput)}"
