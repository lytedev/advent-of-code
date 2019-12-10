require "common"

pattern = "#(%d+)%s*@%s*(%d+),(%d+):%s*(%d+)x(%d+)"
input = -> input_matcher 3, pattern
reduce input!, 0, (n, x, y, w, h) =>
	print @, n, x, y, w, h
	0
