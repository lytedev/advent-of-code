use std::collections::HashMap;
use std::collections::HashSet;

mod common;

struct Input {
    map: Vec<Vec<u8>>,
    start: (usize, usize),
    end: (usize, usize),
}

type Answer = usize;

impl Input {
    fn shortest_path_length(&self, s: Option<(usize, usize)>) -> usize {
        let s = s.unwrap_or(self.start);
        let mut open_set = HashSet::<(usize, usize)>::from([s]);
        let mut came_from = HashMap::<(usize, usize), (usize, usize)>::new();
        let mut cheapest_for = HashMap::<(usize, usize), i64>::from([(s, 0)]);
        let mut guess_score = HashMap::<(usize, usize), i64>::from([(s, 0)]);

        let h = self.map.len();
        let w = self.map[0].len();

        // guess_score.get(&(y, x)).unwrap_or(&i64::MAX).clone()
        while open_set.len() > 0 {
            let (mut y, mut x) = open_set
                .iter()
                .min_by(|(y1, x1), (y2, x2)| {
                    guess_score
                        .get(&(*y1, *x1))
                        .unwrap_or(&i64::MAX)
                        .cmp(&guess_score.get(&(*y2, *x2)).unwrap_or(&i64::MAX))
                })
                .unwrap();

            if (y, x) == self.end {
                let mut n = 0;
                while let Some((ny, nx)) = came_from.get(&(y, x)) {
                    y = *ny;
                    x = *nx;
                    n += 1;
                }
                return n;
            }

            open_set.remove(&(y, x));
            let c = self.map[y][x];
            let mut potential_neighbors = vec![];
            if y > 0 {
                potential_neighbors.push((y - 1, x));
            }
            if y < h - 1 {
                potential_neighbors.push((y + 1, x));
            }
            if x > 0 {
                potential_neighbors.push((y, x - 1));
            }
            if x < w - 1 {
                potential_neighbors.push((y, x + 1));
            }
            for (ny, nx) in potential_neighbors
                .iter()
                .filter(|(y, x)| (self.map[*y][*x] as i32) - (c as i32) <= 1)
            {
                let ny = ny.clone();
                let nx = nx.clone();
                let score = guess_score.get(&(y, x)).unwrap_or(&i64::MAX).clone() + 1;
                let ns = guess_score.get(&(ny, nx)).unwrap_or(&i64::MAX).clone();
                if score < ns {
                    came_from.insert((ny, nx), (y, x));
                    guess_score.insert((ny, nx), score);
                    cheapest_for.insert((ny, nx), score + 1);
                    open_set.insert((ny, nx));
                }
            }
        }

        let mut distances: Vec<Vec<usize>> = vec![];
        let mut previous_bests: Vec<Vec<Option<(usize, usize)>>> = vec![];
        for y in 0..self.map.len() {
            let mut row_distances = vec![];
            let mut row_previous_bests = vec![];
            for _ in 0..self.map[y].len() {
                row_distances.push(std::usize::MAX);
                row_previous_bests.push(None);
            }
            distances.push(row_distances);
            previous_bests.push(row_previous_bests);
        }
        distances[s.0][s.1] = 0;

        // no path found
        usize::MAX
    }
}

fn processed_input(input: &str) -> Input {
    let mut map = vec![];
    let mut start = (0, 0);
    let mut end = (0, 0);
    let lines = input
        .lines()
        .map(|l| l.to_string())
        .collect::<Vec<String>>();
    for y in 0..lines.len() {
        let mut row = vec![];
        let chars = lines[y].chars().collect::<Vec<char>>();
        for x in 0..chars.len() {
            match chars[x] {
                'S' => {
                    row.push(0);
                    start = (y, x);
                }
                'E' => {
                    row.push(25);
                    end = (y, x);
                }
                c => row.push(c as u8 - 'a' as u8),
            }
        }
        map.push(row)
    }
    return Input { map, start, end };
}

fn part1(input: &Input) -> Answer {
    input.shortest_path_length(None)
}

fn part2(input: Input) -> Answer {
    let mut possible_starts = HashSet::<(usize, usize)>::from([input.start]);
    for y in 0..input.map.len() {
        for x in 0..input.map[y].len() {
            if input.map[y][x] == 0 {
                // TODO: if you care in the future, this can be modified so we
                // re-use our scoring graphs to find the shortest path from the end to some a
                possible_starts.insert((y, x));
            }
        }
    }

    possible_starts
        .iter()
        .map(|s| input.shortest_path_length(Some(*s)))
        .min()
        .unwrap()
}

fn main() {
    let input_text = common::day_input(12);
    eprintln!("{}\n\nAbove is your input file.\n\n", input_text);
    let input = processed_input(&input_text);
    common::show_answers(&part1(&input), &part2(input))
    // common::show_both_answers(&both_parts(&input))
}

// fn both_parts(input: &Input) -> (Answer, Answer) {
//     (0, 0)
// }

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_INPUT: &str = "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi";

    #[test]
    fn test() {
        let input = processed_input(TEST_INPUT);
        assert_eq!(part1(&input), 31);
        assert_eq!(part2(input), 29);
        // assert_eq!(both_parts(&input), (0, 0));
    }
}
