import streams, strutils, tables

type Dir = enum north, east, south, west

proc rotate(d: Dir, n = 0): Dir = Dir((ord(d) + n) %% 4)
proc left(d: Dir, n = 1): Dir = d.rotate(n)
proc right(d: Dir, n = 1): Dir = d.rotate(-n)

const dirMap = {north: (0, -1), east: (1, 0), south: (0, 1), west: (-1, 0)}.toTable

proc move(pos: (int, int), nvel: (int, int), mag = 1): (int, int) =
  ((pos[0] + (nvel[0] * mag)), (pos[1] + (nvel[1] * mag)))

proc part1*(s: Stream): int =
  var d = east
  var p = (0, 0)
  for l in s.lines:
    let arg = l[1..^1].parseInt
    case l[0]:
      of 'N': p = p.move(dirMap[north], arg)
      of 'S': p = p.move(dirMap[south], arg)
      of 'E': p = p.move(dirMap[east], arg)
      of 'W': p = p.move(dirMap[west], arg)
      of 'L': d = d.left(arg div 90)
      of 'R': d = d.right(arg div 90)
      else: p = p.move(dirMap[d], arg)
  p[0].abs + p[1].abs

proc `-`(a: (int, int), b: (int, int)): (int, int) = (a[0] - b[0], a[1] - b[1])
proc `+`(a: (int, int), b: (int, int)): (int, int) = (a[0] + b[0], a[1] + b[1])
proc left(p: (int, int), n = 1): (int, int) =
  result = (p[1],-p[0])
  if n > 1: result = left(result, n - 1)
proc right(p: (int, int), n = 1): (int, int) =
  result = (-p[1],p[0])
  if n > 1: result = right(result, n - 1)

proc part2*(s: Stream): int =
  var d = east
  var p = (0, 0)
  var wp = (10, -1)
  for l in s.lines:
    let arg = l[1..^1].parseInt
    case l[0]:
      of 'N': wp = wp.move(dirMap[north], arg)
      of 'S': wp = wp.move(dirMap[south], arg)
      of 'E': wp = wp.move(dirMap[east], arg)
      of 'W': wp = wp.move(dirMap[west], arg)
      of 'L': wp = wp.left(arg div 90)
      of 'R': wp = wp.right(arg div 90)
      else: p = p.move(wp, arg)
  p[0].abs + p[1].abs

doAssert "F10\nN3\nF7\nR90\nF11".newStringStream.part2 == 286
doAssert left((9, 8), 2) == (-9, -8)
doAssert left((9, 1)) == (1, -9)
doAssert right((1, 9)) == (-9, 1)
