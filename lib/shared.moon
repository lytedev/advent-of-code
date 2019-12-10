export input_for_day, input_matcher, reduce

read_whole_file = =>
		f = assert io.open @, "rb"
		content = f\read "*all"
		f\close()
		content

input_for_day = =>
		read_whole_file "input/#{@}.txt"

input_matcher = (pattern) =>
		contents = read_whole_file "input/#{@}.txt"
		contents\gmatch pattern

reduce = (initial, f) =>
	acc = initial
	for e in @
		if "table" == type e
			acc = f acc, unpack e
		else
			acc = f acc, e
	acc

