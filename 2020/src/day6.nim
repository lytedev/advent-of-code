import streams, sets, strutils, sequtils

proc asGroups(s: Stream): seq[seq[string]] =
  s.readAll.split("\n\n").mapIt it.split("\n").filterIt(it != "")

proc part1*(s: Stream): int =
  s.asGroups.mapIt(it.foldl(a.union(b.toHashSet), initHashSet[char]()).len).foldl a + b

proc part2*(s: Stream): int =
  s.asGroups.mapIt(it.foldl(a.intersection(b.toHashSet), toSeq('a'..'z').toHashSet).len).foldl(a + b)
