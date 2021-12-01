import { inputNumbers } from "./common.ts";

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
console.log("Part 1", await part1(await inputNumbers("1")));

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
  // TODO: use a proper FIFO queue data structure for this?
  let window: number[] = await Promise.all(Array.from(
    Array(windowSize),
    async (_x, _i) => parseInt((await input.next()).value),
  ));

  for await (const depth of input) {
    if (depth > window[0]) increases++;
    // TODO: if this was a proper queue, we could just push it on the queue and
    // expect the first-in value to fall out
    window = window.slice(1);
    window.push(depth);
  }
  return increases;
}
console.log("Part 2", await part2(await inputNumbers("1")));
