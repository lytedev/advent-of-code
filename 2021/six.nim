import std/[strutils, sequtils, tables, strformat]
import ./common

const DEFAULT_DAYS = 80
const CYCLE_DAYS = 7
const MATURING_DAYS = 2

proc lanternFish(inputLines: seq[string], days = DEFAULT_DAYS): int =
  var maturingFish: seq[(int, int)]
  var fish = newSeq[int](CYCLE_DAYS)
  for i in inputLines[0].split(',').mapIt(it.parseInt()):
    inc fish[i]
  for day in 0..days+1:
    let daySeq = day mod CYCLE_DAYS
    maturingFish.add((MATURING_DAYS+1, fish[daySeq]))
    for v in maturingFish.mitems(): dec v[0]
    if maturingFish[0][0] == 0:
      fish[daySeq] += maturingFish[0][1]
      maturingFish.delete(0)
  result = fish.foldl(a + b)

let input = 6.loadInput()
time("day 6 part 1"): echo input.lanternFish()
time("day 6 part 2"): echo input.lanternFish(256)

when not defined(release):
  let testInput = @["3,4,3,1,2"]
  doAssert testInput.lanternFish(18) == 26
  doAssert testInput.lanternFish() == 5934
  doAssert testInput.lanternFish(256) == 26984457539
