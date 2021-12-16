use std::env::var as envvar;
use std::path::Path;
use std::fs;

const ASCII_UPPER_A: u8 = 65;
const ASCII_LOWER_A: u8 = 97;
const ASCII_0: u8 = 48;

pub fn day_input(day: u8) -> String {
    let home = &envvar("HOME").unwrap();
    let home_path = Path::new(home);
    let path_buf = home_path.join(format!("./.cache/aoc2021/{0}.input", day));
    let file_path = path_buf.to_str().unwrap();
    fs::read_to_string(file_path).unwrap()
}

pub const fn hex_val(c: char) -> Result<u8, &'static str> {
    match c {
        'A'..='F' => Ok(c as u8 - ASCII_UPPER_A + 10),
        'a'..='f' => Ok(c as u8 - ASCII_LOWER_A + 10),
        '0'..='9' => Ok(c as u8 - ASCII_0 as u8),
        _ => Err("invalid hex char"),
    }
}

