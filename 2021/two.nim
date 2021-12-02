import std/[strutils, sequtils]
import ./common

type SubmarineCommand = enum
  Forward, Up, Down

proc parseArg(c: char): int = c.int() - 48

proc parseSubmarineCommand(l: string): (SubmarineCommand, int) =
  case l[0]:
    # since each arg is only one char, we can use this much faster method to
    # convert to an integer
    of 'd': return (Down, l[5].parseArg())
    of 'u': return (Up, l[3].parseArg())
    else: return (Forward, l[8].parseArg())

proc submarineCommands(inputs: seq[string]): int =
  var x, y = 0
  for (cmd, arg) in inputs.map(parseSubmarineCommand):
    case cmd:
      of Up: y -= arg
      of Down: y += arg
      of Forward: x += arg
  x * y

proc submarineCommandsWithAim(inputs: seq[string]): int =
  var x, y, aim = 0
  for (cmd, arg) in inputs.map(parseSubmarineCommand):
    case cmd:
      of Up: aim -= arg
      of Down: aim += arg
      of Forward:
        x += arg
        y += aim * arg
  x * y

let input = 2.loadInput()
time("submarineCommands part 1"): echo input.submarineCommands()
time("submarineCommandsWithAim part 2"): echo input.submarineCommandsWithAim()

when not defined(release):
  static:
    let testInput = @[
      "forward 5",
      "down 5",
      "forward 8",
      "up 3",
      "down 8",
      "forward 2",
    ]
    doAssert testInput.submarineCommands() == 150
    doAssert testInput.submarineCommandsWithAim() == 900

