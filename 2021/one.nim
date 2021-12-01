import std/[streams, strutils, sugar, strformat, times]

iterator inputForDay(day: int): int =
  var stream: FileStream = fmt"/home/daniel/.home/.config/aoc2021/{day}.input".openFileStream
  for s in stream.lines():
    yield s.parseInt

proc part1(inputs: seq[int], dist=1): int =
  result = 0
  var i = dist
  var x = inputs.len()-1
  while i <= x:
    if inputs[i] > inputs[i-dist]: inc result
    inc i

let dd1 = epochTime()
var input = collect(newSeq):
  for i in inputForDay(1): i

let dd2 = epochTime()
echo &"{(dd2 - dd1) * 1000} ms (to load input)"
echo "Part 1"
let d1 = epochTime()
echo part1(input)
let d2 = epochTime()
echo &"{(d2 - d1) * 1000} ms (to calculate solution)"
echo "Part 2"
let d21 = epochTime()
echo part1(input,3)
let d22 = epochTime()
echo &"{(d22 - d21) * 1000} ms (to calculate solution)"
