# Advent of Code 2022

Solutions for the [Advent of Code 2022](https://adventofcode.com/2022)
(descriptions are available on the website).

I am taking the opportunity during this event to learn programming in Nim.


## Compile and run

Execute the Nim interpreter command (or the compilation command, your choice)
with the file of a chosen day.

```bash
# compile, execute
nim c day1.nim
./day1

# just run (interpret)
nim r day1.nim
```

Make sure to execute the solution in the same directory where the `inputs/`
and the `samples/` directories are. The program searches the input data there.


## Learned

- Day 1:
  - array processing with multiple paradigms Nim offers
  - `collect` and `=>` macros
- Day 2: custom types and enums
- Day 3: HashSets from the `sets` module
- Day 4:
  - split a string on multiple characters
  - override a built-in operator by creating my own `func` or `proc`
- Day 5:
  - lstrip and rstrip with `leading` and `trailing` kwargs of `split()` proc
  - a `discard` keyword for ignoring a return value
  - basic work with a table from `tables` module
  - Nim cannot unpack sequences (e.g. `var (a, b): int = @[1, 2]`)
  - `maxIndex` and `minIndex` get the indices of the max and min values in a sequence
  - sequences have `items`, tables have `keys`, `values` and `pairs` iterators
  - to convert an interator to a sequence use `tab.values.toSeq`
  - `foldl` from `sequtils` can convert a `seq[char]` to a string
  - assigning a table creates a copy of it; in order to keep the same instance
    use `newTable`

- Along the way:
  - `high` and `low` procs; useful when a collection is not indexed 0..N
  - `mpairs`, `mvalues` etc.; iterators that iterate over elements that
    can be changed
  - `mapIt` (and other `xIt`) from `sequtils`; returns a new sequence, useful
    when a collection need to change the types of its elements
   