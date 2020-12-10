import streams, sequtils, options, deques, input_helpers, day1

const WINDOW = 25

proc part1*(s: Stream): int =
  var rollingWindow = initDeque[int](WINDOW)
  for i in s.asInts:
    if rollingWindow.len < WINDOW:
      rollingWindow.addFirst(i)
      continue
    else:
      # TODO: this toSeq every iteration is probably nasty
      let maybe = toSeq(rollingWindow).findComplement(i)
      if maybe.isSome:
        rollingWindow.addFirst(i)
        rollingWindow.popLast
      else: return i

proc part2*(s: Stream): int =
  let n = s.part1
  s.setPosition 0
  let nums = toSeq(s.asInts)
  for i in 0..<nums.len:
    var mn = n
    var mx = 0
    var sum = nums[i]
    mn = min(nums[i], mn)
    mx = max(nums[i], mx)
    for j in i+1..<nums.len:
      mn = min(nums[j], mn)
      mx = max(nums[j], mx)
      if sum == n: return mn+mx
      if sum > n: continue
      sum += nums[j]

