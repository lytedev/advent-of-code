mod common;

use std::cell::RefCell;
use std::collections::HashMap;
use std::collections::HashSet;
use std::rc::Rc;

#[derive(Debug, Clone)]
struct DirTree {
    files: HashMap<String, usize>,
    subdirectories: HashMap<String, Rc<RefCell<Self>>>,
    parent: Option<Rc<RefCell<Self>>>,
}

impl DirTree {
    pub fn new(parent: Option<Rc<RefCell<Self>>>) -> Self {
        Self {
            files: HashMap::new(),
            subdirectories: HashMap::new(),
            parent,
        }
    }

    pub fn root() -> Self {
        Self::new(None)
    }
}

type Input = Rc<RefCell<DirTree>>;
type Result = usize;

fn processed_input(input: &str) -> Input {
    let root = Rc::new(RefCell::new(DirTree::root()));
    let mut current_dir = Rc::clone(&root);

    for l in input.lines() {
        println!("line: {}", l);
        if l == "$ cd /" {
            current_dir = Rc::clone(&root);
        } else if l == "$ ls" {
            continue;
        } else if l.starts_with("dir ") {
            let d = &l[4..];
            current_dir.borrow_mut().subdirectories.insert(
                d.to_string(),
                Rc::new(RefCell::new(DirTree::new(Some(Rc::clone(&current_dir))))),
            );
        } else if l.starts_with("$ cd ..") {
            let cur = Rc::clone(&current_dir);
            current_dir = Rc::clone(&cur.borrow().parent.as_ref().unwrap());
        } else if l.starts_with("$ cd ") {
            let d = &l[5..];
            let cur = Rc::clone(&current_dir);
            current_dir = Rc::clone(&cur.borrow().subdirectories.get(d).unwrap());
        } else {
            let mut args = l.split(' ');
            let size = args.next().unwrap().parse::<usize>().unwrap();
            current_dir
                .borrow_mut()
                .files
                .insert(args.next().unwrap().to_string(), size);
        }
    }
    return root;
}

const PART1_LIMIT: usize = 100_000;

fn dfs1(input: Input, path: String) -> usize {
    let dt = input.borrow();

    let files_size = dt.files.values().map(|r| r.to_owned()).sum::<usize>();
    let subdir_sizes: Vec<usize> = dt
        .subdirectories
        .iter()
        .map(|(p, sdt)| dfs1(sdt.clone(), format!("{}/{}", path, p)))
        .collect();
    let subdirs_size = subdir_sizes.iter().sum::<usize>();
    let this_dir_size = subdirs_size + files_size;

    let counted = subdir_sizes.iter().filter(|s| **s < PART1_LIMIT).sum();

    println!(
        "path: {}, files: {:?}, files_size: {}, subdirs_size: {}, counted: {}",
        path, dt.files, files_size, subdirs_size, counted
    );
    let mut r = counted;
    if this_dir_size < PART1_LIMIT {
        r = counted + this_dir_size;
    }
    println!(
        "return {}, {}",
        counted + this_dir_size,
        "hy" // std::backtrace::Backtrace::capture()
    );
    return r;
}

fn part1(input: &Input) -> Result {
    dfs1(input.clone(), "".to_string())
}

fn part2(input: &Input) -> Result {
    0
}

fn main() {
    let input_text = common::day_input(7);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(&input))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Result, Result) {
//     (0, 0)
// }

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
        assert_eq!(part1(&input), 95437);
        assert_eq!(part2(&input), 0);
        // assert_eq!(both_parts(&input), (0, 0));
    }

    const TEST_INPUT2: &str = "$ cd /
$ ls
dir a
100 x.txt
$ cd a
$ ls
dir b
100 y.txt
$ cd b
$ ls
100 z.txt";
    const TEST_INPUT3: &str = "$ cd /
$ ls
dir a
100 x.txt
$ cd a
$ ls
dir b
100 y.txt
$ cd b
$ ls
dir c
100 z.txt
$ cd c
$ ls
100 zz.txt";
    // $ cd a
    // $ ls
    // dir a
    // 100 c.txt
    // $ cd a
    // $ ls
    // 100 d.txt
    // ";

    #[test]
    fn test2() {
        let input = processed_input(TEST_INPUT2);
        assert_eq!(part1(&input), 600);
        let input3 = processed_input(TEST_INPUT2);
        assert_eq!(part1(&input), 1000);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
