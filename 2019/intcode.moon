class Intcode
	from_tape: (tape) =>
		@tape = tape
		@ops = {
			[99]: -> EXIT, 1
		}

	new: (code) =>
		counter = 1
		tape = {}
		for n in code\gmatch "%d+"
			tape[counter] = tonumber n
			counter += 1
		@from_tape tape

	clone: (target) =>
		@from_tape {k,v for k,v in ipairs target.tape}

	deref: (n) => @tape[@tape[n] + 1]
	deref_set: (n, v) => @tape[@tape[n] + 1] = v

	binary_store_op: (f) ->
		(p) =>
			result = f get_by_ival(@, p + 1), get_by_ival(@, p + 2)
			set_by_ival @, p + 3, result
			result, 4

	run: (ops) =>
		i = 1
		while i <= #@tape
			print "TAPE"
			s = ""
			for i, v in ipairs @tape
				s = s .. tostring(v) .. " "
			print s
			print "END TAPE"
			print #@tape
			print @tape[i], @tape[i + 1], @tape[i + 2], @tape[@tape[i + 1] + 1], @tape[@tape[i + 2] + 1], @tape[i + 3]
			result, jump = ops[@tape[i]](@tape, i)
			if result == EXIT
				print EXIT
				break
			i += math.max jump, 1
		@
