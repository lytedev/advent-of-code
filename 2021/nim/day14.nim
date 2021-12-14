import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

proc parse(input: Lines): (string, Table[(char, char), char]) =
  result[0] = input[0]
  for i in 2..<input.len():
    var c = input[i].split(" -> ")
    result[1][(c[0][0], c[0][1])] = c[1][0]

proc stepPolymer(polymer: string, combis: Table[(char, char), char]): string =
  result.add polymer[0]
  var i = 1
  while i < polymer.len:
    var key = (polymer[i-1], polymer[i])
    if combis.contains key: result.add combis[key]
    result.add polymer[i]
    i += 1

proc p1(input: Lines): uint64 =
  var (polymer, combis) = input.parse
  for i in 1..10:
    polymer = polymer.stepPolymer combis
  var pps = polymer.toCountTable.values.toSeq
  uint64(max(pps) - min(pps))

proc p2(input: Lines): uint64 =
  var (polymer, combis) = input.parse
  for i in 1..40:
    echo &"Step {i}"
    polymer = polymer.stepPolymer combis
  var t = initTable[char, uint64]()
  for c in polymer:
    inc t[c]
  var pps = t.values.toSeq
  max(pps) - min(pps)

const input = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
""".strip().split('\n').mapIt(it.strip)
doDayX 14, n => n.loadInput, p1, p2, (input, 1588'u64, 2188189693529'u64)
