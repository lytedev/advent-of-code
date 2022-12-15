use std::str::FromStr;

mod common;

#[derive(Debug)]
enum Operator {
    Mul,
    Add,
}

impl Operator {
    fn apply(&self, operand: &Operand, old: i64) -> i64 {
        match self {
            Self::Mul => old * operand.amount(old),
            Self::Add => old + operand.amount(old),
        }
    }
}

#[derive(Debug)]
enum Operand {
    I64(i64),
    Old,
}

impl Operand {
    fn amount(&self, old: i64) -> i64 {
        match self {
            Self::I64(n) => n.clone(),
            Self::Old => old,
        }
    }
}

impl FromStr for Operand {
    type Err = ParseOperandError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if let Ok(n) = s.parse::<i64>() {
            Ok(Self::I64(n))
        } else {
            Ok(Self::Old)
        }
    }
}

#[derive(Debug)]
struct ParseOpError;

#[derive(Debug)]
struct ParseOperandError;

impl FromStr for Operator {
    type Err = ParseOpError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.bytes().next().unwrap() {
            43 => Ok(Self::Add),
            _ => Ok(Self::Mul),
        }
    }
}

#[derive(Debug)]
struct Monkey {
    items: Vec<i64>,
    operator: Operator,
    operand: Operand,
    test_div: (i64, usize, usize),
    num_inspections: usize,
}

impl Monkey {
    fn act(&mut self, divisor: i64) -> Vec<(i64, usize)> {
        let mut result = vec![];
        while let Some(item) = self.items.pop() {
            self.num_inspections += 1;
            let new_item = self.operator.apply(&self.operand, item) / divisor;
            if new_item % self.test_div.0 == 0 {
                result.push((new_item, self.test_div.1));
            } else {
                result.push((new_item, self.test_div.2));
            }
        }
        return result;
    }
}

#[derive(Debug)]
struct ParseMonkeyError;

impl FromStr for Monkey {
    type Err = ParseMonkeyError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        println!("FROM Jk:{:?}", s);
        let mut lines = s.split("\n").skip(1);
        let mut p2 = |s| lines.next().unwrap().split(s).skip(1).next().unwrap();
        let items = p2(": ")
            .split(", ")
            .map(|s| s.parse::<i64>().unwrap())
            .collect();
        let oper = p2("old ");
        let operator = oper.parse::<Operator>().unwrap();
        let operand = oper[2..].parse::<Operand>().unwrap();
        let test_div = (
            p2("by ").parse::<i64>().unwrap(),
            p2("monkey ").parse::<usize>().unwrap(),
            p2("monkey ").parse::<usize>().unwrap(),
        );
        Ok(Monkey {
            items,
            operator,
            operand,
            test_div,
            num_inspections: 0,
        })
    }
}

type Input = Vec<Monkey>;
type Answer = usize;

fn processed_input(input: &str) -> Input {
    input
        .split("\n\n")
        .map(|s| s.parse::<Monkey>().unwrap())
        .collect()
}

fn part1(input: &mut Input) -> Answer {
    for _round in 0..20 {
        for monkey_id in 0..input.len() {
            let monkey = &mut input[monkey_id];
            let items_goto = monkey.act(3);
            for (new_item, monkey_id) in items_goto {
                input[monkey_id].items.push(new_item);
            }
        }
    }

    let mut num_inspections = input
        .iter()
        .map(|m| m.num_inspections)
        .collect::<Vec<usize>>();
    num_inspections.sort();
    num_inspections.iter().rev().take(2).product()
}

fn part2(input: &mut Input) -> Answer {
    let monkey_cd = input.iter().map(|m| m.test_div.0).product::<i64>();
    for _round in 0..10000 {
        for monkey_id in 0..input.len() {
            let monkey = &mut input[monkey_id];
            let items_goto = monkey.act(1);
            for (new_item, monkey_id) in items_goto {
                let target_monkey = &mut input[monkey_id];
                target_monkey.items.push(new_item % monkey_cd);
            }
        }
    }

    let mut num_inspections = input
        .iter()
        .map(|m| m.num_inspections)
        .collect::<Vec<usize>>();
    println!("{:?}", num_inspections);
    num_inspections.sort();
    num_inspections.iter().rev().take(2).product()
}

fn main() {
    let input_text = common::day_input(11);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let mut input = processed_input(&input_text);
    let mut input2 = processed_input(&input_text);
    common::show_answers(&part1(&mut input), &part2(&mut input2))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Answer, Answer) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1";

    #[test]
    fn test() {
        let mut input = processed_input(TEST_INPUT);
        assert_eq!(part1(&mut input), 10605);
        let mut input = processed_input(TEST_INPUT);
        assert_eq!(part2(&mut input), 2713310158);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
