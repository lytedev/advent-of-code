import ./common, std/[strutils, sequtils, strformat, sugar, sets, math, algorithm, tables]

const p = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable()
const t = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable()
proc p1(s: seq[string]): int =
  var stack: seq[char] = @[]
  for l in s:
    for c in l:
      if p.hasKey(c): stack.add(p[c])
      else:
        if stack.pop() != c: result += t[c]

const v = {')': 1, ']': 2, '}': 3, '>': 4}.toTable()
proc p2(s: seq[string]): int =
  var scores: seq[int] = @[]
  for l in s:
    var score = 0
    var stack: seq[char] = @[]
    for c in l:
      if p.hasKey(c): stack.add(p[c])
      else:
        if stack.pop() != c:
          score = -1
          break
    if score == -1: continue
    for l in stack.reversed():
      score *= 5
      score += v[l]
    scores.add(score)
  scores.sort()
  result = scores[(scores.len() div 2)]

doDay(10, (n) => n.loadInput(),
  p1,
  p2,
  """[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]""".split('\n'), 26397, 288957)
