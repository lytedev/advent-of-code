import { assertEquals } from "https://deno.land/std@0.116.0/testing/asserts.ts";
import { part1, part2 } from "./3.ts";

const testInput = `00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010`.trim().split("\n").map((s) => s.trim());

Deno.test("day 3 part 1", async () => {
  assertEquals(await part1(testInput), 198);
});

Deno.test("day 3 part 2", async () => {
  assertEquals(await part2(testInput), 230);
});
