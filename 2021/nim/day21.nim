import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes, random]

const BOARD_POSITIONS = 10

proc p1(input: Lines): uint64 =
  var scores = [0, 0]
  var pos = [input[0].split(": ")[1].parseInt - 1, input[1].split(": ")[1].parseInt - 1]
  var rollNum = 1
  var turn = 0
  while scores[0] < 1000 and scores[1] < 1000:
    var move = 0
    for _ in 1..3:
      move += rollNum mod 100
      inc rollNum
    pos[turn] = (pos[turn] + move) mod BOARD_POSITIONS
    scores[turn] += pos[turn] + 1
    turn = (turn + 1) mod 2
  uint64(scores[turn mod 2] * (rollNum - 1))

type DiracGamestate = tuple
  scores: array[2, int]
  positions: array[2, int]
  turn: int

var turnOutcomes = newTable[DiracGamestate, array[2, uint64]]()
proc turn(g: DiracGamestate): array[2, uint64] =
  if turnOutcomes.hasKey g: return turnOutcomes[g]
  if g.scores[0] >= 21:
    return [1'u64, 0]
  elif g.scores[1] >= 21:
    return [0'u64, 1]
  for r in product(@[@[1,2,3],@[1,2,3],@[1,2,3]]):
    let move = r.foldl(a + b)
    var ng = g
    ng.positions[ng.turn] = (ng.positions[ng.turn] + move) mod BOARD_POSITIONS
    ng.scores[ng.turn] += ng.positions[ng.turn] + 1
    ng.turn = (ng.turn + 1) mod 2
    let r = turn(ng)
    turnOutcomes[ng] = r
    result[0] += r[0]
    result[1] += r[1]

proc p2(input: Lines): uint64 =
  var pos = [input[0].split(": ")[1].parseInt - 1, input[1].split(": ")[1].parseInt - 1]
  var g: DiracGamestate = (scores: [0, 0], positions: pos, turn: 0)
  let wins = turn(g)
  wins.max

const input = """
Player 1 starting position: 4
Player 2 starting position: 8
""".strip().split('\n')
doDayX 21, (n: int) => n.loadInput, p1, p2, (input, 739785'u64, 444356092776315'u64)
