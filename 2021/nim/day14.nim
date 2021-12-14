import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

proc parse(input: Lines): (string, Table[(char, char), char]) =
  result[0] = input[0]
  for i in 2..<input.len():
    var c = input[i].split(" -> ")
    result[1][(c[0][0], c[0][1])] = c[1][0]

proc steps(input: Lines, steps: uint): uint64 =
  var (polymer, combis) = input.parse
  var pCounter = initTable[(char, char), uint64]()
  var cCounter = initTable[char, uint64]()
  for k in combis.keys:
    pCounter[k] = 0
    cCounter[k[0]] = 0
    cCounter[k[1]] = 0
  inc cCounter[polymer[0]]
  for i in 1..<polymer.len:
    inc pCounter[(polymer[i-1], polymer[i])]
    inc cCounter[polymer[i]]
  for i in 1..steps:
    var newPCounter = pCounter
    for t, n in pCounter.pairs:
      let (l, r) = t
      var twixt = combis[(l, r)]
      newPCounter[(l, r)] -= n
      newPCounter[(l, twixt)] += n
      newPCounter[(twixt, r)] += n
      cCounter[twixt] += n
    pCounter = newPCounter
  var pps = cCounter.values.toSeq
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
doDayX 14, n => n.loadInput, (i) => steps(i, 10), (i) => steps(i, 40), (input, 1588'u64, 2188189693529'u64)
