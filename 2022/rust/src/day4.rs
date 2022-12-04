mod common;

fn main() {
    let input = common::day_input(4);
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}

fn part1(input: &str) -> i32 {
    let mut r = 0;
    for l in input.lines() {
        let mut c = l.split(",");
        let p1 = c.next().unwrap();
        let p2 = c.next().unwrap();
        let mut p1c = p1.split("-");
        let p1n1 = p1c.next().unwrap().parse::<i32>().unwrap();
        let p1n2 = p1c.next().unwrap().parse::<i32>().unwrap();
        let mut p2c = p2.split("-");
        let p2n1 = p2c.next().unwrap().parse::<i32>().unwrap();
        let p2n2 = p2c.next().unwrap().parse::<i32>().unwrap();

        if (p1n1 <= p2n1 && p1n2 >= p2n2) || (p2n1 <= p1n1 && p2n2 >= p1n2) {
            r += 1
        }
    }
    r
}

fn part2(input: &str) -> i32 {
    let mut r = 0;
    for l in input.lines() {
        println!("{}", l);
        let mut c = l.split(",");
        let p1 = c.next().unwrap();
        let p2 = c.next().unwrap();
        let mut p1c = p1.split("-");
        let x1 = p1c.next().unwrap().parse::<i32>().unwrap();
        let x2 = p1c.next().unwrap().parse::<i32>().unwrap();
        let mut p2c = p2.split("-");
        let y1 = p2c.next().unwrap().parse::<i32>().unwrap();
        let y2 = p2c.next().unwrap().parse::<i32>().unwrap();

        println!("{}-{} , {}-{}", x1, x2, y1, y2);
        if x1 <= y2 && y1 <= x2 {
            r += 1;
            println!("overlap");
        }
    }
    r
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8";

    #[test]
    fn test_part1() {
        assert_eq!(part1(TEST_INPUT), 2)
    }

    #[test]
    fn test_part2() {
        assert_eq!(part2(TEST_INPUT), 4)
    }
}
