-- https://adventofcode.com/2019/day/2

require "common"

EXIT = "EXIT"

-- setup intcode tape
build_tape = =>
	counter = 1
	tape = {}
	for n in @\gmatch "%d+"
		tape[counter] = tonumber n
		counter += 1
	tape

clone_tape = => {k,v for k,v in ipairs @}

-- gets the value at the index indicated by the value at the given index
get_by_ival = (n) => @[@[n] + 1]

-- sets the value at the index indicated by the value at the given index
set_by_ival = (n, v) => @[@[n] + 1] = v

-- returns a function that applies the given function against the values found
-- at the indexes indicated in the next two elements of the tape in the tape and
-- stores the result in the index indicated by the value at 3 plus the current
-- index
-- binary store operation
binary_store_op = (f) ->
	(p) =>
		result = f get_by_ival(@, p + 1), get_by_ival(@, p + 2)
		set_by_ival @, p + 3, result
		result, 4

run = (ops) =>
	i = 1
	while i <= #@
		print "TAPE"
		s = ""
		for i, v in ipairs @
			s = s .. tostring(v) .. " "
		print s
		print "END TAPE"
		print #@
		print @[i], @[i + 1], @[i + 2], @[@[i + 1] + 1], @[@[i + 2] + 1], @[i + 3]
		result, jump = ops[@[i]](@, i)
		if result == EXIT
			print EXIT
			break
		i += math.max jump, 1
	@

ops =
	[1]: binary_store_op (x, y) -> x + y
	[2]: binary_store_op (x, y) -> x * y
	[99]: -> EXIT, 1

tape = build_tape input_for_day 2
-- tape = build_tape "1,9,10,70,2,3,11,0,99,30,40,50"
-- tape = build_tape "1,1,1,4,99,5,6,0,99"
new_tape = run clone_tape(tape), ops

print "Day 2, Part 1", new_tape[1]
