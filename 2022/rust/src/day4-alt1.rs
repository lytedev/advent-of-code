mod common;

use std::ops::Range;

struct AssignmentPair {
    a: Range<i32>,
    b: Range<i32>,
}

impl AssignmentPair {
    fn fully_contained(&self) -> bool {
        (self.a.start <= self.b.start && self.a.end >= self.b.end)
            || (self.b.start <= self.a.start && self.b.end >= self.a.end)
    }

    fn overlap(&self) -> bool {
        self.a.start <= self.b.end && self.b.start <= self.a.end
    }
}

impl From<&str> for AssignmentPair {
    fn from(s: &str) -> Self {
        let mut nums = s.split(&['-', ',']).map(|s| s.parse::<i32>().unwrap());
        Self {
            a: nums.next().unwrap()..nums.next().unwrap(),
            b: nums.next().unwrap()..nums.next().unwrap(),
        }
    }
}

fn main() {
    let text = common::day_input(4);
    let input = process_input(&text);
    common::show_answers(&part1(&input), &part2(&input));
}

fn process_input(input: &str) -> Vec<AssignmentPair> {
    input
        .lines()
        .map(|l| l.into())
        .collect::<Vec<AssignmentPair>>()
}

fn part1(input: &[AssignmentPair]) -> usize {
    input.into_iter().filter(|p| p.fully_contained()).count()
}

fn part2(input: &[AssignmentPair]) -> usize {
    input.iter().filter(|p| p.overlap()).count()
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8";

    #[test]
    fn test() {
        let input = process_input(TEST_INPUT);
        assert_eq!(part1(&input), 2);
        assert_eq!(part2(&input), 4);
    }
}
