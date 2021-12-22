import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes, random, pegs]

const BOARD_POSITIONS = 10

type
  Vec3 = tuple[x: int, y: int, z: int]
  Cuboid = tuple[pos: Vec3, size: Vec3]
  GeoOp = (bool, Cuboid)

let parser = peg"""
grammar <- {'on' / 'off'} ' x=' range ',y=' range ',z=' range
range <- {num} \. \. {num}
num <- ('-' \d+) / \d+
"""

proc `+`(a: Vec3, b: Vec3): Vec3 = (x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)
proc `-`(a: Vec3, b: Vec3): Vec3 = (x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)
proc `*`(a: Vec3, b: Vec3): Vec3 = (x: a.x * b.x, y: a.y * b.y, z: a.z * b.z)

proc parse(s: string): Option[GeoOp] =
  if s =~ parser:
    let
      n = matches[1..6].map(parseInt)
      pos = (x: min(n[0], n[1]), y: min(n[2], n[3]), z: min(n[4], n[5]))
      size = (x: n[0] + n[1], y: n[2] + n[3], z: n[4] + n[5]) - pos
    result = some (matches[0][1] == 'n', (pos, size))

proc vertices(c: Cuboid): array[6, Vec3] =
  result[0] = c.pos
  result[1] = c.pos + (c.size * (x: 1, y: 0, z: 0))
  result[2] = c.pos + (c.size * (x: 0, y: 1, z: 0))
  result[3] = c.pos + (c.size * (x: 0, y: 0, z: 1))
  result[4] = c.pos + (c.size * (x: 1, y: 1, z: 0))
  result[5] = c.pos + (c.size * (x: 1, y: 1, z: 1))

proc intersects(a: Cuboid, b: Cuboid): bool =
  for v in a.vertices:
    if b.contains v:
      return true

proc contains(a: Cuboid, b: Vec3): bool =
  b.x >= a.pos.x and b.x <= (a.pos.x + a.size.x) and
    b.y >= a.pos.y and b.y <= (a.pos.y + a.size.y) and
    b.z >= a.pos.z and b.z <= (a.pos.z + a.size.z)

proc contains(a: Cuboid, b: Cuboid): bool =
  for v in a.vertices:
    if not b.contains v:
      return false

proc shatteredUnion(a: Cuboid, b: Cuboid): seq[Cuboid] =
  if a.contains b: @[a]
  elif b.contains a: @[b]
  elif a.intersects b:
  else: @[a, b]

proc p1(input: Lines): uint64 =
  var onCuboids = initHashSet[Cuboid]()
  for l in input:
    let gop = l.parse

proc p2(input: Lines): uint64 =
  0

const input = """
on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682
""".strip().split('\n')
doDayX 22, (n: int) => n.loadInput, p1, p2, (input, 590784'u64, 0'u64)
