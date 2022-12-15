use std::cmp::Ordering;
use std::str::FromStr;

mod common;

#[derive(Debug, Eq)]
enum Packet {
    Num(i32),
    List(Box<Vec<Packet>>),
}

#[derive(Debug)]
enum ParsePacketError {
    EndOfList,
    EndOfString,
}

impl FromStr for Packet {
    type Err = ParsePacketError;

    fn from_str(orig: &str) -> Result<Self, Self::Err> {
        println!("orig: {}", orig);
        match orig.chars().next() {
            Some('[') => {
                let contents = &orig[1..orig.len() - 1];
                let mut chunks = vec![];
                let mut chunk_start = 0;
                // this is dumb. I should be able to recurse this crap but my brain must be fried
                let mut nest_level = 0;
                for (i, c) in contents.char_indices() {
                    match c {
                        '[' => nest_level += 1,
                        ']' => nest_level -= 1,
                        ',' => {
                            if nest_level == 0 {
                                chunks.push(&contents[chunk_start..i]);
                                chunk_start = i + 1;
                            }
                        }
                        _ => {}
                    }
                }
                if chunk_start < contents.len() {
                    chunks.push(&contents[chunk_start..]);
                }
                println!("{:?}", chunks);
                Ok(Self::List(Box::new(
                    chunks
                        .iter()
                        .map(|s| s.parse::<Packet>().unwrap())
                        .collect(),
                )))
            }
            Some(_) => Ok(Self::Num(orig.parse::<i32>().unwrap())),
            None => Err(ParsePacketError::EndOfString),
        }
    }
}

impl Ord for Packet {
    fn cmp(&self, other: &Self) -> Ordering {
        println!("comparing {:?} with {:?}", self, other);
        match (self, other) {
            (Self::Num(l), Self::Num(r)) => l.cmp(r),
            (Self::List(l), Self::List(r)) => {
                for (l, r) in std::iter::zip(l.iter(), r.iter()) {
                    match l.cmp(r) {
                        Ordering::Equal => continue,
                        v => {
                            println!("done: {:?}", v);
                            return v;
                        }
                    }
                }
                l.len().cmp(&r.len())
            }
            (Self::Num(l), r) => Self::List(Box::new(vec![Self::Num(*l)])).cmp(r),
            (l, Self::Num(r)) => l.cmp(&Self::List(Box::new(vec![Self::Num(*r)]))),
        }
    }
}

impl PartialOrd for Packet {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Packet {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::Num(l), Self::Num(r)) => l == r,
            (Self::List(l), Self::List(r)) => {
                l.len() == r.len() && l.iter().zip(r.iter()).all(|(l, r)| l == r)
            }
            (Self::Num(_), Self::List(_)) => false,
            (Self::List(_), Self::Num(_)) => false,
        }
    }
}

#[derive(Debug)]
struct PacketPair {
    left: Packet,
    right: Packet,
}

type Input = Vec<PacketPair>;
type Answer = usize;

fn processed_input(input: &str) -> Input {
    input
        .split("\n\n")
        .map(|c| {
            let mut l = c.lines();
            let result = PacketPair {
                left: l.next().unwrap().parse::<Packet>().unwrap(),
                right: l.next().unwrap().parse::<Packet>().unwrap(),
            };
            println!("{:?}", result);
            return result;
        })
        .collect::<Vec<PacketPair>>()
}

fn part1(input: &Input) -> Answer {
    let mut sum = 0;
    let mut i = 1;
    for pair in input {
        if pair.left < pair.right {
            sum += i
        }
        i += 1
    }
    sum
}

fn part2(input: &Input) -> Answer {
    let mut packets = vec![];
    for pair in input {
        packets.push(&pair.left);
        packets.push(&pair.right);
    }
    let d1 = "[[2]]".parse::<Packet>().unwrap();
    let d2 = "[[6]]".parse::<Packet>().unwrap();
    packets.push(&d1);
    packets.push(&d2);
    packets.sort();
    let mut di1 = 0;
    let mut di2 = 0;
    let mut i = 1;
    for p in packets {
        if p == &d1 {
            di1 = i;
        }
        if p == &d2 {
            di2 = i;
        }
        i += 1;
    }
    di1 * di2
}

fn main() {
    let input_text = common::day_input(13);
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

    const TEST_INPUT: &str = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]";

    #[test]
    fn test() {
        let mut v = vec![Packet::Num(1), Packet::Num(0)];
        v.sort();
        assert_eq!(v, vec![Packet::Num(0), Packet::Num(1)]);
        assert!("[1,1,3,1]".parse::<Packet>().unwrap() < "[1,1,5,1]".parse::<Packet>().unwrap());
        assert_eq!(
            "[[8,7,6]]".parse::<Packet>().unwrap(),
            Packet::List(Box::new(vec![Packet::List(Box::new(vec![
                Packet::Num(8),
                Packet::Num(7),
                Packet::Num(6)
            ]))]))
        );
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 13);
        assert_eq!(part2(&input), 140);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
