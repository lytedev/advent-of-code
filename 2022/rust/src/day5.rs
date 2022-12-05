mod common;

#[derive(Clone)]
struct Move {
    amount: i32,
    from: usize,
    to: usize,
}

#[derive(Clone)]
struct Crates {
    stacks: Vec<Vec<char>>,
    moves: Vec<Move>,
}

type Input = Crates;
type Result = String;

fn processed_input(input: &str) -> Input {
    let mut moves: Vec<Move> = vec![];

    // scan for the line that denotes the stack numbers (it's the line that starts with " 1")
    let stacks_index = input.find("\n 1").unwrap() + 1;
    let first_slice = &input[stacks_index..];
    // calculate the number of stacks based on the length of that line
    // we do this by subtracting 3 (" 1 ") and then dividing by 4 ("  2 ", "  3 ", ... "  9 ")
    // the last stack number includes the trailing space, so this math holds up
    let end_head_index = first_slice.find('\n').unwrap();
    let num_stacks = ((&first_slice[0..end_head_index].len() - 3) / 4) + 1;
    let mut stacks: Vec<Vec<char>> = (0..num_stacks).map(|_| vec![]).collect();

    // parse the stacks from the bottom up
    for l in input[0..stacks_index].lines().rev() {
        let mut x = 0;
        for c in l.chars().skip(1).step_by(4) {
            x += 1;
            if c == ' ' {
                continue;
            }
            stacks[x - 1].push(c);
        }
    }

    // parse the moves
    for l in input[stacks_index + end_head_index + 2..].lines() {
        let words: Vec<&str> = l.split_whitespace().collect();
        moves.push(Move {
            amount: words[1].parse().unwrap(),
            from: words[3].parse::<usize>().unwrap() - 1,
            to: words[5].parse::<usize>().unwrap() - 1,
        })
    }

    Crates { stacks, moves }
}

fn perform_moves(crates: &mut Crates) {
    let stacks = &mut crates.stacks;
    for Move { amount, from, to } in &crates.moves {
        for _ in 0..*amount {
            let popped = stacks[*from].pop().unwrap();
            stacks[*to].push(popped);
        }
    }
}

fn part1(input: &mut Input) -> Result {
    perform_moves(input);

    input
        .stacks
        .iter()
        .map(|s| s.last().unwrap_or(&' ').clone())
        .collect::<String>()
        .trim()
        .to_string()
}

fn perform_moves2(crates: &mut Crates) {
    let stacks = &mut crates.stacks;
    for Move { amount, from, to } in &crates.moves {
        let f = &mut stacks[*from];
        let ra = (f.len() - (*amount as usize))..;
        let mut popped: Vec<char> = f.splice(ra, vec![]).collect();
        stacks[*to].append(&mut popped);
    }
}

fn part2(input: &mut Input) -> Result {
    perform_moves2(input);

    input
        .stacks
        .iter()
        .map(|s| s.last().unwrap_or(&' ').clone())
        .collect::<String>()
        .trim()
        .to_string()
}

fn main() {
    let input_text = common::day_input(5);
    let mut input = processed_input(&input_text);
    let mut input2 = input.clone();
    common::show_answers(&part1(&mut input), &part2(&mut input2))
}

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
        let mut input2 = input.clone();
        assert_eq!(part1(&mut input), "CMZ");
        assert_eq!(part2(&mut input2), "MCD");
    }
}
