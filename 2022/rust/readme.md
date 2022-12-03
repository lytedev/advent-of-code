# Rust Advent of Code 2022 Solutions

I've been writing more Rust this year for an internal tool at work and have
really enjoyed the tooling. I intent to do more with Rust this year than
last and aim for good performance (without bending over too far backwards,
anyways...)

## Competing

I compete very lightly. I use [my `at` script][at] like `at 2022-12-02 && ./
fetch_input.sh 2` to fetch input as soon as it's available and I use `watchexec
-e rs 'C; clear; cargo test --bin day2 && cargo run --bin day2'` to run my
file(s) as I edit them.

## Running

First, you will want to fetch your input for the day you want to run. You will
need `curl` and your Advent of Code cookie in `~/.advent-of-code-session-cookie`
to run the following script:

```bash
./fetch_input.sh 1
```

Where `1` is the day's input you want to fetch.

### Debug

```bash
cargo run --bin day1
```

### Tests

```bash
cargo test --bin day1
```

### Release Mode

For speeeeeed!

```bash
cargo build --release --bin day1
time ./target/release/day1
```

### Everything

You can use this `fish` script to build all binaries in release mode and run/
time them all:

```fish
cargo build --release --bins
for f in (fd 'day.' target/release/ --type executable --max-depth 1); echo $f; time $f; end
```

[at]: https://git.lyte.dev/lytedev/dotfiles/src/branch/master/common/bin/at
