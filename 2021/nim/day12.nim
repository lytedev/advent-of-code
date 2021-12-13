import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

proc toGraph(lines: seq[string]): Table[string, HashSet[string]] =
  result = initTable[string, HashSet[string]]()
  for l in lines:
    let nodes = l.split("-")
    if result.hasKey(nodes[0]): result[nodes[0]].incl(nodes[1])
    else: result[nodes[0]] = toHashSet([nodes[1]])
    if result.hasKey(nodes[1]): result[nodes[1]].incl(nodes[0])
    else: result[nodes[1]] = toHashSet([nodes[0]])

proc visit(curNode: string, graph: Table[string, HashSet[string]], visitedNodes: HashSet[string], hasVisitedSmallCaveTwice = true): int =
  if curNode == "end": return 1
  echo visitedNodes, curNode, " (", hasVisitedSmallCaveTwice, ")"
  var isBig = curNode == curNode.toUpper()
  if not isBig and not hasVisitedSmallCaveTwice and curNode != "start":
    for node in (graph[curNode] - visitedNodes): result += visit(node, graph, visitedNodes, true)
  var newVisitedNodes = visitedNodes
  if not isBig: newVisitedNodes.incl(curNode)
  for node in (graph[curNode] - visitedNodes): result += visit(node, graph, newVisitedNodes, hasVisitedSmallCaveTwice)

proc pathing(input: seq[string]): int =
  visit("start", input.toGraph, toHashSet[string]([]))

proc pathing2(input: seq[string]): int =
  visit("start", input.toGraph, toHashSet[string]([]), false)

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
