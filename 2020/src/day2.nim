import streams, strutils, re, sequtils

type PasswordPolicy = tuple[min: int, max: int, keyChar: char]

let parsePasswordLineRe = re"^(\d+)-(\d+) (.): (.*)$"
proc parsePasswordLine(str: string): (PasswordPolicy, string) =
  var matches: array[4, string]
  if match(str, parsePasswordLineRe, matches):
    return ((min: parseInt(matches[0]), max: parseInt(matches[1]), keyChar: matches[2][0]), matches[3])

proc asPasswordPolicies(s: Stream): seq[(PasswordPolicy, string)] =
  toSeq(s.lines()).mapIt(it.parsePasswordLine)

proc part1*(s: Stream): int =
  s.asPasswordPolicies.countIt(it[1].count(it[0].keyChar) in it[0].min..it[0].max)

proc part2*(s: Stream): int =
  s.asPasswordPolicies.countIt(
    (it[1][it[0].min - 1] == it[0].keyChar) xor (it[0].keyChar == it[1][it[0].max - 1]))
