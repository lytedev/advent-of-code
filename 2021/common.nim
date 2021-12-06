import std/[streams, sequtils, strutils, sugar, strformat, times, httpclient, os]

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
  echo i & " took " & diff & "ms to calculate solution"
  when not defined(release):
    echo "NOTE: This is not a real measurement of performance. Compile in release mode with -d:release for best performance."
  # jkp: {(stop - start) * 1000} ms to calculate solution: {result}"
