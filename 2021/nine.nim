import ./common, std/[strutils, sequtils, strformat, sugar, sets, math]

proc toGrid(s: seq[string]): seq[seq[int]] =
  for l in s: result.add(l.mapIt(int(it)-int('0')))

proc p1(c: seq[seq[int]]): int =
  let h = c.len()
  let w = c[0].len()
  for y,l in c.pairs():
    for x,n in l.pairs():
      if x > 0 and c[y][x-1] <= n: continue
      if y > 0 and c[y-1][x] <= n: continue
      if x < w-1 and c[y][x+1] <= n: continue
      if y < h-1 and c[y+1][x] <= n: continue
      result += n + 1

doDay(9, (n) => n.loadInput().toGrid(),
  p1,
  p1,
  """2199943210
3987894921
9856789892
8767896789
9899965678""".split('\n').toGrid(), 15, 15)
