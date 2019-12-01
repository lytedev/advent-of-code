-- https://adventofcode.com/2019/day/1

require "common"

input = input_for_day 1

-- part 1

nums = -> input\gmatch "%d+"
mass_to_fuel = => -2 + math.floor @ / 3

print "Part 1:", reduce nums!, 0, (n) => @ + mass_to_fuel n

-- part 2

fuel_for_fuel = =>
	f = mass_to_fuel @
	print "fff:", f
	if f < 1 then return 0 else return f + fuel_for_fuel f

print "Part 2:", reduce nums!, 0, (n) => @ + fuel_for_fuel(n)
