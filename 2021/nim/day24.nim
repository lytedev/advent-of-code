import ./common, std/[strutils, sugar, sequtils, options, tables, sets, strformat, algorithm, pegs]

type
  Register = int
  ALUInstruction = (string, Register, string)
  ALUState = array[4, int]

proc parseInstruction(s: string): ALUInstruction =
  # echo s
  let ss = s.split(' ')
  let i = if ss.len > 2: ss[2] else: ""
  (ss[0], ss[1][0].ord - ord('w'), i)

proc runALUInstructions(instructions: seq[ALUInstruction], input: string): ALUState =
  var inputs = input.reversed
  let registers = toHashSet(['w', 'x', 'y', 'z'])
  var n = 0
  for i in instructions:
    let (op, reg, arg) = i
    var narg = arg
    var num = 0
    if arg != "":
      if registers.contains(arg[0]):
        let index = arg[0].ord - 'w'.ord
        num = result[index]
        narg = &"r{index+1}"
      else: num = arg.parseInt
    if n mod 18 in [4, 5, 15, 0]: 
      echo &"{result} -> {op} {narg} to r{reg+1} (Input Left: {inputs.join})"
    case op:
      of "inp": result[reg] = inputs.pop.ord - '0'.ord
      of "add": result[reg] += num
      of "mul": result[reg] *= num
      of "div": result[reg] = result[reg] div num
      of "mod": result[reg] = result[reg] mod num
      of "eql": result[reg] = (result[reg] == num).int
    inc n

proc p1(input: Lines): uint64 =
  # repeating these 18 instructions:
  # w is used to store the input digit
  # x is zeroed
  # z is added to x
  # x is modulo'd over 26
  # z is divided by either 1 or 26 (mostly in the latter half of the inputs)
  # x is added with SOME NUMBER (sometimes negative)
  # x is ALWAYS eql'd with w and 0
    # this is meant to ensure that x is NOT equal to the input?
  # y is ALWAYS set to 25
  # y is multiplied by x, which will be 25 if x was 1 or 0 otherwise
    # so y will be 25 if x was equal to the input and 0 if not
  # y is incremented
    # 26 now, if x was equal, 1 if not
  # z is multiplied by y
    # so z
  # y is zeroed out, set to w (the input), added with SOME NUMBER, then multiplied with x
  # add y to z

  # if I need to get z to zero, I need to know where those 26-divisions are and leverage them
  # if I can ever get y to be negative, that could help a lot as well

  # probably a relatively simple way to bruteforce over this?
  let instructions = input.map(parseInstruction)
  # let oalu = instructions.runALUInstructions("13579246899999")
  # echo oalu
  let alu = instructions.runALUInstructions("99879249111111")
  echo alu
  0

proc p2(input: Lines): uint64 =
  0

time(&"Day 24 Part 1"): echo 24.loadInput.p1
