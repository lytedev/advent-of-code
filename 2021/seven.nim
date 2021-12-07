import std/[strutils, sequtils, strformat]
import ./common

proc crabFuel(input: string): int =
  let crabs = input.split(',').map(parseInt)
  result = int.high()
  var maxCrab = crabs.foldl(max(a, b), 0)
  for t in 0..maxCrab: result = min(crabs.foldl(a + abs(b - t), 0), result)

proc triangleNumber(n: int): int = int((n * (n + 1)) / 2)

proc crabMoreFuel(input: string): int =
  let crabs = input.split(',').map(parseInt)
  result = int.high()
  var maxCrab = crabs.foldl(max(a, b), 0)
  for t in 0..maxCrab: result = min(crabs.foldl(a + (b - t).abs().triangleNumber(), 0), result)

doDay(7, loadInputText, crabFuel, crabMoreFuel, "16,1,2,0,4,2,7,1,2,14", 37, 168)
