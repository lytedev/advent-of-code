# 2021

This year, I've been tinkering a lot with [Deno][deno] as a [TypeScript][ts]
runtime and have been really enjoying it. I'm hoping to write this year's AoC
solutions using it.

Specifically, here's my `deno --version` output:

    $ deno --version
    deno 1.16.3 (release, x86_64-unknown-linux-gnu)
    v8 9.7.106.5
    typescript 4.4.2

Enjoy!

**EDIT**: Since performance is not what I would like, it looks like I'm also doing some of these in Nim.

    $ nim --version
    Nim Compiler Version 1.6.0 [Linux: amd64]
    Compiled at 2021-10-19
    Copyright (c) 2006-2021 by Andreas Rumpf

    git hash: 727c6378d2464090564dbcd9bc8b9ac648467e38
    active boot switches: -d:release

## Usage

Run these solutions like so:

    deno run --unstable --allow-all $DAY.ts

And the Nim ones like so:

    nim c -d:release -d:ssl --run day$DAY.nim

And if you want to measure memory usage with Deno programs:

    mkdir -p build
    deno compile --output build/$DAY --unstable --allow-all $DAY.ts
    /usr/bin/time -v ./build/$DAY

Or for Nim programs:

    mkdir -p build
    nim c -d:release -d:ssl --outdir:build day$DAY.nim
    /usr/bin/time -v ./day$DAY

# Days

- [x] Day 1: [Deno](./1.ts), [Nim](./one.nim)
- [x] Day 2: [Deno](./2.ts), [Nim](./two.nim)
- [x] Day 3: [Deno](./3.ts), [Nim](./three.nim)
- [x] Day 4: [Nim](./four.nim)
- [x] Day 5: [Nim](./five.nim)
- [x] Day 6: [Nim](./six.nim)
- [x] Day 7: [Nim](./seven.nim)
- [x] Day 8: [Nim](./eight.nim)
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
