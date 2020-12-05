import streams, bitops, sets

# TODO: this one needs some refining for sure

proc row(l: string): uint64 =
  for c in l:
    result = result.rotateLeftBits(1)
    if c == 'B': result.setBit(0)

proc col(l: string): uint64 =
  for c in l:
    result = result.rotateLeftBits(1)
    if c == 'R': result.setBit(0)

# do I really need row * 8 + col or can I just keep rotating and shifting
proc toId(row: uint64, col: uint64): uint64 = (row*8)+col

proc part1*(s: Stream): int =
  for l in s.lines():
    let id = cast[int](toId(row(l[0 .. 6]), col(l[7 .. ^1])))
    if id > result: result = id

proc part2*(s: Stream): int =
  var ids = initHashSet[int]()
  for l in s.lines():
    let id = cast[int](toId(row(l[0 .. 6]), col(l[7 .. ^1])))
    ids.incl(id)
  for i in 1..890:
    if ids.contains(i+1) and ids.contains(i-1) and not ids.contains(i):
      return i
