mod common;

#[derive(Debug)]
struct Move {
    amount: i32,
    from: usize,
    to: usize,
}

#[derive(Debug)]
struct Crates {
    stacks: Vec<Vec<char>>,
    moves: Vec<Move>,
}

const NUM_STACKS: usize = 9;

type Input = Crates;
type Result = String;

fn processed_input(input: &str) -> Input {
    let mut stacks: Vec<Vec<char>> = vec![];
    let mut moves: Vec<Move> = vec![];

    for _ in 0..NUM_STACKS {
        stacks.push(vec![]);
    }

    let mut parsing_stacks = true;
    for l in input.lines() {
        if l.trim() == "" || l.chars().skip(1).next().unwrap() == '1' {
            parsing_stacks = false;
            continue;
        } else if parsing_stacks {
            let mut x = 0;
            for c in l.chars().skip(1).step_by(4) {
                x += 1;
                if c == ' ' {
                    continue;
                }
                stacks[x - 1].push(c);
            }
        } else {
            let words: Vec<&str> = l.split_whitespace().collect();
            println!("words: {:?}", words);
            moves.push(Move {
                amount: words[1].parse().unwrap(),
                from: words[3].parse::<usize>().unwrap() - 1,
                to: words[5].parse::<usize>().unwrap() - 1,
            })
        }
    }

    for s in &mut stacks[..] {
        s.reverse();
    }

    Crates { stacks, moves }
}

fn perform_moves(crates: &mut Crates) {
    let stacks = &mut crates.stacks;
    for Move { amount, from, to } in &crates.moves {
        println!("move: {} {} {}", amount, from, to);
        for _ in 0..*amount {
            let popped = stacks[*from].pop().unwrap();
            stacks[*to].push(popped);
        }
        println!("{:?}", stacks);
    }
}

fn part1(input: &mut Input) -> Result {
    println!("{:?}", input);
    perform_moves(input);

    let mut r = String::from("");
    for s in &input.stacks {
        r.push(s.last().unwrap_or(&' ').clone())
    }
    r.trim().to_string()
}

fn part2(input: &Input) -> Result {
    "".to_string()
}

fn main() {
    let input_text = common::day_input(5);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let mut input = processed_input(&input_text);
    common::show_answers(&part1(&mut input), &part2(&input))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Result, Result) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";

    #[test]
    fn test() {
        let mut input = processed_input(TEST_INPUT);
        assert_eq!(part1(&mut input), "CMZ");
        let mut input = processed_input(TEST_INPUT);
        assert_eq!(part2(&input), "");
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
