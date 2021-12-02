import { collectArray, inputLines, measureDuration } from "./common.ts";
const input = await collectArray(await inputLines("2"));

type SubmarineCommand = ["forward", number] | ["up", number] | ["down", number];

// function parseSubmarineCommand(command: string): SubmarineCommand {
//   let [cmd, arg] = command.split(" ", 2);
//   cmd = ["forward", "up", "down"].includes(cmd) ? cmd : "up";
//   return [cmd, parseInt(arg)];
// }

export function part1(input: string[]): number {
  let x = 0;
  let y = 0;
  for (const line of input) {
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
  let x = 0;
  let y = 0;
  let aim = 0;
  for (const line of input) {
    if (line.startsWith("forward ")) {
      const arg = parseInt(line.substr(8));
      x += arg;
      y += aim * arg;
    } else if (line.startsWith("up ")) {
      const arg = parseInt(line.substr(3));
      aim -= arg;
    } else if (line.startsWith("down ")) {
      const arg = parseInt(line.substr(5));
      aim += arg;
    }
  }
  return x * y;
}

await measureDuration(() => console.log("Part 2", part2(input)));
