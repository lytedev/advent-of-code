mod common;

use std::collections::HashSet;

type Input = Vec<char>;
type Result = usize;

fn processed_input(input: &str) -> Vec<char> {
    input.chars().collect()
}

fn part1(c: &Input) -> Result {
    for i in 3.. {
        if c[i] != c[i - 1]
            && c[i] != c[i - 2]
            && c[i] != c[i - 3]
            && c[i - 1] != c[i - 2]
            && c[i - 1] != c[i - 3]
            && c[i - 2] != c[i - 3]
        {
            return i + 1;
        }
    }

    0
}

fn part2(c: &Input) -> Result {
    for i in 13..c.len() {
        let mut s: HashSet<char> = HashSet::new();
        for j in i - 13..=i {
            s.insert(c[j]);
        }
        if s.len() == 14 {
            return i + 1;
        }
    }

    0
}

fn main() {
    let input_text = common::day_input(6);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "mjqjpqmgbljsphdztnvjfqwrcgsmlb";

    #[test]
    fn test() {
        let input_text = TEST_INPUT;
        let input = processed_input(&input_text);
        assert_eq!(part1(&input), 7);
        assert_eq!(part2(&input), 19);
    }
}
