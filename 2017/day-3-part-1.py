#!/usr/bin/env python3

import sys

"""
this uses a edge detection method that I devised that I think
is particularly interesting - it basically works like this:

1. figure out the area of the spiral (especially the most recent corners
    "spiraled")
2. determine the distance from the center of the current edge of the spiral
3. add that to half the length of the perpendicular edge to get the distance

this algorithm comes out to be less than O(n) - whatever the inverse of the
function for the area of a rectangle where the width and height alternately
increase O(1/rect(n)) or something of that sort.
"""

def rect_area(target):
    # generator for nearly-square rectangles (alternating increasing width and
    # height) up to a certain area (or width * height)
    # generates tuples in the format [width, height, area (or width * height)]
    # just passed a target area (or width * height)
    w, h, a = 1, 1, 1
    yield w, h, a
    # effectively handles target = 1
    while a < target:
        # increase width by 1
        w += 1
        a = w * h
        yield w, h, a
        if a >= target:
            break
        # increase width by 1
        h += 1
        a = w * h
        yield w, h, a
        if a >= target:
            break

def calculate_spiral_coordinates(slot):
    # get a list of "spiral" rectangles
    rects = list(rect_area(slot))
    last = rects[-1]
    w, h, idx = last

    # this determines which edge the corner is on
    # if we're on a right or top edge, we handle that differently (since it's
    # always further from the center of the spiral)
    # TODO: perhaps a floor() might do the trick?
    cw = w
    ch = h
    if w % 2 == 1:
        cw -= 1
    if h % 2 == 1:
        ch -= 1

    # finally, we need to determine how close to the center of the current edge
    # we are
    dtc = 0
    if len(rects) > 1:
        next_last = rects[-2]
        current_edge_center = None
        if w == h: # slot is on the top or bottom edge
            # since we're on the top or bottom edge, half the height plus our
            # distance from the edge's center is our distance
            # our distance from the edge's center is the absolute value of the
            # current slot minus the previous corner's last index + half the
            # modified width + 1
            distance_from_center = abs(slot - (next_last[2] + (cw / 2) + 1))
            return int((ch / 2) + distance_from_center)
        else: # left or right edge
            # same basic idea, only we just swap width and height
            distance_from_center = abs(slot - (next_last[2] + (ch / 2) + 1))
            return int((cw / 2) + distance_from_center)

        dtc = abs(slot - current_edge_center)
        return 
    else:
        return int((cw / 2) + (ch / 2))

if __name__ == "__main__":
    slot = None
    try:
        slot = int(sys.stdin.read().strip())
        print("Slot:", slot)
        spiral = calculate_spiral_coordinates(slot)
        print("Distance:", spiral)
    except ValueError as e: # invalid input
        print("Input must be an integer.")
