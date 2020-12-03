import input_requestor, os, macros, strformat, tables

macro loadDays(): untyped =
  var solver_str = "var solvers = {\n"
  result = newStmtList()
  for day in 1..3:
    let module = fmt"day{day}"
    if fileExists joinPath("src/", &"{module}.nim"):
      result.add parseStmt fmt"from {module} import nil"
      # TODO: do I "need" to close these streams?
      solver_str = solver_str & &"""
      {day}: proc(): tuple[part1: int, part2: int] =
        stdout.write "Day {day}: "
        (
          {module}.part1(getInputFileStreamForDay({day})),
          {module}.part2(getInputFileStreamForDay({day}))
        ),
      """
  result.add parseStmt (solver_str & "\n}.newTable()\nexport solvers")

loadDays()
