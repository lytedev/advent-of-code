mod common;

use std::collections::HashSet;
use std::iter::FromIterator;

fn main() {
    let input = common::day_input(3);
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn part1(input: &str) -> i32 {
    let mut r = 0_i32;
    for l in input.lines() {
        println!("{}", l);
        let mut s: HashSet<u8> = HashSet::new();
        let bytes = l.as_bytes();
        let mut n = 0;
        let bar = bytes.len() / 2;
        println!("{}", bar);
        for b in bytes {
            print!("{}.", b);
            if s.contains(b) && n >= bar {
                if *b >= 97 && *b <= 122 {
                    r += (*b as i32) - 96;
                } else {
                    r += (*b as i32) - 65 + 27;
                }
                println!(" == {}", r);
                break;
            } else if n < bar {
                s.insert(*b);
            }
            n += 1
        }
    }
    r
}

fn part2(input: &str) -> i32 {
    let mut r = 0_i32;
    for t in input.lines().collect::<Vec<&str>>().chunks_exact(3) {
        let a: HashSet<u8> = HashSet::from_iter(t[0].bytes());
        let b: HashSet<u8> = HashSet::from_iter(t[1].bytes());
        let c: HashSet<u8> = HashSet::from_iter(t[2].bytes());
        let ab = HashSet::from_iter(a.intersection(&b).cloned());
        let b = ab.intersection(&c).next().unwrap();
        if *b >= 97 && *b <= 122 {
            r += (*b as i32) - 96;
        } else {
            r += (*b as i32) - 65 + 27;
        }
        println!("+{} = {}", b, r);
    }
    r
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
