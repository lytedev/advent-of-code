use std::env::var as envvar;
use std::fmt::Debug;
use std::fs;
use std::path::Path;

pub fn day_input(day: u8) -> String {
    let home = &envvar("HOME").unwrap();
    let home_path = Path::new(home);
    let path_buf = home_path.join(format!("./.cache/aoc2022/{0}.input", day));
    let file_path = path_buf.to_str().unwrap();
    if !path_buf.exists() {
        eprintln!("Running input downloaded script with day arg {}...", day);
        std::process::Command::new("sh")
            .arg("./fetch_input.sh")
            .arg(format!("{}", day))
            .status()
            .expect("fetch_input.sh failed");
    }
    fs::read_to_string(file_path).unwrap()
}

#[allow(dead_code)]
pub fn show_answers(answer1: &impl Debug, answer2: &impl Debug) {
    println!("Part 1: {:?}", answer1);
    println!("Part 2: {:?}", answer2);
}

#[allow(dead_code)]
pub fn show_both_answers((a, b): &(impl Debug, impl Debug)) {
    show_answers(a, b)
}
