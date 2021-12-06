import std/[strutils, sequtils, tables, strformat]
import ./common

const DEFAULT_DAYS = 80
const CYCLE_DAYS = 7
const MATURING_DAYS = 2

proc lanternFish(inputLines: seq[string], days = DEFAULT_DAYS): int =
  # a place to put newly-spawned fish that are not mature enough themselves to
  # spawn within the cycle
  var maturingFish: seq[(int, int)]

  # here we will keep the counts of fish that spawn on a given day in the cycle
  var fish = newSeq[int](CYCLE_DAYS)

  # initialize our current fish counts based on the input
  for i in inputLines[0].split(',').mapIt(it.parseInt()): inc fish[i]

  for day in 0..days:
    let cycleDay = day mod CYCLE_DAYS
    # since we're just about to decrement the days for all maturing fish, add
    # 1 to offset and spawn our maturing fish
    maturingFish.add((MATURING_DAYS+1, fish[cycleDay]))

    # age maturing fish
    for v in maturingFish.mitems(): dec v[0]

    # if our oldest maturing fish have now matured move them to their place in
    # the cycle
    if maturingFish[0][0] == 0:
      fish[cycleDay] += maturingFish[0][1]
      maturingFish.delete(0)

  # sum all fish counts plus the fish that were spawned two days ago
  fish.foldl(a + b) + (if maturingFish[0][0] <= 1: maturingFish[0][1] else: 0)

let input = 6.loadInput()
time("day 6 part 1"): echo input.lanternFish()
time("day 6 part 2"): echo input.lanternFish(256)

when not defined(release):
  let testInput = @["3,4,3,1,2"]
  doAssert testInput.lanternFish(18) == 26
  doAssert testInput.lanternFish() == 5934
  doAssert testInput.lanternFish(256) == 26984457539
