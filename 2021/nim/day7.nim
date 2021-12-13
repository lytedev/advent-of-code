import ./common, std/[strutils, sequtils, sugar]

proc crabFuel(c: seq[int], f = (n: int) => n): int =
  toSeq((1..c.foldl(max(a, b)))).reduce((r,t) => min(c.foldl(a + f(abs(b - t)), 0), r), high(int))

doDay(7, (n) => n.loadInputText().split(',').map(parseInt),
  (n) => n.crabFuel(),
  (n) => n.crabFuel((c: int) => (c * (c + 1)) div 2),
  @[16,1,2,0,4,2,7,1,2,14], 37, 168)
