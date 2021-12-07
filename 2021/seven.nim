import ./common, std/[strutils, sequtils, strformat, sugar]

proc crabFuel(c: seq[int]): int =
  (0..c.foldl(max(a, b))).toSeq()
    .reduce((r,t) => min(c.foldl(a + abs(b - t), 0), r), high(int))

proc triangleNumber(n: int): int = int((n * (n + 1)) / 2)

proc crabMoreFuel(c: seq[int]): int =
  (0..c.foldl(max(a, b))).toSeq()
    .reduce((r,t) => min(c.foldl(a + abs(b - t).triangleNumber(), 0), r), high(int))

doDay(7,
  (day) => day.loadInputText().split(',').map(parseInt),
  crabFuel,
  crabMoreFuel,
  @[16,1,2,0,4,2,7,1,2,14], 37, 168)
