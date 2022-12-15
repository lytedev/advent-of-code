mod common;

#[derive(Debug)]
enum Instruction {
    AddX(i32),
    Noop,
}

type Input = Vec<Instruction>;
type Answer1 = i32;
type Answer2 = String;

fn processed_input(input: &str) -> Input {
    input
        .lines()
        .map(|l| match l {
            "noop" => Instruction::Noop,
            l => Instruction::AddX(l[5..].parse::<i32>().unwrap()),
        })
        .collect()
}

fn part1(input: &Input) -> Answer1 {
    let mut sum_checkpoints = 0_i32;
    let mut checkpoints = vec![20, 60, 100, 140, 180, 220];
    checkpoints.reverse();
    let mut x = 1;
    let mut cycles = 0;
    for i in input {
        println!("{:?}", i);
        let now_x = x.clone();
        cycles += match i {
            Instruction::Noop => 1,
            Instruction::AddX(n) => {
                x += n;
                2
            }
        };
        if cycles >= *checkpoints.last().unwrap() {
            let checkpoint = checkpoints.pop().unwrap();
            println!("{}: {}", checkpoint, now_x * checkpoint);
            sum_checkpoints += now_x * checkpoint;
            if checkpoints.len() <= 0 {
                break;
            }
        }
    }

    sum_checkpoints
}

fn part2(input: &Input) -> Answer2 {
    let w = 40;
    let mut crt = String::new();
    let mut x = 1;
    let mut draw_pixel = |now_x| {
        let mut pixel = ' ';
        if ((crt.len() % w) as i32).abs_diff(now_x) <= 1 {
            pixel = '#';
        }
        crt.push(pixel);
    };
    for i in input {
        println!("{:?}", i);
        let now_x = x.clone();
        match i {
            Instruction::Noop => draw_pixel(now_x),
            Instruction::AddX(n) => {
                draw_pixel(now_x);
                draw_pixel(now_x);
                x += n;
            }
        };
    }

    crt.chars()
        .enumerate()
        .flat_map(|(i, c)| {
            if i % w == 0 { Some('\n') } else { None }
                .into_iter()
                .chain(std::iter::once(c))
        })
        .collect::<String>()
}

fn main() {
    let input_text = common::day_input(10);
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

    const TEST_INPUT: &str = "addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 13140);
        assert_eq!(
            part2(&input),
            "\n##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."
                .replace('.', " ")
        );
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
