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


const indev = false
template dev(msg: string) =
    if indev: echo msg


const
    ShellLine = (
        change_dir: "$$ cd $+$.",
        list: "$ ls",
        out_dir: "dir $+$.",
        out_file: "$i $+$.",
    )

    DEVICE_SPACE: int = 70_000_000
    UPGRADE_SIZE: int = 30_000_000


type
    # inorder:   left, root, rigth
    # preorder:  root, left, rigth
    # postorder: left, rigth, root
    Order = enum
        inorder, preorder, postorder

    NodeType = enum
        file, dir

    Node = ref object
        # file: just the file size
        # dir: total size of the node's children
        size: int
        name: string
        parent: Node
        children: seq[Node]
        node_type: NodeType

    Tree = object
        root: Node
        current: Node


func new_tree(): Tree =
    let n: Node = Node(name: "/", node_type: NodeType.dir)
    Tree(root: n, current: n)


proc `+=`(tree: Tree, node: Node) =
    node.parent = tree.current
    tree.current.children.add(node)


# TODO try out different traversal styles (+ recursion style?)
proc print(tree: Tree, style: Order = inorder) =
    var nodes: seq[Node] = @[tree.root]
    var current: Node

    while len(nodes) > 0:
        current = nodes.pop()

        # TODO this is levelorder though
        for child in current.children:
            # use 'insert' at index 0, so the left-most child
            # isat the end and ready to be poped
            nodes.insert(child, 0)

        if current.node_type == NodeType.dir:
            echo &"{current.name} {current.size}"


# TODO 1/2 make a traversal proc with a callback proc
proc sum_dirs_below_100000(tree: Tree): int =
    var nodes: seq[Node] = @[tree.root]
    var current: Node

    while len(nodes) > 0:
        current = nodes.pop()

        for child in current.children:
            # use 'insert' at index 0, so the left-most child
            # isat the end and ready to be poped
            nodes.insert(child, 0)

        if current.node_type == NodeType.dir:
            if current.size <= 100_000:
                result += current.size


# TODO 2/2 make a traversal proc with a callback proc
proc find_biggest_dir_below(tree: Tree): int =
    var nodes: seq[Node] = @[tree.root]
    var current: Node
    var to_delete: int = DEVICE_SPACE
    let necessary_to_free: int = UPGRADE_SIZE - (DEVICE_SPACE - tree.root.size)

    while len(nodes) > 0:
        current = nodes.pop()

        for child in current.children:
            # use 'insert' at index 0, so the left-most child
            # isat the end and ready to be poped
            nodes.insert(child, 0)

        if current.node_type == NodeType.dir:
            if necessary_to_free <= current.size and current.size < to_delete:
                to_delete = current.size

    return to_delete


# NOTE: can also be written as:
# proc solve(data: string, count_dirs: Tree -> int): int =
proc solve(data: string, count_dirs: proc(tree: Tree): int): int =
    var name: string
    var size: int
    # device filesystem
    var fs: Tree = new_tree()

    for line in data.splitlines():
        if scanf(line, ShellLine.change_dir, name):
            dev(&"cd: {line} -> {name} :: {fs.current.name}")
            if name == "/":
                fs.current = fs.root
            elif name == "..":
                # assume there is no 'cd ..' when in root '/'
                fs.current = fs.current.parent
            else:
                for child in fs.current.children:
                    if name == child.name:
                        fs.current = child
                        break

        elif line == ShellLine.list:
            dev(&"ls :: {fs.current.name}")
            continue

        elif scanf(line, ShellLine.out_dir, name):
            dev(&"dir: {line} -> {name} :: {fs.current.name}")
            fs += Node(name: name, node_type: NodeType.dir)

        elif scanf(line, ShellLine.out_file, size, name):
            dev(&"file: {line} -> {size} {name} :: {fs.current.name}")
            fs += Node(name: name, size: size, node_type: NodeType.file)

            # update dir sizes in the filesystem
            # NOTE: as written in the puzzle assigment:
            #   "As in this example, this process can count files more than once!"
            var dir: Node = fs.current
            while not dir.isNil:
                dir.size += size
                dir = dir.parent

        else:
            assert false, &"Unreachable {line}"

    return count_dirs(fs)


when isMainModule:
    let data_sample: string = readFile("samples/sample_7.txt").strip()
    let data_input: string = readFile("inputs/input_7.txt").strip()

    echo &"Part 1 sample: {solve(data_sample, sum_dirs_below_100000)} (95437)"
    echo &"Part 1 input:  {solve(data_input, sum_dirs_below_100000)}"
    echo &"Part 2 sample: {solve(data_sample, find_biggest_dir_below)} (24933642)"
    echo &"Part 2 input:  {solve(data_input, find_biggest_dir_below)}"
