import streams, sets, strutils, sequtils

proc part1*(s: Stream): int =
  # s.readAll().split("\n\n").mapIt(it.split("\n").foldl(a.union(b.toHashSet), initHashSet)).len
  s.readAll().split("\n\n").mapIt(it.split("\n").foldl(a.union(b.toHashSet), initHashSet[char]()).len).foldl(a + b)

proc part2*(s: Stream): int =
  9
