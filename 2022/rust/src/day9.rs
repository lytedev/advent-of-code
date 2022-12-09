mod common;

use std::{collections::HashSet, iter::repeat};

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

fn follow((hx, hy): (i32, i32), (tx, ty): (i32, i32)) -> (i32, i32) {
    let (dx, dy) = (tx.abs_diff(hx), ty.abs_diff(hy));
    let (mx, my) = ((hx - tx) / 2, (hy - ty) / 2);
    if dx > 1 && dy > 1 {
        (tx + mx, ty + my)
    } else if dx > 1 {
        (tx + mx, hy)
    } else if dy > 1 {
        (hx, ty + my)
    } else {
        (tx, ty)
    }
}

fn both_parts(input: &Input) -> (Answer, Answer) {
    let mut p1: HashSet<(i32, i32)> = HashSet::new();
    let mut h: (i32, i32) = (0, 0);
    let mut t: (i32, i32) = (0, 0);

    let mut p2: HashSet<(i32, i32)> = HashSet::new();
    let mut r: Vec<(i32, i32)> = repeat((0, 0)).take(10).collect();

    for i in input {
        if let Some((x, y)) = match i.0 {
            'L' => Some((-1, 0)),
            'R' => Some((1, 0)),
            'U' => Some((0, -1)),
            'D' => Some((0, 1)),
            _ => None,
        } {
            for _ in 0..i.1 {
                // move part 1 head/tail
                h = (h.0 + x, h.1 + y);
                t = follow(h, t);
                p1.insert(t);

                // move part 2 rope
                r[0] = (r[0].0 + x, r[0].1 + y);
                for s in 1..r.len() {
                    r[s] = follow(r[s - 1], r[s]);
                }
                p2.insert(r[r.len() - 1]);
            }
        }
    }

    (p1.len(), p2.len())
}

fn main() {
    let input_text = common::day_input(9);
    let input = processed_input(&input_text);
    common::show_both_answers(&both_parts(&input))
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
        assert_eq!(both_parts(&input), (13, 1));
    }

    const TEST_INPUT2: &str = "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20";

    #[test]
    fn part2_test2() {
        let input2 = processed_input(TEST_INPUT2);
        assert_eq!(both_parts(&input2), (88, 36));
    }
}
