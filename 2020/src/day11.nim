import streams, sequtils, strutils

type
  Seat = enum Floor, Empty, Occupied
  Grid = seq[seq[Seat]]

doAssert @[@[Occupied, Empty], @[Floor, Empty]] == @[@[Occupied, Empty], @[Floor, Empty]]

proc gridSummary(g: Grid): (int, int) =
  ## Used during debugging
  var o, v = 0
  for y in 0..<g.len:
    for x in 0..<g[y].len:
      case g[y][x]:
        of Empty: inc v
        of Occupied: inc o
        else: discard
  (o, v)

proc `$`(s: Seat): string =
  case s
    of Empty: "L"
    of Occupied: "#"
    else: "."

proc gridLine(l: seq[Seat]): string = join(l.mapIt($it))

proc toSeat(c: char): Seat =
  case c
    of 'L': Empty
    of '#': Occupied
    else: Floor

proc asGrid(s: Stream): Grid =
  for l in s.lines: result.add l.map toSeat

proc getAdjacent(g: Grid, x: int, y: int): seq[Seat] =
  for sy in y-1..y+1:
    for sx in x-1..x+1:
      if sy >= 0 and sx >= 0 and sy < g.len and sx < g[sy].len:
        result.add g[sy][sx]

proc stepGrid(g: Grid): Grid =
  #echo "Step"
  for y in 0..<g.len:
    #echo g[y].gridLine
    result.add @[]
    for x in 0..<g[y].len:
      let adj = getAdjacent(g, x, y)
      result[y].add case g[y][x]
        of Floor: Floor
        of Empty:
          if adj.countIt(it == Occupied) == 0:
            Occupied
          else:
            Empty
        of Occupied:
          if adj.countIt(it == Occupied) >= 5:
            Empty
          else:
            Occupied
      #echo (x, y, g[y][x], gridSummary(@[adj]), adj.gridLine, result[y][x])

proc part1*(s: Stream): int =
  var g = s.asGrid
  var ng: Grid
  while g != ng:
    echo "\n\nGrid:\n", g.gridSummary
    ng = g
    g = g.stepGrid
  g.foldl(a.concat b).countIt(it == Occupied)


proc part2*(s: Stream): int =
  0
