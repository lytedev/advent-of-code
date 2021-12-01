import { readLines } from "./deps.ts";

// Day 1
let increases = 0;
let lastDepth = Number.MAX_VALUE;
for await (const depthString of readLines(await Deno.open("1.input"))) {
  const depth = parseInt(depthString);
  if (depth > lastDepth) increases++;
  lastDepth = depth;
}
console.log("Number of depth increases:", increases);
