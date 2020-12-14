import streams, sequtils, strutils

proc part1*(s: Stream): int =
  let schedule = toSeq(s.lines)
  let departure = schedule[0].parseInt
  var ss = schedule[1].split(",").filterIt(it != "x" and it != "").map(parseInt)
  var mn = (0, departure*2)
  for n in ss:
    let q = n * ((departure div n) + 1)
    if q < mn[1]:
      mn = (n, q)
  mn[0] * (mn[1] - departure)

import tables
proc part2*(s: Stream): int =
  var ss = toSeq(s.lines)[1].split(",").filterIt(it != "")
  var bb = initTable[int, int]()
  for n in 0..<ss.len:
    if ss[n] == "x": continue
    bb[n] = ss[n].parseInt
  let incr = bb[0]
  var i = 0
  while true:
    # TODO: this takes too long, need to learn the math?
    # maybe between each bus there is a regular period of these "coincidences" and we can reduce along those?
    for j in 1..<ss.len:
      if bb.contains j:
        let d = i+j
        let b = bb[j]
        let nn = b * (d div b)
        # echo ("checking", i, j, b, d, nn)
        if d != nn: break
        # echo ("good", j)
        if j == ss.len-1: return i
      else: continue
    inc i, incr
