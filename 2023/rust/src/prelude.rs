pub use std::fs::File;
pub use std::io::Read;

use std::path::{Path, PathBuf};
use std::{env, io};

pub type Reader = Box<dyn Read>;

#[derive(Debug)]
enum InputFileError {
    VarError(env::VarError),
    IoError(io::Error),
}

/// Ensures that the input file exists
fn ensure_input_file(day: u8) -> Result<PathBuf, InputFileError> {
    let path = Path::new(&env::var("HOME").map_err(InputFileError::VarError)?)
        .join(format!("./.cache/aoc2023/{0}.input", day));
    if !path.exists() {
        eprintln!("Running input downloaded script with day arg {}...", day);
        std::process::Command::new("sh")
            .args(["../fetch-input.sh", &day.to_string()])
            .status()
            .map_err(InputFileError::IoError)?;
    }
    Ok(path)
}

/// Useful when you simply want the day's input as a String.
pub fn day_input(day: u8) -> String {
    let mut buffer = String::new();
    day_input_file(day)
        .read_to_string(&mut buffer)
        .expect(&format!("invalid utf8 input for day {}", day));
    buffer
}

/// Useful when you want the day's input for streaming for maximum performance nonsense
pub fn day_input_file(day: u8) -> File {
    let f = ensure_input_file(day).expect(&format!("Failed to ensure input for day {}", day));
    File::open(&f).expect(format!("Failed to open file {}", f.display()).as_str())
}

pub trait AoCSolution {
    type Input;
    type Solution: std::fmt::Debug + std::cmp::PartialEq + std::fmt::Display;

    // Are part1 and part2 solutions _always_ the same?
    fn part1(input: Self::Input) -> Self::Solution;
    fn part2(input: Self::Input) -> Self::Solution;

    fn show(i1: Self::Input, i2: Self::Input) {
        println!("Part 1: {}", Self::part1(i1));
        println!("Part 2: {}", Self::part2(i2));
    }
}

#[cfg(test)]
pub trait AoCSolutionTest: AoCSolution {
    const PART1_TEST_INPUT: Self::Input;
    const PART2_TEST_INPUT: Self::Input;
    const PART1_TEST_RESULT: Self::Solution;
    const PART2_TEST_RESULT: Self::Solution;

    fn assert_valid() {
        assert_eq!(Self::part1(Self::PART1_TEST_INPUT), Self::PART1_TEST_RESULT);
        assert_eq!(Self::part2(Self::PART2_TEST_INPUT), Self::PART2_TEST_RESULT);
    }
}
