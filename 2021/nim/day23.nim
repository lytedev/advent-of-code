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

proc roomAvailable(s: AmphipodCaveState, column: int): bool =
  true

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
  # echo " -> once in the hallway, we can't move somewhere else in the hallway"
  if pos.y == 0 and goal.y == 0: return false
  # echo " -> no blocking"
  if goal.y == 0 and homeSet.contains(goal.x): return false
  # echo " -> non-positions"
  if goal.y > 0 and not homeSet.contains(goal.x): return false
  # echo " -> can't leave empty spots below when going home"
  if goal.y == 1 and not s.spaceOccupied(v2(goal.x, 2)): return false
  # echo " -> can't enter home if occupied by another breed"
  if goal.y > 0:
    for sib in s:
      if sib.breed == a.breed: continue
      if sib.pos.x == goal.x and sib.pos.y > goal.y: return false
  # echo " -> can't enter somebody else's home"
  if goal.y > 0 and goal.x != a.breed.home: return false
  # echo " -> can't move through any occupied positions"
  let path = s.path(ai, goal)
  if path.anyIt(s.spaceOccupied(it)): return false
  # echo " -> Allowed!"
  true

proc isWin(s: AmphipodCaveState): bool =
  result = s.allIt(it.pos.x == it.breed.home and it.pos.y > 0)
  # if result:
    # echo s
    # echo "I WON"

proc possibleMoves(s: AmphipodCaveState, ai: int): HashSet[Vec2] =
  let a = s[ai]
  var possibleMoves = newSeq[Vec2]()
  if a.pos.y > 0:
    for x in 0..10:
      if not homeSet.contains x: result.incl v2(x, 0)
  for y in 1..2:
    result.incl (x: a.breed.home, y: y)

proc getByPos(s: AmphipodCaveState, pos: Vec2): Option[Amphipod] = s.findFirstO(a => a.pos == pos)
proc isHome(a: Amphipod): bool = a.pos.x == a.breed.home and a.pos.y > 0

proc doneMoving(s: AmphipodCaveState, ai: int): bool =
  let a = s[ai]
  if a.isHome and a.pos.y >= 2: return true
  let below = s.getByPos((x: a.pos.x, y: 2))
  if below.isSome: return a.isHome and below.get.isHome

var cheapestWins = newTable[AmphipodCaveState, (uint64, uint64)]()
proc cheapestWin(s: AmphipodCaveState, cost: uint64, depth = 0): uint64 =
  result = uint64.high
  # echo &"cheapestWin: {cost} {depth}\n{s}"
  if cheapestWins.hasKey s:
    # echo &"cache hit for {s}: {cheapestWins[s]}"
    if cheapestWins[s][0] <= cost:
      return cheapestWins[s][1]
  if s.isWin or cost > 400000: return cost
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
  input.parseCaveState.cheapestWin(0)

proc p2(input: Lines): uint64 =
  var unfoldedInput = input
  unfoldedInput.insert("  #D#C#B#A#", 1)
  unfoldedInput.insert("  #D#C#B#A#", 2)
  unfoldedInput.parseCaveState.cheapestWin(0)

const rt = ("""
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
""".strip().split('\n'), 12521'u64, 44169'u64)
doDayX 23, (n: int) => n.loadInput, p1, p2, rt
