import { collectArray, inputLines, measureDuration } from "./common.ts";
const input = await collectArray(await inputLines("3"));

type SubmarineCommand = ["forward", number] | ["up", number] | ["down", number];

const ASCII_ZERO = "0".charCodeAt(0);
export function part1(input: string[]): number {
  const width = input[0].length;
  const counter = Array.from(Array(width), (_) => [0, 0]);
  for (const l of input) {
    for (let i = 0; i < width; i++) {
      const val = l.charCodeAt(i) - ASCII_ZERO;
      counter[i][val]++;
    }
  }
  let ones = 0;
  for (let i = 0; i < width; i++) {
    if (counter[i][1] >= counter[i][0]) ones++;
    ones = ones << 1;
  }
  ones = ones >> 1;
  const zeroes = ones ^ (Math.pow(2, width) - 1); // xor with a mask the same size as the width
  return ones * zeroes;
}

await measureDuration(() => console.log("Part 1", part1(input)));

export function part2(input: string[]): number {
  return 0;
}

await measureDuration(() => console.log("Part 2", part2(input)));
