import streams, strutils, sequtils, re, options

type PasswordPolicy = tuple[min: int, max: int, keyChar: char]

proc isValidPassword(str: string, pp: PasswordPolicy): bool =
  let count = str.count pp.keyChar
  (pp.min <= count) and (count <= pp.max)

proc isValidPasswordPart2(str: string, pp: PasswordPolicy): bool =
  (str[pp.min - 1] == pp.keyChar) xor (pp.keyChar == str[pp.max - 1])

let parsePasswordPolicyRe = re"^(\d+)-(\d+) (.): (.*)$"
proc parsePasswordPolicy(str: string): (PasswordPolicy, string) =
  var matches: array[4, string]
  if match(str, parsePasswordPolicyRe, matches):
    return ((min: parseInt(matches[0]), max: parseInt(matches[1]), keyChar: matches[2][0]), matches[3])

iterator asPasswordPolicies(s: Stream): (PasswordPolicy, string) =
  for line in s.lines():
    yield parsePasswordPolicy line

proc part1*(s: Stream): int =
  result = 0
  for (pp, pw) in asPasswordPolicies(s):
    if isValidPassword(pw, pp):
      result += 1

proc part2*(s: Stream): int =
  result = 0
  for (pp, pw) in asPasswordPolicies(s):
    if isValidPasswordPart2(pw, pp):
      result += 1
