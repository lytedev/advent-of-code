import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options, json, hashes]

type
  Vec3 = array[3, int]
  Transform = array[3, (0..2, int)]
  Beacons = seq[Vec3]
  Scanner = (Option[Vec3], Beacons)
  Vec3Pair = array[2, Vec3]

const TRANSFORMS: seq[Transform] = collect:
  let x: 0..2 = 0
  let y: 0..2 = 1
  let z: 0..2 = 2
  for xs in [-1, 1]:
    for ys in [-1, 1]:
      for zs in [-1, 1]:
        for t in [[x, y, z], [x, z, y], [y, x, z], [y, z, x], [z, x, y], [z, y, x]]:
          [(t[0], xs), (t[1], ys), (t[2], zs)]

proc `*`(v: Vec3, t: Transform): Vec3 = [v[t[0][0]] * t[0][1], v[t[1][0]] * t[1][1], v[t[2][0]] * t[2][1]]
proc `+`(a: Vec3, b: Vec3): Vec3 = [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
proc `-`(a: Vec3, b: Vec3): Vec3 = [a[0] - b[0], a[1] - b[1], a[2] - b[2]]

proc parse(s: string): Vec3 =
  let l = s.split(",", 3).map parseInt
  [l[0], l[1], l[2]]

proc parse(l: openArray[string]): seq[Scanner] =
  var sb: seq[Vec3] = @[]
  for line in l:
    if line == "":
      result.add (none(Vec3), sb)
      continue
    elif line[0] == '-' and line[1] == '-':
      sb = @[]
    else: sb.add line.parse
  result.add (none(Vec3), sb)

proc maybeGetScannerTransform(s1: Scanner, s2: Scanner): Option[(Vec3, Transform)] =
  let (knownPos, beacons1) = s1
  let (_, beacons2) = s2
  for t in TRANSFORMS:
    var dists = newCountTable[Vec3]()
    for b1 in beacons1:
      for b2 in beacons2:
        let dist = b1 - (b2*t)
        dists.inc dist
        if dists[dist] >= 12:
          return some (dist, t)
  none (Vec3, Transform)

var scanners: seq[Scanner] = @[]

proc p1(input: seq[Scanner]): uint64 =
  scanners = input
  scanners[0][0] = some [0, 0, 0]
  var known = @[0]
  var needTransform = toSeq(1..<scanners.len)
  while needTransform.len > 0:
    block checker:
      for ix in 0..<needTransform.len:
        let i = needTransform[ix]
        for ij in 0..<known.len:
          let j = known[ij]
          let mt = maybeGetScannerTransform(scanners[j], scanners[i])
          if mt.isSome:
            echo &"GOT ONE: {i} at {mt}"
            let (offset, transform) = mt.get
            echo &"Adding {i} (was at index {ix})"
            known.add i
            needTransform.delete(ix)
            scanners[i][0] = some offset
            scanners[i][1] = scanners[i][1].mapIt((it * transform) + offset)
            break checker
  var beaconPositions = toHashSet[Vec3] []
  for s in scanners:
    for b in s[1]:
      beaconPositions.incl b
  beaconPositions.len.uint64

proc p2(input: seq[Scanner]): uint64 =
  for s1 in scanners:
    let (p1o, _) = s1
    for s2 in scanners:
      let (p2o, _) = s2
      let p1 = p1o.get
      let p2 = p2o.get
      result = max(result, (abs(p1[0]-p2[0]) + abs(p1[1]-p2[1]) + abs(p1[2]-p2[2])).uint64)

const input = """
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
""".strip().split('\n').parse
doDayX 19, (n: int) => n.loadInput.parse, p1, p2, (input, 79'u64, 3621'u64)
