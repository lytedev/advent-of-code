import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables]

proc p1(input: Lines): uint64 =
  return 0

const input = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
""".strip().split('\n').mapIt(it.strip)
doDayX 15, n => n.loadInput, p1, p1, (input, 0'u64, 0'u64)
