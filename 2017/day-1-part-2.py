#!/usr/bin/env python3

import sys

def digits(digitString):
    index = 0
    final = 0
    while index < len(digitString):
        d1index = int(index)
        d2index = int((int(index) + (len(digitString) / 2)) % len(digitString))
        print(d1index, d2index)
        if digitString[d1index] == digitString[d2index]:
            final += int(digitString[d1index])
        index += 1
    print("Answer: {}".format(final))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please provide an argument with your string of digits.")
    else:
        digits(sys.argv[1])

