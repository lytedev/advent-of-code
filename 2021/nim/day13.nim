import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

type
  Axis = enum X, Y
  Points = HashSet[(int, int)]
  Fold = (Axis, int)
  Folds = seq[Fold]

proc parse(input: Lines): (Points, Folds) =
  var parsingFolds = false
  for l in input.mapIt it.strip:
    if l == "": parsingFolds = true; continue
    if not parsingFolds:
      let coords = l.split(',').map parseInt
      result[0].incl (coords[0], coords[1])
    else:
      result[1].add ((if l.contains 'x': X else: Y), l.split('=')[1].parseInt)

proc printPoints(points: Points): void =
  var w, h = 0
  for (x, y) in points:
    w = max(w, x)
    h = max(h, y)
  var lines: Lines = @[]
  for y in 0..h: lines.add(' '.repeat(w+1))
  for (x, y) in points: lines[y][x] = '#'
  for l in lines: echo l

proc doFold(points: Points, f: Fold): Points =
  let (axis, n) = f
  for (x, y) in points:
    if (axis == X and x > n): result.incl((n - (x - n), y))
    elif (axis == Y and y > n):
      result.incl((x, n - (y - n)))
    else: result.incl((x, y))

proc p1(input: Lines): int =
  let (points, folds) = input.parse()
  points.doFold(folds[0]).len()

proc p2(input: Lines): int =
  let (points, folds) = input.parse()
  folds.reduce((points: Points, fold) => points.doFold(fold), points).printPoints()
  echo "You'll have to read this one on your own, captain."

const input = @[
  "6,10",
  "0,14",
  "9,10",
  "0,3",
  "10,4",
  "4,11",
  "6,0",
  "6,12",
  "4,1",
  "0,13",
  "10,12",
  "3,4",
  "3,0",
  "8,4",
  "1,10",
  "2,14",
  "8,10",
  "9,0",
  "",
  "fold along y=7",
  "fold along x=5",
]
doDay 13, n => n.loadInput, p1, p2, (input, 17, 0)
