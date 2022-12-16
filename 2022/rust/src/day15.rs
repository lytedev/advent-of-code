mod common;

type XY = (i64, i64);
#[derive(Debug)]
struct Sensor {
    pos: XY,
    nearest_beacon: XY,
    taxi_dist_covered: u64,
}

type Input = Vec<Sensor>;
type Answer = usize;

fn taxi_dist(a: &XY, b: &XY) -> u64 {
    (a.0.abs_diff(b.0) + a.1.abs_diff(b.1)).saturating_sub(1)
}

fn processed_input(input: &str) -> Input {
    input
        .lines()
        .map(|s| {
            let line_res = s
                .split('=')
                .skip(1)
                .map(|s| {
                    s.chars()
                        .take_while(|c| *c == '-' || ('0'..='9').contains(c))
                        .collect::<String>()
                        .parse::<i64>()
                        .unwrap()
                })
                .collect::<Vec<i64>>();

            line_res
        })
        .map(|coords| {
            let pos = (coords[0], coords[1]);
            let nearest_beacon = (coords[2], coords[3]);
            let taxi_dist_covered = taxi_dist(&pos, &nearest_beacon);
            Sensor {
                pos,
                nearest_beacon,
                taxi_dist_covered,
            }
        })
        .collect()
}

fn part1(input: &Input, y: i64) -> Answer {
    let (mut minx, mut maxx) = (i64::MAX, i64::MIN);
    for s in input {
        let (nminx, nmaxx) = (
            s.pos.0 - (s.taxi_dist_covered as i64),
            s.pos.0 + (s.taxi_dist_covered as i64),
        );
        if nminx < minx {
            minx = nminx;
        }
        if nmaxx > maxx {
            maxx = nmaxx;
        }
    }
    let mut unbeaconable_locs = 0;
    println!("{}..{}", minx, maxx);
    for x in minx..=maxx {
        for s in input {
            if (x, y) == s.nearest_beacon {
                break;
            }
            if taxi_dist(&s.pos, &(x, y)) <= s.taxi_dist_covered {
                unbeaconable_locs += 1;
                break;
            }
        }
    }
    println!("{:?}", input);
    unbeaconable_locs
}

fn part2(input: &Input, max: i64) -> Answer {
    let (minx, maxx) = (0, max);
    for y in minx..=maxx {
        'outer: for x in minx..=maxx {
            println!("{},{}", x, y);
            for s in input {
                if taxi_dist(&s.pos, &(x, y)) <= s.taxi_dist_covered {
                    continue 'outer;
                }
            }
            return ((x * 4000000) + y) as usize;
        }
    }
    println!("{:?}", input);
    0
}

fn main() {
    let input_text = common::day_input(15);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input, 2000000), &part2(&input, 4000000))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Answer, Answer) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input, 10), 26);
        assert_eq!(part2(&input, 20), 56000011);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
