import ./common, std/[strutils, sugar, sequtils, options, tables, sets, strformat, algorithm, pegs]

proc parseInstructionArg(s: string): int =
  let ss = s.split(' ')
  if ss.len > 2 and not (ss[2][0] in 'w'..'z'): ss[2].parseInt
  else: 0

proc p1(input: Lines): uint64 =
  let instructionArgs = input.map(parseInstructionArg)
  var reversedDigits = initTable[int, int]()
  var cantComputeYet: seq[(int, int)] = @[]
  for i in 0..13:
    let o = i * 18
    if instructionArgs[o+4] == 26:
      let (previousI, previousAddend) = cantComputeYet.pop
      let diff = previousAddend + instructionArgs[o+5]
      if diff < 0:
        reversedDigits[previousI] = 9
        reversedDigits[i] = 9 + diff
      else:
        reversedDigits[previousI] = 9 - diff
        reversedDigits[i] = 9
    else: cantComputeYet.add (i, instructionArgs[o+15])
  reversedDigits.keys.toSeq.sorted.mapIt($reversedDigits[it]).join().parseBiggestUInt()

time(&"Day 24 Part 1"): echo 24.loadInput.p1
