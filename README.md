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
- Day 3: `HashSets` from the `sets` module
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
- Day 6:
  - `toSet` from the `setutils` module; useful to convert e.g. strings or 
    sequences to a set of characters
  - the implicit `result` variable available in every procedure with a return
    type of the procedure; it is automatically returned when the procedure exits,
    unless the `return` is used
- Day 7:
  - `scanf`: use `$w` to match an ASCII identifier, because `$s` is for
    **s**kipping an optional whitespace... and `$$` to match a dollar sign, 
    `$.` to match end of a string, `$+` to match everything until the following
    token was found (e.g. `$w` cannot match "a.txt" but `$+$.` can)
  - the difference between `object` and `ref object`, and how to use an attribute
    of type `T` in an object of the same type `T`
  - the `nil` type and `isNil` check
  - dereference object for `echo` with `[]` (e.g. `echo refObj[]` will print its fields)
  - object instantiation with `Obj()` and `new Obj`; the former can be used to
    initialize attributes, the latter just uses default values, both approaches
    allocates the object on heap (rumors about removing `new` in Nim 2.0)
  - echo character/string multiple times with `'-'.repeat(3)`
  - use a proc as a proc parameter
- Day 8:
  - overriding `items` iterator makes it possible to iterate custom types just
    with `for in`
  - override `$` for pretty printing custom types
  - Nim style guide prefers camelCamel case over snake_case
- Day 9:
  - in order to use `typeof()` inside string format, it needs to be used with 
    a string conversion `$` operator: `&"{$typeof(num)}: {num}`


- Along the way:
  - `high` and `low` procs; useful when a collection is not indexed 0..N,
    also to get max and min value of e.g. int `high(int) = ...`
  - `mpairs`, `mvalues` etc.; iterators that iterate over elements that
    can be changed
  - a template `mapIt` (and other `xIt`) from `sequtils`; returns a new sequence,
    useful when a collection need to change the types of its elements, it also
    injects a variable `it` that can be used to access the single elements
  - Nim has an `auto` type
  - a `block` statement can be used to break out of nested loops with
    ```nim
    block loops:
      while true:
        while true:
          break loops
    ```
