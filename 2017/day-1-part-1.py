#!/usr/bin/env python3

import sys

def digits(digitString):
    index = 0
    final = 0
    while index < len(digitString):
        ds1 = digitString[index]
        ds2 = "-1"
        if index == len(digitString) - 1:
            ds2 = digitString[0]
        else:
            ds2 = digitString[index + 1]
        if ds1 == ds2:
            final += int(digitString[index])
        print("DS[{}]: {}".format(index, digitString[index]))
        index += 1
    print("Answer: {}".format(final))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please provide an argument with your string of digits.")
    else:
        digits(sys.argv[1])

