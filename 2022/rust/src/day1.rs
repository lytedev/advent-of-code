mod common;

fn main() {
    let calories = ordered_calories(&common::day_input(1));
    println!("Part 1: {}", part1(&calories));
    println!("Part 2: {}", part2(&calories));
}

fn ordered_calories(input: &str) -> Vec<i32> {
    let mut result = Vec::from([0_i32]);
    for l in input.lines() {
        if l.trim() == "" {
            result.push(0);
        } else {
            if let Ok(v) = l.parse::<i32>() {
                *(result.last_mut().unwrap()) += v;
            }
        }
    }
    result.sort_by(|a, b| b.partial_cmp(a).unwrap());
    result
}

fn part1(calories: &Vec<i32>) -> i32 {
    calories[0]
}

fn part2(calories: &Vec<i32>) -> i32 {
    calories.iter().take(3).sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000";

    fn test_calories() -> Vec<i32> {
        ordered_calories(TEST_INPUT)
    }

    #[test]
    fn test_part1() {
        assert_eq!(part1(&test_calories()), 24000)
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(&test_calories()), 45000)
    }
}
