mod common;

use std::cell::RefCell;
use std::collections::HashMap;
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

    pub fn size(&self) -> usize {
        self.files.values().sum::<usize>()
            + self
                .subdirectories
                .values()
                .map(|v| v.borrow().size())
                .sum::<usize>()
    }
}

struct DirTreeIterator {
    dir_tree: Rc<RefCell<DirTree>>,
}

impl IntoIterator for DirTree {
    type Item = Rc<RefCell<DirTree>>;
    type IntoIter = std::iter::Chain<
        std::iter::Once<Rc<RefCell<DirTree>>>,
        std::collections::hash_map::Values<String, Rc<RefCell<DirTree>>>,
    >;

    fn into_iter(&self) -> Self::IntoIter {
        std::iter::once(Rc::new(RefCell::new(*self)))
            .into_iter()
            .chain(self.subdirectories.values().into_iter())
    }
}

type Input = Rc<RefCell<DirTree>>;
type Result = usize;

fn processed_input(input: &str) -> Input {
    let root = Rc::new(RefCell::new(DirTree::root()));
    let mut current_dir = Rc::clone(&root);
    for l in input.lines() {
        println!("{}", l);
        if l == "$ cd /" {
            current_dir = Rc::clone(&root);
        } else if l == "$ ls" {
            continue;
        } else if l.starts_with("dir ") {
            current_dir.borrow_mut().subdirectories.insert(
                l[4..].to_string(),
                Rc::new(RefCell::new(DirTree::new(Some(Rc::clone(&current_dir))))),
            );
        } else if l.starts_with("$ cd ..") {
            let cur = Rc::clone(&current_dir);
            current_dir = Rc::clone(&cur.borrow().parent.as_ref().unwrap());
        } else if l.starts_with("$ cd ") {
            let cur = Rc::clone(&current_dir);
            current_dir = Rc::clone(&cur.borrow().subdirectories.get(&l[5..]).unwrap());
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

fn part1(input: &Input) -> Result {
    100
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
}
