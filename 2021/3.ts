import { collectArray, inputLines, measureDuration } from "./common.ts";
const input = await collectArray(await inputLines("3"));

type SubmarineCommand = ["forward", number] | ["up", number] | ["down", number];

type Counters = [zeroCount: number, oneCount: number][];

const ASCII_ZERO = "0".charCodeAt(0);

function countBits(
  input: string[],
  width?: number,
  windowWidth?: number,
): Counters {
  if (!width) width = input[0].length;
  if (!windowWidth) windowWidth = width;
  const counter: Counters = Array.from(Array(width), (_) => [0, 0]);
  for (const l of input) {
    for (let i = width - windowWidth; i < width; i++) {
      const val = l.charCodeAt(i) - ASCII_ZERO;
      counter[i][val]++;
    }
  }
  return counter;
}

export function part1(input: string[]): number {
  const width = input[0].length;
  const counter = countBits(input);
  const ones = [...Array(width).keys()].reduce((acc, i) =>
    acc += (counter[i][1] >= counter[i][0]) ? (1 << i) : 0
  );
  // xor with a mask the same size as the width to get the zeroes value
  console.log("oz:", ones);
  return ones * (ones ^ (Math.pow(2, width) - 1));
}

await measureDuration(() => console.log("Part 1", part1(input)));

export function part2(input: string[]): number {
  // I hate this.
  const width = input[0].length;
  const counter = Array.from(Array(width), (_) => [0, 0]);
  for (const l of input) {
    for (let i = 0; i < width; i++) {
      const val = l.charCodeAt(i) - ASCII_ZERO;
      counter[i][val]++;
    }
  }
  let oxyGenRating = null;
  let coScrubRating = null;
  let oxyGenCandidates = input.slice(0);
  let coScrubCandidates = input.slice(0);
  for (let i = 0; i < width; i++) {
    const newOxyGenCandidates: string[] = [];
    const newCoScrubCandidates: string[] = [];
    // console.log(counter[i]);
    const moreCommon = (counter[i][1] > counter[i][0] ? 1 : 0).toString();
    // console.log(i, width, moreCommon);
    if (!oxyGenRating) {
      for (const binnum of oxyGenCandidates) {
        if (binnum[i] == moreCommon) newOxyGenCandidates.push(binnum);
      }
      if (newOxyGenCandidates.length == 1) {
        oxyGenRating = parseInt(newOxyGenCandidates[0], 2);
        /*
        console.log(
          "Oxygen Generator Rating:",
          oxyGenRating,
          oxyGenCandidates,
          newOxyGenCandidates,
        );
        */
      } else oxyGenCandidates = newOxyGenCandidates;
      // console.log(oxyGenCandidates);
    }
    if (!coScrubRating) {
      for (const binnum of coScrubCandidates) {
        if (binnum[i] != moreCommon) newCoScrubCandidates.push(binnum);
      }
      if (newCoScrubCandidates.length == 1) {
        coScrubRating = parseInt(newCoScrubCandidates[0], 2);
        /*
        console.log(
          "CO2 Scrubber Rating:",
          coScrubRating,
          coScrubCandidates,
          newCoScrubCandidates,
        );
        */
      } else coScrubCandidates = newCoScrubCandidates;
      // console.log(coScrubCandidates);
    }
  }
  return (oxyGenRating || 0) * (coScrubRating || 0);
}

// await measureDuration(() => console.log("Part 2", part2(input)));
