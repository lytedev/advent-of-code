import ./common, std/[strutils, sequtils, tables, strformat, algorithm]

proc parseInstructionArg(s: string): int =
  let ss = s.split(' ')
  if ss.len > 2 and not (ss[2][0] in 'w'..'z'): ss[2].parseInt
  else: 0

proc process(input: Lines): Table[int, (int, int)] =
  let instructionArgs = input.map(parseInstructionArg)
  var cantComputeYet: seq[(int, int)] = @[]
  for i in 0..13:
    let o = i * 18
    if instructionArgs[o+4] == 26:
      let (previousI, previousAddend) = cantComputeYet.pop
      let diff = previousAddend + instructionArgs[o+5]
      if diff < 0:
        result[previousI] = (9, -diff + 1)
        result[i] = (9 + diff, 1)
      else:
        result[previousI] = (9 - diff, 1)
        result[i] = (9, 1 + diff)
    else: cantComputeYet.add (i, instructionArgs[o+15])

proc p1(input: Lines): uint64 =
  let processed = input.process
  processed.keys.toSeq.sorted.mapIt($processed[it][0]).join().parseBiggestUInt()

proc p2(input: Lines): uint64 =
  let processed = input.process
  processed.keys.toSeq.sorted.mapIt($processed[it][1]).join().parseBiggestUInt()

time(&"Day 24 Part 1"): echo 24.loadInput.p1
time(&"Day 24 Part 2"): echo 24.loadInput.p2
