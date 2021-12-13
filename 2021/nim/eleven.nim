import ./common, std/[strutils, sequtils, algorithm, sugar, tables]

const pairs = toTable {'(': ')', '[': ']', '{': '}', '<': '>'}
const corruptPoints = toTable {')': 3, ']': 57, '}': 1197, '>': 25137}

proc parse(input: seq[string]): (int, int) =
  var cmps = newSeq[int]()
  for line in input:
    var stack: seq[char] = @[]
    for ch in line:
      if pairs.hasKey ch: stack.add pairs[ch]
      elif stack.pop != ch:
        result[0] += corruptPoints[ch]
        stack.setLen 0
        break
    if stack.len > 0: cmps.add stack.mapIt(" )]}>".find it).foldr 5 * b + a
  result[1] = cmps.sorted[cmps.len div 2]

doDay 10, n => n.loadInput(), s => s.parse[0], s => s.parse[1],
  @[
    "[({(<(())[]>[[{[]{<()<>>",
    "[(()[<>])]({[<{<<[]>>(",
    "{([(<{}[<>[]}>{[]{[(<()>",
    "(((({<>}<{<{<>}{[]{[]{}",
    "[[<[([]))<([[{}[[()]]]",
    "[{[{({}]{}}([{[{{{}}([]",
    "{<[[]]>}<{[{[{[]{()[[[]",
    "[<(<(<(<{}))><([]([]()",
    "<{([([[(<>()){}]>(<<{{",
    "<{([{{}}[<[[[<>{}]]]>[]]",
  ], 26397, 288957
