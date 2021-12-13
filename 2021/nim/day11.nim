import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils]

proc toGrid(s: seq[string]): seq[seq[int]] =
  for l in s: result.add(l.mapIt(int(it)-int('0')))

proc octopi(input: seq[seq[int]]): int =
  var o = input
  let h = o.len
  let w = o[0].len
  # echo &"w{w} h{h}"
  for n in 1..100:
    # for nums in o:
      # echo nums.mapIt($it).join()
    # echo n
    var allFlashes = toHashSet[(int, int)] []
    var flashes = toHashSet[(int, int)] []
    for y in 0..<h:
      for x in 0..<w:
        # inc and check flashes
        inc o[y][x]
        if o[y][x] > 9:
          # echo &"Flash {y}, {x}"
          inc result
          flashes.incl (y, x)
          allFlashes.incl (y, x)
    while flashes.len > 0:
      let (y, x) = flashes.pop
      # echo &"Handling flash {y}, {x}"
      for p in product @[@[y-1, y, y+1], @[x-1, x, x+1]]:
        let (fy, fx) = (p[0], p[1])
        if fx < 0 or fy < 0 or fx >= w or fy >= h or (fx == x and fy == y): continue
        # inc and check flashes
        inc o[fy][fx]
        if o[fy][fx] > 9 and not allFlashes.contains (fy, fx):
          # echo &"Subflash {fy}, {fx}"
          inc result
          flashes.incl (fy, fx)
          allFlashes.incl (fy, fx)
    for f in allFlashes.items():
      o[f[0]][f[1]] = 0

proc octopiUntilAll(input: seq[seq[int]]): int =
  var o = input
  let h = o.len
  let w = o[0].len
  # echo &"w{w} h{h}"
  for n in 1..1000000:
    # for nums in o:
      # echo nums.mapIt($it).join()
    # echo n
    var allFlashes = toHashSet[(int, int)] []
    var flashes = toHashSet[(int, int)] []
    for y in 0..<h:
      for x in 0..<w:
        # inc and check flashes
        inc o[y][x]
        if o[y][x] > 9:
          # echo &"Flash {y}, {x}"
          inc result
          flashes.incl (y, x)
          allFlashes.incl (y, x)
    while flashes.len > 0:
      let (y, x) = flashes.pop
      # echo &"Handling flash {y}, {x}"
      for p in product @[@[y-1, y, y+1], @[x-1, x, x+1]]:
        let (fy, fx) = (p[0], p[1])
        if fx < 0 or fy < 0 or fx >= w or fy >= h or (fx == x and fy == y): continue
        # inc and check flashes
        inc o[fy][fx]
        if o[fy][fx] > 9 and not allFlashes.contains (fy, fx):
          # echo &"Subflash {fy}, {fx}"
          inc result
          flashes.incl (fy, fx)
          allFlashes.incl (fy, fx)
    if allFlashes.len() == (w * h):
      return n
    for f in allFlashes.items():
      o[f[0]][f[1]] = 0

doDay 11, n => n.loadInput().toGrid(), octopi, octopiUntilAll,
  @[
    "5483143223",
    "2745854711",
    "5264556173",
    "6141336146",
    "6357385478",
    "4167524645",
    "2176841721",
    "6882881134",
    "4846848554",
    "5283751526",
    ].toGrid(), 1656, 195
