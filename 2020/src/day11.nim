import streams, sequtils

type
  Seat = enum Floor, Empty, Occupied
  Grid[T] = seq[seq[T]]

proc row[T](g: Grid[T], y: int): seq[T] = g[y]
proc at[T](g: Grid[T], x: int, y: int): T = g.row(y)[x]

proc toSeat(c: char): Seat =
  case c
    of 'L': Empty
    of '#': Occupied
    else: Floor

proc asGrid(s: Stream): Grid[Seat] =
  for l in s.lines: result.add l.map toSeat

proc getAdjacent(g: Grid[Seat], x: int, y: int): seq[Seat] =
  for sy in y-1..y+1:
    for sx in x-1..x+1:
      if sy >= 0 and sx >= 0 and sy < g.len and sx < g.row(sy).len:
        result.add g.at(sx, sy)

proc stepGrid(g: Grid[Seat]): Grid[Seat] =
  for y in 0..<g.len:
    result.add @[]
    for x in 0..<g.row(y).len:
      let adj = getAdjacent(g, x, y)
      result[y].add case g.at(x, y)
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

proc part1*(s: Stream): int =
  # TODO: part1 has tons of allocating - needs cleaning up
  return 0
  var g = s.asGrid
  var ng: Grid[Seat]
  while g != ng:
    ng = g
    g = g.stepGrid
  g.foldl(a.concat b).countIt(it == Occupied)

type
  SightSeat = (Seat, seq[tuple[x: int, y: int]])
  SightGrid = seq[seq[SightSeat]]

proc inBounds(g: Grid, x: int, y: int): bool =
  x >= 0 and y >= 0 and y < g.len and x < g.row(y).len

proc toSightSeat(g: Grid[Seat], x: int, y: int): SightSeat =
  echo "toSightSeat"
  result[0] = g.at(x, y)
  for vy in -1..1:
    for vx in -1..1:
      if vy == 0 and vx == 0: continue
      var tx = x + vx
      var ty = y + vy
      while g.inBounds(tx, ty) and g.at(tx, ty) == Floor:
        echo "Still...", tx, ty
        tx += vx
        ty += vy
      if g.inBounds(tx, ty): result[1].add (x: tx, y: ty)

proc asSightGrid(s: Stream): SightGrid =
  let g = s.asGrid
  for y in 0..<g.len:
    result.add @[]
    for x in 0..<g.row(y).len:
      result[y].add g.toSightSeat(x, y)

proc getSightAdjacent(g: Grid[SightSeat], x: int, y: int): seq[Seat] =
  for (tx, ty) in g.at(x, y)[1]:
    result.add g.at(tx, ty)[0]

proc stepSightGrid(g: Grid[SightSeat]): Grid[SightSeat] =
  echo "Step..."
  for y in 0..<g.len:
    result.add @[]
    for x in 0..<g.row(y).len:
      let adj = getSightAdjacent(g, x, y)
      let (s, sights) = g.at(x, y)
      let newSeat = case s
        of Floor: Floor
        of Empty:
          if adj.countIt(it == Occupied) == 0:
            Occupied
          else:
            Empty
        of Occupied:
          if adj.countIt(it == Occupied) >= 6:
            Empty
          else:
            Occupied
      result[y].add (newSeat, sights)

proc part2*(s: Stream): int =
  # TODO: part2 has tons of allocating - needs cleaning up
  var g = s.asSightGrid
  var ng: Grid[SightSeat]
  while g != ng:
    ng = g
    g = g.stepSightGrid
  g.foldl(a.concat b).countIt(it[0] == Occupied)
