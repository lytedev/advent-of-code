mod common;

use std::collections::HashSet;
use std::iter::FromIterator;

fn main() {
    let input = common::day_input(3);
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn priority(b: u8) -> i32 {
    (b as i32) - if b >= 97 && b <= 122 { 96 } else { 38 }
}

fn part1(input: &str) -> i32 {
    input.lines().map(str::as_bytes).fold(0, |r, b| {
        let h = b.len() / 2;
        r + priority(
            *HashSet::<u8>::from_iter((&b[0..h]).iter().cloned())
                .intersection(&HashSet::from_iter((&b[h..b.len()]).iter().cloned()))
                .next()
                .unwrap(),
        )
    })
}

fn part2(input: &str) -> i32 {
    input
        .lines()
        .collect::<Vec<&str>>()
        .chunks_exact(3)
        .fold(0, |r, t| {
            r + priority(
                *t.iter()
                    .map(|l| HashSet::<u8>::from_iter(l.bytes()))
                    .reduce(|a, b| HashSet::from_iter(a.intersection(&b).cloned()))
                    .unwrap()
                    .iter()
                    .next()
                    .unwrap(),
            )
        })
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw";

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 157)
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 70)
    }
}
