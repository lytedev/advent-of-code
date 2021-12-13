import ./common, std/[sequtils, sugar]

proc countDepthIncreases(inputs: seq[int], dist=1): int  =
  (dist..<inputs.len()).toSeq().foldl(a + int(inputs[b] > inputs[b-dist]), 0)

doDay(1, (n) => n.loadInput().toInts(),
  (n) => n.countDepthIncreases(),
  (n) => n.countDepthIncreases(3),
  @[199,200,208,210,200,207,240,269,260,263], 7, 5)
