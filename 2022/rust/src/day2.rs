mod common;

// A -> Rock
// B -> Paper
// C -> Scissors

// X -> Rock -> 1
// Y -> Paper -> 2
// Z -> Scissors -> 3

fn main() {
    let input = common::day_input(2);
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn rps(a: char, b: char) -> i32 {
    match b {
        'X' => {
            1 + match a {
                'A' => 3,
                'B' => 0,
                'C' => 6,
                _ => 1000000,
            }
        }
        'Y' => {
            2 + match a {
                'A' => 6,
                'B' => 3,
                'C' => 0,
                _ => 1000000,
            }
        }
        'Z' => {
            3 + match a {
                'A' => 0,
                'B' => 6,
                'C' => 3,
                _ => 1000000,
            }
        }
        _ => 1000000,
    }
}

fn part1(input: &str) -> i32 {
    input
        .lines()
        .map(|s| {
            println!("{:?}", s);
            println!("{:?}", s.chars().nth(2));
            let mut c = s.chars();
            rps(c.nth(0).unwrap(), c.nth(1).unwrap())
        })
        .sum()
}

fn part2(input: &str) -> i32 {
    0
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

    // #[test]
    // fn test_part2() {
    //     assert_eq!(part2(TEST_INPUT), 10000)
    // }
}
