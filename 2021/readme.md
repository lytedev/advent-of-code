# 2021

This year, I've been tinkering a lot with [Deno][deno] as a [TypeScript][ts]
runtime and have been really enjoying it. I'm hoping to write this year's AoC
solutions using it.

Specifically, here's my `deno --version` output:

    $ deno --version
    deno 1.16.3 (release, x86_64-unknown-linux-gnu)
    v8 9.7.106.5
    typescript 4.4.2

It looks like I'm also doing some of these in Nim.

    $ nim --version
    Nim Compiler Version 1.6.0 [Linux: amd64]
    Compiled at 2021-10-19
    Copyright (c) 2006-2021 by Andreas Rumpf

    git hash: 727c6378d2464090564dbcd9bc8b9ac648467e38
    active boot switches: -d:release

And I decided part way through to do some Rust.

    $ rustc --version
    rustc 1.58.0-beta.2 (0e07bcb68 2021-12-04)

Enjoy!

## Usage

Run these solutions like so from their respective directories:

    deno run --unstable --allow-all $DAY.ts

And the Nim ones like so:

    nim c -d:release -d:ssl --run day$DAY.nim

And Rust:

    rustc -O --out-dir build day$DAY.rs && ./build/day$DAY

And if you want to measure memory usage with Deno programs:

    mkdir -p build
    deno compile --output build/$DAY --unstable --allow-all $DAY.ts
    /usr/bin/time -v ./build/$DAY

Or for Nim programs:

    mkdir -p build
    nim c -d:release -d:ssl --outdir:build day$DAY.nim
    /usr/bin/time -v ./day$DAY

And similarly for Rust:

    rustc -O --out-dir build day$DAY.rs
    /usr/bin/time -v ./build/day$DAY

# Days

- [x] Day 1: [Deno](./deno/1.ts), [Nim](./nim/day1.nim)
- [x] Day 2: [Deno](./deno/2.ts), [Nim](./nim/day2.nim)
- [x] Day 3: [Deno](./deno/3.ts), [Nim](./nim/day3.nim)
- [x] Day 4: [Nim](./nim/day4.nim)
- [x] Day 5: [Nim](./nim/day5.nim)
- [x] Day 6: [Nim](./nim/day6.nim)
- [x] Day 7: [Nim](./nim/day7.nim)
- [x] Day 8: [Nim](./nim/day8.nim)
- [x] Day 9: [Nim](./nim/day9.nim)
- [x] Day 10: [Nim](./nim/day10.nim)
- [x] Day 11: [Nim](./nim/day11.nim)
- [x] Day 12: [Nim](./nim/day12.nim)
- [x] Day 13: [Nim](./nim/day13.nim)
- [x] Day 14: [Nim](./nim/day14.nim)
- [x] Day 15: [Nim](./nim/day15.nim)
- [x] Day 16: [Rust](./rust/day16.rs)
- [x] Day 17: [Rust](./rust/day17.rs)
- [x] Day 18: [Nim](./nim/day18.nim)
- [ ] Day 19
- [ ] Day 20
- [ ] Day 21
- [ ] Day 22
- [ ] Day 23
- [ ] Day 24
- [ ] Day 25

[deno]: https://deno.land/
[ts]: https://deno.land/manual/typescript
