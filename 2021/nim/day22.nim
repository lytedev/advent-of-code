import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes, random, pegs]

const BOARD_POSITIONS = 10

type
  Vec3 = tuple[x: int, y: int, z: int]
  Cuboid = tuple[pos: Vec3, size: Vec3]
  CuboidGeometry = HashSet[Cuboid]

  CuboidOperator = enum union, difference
  CuboidOperation = (CuboidOperator, Cuboid)

let parser = peg"""
grammar <- {'on' / 'off'} ' x=' range ',y=' range ',z=' range
range <- {num} \. \. {num}
num <- ('-' \d+) / \d+
"""

proc apply(a: Vec3, b: Vec3, f: (int, int) -> int): Vec3 = (x: f(a.x, b.x), y: f(a.y, b.y), z: f(a.z, b.z))
proc `+`(a: Vec3, b: Vec3): Vec3 = a.apply(b, (a, b) => a + b)
proc `-`(a: Vec3, b: Vec3): Vec3 = a.apply(b, (a, b) => a - b)
proc `*`(a: Vec3, b: Vec3): Vec3 = a.apply(b, (a, b) => a * b)
proc volume(a: Vec3): uint64 = a.x.abs.uint64 * a.y.abs.uint64 * a.z.abs.uint64
proc volume(c: CuboidGeometry): uint64 =
  for cb in c: result += cb.size.volume
proc min(a: Vec3, b: Vec3): Vec3 = a.apply(b, (a, b) => min(a, b))
proc max(a: Vec3, b: Vec3): Vec3 = a.apply(b, (a, b) => max(a, b))
proc v3(x: int, y: int, z: int): Vec3 = (x: x, y: y, z: z)
proc cuboid(pos: Vec3, size: Vec3): Cuboid = (pos: pos, size: size)
proc cuboid(x: int, y: int, z: int, w: int, d: int, h: int): Cuboid = cuboid(v3(x, y, z), v3(w, d, h))

proc parseCuboidOperator(s: string): CuboidOperator =
  if s[1] == 'n': union else: difference

proc parse(s: string): Option[CuboidOperation] =
  if s =~ parser:
    let
      n = matches[1..6].map parseInt
      pos = v3(min(n[0], n[1]), min(n[2], n[3]), min(n[4], n[5]))
      size = v3(max(n[0], n[1]) + 1, max(n[2], n[3]) + 1, max(n[4], n[5]) + 1) - pos
    result = some (matches[0].parseCuboidOperator, (pos, size))

proc vertices(c: Cuboid): array[6, Vec3] =
  result[0] = c.pos
  result[1] = c.pos + (c.size * v3(1, 0, 0))
  result[2] = c.pos + (c.size * v3(0, 1, 0))
  result[3] = c.pos + (c.size * v3(0, 0, 1))
  result[4] = c.pos + (c.size * v3(1, 1, 0))
  result[5] = c.pos + (c.size * v3(1, 1, 1))

proc contains(a: Cuboid, b: Vec3): bool =
  b.x >= a.pos.x and b.x <= (a.pos.x + a.size.x) and
    b.y >= a.pos.y and b.y <= (a.pos.y + a.size.y) and
    b.z >= a.pos.z and b.z <= (a.pos.z + a.size.z)

proc contains(a: Cuboid, b: Cuboid): bool = b.vertices.allIt a.contains it

proc intersect(a: Cuboid, b: Cuboid): Option[Cuboid] =
  let amx = a.pos + a.size
  let bmx = b.pos + b.size
  if amx.x < b.pos.x or bmx.x < a.pos.x or
    amx.y < b.pos.y or bmx.y < a.pos.y or
    amx.z < b.pos.z or bmx.z < a.pos.z:
    return none Cuboid
  let pos = max(a.pos, b.pos)
  some (pos: pos, size: min(amx, bmx) - pos)

