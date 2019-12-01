#!/usr/bin/env python3

# usage: cat inputs/day-2.txt | ./$SCRIPTNAME.py

import sys

def spreadsheet_line(line, sep="\t"):
    highest = -sys.maxsize
    lowest = sys.maxsize
    numbers = map(int, line.strip().split(sep))
    try:
        for x in numbers:
            if x < lowest:
                lowest = x
            if x > highest:
                highest = x
    except:
        return

    return highest - lowest

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

