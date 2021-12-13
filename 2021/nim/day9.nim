import ./common, std/[strutils, sequtils, strformat, sugar, sets, math, algorithm]

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

proc p2(c: seq[seq[int]]): int =
  let h = c.len()
  let w = c[0].len()
  var crawledPoints = toHashSet[(int, int)]([])
  var basins: seq[int] = @[]
  for y,l in c.pairs():
    for x,n in l.pairs():
      if crawledPoints.contains((x, y)): continue
      crawledPoints.incl((x, y))
      if n >= 9: continue
      var eligiblePoints = toHashSet[(int, int)]([(x, y)])
      var basin = 0
      while eligiblePoints.len() > 0:
        var newEligiblePoints = toHashSet[(int, int)]([])
        for (cx,cy) in eligiblePoints:
          inc basin
          for (nx,ny) in [(cx-1,cy),(cx+1,cy),(cx,cy-1),(cx,cy+1)]:
            if crawledPoints.contains((nx,ny)): continue
            if nx >= 0 and nx < w and ny >= 0 and ny < h and c[ny][nx] < 9:
              newEligiblePoints.incl((nx,ny))
              crawledPoints.incl((nx,ny))
        eligiblePoints = newEligiblePoints
      basins.add(basin)
  basins.sort(system.cmp[int], SortOrder.Descending)
  basins[0] * basins[1] * basins[2]

doDay(9, (n) => n.loadInput().toGrid(),
  p1,
  p2,
  """2199943210
3987894921
9856789892
8767896789
9899965678""".split('\n').toGrid(), 15, 1134)
