export input_for_day, reduce

read_whole_file = =>
		f = assert io.open @, "rb"
		content = f\read "*all"
		f\close()
		content

input_for_day = =>
		read_whole_file "input/#{@}.txt"

reduce = (initial, f) =>
	acc = initial
	for e in @
		acc = f acc, e
	acc
