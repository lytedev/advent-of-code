import { readLines } from "./deps.ts";

// Day 1
/*
 * This solution is relatively simple. Keep track of the last depth we measured
 * in `lastDepth` (skipping the first line of input by defaulting it to
 * `Number.MAX_VALUE`) and compare it to each line of input as we read it. Once
 * we've compared, set the `lastDepth` to the current depth for the next
 * iteration.
 *
 * This solution should be O(n) for compute and O(n) for memory since we
 * iterate the input once and only read a line at a time, we actually have O(1)
 * memory, but since the input is on disk, that's kind of unfair to say.
 */
let part1Increases = 0;
let lastDepth = Number.MAX_VALUE;
for await (const depthString of readLines(await Deno.open("1.input"))) {
  const depth = parseInt(depthString);
  if (depth > lastDepth) part1Increases++;
  lastDepth = depth;
}
console.log("Number of depth increases (Part 1):", part1Increases);

// Day 2
/*
 * Since the windows we need to compare overlap, we really only need to compare
 * the values unique to each window, which will be the first of the first window
 * and the last of the last window. Since the windows have size 3, we really
 * only need to compare a value with the "three-lines-ago" value. This solution
 * otherwise is identical to the previous one.
 */
let part2Increases = 0;
const WINDOW_SIZE = 3;
const input = readLines(await Deno.open("1.input"));

// TODO: use a proper FIFO queue data structure for this?
// read the first `WINDOW_SIZE` values from our input in preparation
let window: number[] = await Promise.all(Array.from(
  Array(WINDOW_SIZE),
  async (_x, _i) => parseInt((await input.next()).value),
));

for await (const depthString of input) {
  const depth = parseInt(depthString);
  // compare the current depth to the depth we read `WINDOW_SIZE` ago
  if (depth > window[0]) part2Increases++;
  // now we push the current depth onto the window and cut the one we just compared off
  // TODO: if this was a proper queue, we could just push it on the queue and
  // expect the first-in value to fall out
  window = window.slice(1);
  window.push(depth);
}
console.log("Number of summed depth increases (Part 2):", part2Increases);
