import ./common, std/[strutils, sequtils, strformat, sugar, sets, math]

proc parseLine(s: string): seq[seq[string]] = s.split(" | ").mapIt(it.split(" "))

proc p1(c: seq[string]): int =
  c.reduce((a: int, l: string) =>
    a + l.parseLine()[1].reduce((b: int, h) => b + int(h.len() in [2, 3, 4, 7]), 0), 0)

proc numShared(s1: string, s2: string): int = (s1.toHashSet() * s2.toHashSet()).len()
proc p2(c: seq[string]): int =
  for oLine in c.map(parseLine):
    let four = oLine[0].findFirst((s) => s.len() == 4)
    let seven = oLine[0].findFirst((s) => s.len() == 3)
    for i, output in oLine[1].pairs():
      let outputVal = case output.len():
        of 2: 1
        of 3: 7
        of 4: 4
        of 7: 8
        of 5:
          case output.numShared(four) + output.numShared(seven):
            of 4: 2
            of 6: 3
            else: 5
        else:
          case output.numShared(four) + output.numShared(seven):
            of 6: 0
            of 5: 6
            else: 9
      let x = (abs(oLine[1].len() - i) - 1)
      result += outputVal * int(10 ^ x)

# Explanation:
# 1, 7, 8, and 4 are known and may be identified just by length, so we only
# need to figure out the 5- and 6- inputs, 0, 2, 3, 5, 6, and 9
# we should be able to do this by seeing how many segments are shared with the
# known digits
# 5-inputs: 235
#   2: shares 2 with 4, 1 with 1, 2 with 7
#   3: shares 3 with 4, 2 with 1, 3 with 7
#   5: shares 3 with 4, 1 with 1, 2 with 7
# 6-inputs: 069
#   0: shares 3 with 4, 2 with 1, 3 with 7
#   6: shares 3 with 4, 1 with 1, 2 with 7
#   9: shares 4 with 4, 2 with 1, 3 with 7
# from this information, we can identify each digit simply by knowing the
# number of shared segments with 4 and 7 alone:
# 2: 22
# 3: 33
# 5: 32
# 0: 33
# 6: 32
# 9: 43

doDay(8, (n) => n.loadInput(),
  p1,
  p2,
  """be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce""".split('\n'), 26, 61229)
