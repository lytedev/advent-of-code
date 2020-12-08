import streams, strutils, sequtils, sets

type
  InstructionType = enum nop acc jmp
  Instruction = object
    instruction: InstructionType
    arg: int
  HandheldState = object
    bootcode: seq[Instruction]
    acc: int
    pointer: int
    running: bool

proc newHandheld(bootcode: seq[Instruction], acc = 0, pointer = 0, running = true): HandheldState =
  HandheldState(bootcode: bootcode, acc: acc, pointer: pointer, running: running)

proc instructions(s: Stream): seq[Instruction] =
  toSeq(s.lines).mapIt(it.split).mapIt(Instruction(instruction: parseEnum[InstructionType](it[0]), arg: parseInt(it[1].replace("+"))))

proc stepHandheld(state: var HandheldState) =
  if state.pointer >= state.bootcode.len:
    echo "Reached end of instructions"
    state.running = false
  let i = state.bootcode[state.pointer]
  case i.instruction:
    of acc: inc state.acc, i.arg
    of jmp: inc state.pointer, i.arg; return
    else: discard
  inc state.pointer

proc part1*(s: Stream): int =
  var hasRun = initHashSet[int]()
  var handheld = newHandheld(s.instructions)
  while handheld.running:
    stepHandheld handheld
    if hasRun.contains handheld.pointer: return handheld.acc
    hasRun.incl handheld.pointer

proc correctingHandheld(state: var HandheldState) =
  if state.pointer >= state.bootcode.len:
    echo "Reached end of instructions"
    state.running = false
  let i = state.bootcode[state.pointer]
  case i.instruction:
    of acc: inc state.acc, i.arg
    of jmp: inc state.pointer, i.arg; return
    else: discard
  inc state.pointer

proc part2*(s: Stream): int =
  var hasRun = initHashSet[int]()
  var handheld = newHandheld(s.instructions)
  while handheld.running:
    stepHandheld handheld
    if hasRun.contains handheld.pointer: return handheld.acc
    hasRun.incl handheld.pointer
