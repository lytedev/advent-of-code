import day_loader, tables

proc solve_all() {.used.} =
  for (_, solver) in solvers.pairs():
    echo solver()

proc solve_for_day(n: int) {.used.} =
  echo solvers[n]()

when isMainModule:
  # solve_all()
  solve_for_day(13)
