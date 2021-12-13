import {
  collectArray,
  inputNumbers,
  measureDuration,
  preloadedAsyncIterator,
} from "./common.ts";

/** This solution is relatively simple. Keep track of the last depth we
 * measured in `lastDepth` (skipping the first line of input by defaulting it
 * to `Number.MAX_VALUE`) and compare it to each line of input as we read it.
 * Once we've compared, set the `lastDepth` to the current depth for the next
 * iteration.
 *
 * This solution should be O(n) for compute and O(n) for memory since we
 * iterate the input once and only read a line at a time, we actually have O(1)
 * memory, but since the input is on disk, that's kind of unfair to say.
 */
export async function part1(
  input: AsyncIterableIterator<number>,
): Promise<number> {
  let increases = 0;
  let lastDepth = Number.MAX_VALUE;
  for await (const depth of input) {
    if (depth > lastDepth) increases++;
    lastDepth = depth;
  }
  return increases;
}
const input1 = await inputNumbers("1");
await measureDuration(async () =>
  console.log("Part 1 Async Naive", await part1(input1))
);
const input1pre = await preloadedAsyncIterator(await inputNumbers("1"));
await measureDuration(async () =>
  console.log("Part 1 Preloaded", await part1(input1pre))
);
const input1pre2 = await preloadedAsyncIterator(await inputNumbers("1"));
await measureDuration(async () =>
  console.log("Part 1 via Part2's Method", await part2(input1pre2, 1))
);

const input1pre3 = await collectArray(await inputNumbers("1"));
const p1t = window.performance.now();
let answer = 0;
for (let i = 1; i <= input1pre3.length - 1; i++) {
  if (input1pre3[i] > input1pre3[i - 1]) answer++;
}
console.log("Part 1 Fast", answer);
const p1t2 = window.performance.now();
console.log(p1t2 - p1t, "ms");

/** Since the windows we need to compare overlap, we really only need to
 * compare the values unique to each window, which will be the first of the
 * first window and the last of the last window. Since the windows have size 3,
 * we really only need to compare a value with the "three-lines-ago" value.
 * This solution otherwise is identical to the previous one.
 */
export async function part2(
  input: AsyncIterableIterator<number>,
  windowSize = 3,
): Promise<number> {
  let increases = 0;
  const window: number[] = await Promise.all(Array.from(
    Array(windowSize),
    async (_x, _i) => parseInt((await input.next()).value),
  ));

  for await (const depth of input) {
    if (depth > (window.shift() as number)) increases++;
    window.push(depth);
  }
  return increases;
}
const input2 = await inputNumbers("1");
await measureDuration(async () => console.log("Part 2", await part2(input2)));

const input2f = await collectArray(await inputNumbers("1"));
const p2t = window.performance.now();
let answer2 = 0;
for (let i = 2; i <= input2f.length - 1; i++) {
  if (input2f[i] > input2f[i - 3]) answer2++;
}
console.log("Part 2 Fast", answer2);
const p2t2 = window.performance.now();
console.log(p2t2 - p2t, "ms");
