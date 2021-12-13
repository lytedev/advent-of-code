import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

proc visit(curNode: string, graph: Table[string, HashSet[string]], visitedNodes: HashSet[string]): int =
  if curNode == "end": return 1
  let nv = if curNode == curNode.toUpper(): visitedNodes else: visitedNodes + [curNode].toHashSet
  let toVisit = (graph[curNode] - nv)
  if toVisit.len() == 0: return 0
  for node in toVisit: result += visit(node, graph, nv)

proc pathing(input: seq[string]): int =
  var graph: Table[string, HashSet[string]] = initTable[string, HashSet[string]]()
  for l in input:
    let nodes = l.split("-")
    if graph.hasKey(nodes[0]): graph[nodes[0]].incl(nodes[1])
    else: graph[nodes[0]] = toHashSet([nodes[1]])
    if graph.hasKey(nodes[1]): graph[nodes[1]].incl(nodes[0])
    else: graph[nodes[1]] = toHashSet([nodes[0]])
  visit("start", graph, toHashSet[string]([]))

proc part2(input: seq[string]): int = 
  result = 0

doDay 12, n => n.loadInput, pathing, part2,
  @[
    "fs-end",
    "he-DX",
    "fs-he",
    "start-DX",
    "pj-DX",
    "end-zg",
    "zg-sl",
    "zg-pj",
    "pj-he",
    "RW-he",
    "fs-DX",
    "pj-RW",
    "zg-RW",
    "start-pj",
    "he-WI",
    "zg-he",
    "pj-fs",
    "start-RW",
    ], 226, 0
