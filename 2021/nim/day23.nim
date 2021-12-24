import ./common, std/[strutils, sugar, sequtils, options, tables, sets, strformat, algorithm]

type
  Vec2 = tuple[x: int, y: int]
  AmphipodBreed = enum A, B, C, D
  Amphipod = tuple[breed: AmphipodBreed, pos: Vec2]
  AmphipodCaveState = seq[Amphipod]

const HOMES = [2, 4, 6, 8]
let homeSet = HOMES.toHashSet

proc `$`(s: AmphipodCaveState): string =
  var ss = @["...........", "  . . . .", "  . . . .", ""]
  if s.len > 8:
    ss = @["...........", "  . . . .", "  . . . .", "  . . . .", "  . . . .", ""]
  for a in s:
    let bb = $a.breed
    ss[a.pos.y][a.pos.x] = bb[0]
  ss.join("\n")

proc weight(b: AmphipodBreed): int = [1, 10, 100, 1000][b.ord]
proc home(b: AmphipodBreed): int = HOMES[b.ord]
proc newAmphipod(b: AmphipodBreed, x: int, y: int): Amphipod = (breed: b, pos: (x: x, y: y))
proc parseAmphipodBreed(c: char): Option[AmphipodBreed] =
  case c:
    of 'A': some A
    of 'B': some B
    of 'C': some C
    of 'D': some D
    else: none AmphipodBreed

proc v2(x: int, y: int): Vec2 = (x, y)

proc parseCaveState(l: Lines): AmphipodCaveState =
  for y,s in l:
    for x,c in s:
      let b = c.parseAmphipodBreed
      if b.isSome: result.add newAmphipod(b.get, x - 1, y - 1)

proc path(s: AmphipodCaveState, ai: int, goal: Vec2): seq[Vec2] =
  let a = s[ai]
  if a.pos.y > 0:
    for y in toSeq(0..<a.pos.y).reversed:
      result.add (x: a.pos.x, y: y)
  for x in min(a.pos.x, goal.x)..max(a.pos.x, goal.x):
    if x == a.pos.x: continue
    result.add (x: x, y: 0)
  if goal.y > 0:
    for y in 1..goal.y:
      result.add (x: goal.x, y: y)

proc move(s: AmphipodCaveState, ai: int, p: Vec2): (AmphipodCaveState, uint64) =
  var newState = s
  newState[ai].pos = p
  (newState, s.path(ai, p).len.uint64 * s[ai].breed.weight.uint64)

proc spaceOccupied(s: AmphipodCaveState, p: Vec2): bool =
  s.anyIt(it.pos == p) or (p.y > 2 or p.y < 0 or p.x < 0 or p.x > 10)

proc canMoveTo(s: AmphipodCaveState, ai: int, goal: Vec2): bool =
  let a = s[ai]
  let pos = s[ai].pos
  if pos.y == 0 and goal.y == 0: return false
  if goal.y == 0 and homeSet.contains(goal.x): return false
  if goal.y > 0 and not homeSet.contains(goal.x): return false
  if goal.y >= 1:
    let maxY = if s.len > 8: 4 else: 2
    for y in 2..maxY:
      if not s.spaceOccupied(v2(goal.x, y)): return false
  if goal.y > 0:
    for sib in s:
      if sib.breed == a.breed: continue
      if sib.pos.x == goal.x and sib.pos.y > goal.y: return false
  if goal.y > 0 and goal.x != a.breed.home: return false
  let path = s.path(ai, goal)
  if path.anyIt(s.spaceOccupied(it)): return false
  true

proc isWin(s: AmphipodCaveState): bool =
  result = s.allIt(it.pos.x == it.breed.home and it.pos.y > 0)
  if result: echo &"WIN\n{s}\n"

proc possibleMoves(s: AmphipodCaveState, ai: int): HashSet[Vec2] =
  let a = s[ai]
  if a.pos.y > 0:
    for x in 0..10:
      if not homeSet.contains x: result.incl v2(x, 0)
  let maxY = if s.len > 8: 4 else: 2
  for y in 1..maxY:
    result.incl (x: a.breed.home, y: y)

proc getByPos(s: AmphipodCaveState, pos: Vec2): Option[Amphipod] = s.findFirstO(a => a.pos == pos)
proc isHome(a: Amphipod): bool = a.pos.x == a.breed.home and a.pos.y > 0

