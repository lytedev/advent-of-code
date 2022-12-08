mod common;

use std::{collections::HashMap, num::Wrapping};

type Result = Wrapping<usize>;
type Input = HashMap<String, Result>;

fn processed_input(input: &str) -> Input {
    let mut result: Input = HashMap::from([("/".to_string(), Wrapping(0))]);
    let mut current_path = vec![];

    let vp = |v: &[&str]| format!("/{}", v.join("/"));

    for l in input.lines() {
        println!("line: {}", l);
        if l == "$ cd /" {
            println!("cwd '/'");
            current_path.clear();
        } else if l == "$ ls" {
            continue;
        } else if l.starts_with("dir ") {
            current_path.push(&l[4..]);
            let p = vp(&current_path);
            println!("inserting path '{}'", p);
            current_path.pop();
            result.insert(p, Wrapping(0));
        } else if l.starts_with("$ cd ..") {
            current_path.pop();
            println!("cwd '{}'", vp(&current_path));
        } else if l.starts_with("$ cd ") {
            current_path.push(&l[5..]);
            println!("cwd '{}'", vp(&current_path));
        } else {
            let size = l.split(' ').next().unwrap().parse::<usize>().unwrap();
            for i in (0..=current_path.len()).rev() {
                let p = vp(&current_path[0..i]);
                println!("adding {} to path '{}'", size, p);
                *(result.get_mut(&p).unwrap()) += size;
            }
        }
    }

    return result;
}

const PART1_LIMIT: usize = 100_000;

fn part1(input: &Input) -> Result {
    let lim = Wrapping(PART1_LIMIT);
    input.values().filter(|s| **s < lim).sum()
}

fn part2(input: &Input) -> Result {
    let to_free = input.get("/").unwrap() - Wrapping(40_000_000);
    *input
        .values()
        .min_by(|a, b| (**a - to_free).cmp(&(**b - to_free)))
        .unwrap()
}

fn main() {
    let input_text = common::day_input(7);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), Wrapping(95437));
        assert_eq!(part2(&input), Wrapping(24933642));
    }
}
