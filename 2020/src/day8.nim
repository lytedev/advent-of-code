import streams, strutils, sequtils, sets, options, strformat, tables

type
  InstructionType = enum nop acc jmp
  Instruction = object
    instruction: InstructionType
    arg: int
  HandheldState = object
    bootcode: seq[Instruction]
    acc: int
    pointer: int

proc `$`(i: Instruction): string = return fmt"{i.instruction} {i.arg}"
proc `$`(h: HandheldState): string = return fmt"@{h.pointer} ({h.acc}): {h.bootcode}"
proc statusString(h: HandheldState): string =
  let i = h.bootcode[h.pointer]
  fmt"{h.pointer}: {i.instruction} {i.arg} ({h.acc})"

proc newHandheld(bootcode: seq[Instruction], acc = 0, pointer = 0): HandheldState =
  HandheldState(bootcode: bootcode, acc: acc, pointer: pointer)

proc instructions(s: Stream): seq[Instruction] =
  toSeq(s.lines).mapIt(it.split).mapIt(Instruction(instruction: parseEnum[InstructionType](it[0]), arg: parseInt(it[1].replace("+"))))

proc stepHandheld(state: var HandheldState): bool =
  if state.pointer >= state.bootcode.len: return true
  let i = state.bootcode[state.pointer]
  case i.instruction:
    of acc: inc state.acc, i.arg
    of jmp: inc state.pointer, i.arg; return false
    else: discard
  inc state.pointer

proc bootHandheld(h: var HandheldState): bool =
  var hasRun = initHashSet[int]()
  while h.pointer <= h.bootcode.len:
    if h.stepHandheld(): return true
    if hasRun.contains h.pointer: return false
    hasRun.incl h.pointer
  true

proc part1*(s: Stream): int =
  var h = s.instructions.newHandheld
  if not h.bootHandheld: return h.acc

proc flipped(h: var HandheldState): HandheldState =
  var nbc = h.bootcode.deepCopy
  case h.bootcode[h.pointer].instruction:
    of nop: nbc[h.pointer].instruction = jmp
    of jmp: nbc[h.pointer].instruction = nop
    else: discard
  nbc.newHandheld

proc altHandheld(h: var HandheldState): Option[HandheldState] =
  case h.bootcode[h.pointer].instruction:
    of acc: return none(HandheldState)
    of jmp, nop: return some(h.flipped)

proc part2*(s: Stream): int =
  var alts = initTable[int, HandheldState]()
  var h = s.instructions.newHandheld
  var hasRun = initHashSet[int]()
  while h.pointer <= h.bootcode.len:
    var alt = h.altHandheld
    if alt.isSome: alts[h.pointer] = alt.get
    discard h.stepHandheld()
    if hasRun.contains h.pointer: break
    hasRun.incl h.pointer
  #for i in 1..<alts.len:
  var c = 0
  for k,v in alts.pairs:
    var ah = alts[k]
    if ah.bootHandheld: return ah.acc
    inc c
