mod common;

fn processed_input(input: &str) -> Vec<Vec<i32>> {
    input
        .lines()
        .map(|l| l.split(&['-', ',']).map(|s| s.parse().unwrap()).collect())
        .collect()
}

fn both_parts(input: &Vec<Vec<i32>>) -> (usize, usize) {
    input.iter().fold((0, 0), |(a, b), n| {
        (
            (a + ((n[0] <= n[2] && n[1] >= n[3]) || (n[2] <= n[0] && n[3] >= n[1])) as usize),
            b + ((n[0] <= n[3] && n[2] <= n[1]) as usize),
        )
    })
}

fn main() {
    let input = processed_input(&common::day_input(4));
    common::show_both_answers(&both_parts(&input))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let input = processed_input(
            "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8",
        );
        assert_eq!(both_parts(&input), (2, 4));
    }
}
