#!/usr/bin/env python3

# usage: cat inputs/day-2.txt | ./$SCRIPTNAME.py

import sys

def try_to_int(val):
    try:
        return int(val)
    except:
        return

def spreadsheet_line(line, sep="\t"):
    numbers = list(filter(lambda x: x != None, map(try_to_int, line.strip().split(sep))))
    length = len(numbers)
    print(numbers)
    try:
        for i in range(0, length):
            x = numbers[i]
            for j in range(i + 1, length):
                y = numbers[j]
                low = min(x, y)
                high = max(x, y)
                rem = high % low
                if rem == 0:
                    print(high / low)
                    return high / low
    except:
        return

def checksum(spreadsheet_text, line_sep="\n"):
    total = 0
    lines = spreadsheet_text.split(line_sep)
    for line in lines:
        line_diff = spreadsheet_line(line)
        try:
            total += line_diff
        except:
            pass
    return total

if __name__ == "__main__":
    print(checksum(sys.stdin.read()).strip())

