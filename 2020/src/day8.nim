import streams, strutils, sequtils, sets

type
  InstructionType = enum nop acc jmp
  Instruction = ref object of RootObj
    instruction: InstructionType
    arg: int

proc instructions(s: Stream): seq[Instruction] =
  toSeq(s.lines).mapIt(it.split).mapIt(Instruction(instruction: parseEnum[InstructionType](it[0]), arg: parseInt(it[1].replace("+"))))

proc part1*(s: Stream): int =
  var hasRun = initHashSet[int]()
  var p = 0
  let code = s.instructions
  while true:
    if hasRun.contains p: return result
    hasRun.incl p
    let i = code[p]
    case i.instruction:
      of acc: inc result, i.arg
      of jmp: p += i.arg; continue
      else: discard
    inc p

proc part2*(s: Stream): int =
  0
