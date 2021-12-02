import ./common

proc countDepthIncreases(inputs: seq[int], dist=1): int  =
  for i in dist..<inputs.len():
    if inputs[i] > inputs[i-dist]: inc result

let input = 1.loadInput().toInts()
time("countDepthIncreases part 1"): echo input.countDepthIncreases()
time("countDepthIncreases part 2"): echo input.countDepthIncreases(3)

when not defined(release):
  static:
    let testInputs = @[199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    doAssert testInputs.countDepthIncreases() == 7
    doAssert testInputs.countDepthIncreases(3) == 5
