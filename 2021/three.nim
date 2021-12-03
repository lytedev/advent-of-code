import std/[strutils, sequtils, options, math]
import ./common

const ASCII_ZERO = int('0')
type BitCounter = object
  zeroes: int
  ones: int

proc countBits(inputs: seq[string], maybeWidth: Option[int], maybeWindow: Option[int]): seq[BitCounter] =
  let width = maybeWidth.get(inputs[0].len())
  let window = maybeWindow.get(width)
  let start = (width - window)
  for i in 0..<window: result.add(BitCounter(zeroes: 0, ones: 0))
  for binstring in inputs:
    for i in start..<width:
      if (binstring[i].int() - ASCII_ZERO) > 0: inc result[i - start].ones
      else: inc result[i - start].zeroes

proc powerConsumption(inputs: seq[string]): int =
  let counters = inputs.countBits(none(int), none(int))
  let width: Natural = inputs[0].len()
  for i in 0..<width:
    if counters[i].ones > counters[i].zeroes: inc result
    result = result shl 1
  result = result shr 1
  result = result * (result xor ((2 ^ width) - 1))

proc lifeSupportRating(inputs: seq[string]): int =
  return 0

let input = 3.loadInput()
time("countBits part 1"): echo input.powerConsumption()

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
