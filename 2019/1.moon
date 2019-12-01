-- https://adventofcode.com/2019/day/1

require "common"

input = -> input_for_day(1)\gmatch "%d+"

mass_to_fuel = => -2 + math.floor @ / 3
print "Part 1:", reduce input!, 0, (n) => @ + mass_to_fuel n

fuel_for_fuel = =>
	f = mass_to_fuel @
	if f < 1 then return 0 else return f + fuel_for_fuel f
print "Part 2:", reduce input!, 0, (n) => @ + fuel_for_fuel n
