import std/[streams, sequtils, strutils, sugar, strformat, times, httpclient, os, options]

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

proc loadInput*(day: int): seq[string] =
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

proc doDay*[T](
  day: int,
  inputLoader: int -> T,
  part1: T -> int,
  part2: T -> int,
  testInput: T,
  expectedPart1: int,
  expectedPart2: int): void =
  time(&"day {day} part 1"): echo day.inputLoader().part1()
  time(&"day {day} part 2"): echo day.inputLoader().part2()

  when not defined(release):
    doAssert testInput.part1() == expectedPart1
    doAssert testInput.part2() == expectedPart2

proc reduce*[T](s: openArray[T], op: (T, T) -> T, init: T): T =
  result = init
  for n in s: result = op(result, n)
