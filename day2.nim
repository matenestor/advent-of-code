import math         # sum
import strformat    # echo &"{}"
import strutils     # split
import sugar        # collect, =>
import tables       # toTable


# NOTE: use 'ord' proc to get an enum's value
type
    Outcome = enum
        loss = 0
        draw = 3
        win = 6

    Shape = enum
        rock = 1
        paper = 2
        scissors = 3

    # use char ranges to index the result array easily
    # PART 1
    # opponent: A, B, C
    # me: X, Y, Z
    Results_1 = array['A'..'C', array['X'..'Z', Outcome]]
    # PART 2
    # opponent: A, B, C
    # outcomes: X, Y, Z
    Results_2 = array['A'..'C', array['X'..'Z', Shape]]

const
    # PART 1
    results_1: Results_1 = [
        # X, rock      Y, paper      Z, scissors
        [Outcome.draw, Outcome.win,  Outcome.loss], # A, rock
        [Outcome.loss, Outcome.draw, Outcome.win],  # B, paper
        [Outcome.win,  Outcome.loss, Outcome.draw], # C, scissors
    ]
    # avoid a case statement or char arithmetics in part1() with this
    # Table is like a Python dict
    choices: Table[char, int] = {
        'X': ord(Shape.rock),
        'Y': ord(Shape.paper),
        'Z': ord(Shape.scissors),
    }.toTable

    # PART 2
    # the relation changed from:
    #   opponent choice + my choice = result
    # to:
    #   opponent choice + result = my choice
    results_2: Results_2 = [
        # X, loss        Y, draw         Z, win
        [Shape.scissors, Shape.rock,     Shape.paper],    # A, rock
        [Shape.rock,     Shape.paper,    Shape.scissors], # B, paper
        [Shape.paper,    Shape.scissors, Shape.rock],     # C, scissors
    ]
    choices2: Table[char, int] = {
        'X': ord(Outcome.loss),
        'Y': ord(Outcome.draw),
        'Z': ord(Outcome.win),
    }.toTable


proc part1(data: string): int =
    let score: seq[int] = collect:
        for line in data.split("\n"):
            let (opp, me) = (line[0], line[2])
            ord(results_1[opp][me]) + choices[me]

    return sum(score)


proc part2(data: string): int =
    let score: seq[int] = collect:
        for line in data.split("\n"):
            let (opp, res) = (line[0], line[2])
            ord(results_2[opp][res]) + choices2[res]

    return sum(score)


when isMainModule:
    let data_sample: string = readFile("samples/sample_2.txt").strip()
    let data_input: string = readFile("inputs/input_2.txt").strip()

    echo &"Part 1 sample: {part1(data_sample)}"
    echo &"Part 1 input:  {part1(data_input)}"
    echo &"Part 2 sample: {part2(data_sample)}"
    echo &"Part 2 input:  {part2(data_input)}"
