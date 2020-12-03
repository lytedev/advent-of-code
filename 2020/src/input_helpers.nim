import streams, strutils, sugar

iterator mapStream*[T](s: Stream, cb: (string) -> T): T =
  for line in s.lines():
    yield cb line

iterator asInts*(s: Stream): int =
  for i in mapStream[int](s, parseInt):
    yield i
