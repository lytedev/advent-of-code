# 2021

This year, I've been tinkering a lot with [Deno][deno] as a [TypeScript][ts]
runtime and have been really enjoying it. I'm hoping to write this year's AoC
solutions using it.

Specifically, here's my `deno --version` output:

    deno 1.16.3 (release, x86_64-unknown-linux-gnu)
    v8 9.7.106.5
    typescript 4.4.2

Enjoy!

**EDIT**: Since performance is not what I would like, it looks like I'm also doing some of these in nim.

## Usage

Run these solutions like so:

    deno run --unstable --allow-all $DAY.ts

And the nim ones like so:

    nim c -d:release -d:ssl --run $DAYMODULE.nim

And if you want to measure memory usage:

    mkdir -p build
    deno compile --output build/$DAY --unstable --allow-all $DAY.ts
    /usr/bin/time -v ./build/$DAY

Or

    mkdir -p build
    nim c -d:release -d:ssl --outdir:build $DAYMODULE.nim
    /usr/bin/time -v ./$DAYMODULE

# Days

- [x] [Day 1](./1.ts)
- [x] [Day 2](./2.ts)
- [ ] Day 3
- [ ] Day 4
- [ ] Day 5
- [ ] Day 6
- [ ] Day 7
- [ ] Day 8
- [ ] Day 9
- [ ] Day 10
- [ ] Day 11
- [ ] Day 12
- [ ] Day 13
- [ ] Day 14
- [ ] Day 15
- [ ] Day 16
- [ ] Day 17
- [ ] Day 18
- [ ] Day 19
- [ ] Day 20
- [ ] Day 21
- [ ] Day 22
- [ ] Day 23
- [ ] Day 24
- [ ] Day 25

[deno]: https://deno.land/
[ts]: https://deno.land/manual/typescript
