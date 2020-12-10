import streams, input_helpers, algorithm, sequtils, math

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
  result = 1
  var nums = @[0].concat(toSeq(s.asInts).sorted)
  nums = nums.concat @[nums.max + 3]
  var l,r = 0
  while l < nums.len:
    r = l
    while r < (nums.len-1) and nums[r+1] - nums[r] == 1: inc r
    let ln = r+1-l
    case ln:
      of 0..2: discard
      of 3: result *= 2
      else: result *= 1 + (ln - 2) + (ln - 2).fac.div(2)
    l = r + 1

# needed the tests on this one - math was a doozy
const t2 = "1\n4\n5\n6\n7\n10\n11\n12\n15\n16\n19".newStringStream().part2()
const t = ("1\n2\n3\n4\n7\n8\n9\n10\n11\n14\n17\n18\n19\n20\n23\n24\n25\n" &
  "28\n31\n32\n33\n34\n35\n38\n39\n42\n45\n46\n47\n48\n49").newStringStream().part2()

doAssert 8 == t2
doAssert 19208 == t
