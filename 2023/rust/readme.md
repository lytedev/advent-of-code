# Rust Advent of Code 2023 Solutions

## Competing

I compete very lightly. I use [my `at` script][at] like `at 2022-12-02 && ../
fetch-input.sh 2` to fetch input as soon as it's available and I use `watchexec
-e rs 'clear; cargo test --bin day2 && cargo run --bin day2'` to run my file(s)
as I edit them.

## Running

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
time for f in (fd 'day.' target/release/ --type executable --max-depth 1); echo $f; time $f; end
```

[at]: https://git.lyte.dev/lytedev/nix/src/branch/main/modules/home-manager/scripts/common/bin/at
