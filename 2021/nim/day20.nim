import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes]

type
  Point = (int, int)
  Image = object
    pixels: TableRef[Point, bool]
    topLeft: Point
    bottomRight: Point
    infinite: bool

proc parse(s: openArray[string]): Image =
  var pixels = newTable[Point, bool]()
  for y,l in s.pairs:
    for x,c in l:
      pixels[(x, y)] = c == '#'
  return Image(topLeft: (0, 0), bottomRight: (s[0].len-1, s.len-1), pixels: pixels, infinite: false)

proc enhance(image: var Image, algo: string) =
  var (tlx, tly) = image.topLeft
  var (brx, bry) = image.bottomRight
  var newPixels = newTable[Point, bool]()
  var xr = tlx-1..brx+1
  var yr = tly-1..bry+1
  for x in xr:
    for y in yr:
      var sample = 0
      for sy in y-1..y+1:
        for sx in x-1..x+1:
          if image.pixels.getOrDefault((sx, sy), image.infinite):
            inc sample
          sample = sample shl 1
      sample = sample shr 1
      # echo &"{x}, {y} => {sample}"
      newPixels[(x, y)] = algo[sample] == '#'
      if x < tlx: tlx = x
      if y < tly: tly = y
      if x > brx: brx = x
      if y > bry: bry = y
  image.topLeft = (tlx, tly)
  image.bottomRight = (brx, bry)
  image.pixels = newPixels
  if image.infinite:
    image.infinite = algo[^1] == '#'
  else:
    image.infinite = algo[0] == '#'

proc `$`(image: Image): string =
  var s: seq[string] = @[]
  var (tlx, tly) = image.topLeft
  var (brx, bry) = image.bottomRight
  for _ in tly..bry:
    s.add ".".repeat((brx-tlx)+1)
  for p in image.pixels.keys:
    let (x, y) = p
    if image.pixels[p]: s[y-tly][x-tlx] = '#'
  s.join("\n")

proc solver(input: Lines, times: int): uint64 =
  let algo = input[0]
  var image = input[2..^1].parse()
  for _ in 1..times: image.enhance algo
  for v in image.pixels.values:
    if v: inc result

proc p1(input: Lines): uint64 = input.solver(2)
proc p2(input: Lines): uint64 = input.solver(50)

const input = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..### """.strip().split('\n')
doDayX 20, (n: int) => n.loadInput, p1, p2, (input, 35'u64, 3351'u64)
