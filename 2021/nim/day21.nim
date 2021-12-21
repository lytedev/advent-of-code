import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes, random]

proc p1(input: Lines): uint64 =
  const DIE_FACES = 100
  const TARGET_SCORE = 1000
  const BOARD_POSITIONS = 10

  var scores = [0, 0]
  var pos = [input[0].split(": ")[1].parseInt - 1, input[1].split(": ")[1].parseInt - 1]
  var rollNum = 1
  var turn = 0
  while scores[0] < TARGET_SCORE and scores[1] < TARGET_SCORE:
    var move = 0
    for _ in 1..3:
      move += rollNum mod DIE_FACES
      inc rollNum
    pos[turn] = (pos[turn] + move) mod BOARD_POSITIONS
    scores[turn] += pos[turn] + 1
    echo &"{move}, {pos[turn]}, {scores}"
    turn = (turn + 1) mod 2

  echo rollNum, scores
  uint64(scores[turn mod 2] * (rollNum - 1))

proc p2(input: Lines): uint64 =
  0

const input = """
Player 1 starting position: 4
Player 2 starting position: 8
""".strip().split('\n')
doDayX 21, (n: int) => n.loadInput, p1, p2, (input, 739785'u64, 444356092776315'u64)
