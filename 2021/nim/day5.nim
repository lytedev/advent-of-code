import std/[strutils, sequtils, options, math, parseutils, sets, strformat, algorithm, tables]
import ./common

proc toPointPair(s: string): (int, int, int, int) =
  let nums = s.split(" -> ").mapIt(it.split(',').mapIt(it.parseInt())).concat()
  (nums[0], nums[1], nums[2], nums[3])

proc part1(inputLines: seq[string]): int =
  var points: CountTable[(int, int)] = initCountTable[(int, int)](1000)
  for l in inputLines:
    let (x1, y1, x2, y2) = l.toPointPair()
    if x1 == x2 or y1 == y2:
      for x in min(x1, x2)..max(x1, x2):
        for y in min(y1, y2)..max(y1, y2):
          points.inc((x, y))
  for p in points.values():
    if p >= 2:
      inc result

proc part2(inputLines: seq[string]): int =
  var points: CountTable[(int, int)] = initCountTable[(int, int)](1000)
  for l in inputLines:
    let (x1, y1, x2, y2) = l.toPointPair()
    let ang = arctan2(float(y2 - y1), float(x2 - x1)) * 180 / PI
    if (ang.abs() mod 90) == 45.0:
      var x = x1
      var y = y1
      let xd = if x1 > x2: -1 else: 1
      let yd = if y1 > y2: -1 else: 1
      while x >= min(x1, x2) and x <= max(x1, x2) and y >= min(y1, y2) and y <= max(y1, y2):
        points.inc((x, y))
        x += xd
        y += yd
    elif x1 == x2 or y1 == y2:
      for x in min(x1, x2)..max(x1, x2):
        for y in min(y1, y2)..max(y1, y2):
          points.inc((x, y))
  for p in points.values():
    if p >= 2:
      inc result

let input = 5.loadInput()
time("day 5 part 1"): echo input.part1()
time("day 5 part 2"): echo input.part2()

when not defined(release):
  let testInput = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2""".split('\n')
  doAssert testInput.part1() == 5
  doAssert testInput.part2() == 12
