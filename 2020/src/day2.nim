import streams, strutils, re

type PasswordPolicy = tuple[min: int, max: int, keyChar: char]

let parsePasswordLineRe = re"^(\d+)-(\d+) (.): (.*)$"
proc parsePasswordLine(str: string): (PasswordPolicy, string) =
  var matches: array[4, string]
  if match(str, parsePasswordLineRe, matches):
    return ((min: parseInt(matches[0]), max: parseInt(matches[1]), keyChar: matches[2][0]), matches[3])

iterator asPasswordPolicies(s: Stream): (PasswordPolicy, string) =
  for line in s.lines(): yield parsePasswordLine line

proc isValidPassword(str: string, pp: PasswordPolicy): bool =
  let count = str.count pp.keyChar
  (pp.min <= count) and (count <= pp.max)

proc isValidPasswordPart2(str: string, pp: PasswordPolicy): bool =
  (str[pp.min - 1] == pp.keyChar) xor (pp.keyChar == str[pp.max - 1])

proc part1*(s: Stream): int =
  for (pp, pw) in s.asPasswordPolicies:
    if isValidPassword(pw, pp): inc result

proc part2*(s: Stream): int =
  for (pp, pw) in s.asPasswordPolicies:
    if isValidPasswordPart2(pw, pp): inc result
