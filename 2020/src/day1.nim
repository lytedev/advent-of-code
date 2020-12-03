import sets, streams, strutils, options, input_helpers

# Day 1

let day1TargetSum = 2020

proc part1*(s: Stream): int =
  var targets = initHashSet[int]()
  for n in asInts(s):
    if targets.contains(day1TargetSum - n):
      return (day1TargetSum - n) * n
    else:
      targets.incl n

proc part2*(strm: Stream): int =
  # this works exactly the same as the previous algorithm, except we simply
  # permute once more
  # TODO: if I was really cool, I could split the shared functionality into
  # a shared proc
  var nums: seq[int]
  for line in strm.lines():
    nums.add parseInt line
  for n in nums:
    var iset = initHashSet[int]()
    let nTargetSum = day1TargetSum - n
    for n2 in nums:
      if iset.contains(nTargetSum - n2):
        return n * n2 * (nTargetSum - n2)
      iset.incl n2
