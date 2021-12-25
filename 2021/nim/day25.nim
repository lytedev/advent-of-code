import ./common, std/[strutils, hashes, sugar, strformat]

proc p1(input: Lines): uint64 =
  var h = input.len
  var w = input[0].len
  var cukes = input
  while true:
    echo result
    var nextCukes = cukes
    if result < 4:
      echo nextCukes.join("\n")
      echo ""
    let startHash = nextCukes.hash
    for y,line in nextCukes.pairs:
      for x,c in line.pairs:
        let tx = if x >= w - 1: 0 else: x + 1
        if c == '>' and nextCukes[y][tx] == '.':
          echo &"{x}, {y} going right"
          nextCukes[y][x] = '.'
          nextCukes[y][tx] = 'r'
    for y,line in cukes.pairs:
      for x,c in line.pairs:
        let ty = if y >= h - 1: 0 else: y + 1
        if c == 'v' and nextCukes[ty][x] == '.':
          echo &"{x}, {y} going down"
          nextCukes[y][x] = 'u'
          nextCukes[ty][x] = 'v'
    for y,line in nextCukes.pairs:
      for x,c in line:
        if c == 'u': nextCukes[y][x] = '.'
        elif c == 'r': nextCukes[y][x] = '>'

    if nextCukes.hash == startHash: break
    cukes = nextCukes
    inc result

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
