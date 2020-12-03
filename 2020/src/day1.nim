import sets, streams, input_helpers, sequtils, options

let targetSum = 2020

proc findComplement(nums: seq[int], complement = targetSum): Option[(int, int)] =
  var targets = initHashSet[int]()
  for n in nums:
    if targets.contains(complement - n): return some(((complement - n), n))
    else: targets.incl n

proc part1*(s: Stream): int =
  let (n1, n2) = findComplement(toSeq(asInts(s))).get; n1 * n2

proc part2*(s: Stream): int =
  let nums = toSeq(asInts(s))
  for n in nums:
    let comp = findComplement(nums, targetSum - n)
    if comp.isSome:
      let (n1, n2) = comp.get; return n * n1 * n2
