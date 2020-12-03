import streams

proc sled(s: Stream, velx: int, vely: int): int =
  var xpos, ypos: int
  for line in s.lines():
    ypos += 1
    if (ypos - 1) mod vely > 0:
      continue
    if line[xpos mod line.len()] == '#':
      result += 1
    xpos += velx

proc part1*(s: Stream): int =
  sled(s, 3, 1)

proc part2*(s: Stream): int =
  result = part1(s)
  for vels in [(1, 1), (5, 1), (7, 1), (1, 2)]:
    setPosition(s, 0)
    let (velx, vely) = vels
    result *= sled(s, velx, vely)
