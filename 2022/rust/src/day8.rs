mod common;

use std::collections::HashSet;

type Input = Vec<Vec<u8>>;
type Result = usize;

fn processed_input(input: &str) -> Input {
    let mut result = vec![];
    for l in input.trim().lines() {
        let mut v = vec![];
        for b in l.trim().bytes() {
            v.push(b - 48);
        }
        result.push(v);
    }
    return result;
}

fn part1(input: &Input) -> Result {
    let mut trees: HashSet<(usize, usize)> = HashSet::new();

    let mut add = |y, x| {
        trees.insert((y, x))
    }

    let h = input.len();
    let w = input[0].len();

    for y in 1..=h - 2 {
        let row = &input[y];
        let mut tallest_left = row[0];
        let mut tallest_right = row[w - 1];
        let mut xd = 1;
        while xd < w - 1 {
            if row[xd] > tallest_left {
                tallest_left = row[xd];
                add(y, xd);
            }
            let rxd = w - 1 - xd;
            if row[rxd] > tallest_right {
                tallest_right = row[rxd];
                add(y, rxd);
            }
            xd += 1;
        }
    }

    for x in 1..=w - 2 {
        let mut tallest_top = input[0][x];
        let mut tallest_bottom = input[h - 1][x];
        let mut yd = 1;
        while yd < h - 1 {
            if input[yd][x] > tallest_top {
                tallest_top = input[yd][x];
                add(yd, x);
            }
            let ryd = h - 1 - yd;
            if input[ryd][x] > tallest_bottom {
                tallest_bottom = input[ryd][x];
                add(ryd, x);
            }
            yd += 1;
        }
    }

    trees.len() + (2 * (h - 1)) + (2 * (w - 1))
}

fn part2(input: &Input) -> Result {
    // 29155 is too low
    let dh = input.len();
    let dw = input[0].len();
    let mut best = 0;
    println!("width: {}, height: {}", dw, dh);
    for x in 1..dw - 1 {
        for y in 1..dh - 1 {
            println!("y: {}, x: {}", y, x);
            let mut score = 1;
            let h = input[y][x];
            for lx in (0..x).rev() {
                if input[y][lx] >= h || lx == 0 {
                    println!("left: {}", x - lx);
                    score = score * (x - lx);
                    break;
                }
            }
            for ty in (0..y).rev() {
                if input[ty][x] >= h || ty == 0 {
                    println!("top: {}", y - ty);
                    score = score * (y - ty);
                    break;
                }
            }
            for rx in x + 1..dw {
                if input[y][rx] >= h || rx == (dw - 1) {
                    println!("right: {}", rx - x);
                    score = score * (rx - x);
                    break;
                }
            }
            for by in y + 1..dh {
                if input[by][x] >= h || by == (dh - 1) {
                    println!("bottom: {}", by - y);
                    score = score * (by - y);
                    break;
                }
            }
            println!("y: {}, x: {}, score: {}", y, x, score);
            best = score.max(best)
        }
    }
    return best;
}

fn main() {
    let input_text = common::day_input(8);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
    // 1755 for part 1 is too high (so is 1750 in case off-by-one-ish) and so is 1745
    // 1705 is wrong
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
        assert_eq!(part2(&input), 8);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
