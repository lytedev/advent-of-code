import std/[strutils, sequtils, options, math, parseutils]
import ./common

const ASCII_ZERO = int('0')
type BitCounter = object
  zeroes: int
  ones: int

proc countBits(inputs: seq[string], maybeWidth: Option[int], offset = 0): seq[BitCounter] =
  let width = maybeWidth.get(inputs[0].len())
  let maxIndex = offset+width
  for i in offset..<maxIndex: result.add(BitCounter(zeroes: 0, ones: 0))
  for binstring in inputs:
    for i in offset..<maxIndex:
      let outIndex = i - offset
      if (binstring[i].int() - ASCII_ZERO) > 0: inc result[outIndex].ones
      else: inc result[outIndex].zeroes

proc powerConsumption(inputs: seq[string]): int =
  let counters = inputs.countBits(none(int))
  let width: Natural = inputs[0].len()
  for i in 0..<width:
    if counters[i].ones > counters[i].zeroes: inc result
    result = result shl 1
  result = result shr 1
  result = result * (result xor ((2 ^ width) - 1))

proc lifeSupportRating(inputs: seq[string]): int =
  let width: Natural = inputs[0].len()
  var oxygenRating, co2Rating = 0
  var oxygenCandidates, co2Candidates: seq[int] = toSeq(0..<inputs.len)
  echo oxygenCandidates, co2Candidates
  for i in 0..<width:
    var newOxygenCandidates, newCo2Candidates: seq[int] = @[]
    if oxygenRating == 0:
      let candidates = oxygenCandidates.mapIt(inputs[it])
      let counters = countBits(candidates, some(1), i)
      let moreCommon: char = if counters[0].ones >= counters[0].zeroes: '1' else: '0'
      echo "OX: ", i, candidates, moreCommon, counters[0]
      if counters[0].zeroes == counters[0].ones:
        echo "SAME OX"
      for j in oxygenCandidates:
        if inputs[j][i] == moreCommon:
          newOxygenCandidates.add(j)
      if newOxygenCandidates.len() == 1:
        discard inputs[newOxygenCandidates[0]].parseBin(oxygenRating)
        echo "OX DONE"
    if co2Rating == 0:
      let candidates = co2Candidates.mapIt(inputs[it])
      let counters = countBits(candidates, some(1), i)
      let lessCommon: char = if counters[0].zeroes <= counters[0].ones: '0' else: '1'
      echo "CO2 ", i, candidates, lessCommon, counters[0]
      if counters[0].zeroes == counters[0].ones:
        echo "SAME CO2"
      for j in co2Candidates:
        if inputs[j][i] == lessCommon:
          newCo2Candidates.add(j)
      if newCo2Candidates.len() == 1:
        discard inputs[newCo2Candidates[0]].parseBin(co2Rating)
        echo "CO2 DONE"
    oxygenCandidates = newOxygenCandidates
    co2Candidates = newCo2Candidates
    if oxygenRating != 0 and co2Rating != 0: break
  echo "OX: ", oxygenRating
  echo "CO2: ", co2Rating
  return oxygenRating * co2Rating

let input = 3.loadInput()
time("powerConsumption part 1"): echo input.powerConsumption()
time("lifeSupportRating part 2"): echo input.lifeSupportRating()

when not defined(release):
  static:
    let testInput = @[
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010",
    ]
    doAssert testInput.powerConsumption() == 198
    doAssert testInput.lifeSupportRating() == 230
