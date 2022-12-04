mod common;

fn main() {
    let input = common::day_input(4);
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn nums(input: &str) -> Vec<i32> {
    input
        .replace(",", "-")
        .split("-")
        .map(|s| s.parse::<i32>().unwrap())
        .collect()
}

fn part1(input: &str) -> i32 {
    input
        .lines()
        .map(|l| {
            let n = nums(l);
            ((n[0] <= n[2] && n[1] >= n[3]) || (n[2] <= n[0] && n[3] >= n[1])) as i32
        })
        .sum()
}

fn part2(input: &str) -> i32 {
    input
        .lines()
        .map(|l| {
            let n = nums(l);
            (n[0] <= n[3] && n[2] <= n[1]) as i32
        })
        .sum()
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
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 2)
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 4)
    }
}
