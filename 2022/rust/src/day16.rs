use std::collections::HashMap;

mod common;

type Addr = [u8; 2];

#[derive(Debug)]
struct Valve {
    flow_rate: usize,
    tunnels_to: Vec<Addr>,
}

type Map = HashMap<Addr, Valve>;

type Input = Map;
type Answer = usize;

fn processed_input(input: &str) -> Input {
    let mut result = HashMap::<Addr, Valve>::new();
    for l in input.lines() {
        println!("{}", l);
        let mut bytes = l[6..=7].bytes();
        let addr = [bytes.next().unwrap(), bytes.next().unwrap()];
        let flow_rate = l
            .split('=')
            .skip(1)
            .next()
            .unwrap()
            .split(';')
            .next()
            .unwrap()
            .parse::<usize>()
            .unwrap();
        let tunnels_to = l
            .split("valve")
            .skip(1)
            .next()
            .unwrap()
            .trim_start_matches(&['s', ' '])
            .split(", ")
            .map(|s| {
                let mut b = s.bytes();
                [b.next().unwrap(), b.next().unwrap()]
            })
            .collect();
        result.insert(
            addr,
            Valve {
                flow_rate,
                tunnels_to,
            },
        );
    }
    result
}

const MINUTES: usize = 30;

fn part1(input: &Input) -> Answer {
    println!("{:?}", input);
    100
}

fn part2(input: &Input) -> Answer {
    0
}

fn main() {
    let input_text = common::day_input(16);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Answer, Answer) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 0);
        assert_eq!(part2(&input), 0);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
