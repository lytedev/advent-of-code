import streams, strutils, bitops, tables

proc asMasks(s: string): (uint64, uint64) =
  var ones, zeroes = 0'u64
  for c in s:
    ones = rotateLeftBits(ones, 1'u8)
    zeroes = rotateLeftBits(zeroes, 1'u8)
    case c:
      of '1': ones.setBit(0'u8)
      of '0': zeroes.setBit(0'u8)
      else: discard
  echo ("Masks:", ones, zeroes)
  return (ones, zeroes)

doAssert "01X".asMasks() == (2'u64, 4'u64)

proc withMasks(n: uint64, mask: (uint64, uint64)): uint64 =
  echo n.toBin
  n.bitand(mask[1]).bitnot.bitand(mask[0].bitnot).bitnot

proc part1*(s: Stream): int =
  var masks: (uint64, uint64)
  var memory = newTable[uint64, uint64]()
  var i = 0
  for l in s.lines:
    if l.startsWith("mask = "):
      masks = l.split(" = ")[1].asMasks
    elif l.startsWith("mem["):
      let ll = l.split("[")[1].split("] = ")
      memory[ll[0].parseUInt] = ll[1].parseUInt.withMasks(masks)
    inc i
  echo memory
  for v in memory.values: result += int v

  # 9,639,694,085,526 is too high

let n = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
""".newStringStream.part1()
echo n
doAssert n == 165

proc part2*(s: Stream): int =9
