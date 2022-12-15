use std::cmp::{max, min};
use std::collections::HashMap;

mod common;

type XY = (i32, i32);
type Map = HashMap<XY, char>;
struct Input {
    map: Map,
    low_point: i32,
}
type Answer = usize;

fn processed_input(input: &str) -> Input {
    let mut map = HashMap::new();
    let mut low_point = i32::MIN;
    let mut set = |x, y, c| {
        println!("{}, {} -> {}", x, y, c);
        map.insert((x, y), c);
        if y > low_point {
            low_point = y + 1
        }
    };
    for l in input.lines() {
        println!("{}", l);
        let coords = l
            .split(" -> ")
            .map(|c| {
                let (x, y) = c.split_once(',').unwrap();
                (
                    x.parse::<i32>().unwrap() + OFFSET.0,
                    y.parse::<i32>().unwrap() + OFFSET.1,
                )
            })
            .collect::<Vec<XY>>();
        for i in 1..coords.len() {
            let a = coords[i - 1];
            let b = coords[i];
            if a.0 == b.0 {
                let x = a.0;
                for y in min(a.1, b.1)..=max(a.1, b.1) {
                    set(x, y, '#');
                }
            } else {
                let y = a.1;
                for x in min(a.0, b.0)..=max(a.0, b.0) {
                    set(x, y, '#');
                }
            }
        }
    }
    return Input { map, low_point };
}

const OFFSET: XY = (-500, 0);
const SAND_LOC: XY = (0, 0);

fn fall_to_first_empty_or_void(map: &Map, void_height: i32) -> Result<XY, ()> {
    let (mut x, mut y) = (0, 0);
    while y < void_height {
        println!("{}", y);
        let ny = y + 1;
        match [(x, ny), (x - 1, ny), (x + 1, ny)]
            .iter()
            .find(|(x, y)| map.get(&(*x, *y)).is_none())
        {
            Some((nx, ny)) => (x, y) = (*nx, *ny),
            None => return Ok((x, y)),
        }
    }
    Err(())
}

fn part1(input: &mut Input) -> Answer {
    println!("{}", input.low_point);
    let mut result = 0;
    loop {
        match fall_to_first_empty_or_void(&input.map, input.low_point) {
            Ok((x, y)) => input.map.insert((x, y), 'O'),
            Err(_) => break,
        };
        result += 1;
    }
    result
}

fn part2(input: &Input) -> Answer {
    0
}

fn main() {
    let input_text = common::day_input(14);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let mut input = processed_input(&input_text);
    let input2 = processed_input(&input_text);
    common::show_answers(&part1(&mut input), &part2(&input2))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Answer, Answer) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9";

    #[test]
    fn test() {
        let mut input = processed_input(TEST_INPUT);
        assert_eq!(part1(&mut input), 24);
        let input2 = processed_input(TEST_INPUT);
        assert_eq!(part2(&input2), 0);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
