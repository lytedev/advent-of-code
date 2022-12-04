mod common;

type Input = String;
type Result = usize;

fn processed_input(input: &str) -> Input {
    input.to_owned()
}

fn part1(input: &Input) -> Result {
    100
}

fn part2(input: &Input) -> Result {
    0
}

fn main() {
    let input_text = common::day_input(5);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
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
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
