import ./common, std/[strutils, hashes, sugar]

proc p1(input: Lines): uint64 =
  var h = input.len
  var w = input[0].len
  var cukes = input
  while true:
    var nextCukes = cukes
    let startHash = cukes.hash
    for y,line in cukes.pairs:
      for x,c in line.pairs:
        let tx = if x >= w - 1: 0 else: x + 1
        if c == '>' and cukes[y][tx] == '.':
          nextCukes[y][x] = '.'
          nextCukes[y][tx] = '>'
    cukes = nextCukes
    for y,line in cukes.pairs:
      for x,c in line.pairs:
        let ty = if y >= h - 1: 0 else: y + 1
        if c == 'v' and cukes[ty][x] == '.':
          nextCukes[y][x] = '.'
          nextCukes[ty][x] = 'v'

    inc result
    if nextCukes.hash == startHash: break
    cukes = nextCukes

proc p2(input: Lines): uint64 =
  0

doDayX 25, (n: int) => n.loadInput, p1, p2, ("""v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>""".split('\n'), 58'u64, 0'u64)
