import input_requestor, os, macros, strformat, tables

macro loadDays(): untyped =
  var solver_str = "var solvers = {\n"
  result = newStmtList()
  for day in 1..2:
    let module = fmt"day{day}"
    if fileExists joinPath("src/", &"{module}.nim"):
      result.add parseStmt fmt"from {module} import nil"
      solver_str = solver_str & &"""
      {day}: proc(): (string, string) = (
        $(day{day}.part1(getInputFileStreamForDay({day}))),
        $(day{day}.part2(getInputFileStreamForDay({day})))
      ),
      """
  result.add parseStmt (solver_str & "\n}.newTable()\nexport solvers")

loadDays()
