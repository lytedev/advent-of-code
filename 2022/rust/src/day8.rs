mod common;

use std::collections::HashSet;

type Input = Vec<Vec<u8>>;
type Result = usize;

fn processed_input(input: &str) -> Input {
    let mut result = vec![];
    for l in input.lines() {
        let mut v = vec![];
        for b in l.bytes() {
            v.push(b - 48);
        }
        result.push(v);
    }
    return result;
}

fn part1(input: &Input) -> Result {
    let mut trees: HashSet<(usize, usize)> = HashSet::new();
    let mut add = |y, x| {
        println!(
            "tree @ row {}, col {} ({})",
            y,
            x,
            (&input[y] as &Vec<u8>)[x]
        );
        trees.insert((y, x));
    };
    let h = input.len();
    let w = input[0].len();
    for y in 0..h {
        let row = &input[y];
        let mut tallest_left = row[0];
        let mut tallest_right = row[w - 1];
        let mut xd = 1;
        add(y, 0);
        add(y, w - 1);
        while xd < w {
            if row[xd] > tallest_left {
                tallest_left = row[xd];
                add(y, xd);
            }
            let rx = w - 1 - xd;
            if row[rx] > tallest_right {
                tallest_right = row[rx];
                add(y, rx);
            }
            xd += 1;
        }
    }

    for x in 0..w {
        let mut tallest_top = input[0][x];
        let mut tallest_bottom = input[h - 1][x];
        let mut yd = 1;
        add(0, x);
        add(h - 1, x);
        while yd < h {
            if input[yd][x] > tallest_top {
                tallest_top = input[yd][x];
                add(yd, x);
            }
            let ry = h - 1 - yd;
            if input[yd][ry] > tallest_bottom {
                tallest_bottom = input[yd][ry];
                add(ry, x);
            }
            yd += 1;
        }
    }

    println!("{:?}", trees);

    trees.len()
}

fn part2(input: &Input) -> Result {
    0
}

fn main() {
    let input_text = common::day_input(8);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
    // 1755 for part 1 is too high
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Result, Result) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "30373
25512
65332
33549
35390";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 21);
        assert_eq!(part2(&input), 0);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
