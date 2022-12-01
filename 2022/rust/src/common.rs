use std::env::var as envvar;
use std::fs;
use std::path::Path;

pub fn day_input(day: u8) -> String {
    let home = &envvar("HOME").unwrap();
    let home_path = Path::new(home);
    let path_buf = home_path.join(format!("./.cache/aoc2022/{0}.input", day));
    let file_path = path_buf.to_str().unwrap();
    fs::read_to_string(file_path).unwrap()
}
