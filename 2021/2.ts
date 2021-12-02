import { collectArray, inputLines, measureDuration } from "./common.ts";
const input = await collectArray(await inputLines("2"));

export function part1(input: string[]): number {
  let x = 0;
  let y = 0;
  for (const line of input) {
    console.log(line);
    if (line.startsWith("forward ")) {
      x += parseInt(line.substr(8));
    } else if (line.startsWith("up ")) {
      y -= parseInt(line.substr(3));
    } else if (line.startsWith("down ")) {
      y += parseInt(line.substr(5));
    }
  }
  return x * y;
}

await measureDuration(() => console.log("Part 1", part1(input)));

export function part2(input: string[]): number {
  return 0;
}

await measureDuration(() => console.log("Part 2", part2(input)));
