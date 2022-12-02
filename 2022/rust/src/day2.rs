use std::cmp::{Ord, Ordering, PartialEq};
use std::str::FromStr;

mod common;

#[derive(Debug, PartialEq, Eq)]
enum Choice {
    Rock = 1,
    Paper = 2,
    Scissors = 3,
}

impl PartialOrd for Choice {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Choice {
    fn cmp(&self, other: &Self) -> Ordering {
        match self {
            Choice::Rock => match other {
                Choice::Rock => Ordering::Equal,
                Choice::Paper => Ordering::Less,
                Choice::Scissors => Ordering::Greater,
            },
            Choice::Paper => match other {
                Choice::Rock => Ordering::Greater,
                Choice::Paper => Ordering::Equal,
                Choice::Scissors => Ordering::Less,
            },
            Choice::Scissors => match other {
                Choice::Rock => Ordering::Less,
                Choice::Paper => Ordering::Greater,
                Choice::Scissors => Ordering::Equal,
            },
        }
    }
}

#[derive(Debug)]
struct ParseChoiceError;

impl std::fmt::Display for ParseChoiceError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{}", self)
    }
}

impl FromStr for Choice {
    type Err = ParseChoiceError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.chars().nth(0) {
            Some('X') | Some('A') => Ok(Choice::Rock),
            Some('Y') | Some('B') => Ok(Choice::Paper),
            Some('Z') | Some('C') => Ok(Choice::Scissors),
            _ => Err(ParseChoiceError),
        }
    }
}

fn main() {
    let input = common::day_input(2);
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn score_part1(opponent: &Choice, mine: &Choice) -> i32 {
    (*mine as i32)
        + match mine.cmp(opponent) {
            Ordering::Less => 0,
            Ordering::Equal => 3,
            Ordering::Greater => 6,
        }
}

fn part1(input: &str) -> i32 {
    input.lines().fold(0, |points, line| {
        points
            + score_part1(
                &line[0..1].parse::<Choice>().unwrap(),
                &line[2..3].parse::<Choice>().unwrap(),
            )
    })
}

#[derive(Debug)]
struct ParseOrderingError;

fn desired_outcome(s: &str) -> Result<Ordering, ParseOrderingError> {
    match s.chars().nth(0) {
        Some('X') => Ok(Ordering::Less),
        Some('Y') => Ok(Ordering::Equal),
        Some('Z') => Ok(Ordering::Greater),
        _ => Err(ParseOrderingError),
    }
}

fn outcome_choice(opponent: &Choice, desired_outcome: Ordering) -> Choice {
    match opponent {
        Choice::Rock => match desired_outcome {
            Ordering::Equal => Choice::Rock,
            Ordering::Greater => Choice::Paper,
            Ordering::Less => Choice::Scissors,
        },
        Choice::Paper => match desired_outcome {
            Ordering::Less => Choice::Rock,
            Ordering::Equal => Choice::Paper,
            Ordering::Greater => Choice::Scissors,
        },
        Choice::Scissors => match desired_outcome {
            Ordering::Greater => Choice::Rock,
            Ordering::Less => Choice::Paper,
            Ordering::Equal => Choice::Scissors,
        },
    }
}

fn score_part2(opponent: &Choice, outcome: &str) -> i32 {
    score_part1(
        &opponent,
        &outcome_choice(&opponent, desired_outcome(outcome).unwrap()),
    )
}

fn part2(input: &str) -> i32 {
    input.lines().fold(0, |points, line| {
        points + score_part2(&line[0..1].parse::<Choice>().unwrap(), &line[2..3])
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "A Y
B X
C Z";

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 15)
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 12)
    }
}
