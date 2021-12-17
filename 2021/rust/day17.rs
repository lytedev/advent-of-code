#![warn(clippy::all, clippy::pedantic)]

mod common;
use common::day_input;

#[derive(Debug)]
struct Vec2 { x: i64, y: i64 }
#[derive(Debug)]
struct Rect { top_left: Vec2, bottom_right: Vec2 }

fn parse_target_rect(s: &str) -> Rect {
    let mut nums: Vec<Vec<i64>> =
        s
        .split(": ")
        .nth(1).unwrap()
        .split(", ")
        .take(2)
        .map(|s| s.split("=")
            .nth(1).unwrap()
            .split("..")
            .map(|s2| {
                println!("Parsing Int: {}", s2);
                s2.parse::<i64>().unwrap()
            })
            .take(2)
            .collect()
        ).collect();
    let mut xr: Vec<i64> = nums.remove(0);
    let mut yr: Vec<i64> = nums.remove(0);
    xr.sort();
    yr.sort();
    Rect { top_left: Vec2 { x: xr[0], y: yr[1] }, bottom_right: Vec2 { x: xr[1], y: yr[0] } }
}

fn simulate_shot(initial_vel: Vec2, target: &Rect) -> Result<(Vec2, i64), (Vec2, Vec2)> {
    let mut vel = Vec2 { x: initial_vel.x, y: initial_vel.y };
    let mut last_pos = Vec2 { x: 0, y: 0 };
    let mut x: i64 = 0;
    let mut y: i64 = 0;
    let mut highest_y = y;
    while x <= target.bottom_right.x && y >= target.bottom_right.y {
        // println!("At {}, {} (lim: {}->{}, {}->{})", x, y, target.top_left.x, target.bottom_right.x, target.top_left.y, target.bottom_right.y);
        if x >= target.top_left.x && y <= target.top_left.y && x <= target.bottom_right.x && y >= target.bottom_right.y {
            // println!("Ding!: {}, {} (lim: {}->{}, {}->{})", x, y, target.top_left.x, target.bottom_right.x, target.top_left.y, target.bottom_right.y);
            return Ok((Vec2 { x, y }, highest_y));
        }
        last_pos = Vec2 { x, y };
        x += vel.x;
        y += vel.y;
        if vel.x != 0 {
            if vel.x > 0 { vel.x -= 1; }
            else { vel.x += 1; }
        }
        if y > highest_y { highest_y = y; }
        vel.y -= 1
    }
    // println!("Too Far: {}, {} (lim: {}->{}, {}->{})", x, y, target.top_left.x, target.bottom_right.x, target.top_left.y, target.bottom_right.y);
    Err((Vec2 { x, y }, last_pos))
}

fn trick_shot(r: &Rect) -> Option<i64> {
    let mut result = None;
    for x in 1..=r.top_left.x {
        for y in r.bottom_right.y..=2000 {
            println!("Simulating {}, {}", x, y);
            if let Ok((v, hy)) = simulate_shot(Vec2 { x, y }, r) {
                if result.is_some() {
                    if hy > result.unwrap() { result = Some(hy); }
                } else {
                    println!("!! New Highest Y: {} via {}, {}", hy, x, y);
                    result = Some(hy);
                }
            }
        }
    }
    result
}

fn main() {
    let r = parse_target_rect(&day_input(17).trim());
    println!("Trick Shot Apex: {}", trick_shot(&r).unwrap());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn packet_op_result_examples() {
        let tester = |s: &str| trick_shot(&parse_target_rect(s));
        assert_eq!(tester("target area: x=20..30, y=-10..-5").unwrap(), 45);
    }
}
