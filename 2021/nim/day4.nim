import std/[strutils, sequtils, options, math, parseutils, sets, strformat, algorithm]
import ./common

type Board = object
  entries: seq[string]
  checked: seq[int]

proc isBoardWinning(b: Board): bool =
  let winningSets: seq[HashSet[int]] = [
    [0, 1, 2, 3, 4],
    [5, 6, 7, 8, 9],
    [10, 11, 12, 13, 14],
    [15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24],
    [0, 5, 10, 15, 20],
    [1, 6, 11, 16, 21],
    [2, 7, 12, 17, 22],
    [3, 8, 13, 18, 23],
    [4, 9, 14, 19, 24]
  ].mapIt(it.toHashSet())

  let s = b.checked.toHashSet()
  for w in winningSets:
    if w < s:
      return true
  return false

proc squidBingo(inputLines: seq[string]): int =
  var input: seq[string] = inputLines
  let calledNumbers: seq[string] = input[0].split ','
  input.delete 0..1

  # construct boards
  var boards: seq[Board]
  var board: Board = Board(entries: @[], checked: @[])
  for l in input:
    if l.strip() == "":
      boards.add board
      board = Board(entries: @[], checked: @[])
      continue
    board.entries.add l.split(' ').filterIt(it != "").mapIt(it.strip())

  boards.add board

  for n in calledNumbers:
    for b in boards.mitems():
      for i, e in b.entries:
        if n == e:
          b.checked.add i
      if b.isBoardWinning():
        var entriesSum = 0
        for i, v in b.entries:
          if not (i in b.checked): entriesSum += v.parseInt()
        return entriesSum * n.parseInt()

  return 0

proc loseSquidBingo(inputLines: seq[string]): int =
  var input: seq[string] = inputLines
  let calledNumbers: seq[string] = input[0].split ','
  input.delete 0..1

  # construct boards
  var boards: seq[Board]
  var board: Board = Board(entries: @[], checked: @[])
  for l in input:
    if l.strip() == "":
      boards.add board
      board = Board(entries: @[], checked: @[])
      continue
    board.entries.add l.split(' ').filterIt(it != "").mapIt(it.strip())

  boards.add board

  for n in calledNumbers:
    var removeBoards: seq[int] = @[]
    for bbi, b in boards.mpairs():
      for i, e in b.entries:
        if n == e:
          b.checked.add i
      if b.isBoardWinning():
        if (boards.len() - removeBoards.len()) < 2:
          var entriesSum = 0
          for i, v in b.entries:
            if not (i in b.checked): entriesSum += v.parseInt()
          return entriesSum * n.parseInt()
        else:
          removeBoards.add(bbi)
    for i in removeBoards.reversed():
      boards.delete(i..i)
  return 0

let input = 4.loadInput()
time("squidBingo part 1"): echo input.squidBingo()
time("loseSquidBingo part 2"): echo input.loseSquidBingo()

when not defined(release):
  let testInput = """7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
8  2 23  4 24
21  9 14 16  7
6 10  3 18  5
1 12 20 15 19

3 15  0  2 22
9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
2  0 12  3  7""".split('\n')
  doAssert testInput.squidBingo() == 4512
  doAssert testInput.loseSquidBingo() == 1924
