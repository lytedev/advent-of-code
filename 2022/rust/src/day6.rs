mod common;

use std::collections::HashSet;

type Input = String;
type Result = usize;

fn processed_input(input: &str) -> Input {
    input.to_owned()
}

fn part1(input: &Input) -> Result {
    let c: Vec<char> = input.chars().collect();
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

fn part2(input: &Input) -> Result {
    let c: Vec<char> = input.chars().collect();
    println!("{} {}", 88, c.len());

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
    let input2 = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input2))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Result, Result) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "mjqjpqmgbljsphdztnvjfqwrcgsmlb";

    #[test]
    fn test() {
        // let input = processed_input(TEST_INPUT);
        // assert_eq!(part1(&input), 7);
        let input = processed_input(TEST_INPUT);
        assert_eq!(part2(&input), 19);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
