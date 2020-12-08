import streams, sequtils, pegs, tables, sets, algorithm, strutils

let parser = peg"""
grammar <- c ' bags contain ' (nc+ / nob) '.'
nob <- 'no other bags'
nc <- {\d} ' ' c ' bag' 's'? ', '?
c <- {\ident ' ' \ident}
"""

let target = "shiny gold"
iterator asParsed(s: Stream): (string, seq[string]) =
  for l in s.lines:
    if l =~ parser:
      var d = matches.filterIt(it != "").reversed
      let key = d.pop
      yield (key, d)

proc walkUp(t: TableRef[string, HashSet[string]], tar: string): HashSet[string] =
  if t.contains(tar):
    let parents = t[tar]
    result = parents
    for p in parents:
      result = result + t.walkUp(p)

proc part1*(s: Stream): int =
  var t = newTable[string, HashSet[string]]()
  for (key, parsed) in s.asParsed:
    var parents = parsed.filterIt(not(it =~ peg"\d+"))
    for p in parents:
      if t.contains(p): t[p].incl(key)
      else: t[p] = [key].toHashSet()
  t.walkUp(target).len

proc walkDown(t: TableRef[string, TableRef[string, int]], tar: string): int =
  let children = t[tar]
  for (s, n) in children.pairs:
    result += n + (n * t.walkDown(s))

iterator asPairChunks(s: seq[string]): (string, int) =
  for i in countup(0, s.len - 1, 2): yield (s[i], s[i+1].parseInt)

proc part2*(s: Stream): int =
  var t = newTable[string, TableRef[string, int]]()
  for (key, parsed) in s.asParsed:
    var innert = newTable[string, int]()
    for (innerkey, n) in parsed.asPairChunks:
      innert[innerkey] = n
    t[key] = innert
  t.walkDown target
