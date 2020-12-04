import httpclient, strformat, os, logging, streams

var fileLog = newFileLogger("aoc2020.log")
var consoleLog = newConsoleLogger()
addHandler(consoleLog)
addHandler(fileLog)

let cacheDir = joinPath(getEnv("XDG_CACHE_HOME", expandTilde("~/.cache")), "/aoc2020")
createDir(cacheDir)

# TODO: add login capabilities via `pass` for auto-cookie-retrieval?

proc requestAocContentAuthed(url: string): TaintedString =
  let cookie = getEnv("ADVENT_OF_CODE_AUTH_COOKIE", readFile(expandTilde("~/.advent-of-code-auth-cookie")))
  let client = newHttpClient()
  client.headers = newHttpHeaders({"cookie": cookie})
  # client.getContent(url)
  ""

proc getInputFileStreamForDay*(day: int): FileStream =
  # retrieve the input and dump it to a file if we don't have it yet
  let cacheFile = joinPath(cacheDir, fmt"/day-{day}.aoc-input")
  if not fileExists(cacheFile):
    let url = fmt"https://adventofcode.com/2020/day/{day}/input"
    writeFile(cacheFile, requestAocContentAuthed(url).string)
  openFileStream(cacheFile)

proc getInputForDay*(day: int): string =
  getInputFileStreamForDay(day).readAll()
