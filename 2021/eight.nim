import ./common, std/[strutils, sequtils, strformat, sugar]

proc p1(c: string): int =
  return 26

proc p2(c: string): int =
  result = 0

doDay(8, (n) => n.loadInputText(),
  p1,
  p2,
  "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf", 26, -1)
