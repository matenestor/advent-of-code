import std/[
    sequtils,     # map
    strformat,    # echo &"{}"
    strutils,     # split
    sugar,        # collect, =>
]


const
    WIDTH = 40
    HEIGHT = 6

type
    Display = array[HEIGHT, array[WIDTH, char]]


proc render(display: Display): string =
    for row in display:
        for pixel in row:
            # stdout.write if pixel in {'#', '.'}: pixel else: '?'
        # echo ""
            result &= pixel
        result &= '\n'


proc tick(counter: var int, register: int, display: var Display): int =
    let
        displayRow: int = counter div WIDTH
        spritePos: int = counter mod WIDTH

    if register - 1 <= spritePos and spritePos <= register + 1:
        display[displayRow][spritePos] = '#'
    else:
        display[displayRow][spritePos] = '.'

    inc counter
    if counter in {20, 60, 100, 140, 180, 220}:
        result = counter * register


proc solve(data: string): (int, string) =
    var
        # incremented every 'tick' proc call
        counter: int = 0
        # changed in 'tick' proc on 20th and then every 40th cycle
        # (middle of the display)
        register: int = 1
        # new pixel rendered every 'tick' call
        display: Display

        signalStrength: int

    for instruction in data.splitlines.map(x => x.split):
        case instruction[0]:
        of "noop":
            signalStrength += tick(counter, register, display)

        of "addx":
            signalStrength += tick(counter, register, display)
            signalStrength += tick(counter, register, display)
            register += instruction[1].parseInt

        else:
            assert false, "Unreachable"

    return (signalStrength, display.render)


when isMainModule:
    let dataSample: string = readFile("samples/sample10.txt").strip()
    let dataInput: string = readFile("inputs/input10.txt").strip()

    let (sampleSignalStrength, sampleDisplay) = solve(dataSample)
    let (inputSignalStrength, inputDisplay) = solve(dataInput)

    echo &"Part 1 sample: {sampleSignalStrength} (13140)"
    echo &"Part 1 input: {inputSignalStrength}"
    echo ""

    echo """Part 2 sample:
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
"""
    echo sampleDisplay

    echo &"Part 2 input:"
    echo inputDisplay
