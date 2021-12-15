import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

type
  Coordinate = uint
  Cost = uint
  Node = (Coordinate, Coordinate)
  NodeSet = HashSet[Node]
  Grid = Table[Node, Cost]

proc digitToUint(c: char): Cost = c.uint - '0'.uint
proc toGrid(input: Lines): (Grid, Coordinate, Coordinate) =
  for y, line in input.pairs:
    for x, c in line:
      result[1] = max(x.uint + 1, result[1])
      result[2] = max(y.uint + 1, result[2])
      result[0][(x.uint, y.uint)] = c.digitToUint

proc lowest(nodes: NodeSet, scores: Grid): Node =
  var lowest = uint.high
  for n in nodes:
    let score = scores.getOrDefault(n, uint.high)
    if score < lowest:
      result = n
      lowest = score

proc astarCost(grid: Grid, start: Node, goal: Node, w: Coordinate, h: Coordinate, heuristic: (Node) -> Cost): Cost =
  var open: NodeSet = [start].toHashSet
  var cameFrom = initTable[Node, Node]()
  var bestScores: Grid = {start: start.heuristic}.toTable
  var guessScores: Grid = {start: start.heuristic}.toTable

  while open.len() > 0:
    var (x, y) = open.lowest guessScores
    if (x, y) == goal:
      var walker = goal
      while cameFrom.contains(walker):
        result += walker.heuristic
        walker = cameFrom[walker]
      return

    open.excl (x, y)
    for neighbor in [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]:
      if uint.high == neighbor[0] or uint.high == neighbor[1] or w == neighbor[0] or h == neighbor[1]: continue
      # TODO: could this overflow?
      var maybeBestScore = bestScores[(x, y)] + neighbor.heuristic
      if maybeBestScore < bestScores.getOrDefault(neighbor, uint.high):
        cameFrom[neighbor] = (x, y)
        bestScores[neighbor] = maybeBestScore
        guessScores[neighbor] = maybeBestScore + neighbor.heuristic
        if not open.contains(neighbor):
          open.incl(neighbor)

proc p1(input: Lines): uint64 =
  let (grid, w, h) = input.toGrid
  let heuristic = (n: Node) => grid[n]
  let start: Node = (0'u, 0'u)
  let goal: Node = (w - 1, h - 1)
  astarCost(grid, start, goal, w, h, heuristic)

proc p2(input: Lines): uint64 =
  let (mainTile, mtw, mth) = input.toGrid
  var grid: Grid = initTable[Node, Cost]()
  for tx in 0'u..<5'u:
    for ty in 0'u..<5'u:
      for x in 0'u..<mtw:
        for y in 0'u..<mth:
          let (ax, ay) = ((mtw * tx) + x, (mth * ty) + y)
          var c = mainTile[(x, y)] + tx + ty
          if c > 9: c -= 9
          grid[(ax, ay)] = c
  let (w, h) = (mtw * 5'u, mth * 5'u) 
  let heuristic = (n: Node) => grid[n]
  let start: Node = (0'u, 0'u)
  let goal: Node = (w - 1, h - 1)
  astarCost(grid, start, goal, w, h, heuristic)

  # astar
const input = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
""".strip().split('\n').mapIt(it.strip)
doDayX 15, (n: int) => n.loadInput, p1, p2, (input, 40'u64, 315'u64)
