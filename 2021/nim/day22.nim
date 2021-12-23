import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes, random, pegs]

type
  Cuboid = (int, int, int, int, int, int)
  CuboidOperator = enum union, difference
  CuboidOperation = (CuboidOperator, Cuboid)
  CuboidOperations = HashSet[CuboidOperation]

let parser = peg"""
grammar <- {'on' / 'off'} ' x=' range ',y=' range ',z=' range
range <- {num} \. \. {num}
num <- ('-' \d+) / \d+
"""

proc parseCuboidOperator(s: string): CuboidOperator =
  if s[1] == 'n': union else: difference

proc parse(s: string): Option[CuboidOperation] =
  if s =~ parser:
    let n: seq[int] = matches[1..6].map(parseInt)
    return some (matches[0].parseCuboidOperator, (n[0], n[1], n[2], n[3], n[4], n[5]))

proc asOps(l: Lines): seq[CuboidOperation] =
  for s in l:
    let cop = s.parse
    if cop.isNone: continue
    result.add cop.get

proc intersection(n: Cuboid, p: Cuboid): Option[Cuboid] =
  let (nx1, nx2, ny1, ny2, nz1, nz2) = n
  let (px1, px2, py1, py2, pz1, pz2) = p
  if nx1 <= px2 and px1 <= nx2 and ny1 <= py2 and py1 <= ny2 and nz1 <= pz2 and pz1 <= nz2:
    return some (max(px1, nx1), min(px2, nx2), max(py1, ny1), min(py2, ny2), max(pz1, nz1), min(pz2, nz2))

proc merge(pastOps: var CuboidOperations, newOp: CuboidOperation) =
  var toIncl = initHashSet[CuboidOperation]()
  var toExcl = initHashSet[CuboidOperation]()
  var included = false

  for pastOp in pastOps:
    let (pastOpType, pastCuboid) = pastOp
    let intersect = pastCuboid.intersection newOp[1]
    if intersect.isNone: continue
    included = true
    toExcl.incl pastOp

    let (px1, px2, py1, py2, pz1, pz2) = pastCuboid
    let (ix1, ix2, iy1, iy2, iz1, iz2) = intersect.get
    let (nx1, nx2, ny1, ny2, nz1, nz2) = newOp[1]

    if px1 < ix1: toIncl.incl (pastOpType, (px1, ix1 - 1, py1, py2, pz1, pz2))
    if ix2 < px2: toIncl.incl (pastOpType, (ix2 + 1, px2, py1, py2, pz1, pz2))
    if py1 < iy1: toIncl.incl (pastOpType, (ix1, ix2, py1, iy1 - 1, pz1, pz2))
    if iy2 < py2: toIncl.incl (pastOpType, (ix1, ix2, iy2 + 1, py2, pz1, pz2))
    if pz1 < iz1: toIncl.incl (pastOpType, (ix1, ix2, iy1, iy2, pz1, iz1 - 1))
    if iz2 < pz2: toIncl.incl (pastOpType, (ix1, ix2, iy1, iy2, iz2 + 1, pz2))
    
    toIncl.incl (newOp[0], (min(ix1, nx1), max(ix2, nx2), min(iy1, ny1), max(iy2, ny2), min(iz1, nz1), max(iz2, nz2)))

  pastOps.excl toExcl
  pastOps.incl toIncl
  if not included: pastOps.incl(newOp)

proc p1(input: Lines): uint64 =
  var ops = initHashSet[CuboidOperation]()
  for op in input.asOps:
    let (_, c) = op
    if [c[0], c[1], c[2], c[3], c[4], c[5]].anyIt((it < -50) or (it > 50)): continue
    ops.merge op
  for op in ops:
    let (t, c) = op
    if t == union:
      let (x1, x2, y1, y2, z1, z2) = c
      result += (abs(x2 - x1 + 1) * abs(y2 - y1 + 1) * abs(z2 - z1 + 1)).uint64

proc p2(input: Lines): uint64 =
  var ops = initHashSet[CuboidOperation]()
  for op in input.asOps: ops.merge op
  for op in ops:
    let (t, c) = op
    if t == union:
      let (x1, x2, y1, y2, z1, z2) = c
      result += abs(x2 - x1 + 1).uint64 * abs(y2 - y1 + 1).uint64 * abs(z2 - z1 + 1).uint64

const rt = ("""on x=-20..26,y=-36..17,z=-47..7
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
on x=967..23432,y=45373..81175,z=27513..53682""".split('\n'), 590784'u64, 39769202357779'u64)
doDayX 22, (n: int) => n.loadInput, p1, p2, rt
