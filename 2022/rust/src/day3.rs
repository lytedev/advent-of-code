mod common;

use std::collections::HashSet;

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
    return r;
}

fn part2(input: &str) -> i32 {
    0
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
        assert_eq!(part2(TEST_INPUT), 0)
    }
}
