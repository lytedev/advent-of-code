mod common;

fn main() {
    let input = common::day_input(2);
    let bytes = input.as_bytes();
    println!("Part 1: {}", part1(bytes));
    println!("Part 2: {}", part2(bytes));
}

fn sum_outcomes(b: &[u8], t: [isize; 3]) -> i32 {
    (0..b.len()).step_by(4).fold(0, |p, x| {
        let y: usize = ((b[x] - 65) % 3).into();
        p + [[4, 8, 3], [1, 5, 9], [7, 2, 6]][y as usize]
            [((((b[x + 2] - 88) % 3) as isize + t[y]).rem_euclid(3)) as usize]
    })
}

fn part1(input: &[u8]) -> i32 {
    sum_outcomes(input, [0, 0, 0])
}

fn part2(input: &[u8]) -> i32 {
    sum_outcomes(input, [-1, 0, 1])
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &[u8] = "A Y
B X
C Z"
    .as_bytes();

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 15)
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 12)
    }
}
