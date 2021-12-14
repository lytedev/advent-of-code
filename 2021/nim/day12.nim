import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

type
  Lines = seq[string]
  Path = seq[string]
  NodeSet = HashSet[string]
  Graph = Table[string, NodeSet]

proc toGraph(lines: Lines): Graph =
  for l in lines:
    let nodes = l.split "-"
    if result.hasKey nodes[0]: result[nodes[0]].incl nodes[1]
    else: result[nodes[0]] = toHashSet [nodes[1]]
    if result.hasKey nodes[1]: result[nodes[1]].incl nodes[0]
    else: result[nodes[1]] = toHashSet [nodes[0]]

proc basicIneligibleNodes(path: Path): NodeSet =
  for n in path:
    if n in ["start", "end"] or n.toUpper != n:
      result.incl n

proc part2IneligibleNodes(path: Path): NodeSet =
  # determine if we've double visited any small caves yet
  var hasVisitedSingleSmallCaveTwice: bool = path.filterIt(not (it in ["start", "end"]) and it != it.toUpper).toCountTable.values.toSeq.anyIt(it >= 2)
  for n in path:
    let isStartOrEnd = n == "start" or n == "end"
    let isSmall = n.toUpper != n
    if isStartOrEnd or (isSmall and hasVisitedSingleSmallCaveTwice): result.incl n

# TODO: tail-call optimization?
proc visit(node: string, graph: Graph, ineligibleNodesReducer: (Path) -> NodeSet, path: Path = @[]): int =
  if node == "end": return 1
  let newPath = path & @[node]
  let forbiddenNodes = newPath.ineligibleNodesReducer()
  let toVisit = graph[node] - forbiddenNodes
  for n in toVisit: result += visit(n, graph, ineligibleNodesReducer, newPath)

proc pathing(input: seq[string]): int =
  visit("start", input.toGraph, basicIneligibleNodes)

proc pathing2(input: seq[string]): int =
  visit("start", input.toGraph, part2IneligibleNodes)

const smallTestInput = @[
  "start-A",
  "start-b",
  "A-c",
  "A-b",
  "b-d",
  "A-end",
  "b-end",
]
const stest = (smallTestInput, 10, 36)

# const largeTestInput = @[
#   "fs-end",
#   "he-DX",
#   "fs-he",
#   "start-DX",
#   "pj-DX",
#   "end-zg",
#   "zg-sl",
#   "zg-pj",
#   "pj-he",
#   "RW-he",
#   "fs-DX",
#   "pj-RW",
#   "zg-RW",
#   "start-pj",
#   "he-WI",
#   "zg-he",
#   "pj-fs",
#   "start-RW",
# ]
# 
# const ltest = (largeTestInput, 225, 3509)

doDay 12, n => n.loadInput, pathing, pathing2, stest
