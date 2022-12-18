import std/[
    algorithm,    # sorted
    math,         # sum
    sequtils,     # map
    sets,         # intersection, toHashSet
    setutils,     # toSet
    strformat,    # echo &"{}"
    strscans,     # scanf
    strutils,     # split
    sugar,        # collect, =>
    tables,       # toTable
]


type
    Monkey = object
        id: int
        stolenItems: seq[int]
        updateFunc: (int) -> int
        modNum: int
        throwTo: Table[bool, int]
        counterInspections: int


# NOTE: shorted version could be written with two macros, but that gives an error:
#   A nested proc can have generic parameters only when it is used as
#   an operand to another routine and the types of the generic paramers can
#   be inferred from the expected signature.
# func opAdd(a: int): (int) -> int = (b => a + b)
# func opMul(a: int): (int) -> int = (b => a * b)
func opAdd(a: int): (int) -> int = (proc(b: int): int = a + b)
func opMul(a: int): (int) -> int = (proc(b: int): int = a * b)
func opAddEq(a: int): int = a + a
func opMulEq(a: int): int = a * a


proc transformData(data: string): seq[Monkey] =
    for monkey in data.split("\n\n"):
        let monkeyInfo = monkey.splitlines
        var
            newMonkey: Monkey = Monkey(throwTo: {true: -1, false: -1}.toTable)
            itemsString: string
            opIns: char
            # NOTE: is it possible to create something like
            #   'opNum: int | string'? with generics?
            opNum: int
            opNumS: string

        discard scanf(monkeyInfo[0], "Monkey $i", newMonkey.id)
        discard scanf(monkeyInfo[1], "$sStarting items: $+$.", itemsString)
        if not scanf(monkeyInfo[2], "$sOperation: new = old $c $i", opIns, opNum):
            discard scanf(monkeyInfo[2], "$sOperation: new = old $c $w", opIns, opNumS)
        discard scanf(monkeyInfo[3], "$sTest: divisible by $i", newMonkey.modNum)
        discard scanf(monkeyInfo[4], "$sIf true: throw to monkey $i", newMonkey.throwTo[true])
        discard scanf(monkeyInfo[5], "$sIf false: throw to monkey $i", newMonkey.throwTo[false])

        # convert the items a monkey is holding to int
        if ',' in itemsString:
            newMonkey.stolenItems = itemsString.split(',').map(x => x.strip.parseInt)
        else:
            newMonkey.stolenItems = @[itemsString.strip.parseInt]

        # assign the inspection operation
        if opNumS == "old":
            newMonkey.updateFunc = if opIns == '*': opMulEq else: opAddEq
        else:
            newMonkey.updateFunc = if opIns == '*': opMul(opNum) else: opAdd(opNum)

        result.add(newMonkey)


proc part1(dataOrig: seq[Monkey]): int =
    # just copy the input data, so I don't have to deal with 'var' parameters..
    var data = dataOrig

    for _ in 0..<20:
        for monkey in data.mitems:
            monkey.counterInspections += len(monkey.stolenItems)

            for item in monkey.stolenItems:
                # update worry level and divide by 3
                let inspectedItem = monkey.updateFunc(item) div 3
                let anotherMonkeyId = monkey.throwTo[inspectedItem mod monkey.modNum == 0]
                # throw to another monkey
                data[anotherMonkeyId].stolenItems.add(inspectedItem)
            # all go inspected
            monkey.stolenItems = @[]

    var monkeyBusinnes: seq[int] = collect:
        for monkey in data:
            monkey.counterInspections
    sort(monkeyBusinnes, SortOrder.Descending)

    return monkeyBusinnes[0] * monkeyBusinnes[1]


proc part2(dataOrig: seq[Monkey]): int =
    return 0


when isMainModule:
    let dataSample: seq[Monkey] = transformData(readFile("samples/sample11.txt").strip())
    let dataInput: seq[Monkey] = transformData(readFile("inputs/input11.txt").strip())

    echo &"Part 1 sample: {part1(dataSample)} (10605)"
    echo &"Part 1 input:  {part1(dataInput)}"
    # echo &"Part 2 sample: {part2(dataSample)} (2713310158)"
    #echo &"Part 2 input:  {part2(dataInput)}"
