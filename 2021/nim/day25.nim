import ./common, std/[strutils, sequtils, tables, strformat, algorithm, hashes]

proc p1(input: Lines): uint64 =
  var cukes = input
  while cukes.hash != nextCukes.hash
    var nextCukes = cukes
    for y,line in cukes:
      for x,c in cukes:
        case c:
          # don't forget to wrap
          of '>': # TODO: check next x
          of 'v': # TODO: check next y
          else: continue
    cukes = nextCukes
    inc result

proc p2(input: Lines): uint64 =
  0

time(&"Day 25 Part 1"): echo 25.loadInput.p1
time(&"Day 25 Part 2"): echo 25.loadInput.p2
