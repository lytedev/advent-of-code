# Rust Advent of Code 2022 Solutions

I've been writing more Rust this year for an internal tool at work and have
really enjoyed the tooling. I intent to do more with Rust this year than
last and aim for good performance (without bending over too far backwards,
anyways...)

## Running

First, you will want to fetch your input for the day you want to run. You will
need `curl` and your Advent of Code cookie in `~/.advent-of-code-session-cookie`
to run the following script:

```bash
fetch_input.sh 1
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
