use crate::prelude::*;

mod prelude;

fn main() {
    Day1::show(day_input(1), day_input(1))
}

struct Day1 {}
impl AoCSolution for Day1 {
    type Input = String;
    type Solution = i128;

    fn part1(input: Self::Input) -> Self::Solution {
        println!("{}", input);
        return 1;
    }

    fn part2(_input: Self::Input) -> Self::Solution {
        return 0;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        assert_eq!(Day1::part1("asdf".into()), 1);
        assert_eq!(Day1::part2("asdf".into()), 2);
    }
}