proc doneMoving(s: AmphipodCaveState, ai: int): bool =
  let maxY = if s.len > 8: 4 else: 2
  let a = s[ai]
  if a.isHome:
    if a.pos.y >= maxY: return true
    for y in (a.pos.y+1)..maxY:
      let below = s.getByPos((x: a.pos.x, y: y))
      if below.isSome:
        if below.get.breed != a.breed: return false
      else: return false
    return true
  false

var cheapestWins = newTable[AmphipodCaveState, (uint64, uint64)]()
proc cheapestWin(s: AmphipodCaveState, cost: uint64, depth = 0): uint64 =
  result = uint64.high
  # echo &"cheapestWin: {cost} {depth}\n{s}"
  if cheapestWins.hasKey s:
    if cheapestWins[s][0] <= cost:
      # echo &"cache hit for\n{s}\n -> {cheapestWins[s]}"
      return cheapestWins[s][1]
  if s.isWin or cost > 400000 or depth >= (s.len * 2): return cost
  var costs = initHashSet[uint64]()
  for ai,a in s:
    if s.doneMoving(ai): continue
    for p in s.possibleMoves ai:
      if not s.canMoveTo(ai, p): continue
      # echo &"Moving {ai} from {a.pos} to {p} at turn {depth}"
      let (newState, moveCost) = s.move(ai, p)
      costs.incl newState.cheapestWin(cost + moveCost, depth + 1)
  for c in costs: result = min(result, c)
  cheapestWins[s] = (cost, result)

proc testMoves(state: AmphipodCaveState, moves: seq[(int, Vec2)]) =
  var s = state
  var cost: uint64 = 0
  for m in moves:
    echo s
    let (ai, goal) = m
    let doneMoving = s.doneMoving(ai)
    let suggestions = s.possibleMoves(ai)
    echo suggestions
    var sugs = @["...........", "  . . . .", "  . . . .", ""]
    if s.len > 8:
      sugs = @["...........", "  . . . .", "  . . . .", "  . . . .", "  . . . .", ""]
    for sug in suggestions:
      sugs[sug.y][sug.x] = 'X'
    sugs[s[ai].pos.y][s[ai].pos.x] = 'O'
    sugs[goal.y][goal.x] = '#'
    echo sugs.join("\n")
    let allowed = s.canMoveTo(ai, goal)
    let suggested = suggestions.contains goal
    echo &"Can move {ai} from {s[ai].pos} to {goal}: allowed: {allowed}, suggested: {suggested}, doneMoving: {doneMoving}"
    var (newState, moveCost) = s.move(ai, goal)
    cost += moveCost
    s = newState
    echo &"Did we win? {s.isWin} -- Cost so far: {cost}"

proc p1(input: Lines): uint64 =
  echo "Crunching part 1"
  input.parseCaveState.cheapestWin(0)

proc p2(input: Lines): uint64 =
  echo "Crunching part 2"
  var unfoldedInput = input
  unfoldedInput.insert("  #D#C#B#A#", 3)
  unfoldedInput.insert("  #D#B#A#C#", 4)
  echo unfoldedInput.parseCaveState
  unfoldedInput.parseCaveState.testMoves(@[
    (3, (x: 10, y: 0)),
    (7, (x: 0, y: 0)),
    (2, (x: 9, y: 0)),
    (6, (x: 7, y: 0)),
    (10, (x: 1, y: 0)),
    (1, (x: 6, y: 3)),
    (5, (x: 6, y: 2)),
    (9, (x: 5, y: 0)),
    (13, (x: 3, y: 0)),
    (9, (x: 4, y: 4)),
    (6, (x: 4, y: 3)),
    (2, (x: 4, y: 2)),
    (11, (x: 6, y: 1)),
    (15, (x: 9, y: 0)),
    (13, (x: 8, y: 4)),
    (0, (x: 4, y: 1)),
    (4, (x: 8, y: 3)),
    (8, (x: 8, y: 2)),
    (10, (x: 2, y: 3)),
    (7, (x: 2, y: 2)),
    (15, (x: 2, y: 1)),
    (3, (x: 8, y: 1)),
  ])
  echo "Crunching part 2"
  unfoldedInput.parseCaveState.cheapestWin(0)

const rt = ("""
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
""".strip().split('\n'), 12521'u64, 44169'u64)
doDayX 23, (n: int) => n.loadInput, p1, p2, rt
