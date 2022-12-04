mod common;

type Input = String;
type Result = usize;

fn processed_input(input: &str) -> Input {
    input.to_owned()
}

fn part1(input: &Input) -> Result {
    0
}

fn part2(input: &Input) -> Result {
    0
}

fn main() {
    let input = processed_input(&common::day_input(panic!(
        "PUT THE CORRECT DAY NUMBER HERE AND ADD bin TO Cargo.toml"
    )));
    common::show_answers(&part1(&input), &part2(&input))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Result, Result) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 0);
        assert_eq!(part2(&input), 0);
    }
}
