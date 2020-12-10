import streams, input_helpers, algorithm, sequtils

proc part1*(s: Stream): int =
  var d1 = 0
  var d3 = 1
  var nums = @[0].concat(toSeq(s.asInts).sorted)
  for i in 1..<nums.len:
    case nums[i] - nums[i-1]:
      of 1: inc d1
      of 3: inc d3
      else: discard
  d1 * d3


proc part2*(s: Stream): int =
  0
