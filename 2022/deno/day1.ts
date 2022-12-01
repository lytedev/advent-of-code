import { inputLinesArray } from "./common.ts";

function orderedCalories(lines: string[]) {
  const calories: number[] = [0];

  lines.forEach((line) => {
    if (line.trim() == "") {
      calories.splice(0, 0, 0);
    } else {
      calories[0] += parseInt(line);
    }
  });
  calories.sort((a, b) => b - a);
  return calories;
}

const calories = orderedCalories(await inputLinesArray(1));
console.log("Part 1:", calories[0]);
console.log("Part 2:", calories.slice(0, 3).reduce((a, b) => a + b));

const TEST_INPUT = `1000
2000
3000

4000

5000
6000

7000
8000
9000

10000`.split("\n");

Deno.test("orderedCalories", async (t) => {
  const { assertEquals } = await import(
    "https://deno.land/std@0.167.0/testing/asserts.ts"
  );

  const calories = orderedCalories(TEST_INPUT);
  await t.step("part 1", () => assertEquals(calories[0], 24000));
  await t.step(
    "part 2",
    () => assertEquals(calories.slice(0, 3).reduce((a, b) => a + b), 45000),
  );
});
