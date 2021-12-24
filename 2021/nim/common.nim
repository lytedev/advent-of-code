import std/[streams, sequtils, strutils, sugar, strformat, times, httpclient, os, options]

type
  Lines* = seq[string]

const YEAR = getEnv("AOC_YEAR", "2021").parseInt()
proc getCookie(): string = "~/.advent-of-code-auth-cookie".expandTilde().readFile()
proc getCacheDir(): string = joinPath(expandTilde("~/.cache"), fmt"/aoc{YEAR}")
proc inputFilePath(day: int): string = joinPath(getCacheDir(), fmt"{day}.input")

proc fetchInput(day: int, filePath: string): StringStream =
  let client = newHttpClient()
  client.headers = {"cookie": getCookie()}.newHttpHeaders()
  let content = client.getContent(fmt"https://adventofcode.com/{YEAR}/day/{day}/input")
  filePath.writeFile(content)
  content.newStringStream()

proc inputStream*(day: int): Stream =
  getCacheDir().createDir()
  let cachedFile = day.inputFilePath()
  if not cachedFile.fileExists(): day.fetchInput(cachedFile)
  else: openFileStream(cachedFile)

proc toInts*(s: seq[string]): seq[int] = s.map(parseInt)

proc loadInputText*(day: int): string = day.inputFilePath().readFile().strip()

proc loadInput*(day: int): Lines =
  result = collect:
    for l in day.inputStream().lines(): l

template time*(i: string, body: untyped): untyped =
  let start = cpuTime()
  body
  let stop = cpuTime()
  let diff = $((stop - start) * 1000)
  echo i & " took " & diff & "ms to process input file and calculate solution"
  when not defined(release):
    echo "NOTE: This is not a real measurement of performance. Compile in release mode with -d:release for best performance."

proc doDay*[T, X](
  day: int,
  inputLoader: int -> T,
  part1: T -> X,
  part2: T -> X,
  testInput: T,
  expectedPart1: X,
  expectedPart2: X): void =

  # when not defined(release):
  # var p1 = testInput.part1()
  # echo "Day ", day, " Part 1: ", p1, " (Expected: ", expectedPart1, ")"
  # doAssert p1 == expectedPart1

  # time(&"Day {day} Part 1"): echo day.inputLoader().part1()

  # when not defined(release):
  var p2 = testInput.part2()
  echo "Day ", day, " Part 2: ", p2, " (Expected: ", expectedPart2, ")"
  doAssert p2 == expectedPart2

  time(&"Day {day} Part 2"): echo day.inputLoader().part2()

proc doDayX*[T, X](
  day: int,
  inputLoader: int -> T,
  part1: T -> X,
  part2: T -> X,
  testTuple: (T, X, X)): void =
  let (tin, expectedPart1, expectedPart2) = testTuple
  doDay(day, inputLoader, part1, part2, tin, expectedPart1, expectedPart2)

proc doDay*[T](
  day: int,
  inputLoader: int -> T,
  part1: T -> int,
  part2: T -> int,
  testTuple: (T, int, int)): void =
  let (tin, expectedPart1, expectedPart2) = testTuple
  doDay(day, inputLoader, part1, part2, tin, expectedPart1, expectedPart2)

proc reduce*[T, X](s: openArray[T], op: (X, T) -> X, init: X): X =
  result = init
  for n in s: result = op(result, n)

proc findFirst*[T](s: openArray[T], op: (T) -> bool): T =
  for n in s:
    if op(n): return n

proc findFirstO*[T](s: openArray[T], op: (T) -> bool): Option[T] =
  for n in s:
    if op(n): return some n
