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


const
    ShellLine = (
        change_dir: "$$ cd $+$.",
        list: "$ ls",
        out_dir: "dir $+$.",
        out_file: "$i $+$.",
    )


type
    Tree = ref object
        # file: just their size
        # dir: total size of its children
        size: int
        name: string
        parent: Tree
        children: seq[Tree]

# TODO
#  proc isLeaf(node: Tree): bool =
#      len(node.children) == 0

proc add(node: Tree, new_node: Tree) =
    node.children.add(new_node)


proc part1(data: string): int =
    var name: string
    var size: int
    var filesystem: Tree = Tree(name: "/")
    let root: Tree = filesystem
    # root is parent to itself
    filesystem.parent = filesystem

    for line in data.splitlines():
        if scanf(line, ShellLine.change_dir, name):
            echo &"cd: {line} -> {name}"
            if name == "/":
                filesystem = root
            elif name == "..":
                filesystem = filesystem.parent
            else:
                for child in filesystem.children:
                    if line == child.name:
                        filesystem = child
                        break

        elif line == ShellLine.list:
            echo "ls"
            continue

        elif scanf(line, ShellLine.out_dir, name):
            echo &"dir: {line} -> {name}"
            filesystem.add(Tree(name: name, parent: filesystem))

        elif scanf(line, ShellLine.out_file, size, name):
            echo &"fil: {line} -> {size} {name}"
            filesystem.add(Tree(size: size, name: name, parent: filesystem))

        else:
            assert false, &"Unreachable {line}"

    return 0


proc part2(data: string): int =
    return 0


when isMainModule:
    let data_sample: string = readFile("samples/sample_7.txt").strip()
    let data_input: string = readFile("inputs/input_7.txt").strip()

    echo &"Part 1 sample: {part1(data_sample)} (95437)"
    #echo &"Part 1 input:  {part1(data_input)}"
    #echo &"Part 2 sample: {part2(data_sample)}"
    #echo &"Part 2 input:  {part2(data_input)}"
