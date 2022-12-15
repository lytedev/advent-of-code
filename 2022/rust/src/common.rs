use std::env::var as envvar;
use std::fmt::Display;
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
pub fn show_answers(answer1: &impl Display, answer2: &impl Display) {
    println!("Part 1: {}", answer1);
    println!("Part 2: {}", answer2);
}

#[allow(dead_code)]
pub fn show_both_answers((a, b): &(impl Display, impl Display)) {
    show_answers(a, b)
}
