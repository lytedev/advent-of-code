mod common;

use std::collections::HashSet;

type Input = Vec<(char, i32)>;
type Answer = usize;

fn processed_input(input: &str) -> Input {
    input
        .lines()
        .map(|l| {
            let mut args = l.split(' ');
            (
                args.next().unwrap().chars().next().unwrap(),
                args.next().unwrap().parse::<i32>().unwrap(),
            )
        })
        .collect()
}

fn part1(input: &Input) -> Answer {
    let mut p: HashSet<(i32, i32)> = HashSet::new();
    let mut h: (i32, i32) = (0, 0);
    let mut t: (i32, i32) = (0, 0);

    let mut m = |x, y, n| {
        for _ in 0..n {
            h.0 += x;
            h.1 += y;
            if t.0.abs_diff(h.0) > 1 && t.1.abs_diff(h.1) > 1 {
                t.0 += (h.0 - t.0) / 2;
                t.1 += (h.1 - t.1) / 2;
            } else if t.0.abs_diff(h.0) > 1 {
                t.0 += (h.0 - t.0) / 2;
                t.1 = h.1;
            } else if t.1.abs_diff(h.1) > 1 {
                t.1 += (h.1 - t.1) / 2;
                t.0 = h.0;
            }
            p.insert(t);
            println!("h: ({}, {}), t: ({}, {})", h.0, h.1, t.0, t.1);
        }
    };

    for i in input {
        println!("{:?}", i);
        match i.0 {
            'L' => m(-1, 0, i.1),
            'R' => m(1, 0, i.1),
            'U' => m(0, -1, i.1),
            'D' => m(0, 1, i.1),
            _ => (),
        }
    }

    p.len()
}

fn part2(input: &Input) -> Answer {
    0
}

fn main() {
    let input_text = common::day_input(9);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 13);
        assert_eq!(part2(&input), 0);
    }
}
