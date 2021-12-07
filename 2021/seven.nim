import std/[strutils, sequtils, tables, strformat]
import ./common

proc crabsDistance(input: string): int =
  result = int.high()
  var max_try = 0
  let dists = input.split(',').map(parseInt)
  for d in dists:
    if d > max_try: max_try = d
  for t in 0..max_try:
    let fuel = dists.foldl(a + abs(b - t), 0)
    if fuel < result: result = fuel

let input = 7.loadInputText()
time("day 7 part 1"): echo input.crabsDistance()
# time("day 7 part 2"): echo "?"

when not defined(release):
  let testInput = "16,1,2,0,4,2,7,1,2,14"
  doAssert testInput.crabsDistance() == 37
