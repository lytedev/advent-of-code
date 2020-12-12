import streams, sequtils, strutils, tables

type Dir = enum north, east, south, west

proc left(d: Dir, n = 1): Dir = Dir((ord(d) - n) %% 4)
proc right(d: Dir, n = 1): Dir = Dir((ord(d) + n) %% 4)

const dirMap = {north: (0, -1), east: (1, 0), south: (0, 1), west: (-1, 0)}.toTable

proc move(pos: (int, int), nvel: (int, int), mag: int): (int, int) =
  ((pos[0] + (nvel[0] * mag)), (pos[1] + (nvel[1] * mag)))

proc part1*(s: Stream): int =
  var d = east
  var p = (0, 0)
  for l in s.lines:
    let arg = l[1..^1].parseInt
    echo arg
    case l[0]:
      of 'N': p = p.move(dirMap[north], arg)
      of 'S': p = p.move(dirMap[south], arg)
      of 'E': p = p.move(dirMap[east], arg)
      of 'W': p = p.move(dirMap[west], arg)
      of 'L': d = d.left(arg div 90)
      of 'R': d = d.right(arg div 90)
      else: p = p.move(dirMap[d], arg)
  p[0].abs + p[1].abs


proc part2*(s: Stream): int =
  9
