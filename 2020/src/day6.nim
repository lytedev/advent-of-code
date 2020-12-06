import streams, sets, strutils, sequtils

proc part1*(s: Stream): int =
  s.readAll().split("\n\n").mapIt(it.split("\n").foldl(a.union(b.toHashSet), initHashSet[char]()).len).foldl(a + b)

proc part2*(s: Stream): int =
  s.readAll().split("\n\n").mapIt(
    it.split("\n").filterIt(it != "").foldl(a.intersection(b.toHashSet), "abcdefghijklmnopqrstuvwxyz".toHashSet()).len
  ).foldl(a + b)
