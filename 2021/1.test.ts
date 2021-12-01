import { assertEquals } from "https://deno.land/std@0.116.0/testing/asserts.ts";
import { asyncIterator } from "./common.ts";
import { part1, part2 } from "./1.ts";

const testInput = [
  199,
  200,
  208,
  210,
  200,
  207,
  240,
  269,
  260,
  263,
];

Deno.test("day 1 part 1", async () => {
  assertEquals(await part1(asyncIterator(testInput)), 7);
});

Deno.test("day 1 part 2", async () => {
  assertEquals(await part2(asyncIterator(testInput)), 5);
});