proc difference(a: Cuboid, b: Cuboid): HashSet[Cuboid] =
  let amx = a.pos + a.size
  let bmx = b.pos + b.size
  var xx = [(b.pos.x, b.size.x)].toSeq
  var yy = [(b.pos.y, b.size.y)].toSeq
  var zz = [(b.pos.z, b.size.z)].toSeq
  echo &"difference:\n ==> {a}\n ==> {b}\n   -> {amx}, {bmx}"
  if a.pos.x < b.pos.x: xx.add (a.pos.x, b.pos.x - a.pos.x)
  if bmx.x < amx.x: xx.add (bmx.x, amx.x)
  if a.pos.y < b.pos.y: yy.add (a.pos.y, b.pos.y - a.pos.y)
  if bmx.y < amx.y: yy.add (bmx.y, amx.y)
  if a.pos.z < b.pos.z: zz.add (a.pos.z, b.pos.z - a.pos.z)
  if bmx.z < amx.z: zz.add (bmx.z, amx.z)
  echo &"xyz diff: {xx}, {yy}, {zz}"
  for xi in 0..<xx.len:
    for yi in 0..<yy.len:
      for zi in 0..<zz.len:
        result.incl (pos: (x: xx[xi][0], y: yy[yi][0], z: zz[zi][0]), size: (x: xx[xi][1], y: yy[yi][1], z: zz[zi][1]))

proc `+=`(a: var CuboidGeometry, b: Cuboid) =
  var toIncl = toHashSet([b])
  var toExcl = initHashSet[Cuboid]()
  for ac in a:
    var nextIncl = toIncl
    for nc in toIncl:
      if ac.contains nc:
        nextIncl.excl nc
        break
      elif nc.contains ac:
        toExcl.incl ac
      else:
        nextIncl.excl nc
        let intersect = ac.intersect nc
        echo &"intersect for union: {intersect}"
        if intersect.isSome: nextIncl.incl(intersect.get.difference(nc))
    toIncl = nextIncl
  a = (a - toExcl) + toIncl

when not defined(release):
  block:
    let cv = proc (n: openArray[Cuboid]): uint64 =
      var s = toHashSet([n[0]])
      for i in 1..<n.len:
        s += n[i]
      result = s.volume
      echo &"cv test: {result}\n"
    assert [cuboid(0, 0, 0, 10, 10, 10), cuboid(-4, 5, 7, 4, 2, 2)].cv == 1016
    assert [cuboid(0, 0, 0, 1, 1, 1), cuboid(1, 0, 0, 1, 1, 1)].cv == 2
    assert [cuboid(0, 0, 0, 1, 1, 1), cuboid(1, 0, 0, 2, 2, 2)].cv == 9
    assert [cuboid(0, 0, 0, 10, 10, 10), cuboid(8, 8, 8, 5, 5, 5)].cv == 1000 - 8 + 125

proc `-=`(a: var CuboidGeometry, b: Cuboid) =
  var toIncl = toHashSet[Cuboid]([])
  var toDiff = toHashSet[Cuboid]([b])
  var toExcl = initHashSet[Cuboid]()
  echo &"diff b: {b}"
  for ac in a:
    for dc in toDiff:
      let intersect = ac.intersect dc
      echo &"intersect for diff: {intersect}"
      if intersect.isSome:
        toExcl.incl ac
        toIncl.incl(ac.difference(intersect.get))
  a = (a - toExcl) + toIncl

proc p1(input: Lines): uint64 =
  let bounds = (pos: (x: -50, y: -50, z: -50), size: (x: 100, y: 100, z: 100))
  var onCuboids = initHashSet[Cuboid]()
  for l in input:
    let cop = l.parse
    if cop.isNone: continue
    let (op, cuboid) = cop.get
    echo &"c: {op} {cuboid} ({cuboid.size.volume})"
    if not bounds.contains cuboid: continue
    case op:
      of union: onCuboids += cuboid
      of difference: onCuboids -= cuboid
  echo &"onCuboids: {onCuboids}"
  onCuboids.volume
  # TODO: sum volume of all cuboids in `onCuboids`

proc p2(input: Lines): uint64 =
  0

# const alt = ("""
# on x=0..9,y=0..9,z=0..9
# on x=-4..3,y=5..6,z=7..8
# """.strip().split('\n'), 1016'u64, 0'u64)

const alt = ("""
on x=0..1,y=0..0,z=0..0
off x=0..0,y=0..0,z=0..0
""".strip().split('\n'), 1'u64, 0'u64)

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
const rt = (input, 590784'u64, 0'u64)
doDayX 22, (n: int) => n.loadInput, p1, p2, alt
