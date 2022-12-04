use std::env::var as envvar;
use std::fmt::Debug;
use std::fs;
use std::path::Path;

pub fn day_input(day: u8) -> String {
    let home = &envvar("HOME").unwrap();
    let home_path = Path::new(home);
    let path_buf = home_path.join(format!("./.cache/aoc2022/{0}.input", day));
    let file_path = path_buf.to_str().unwrap();
    fs::read_to_string(file_path).unwrap()
}

pub fn show_answers(answer1: &impl Debug, answer2: &impl Debug) {
    println!("Part 1: {:?}", answer1);
    println!("Part 2: {:?}", answer2);
}
pub fn show_both_answers((a, b): &(impl Debug, impl Debug)) {
    show_answers(a, b)
}
