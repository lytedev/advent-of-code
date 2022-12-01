const tDec = new TextDecoder();
const input = tDec.decode(Deno.readFileSync("../inputs/day1.input"));

console.log(
  "final",
  input.split("\n\n").map((p) => {
    const ns = p.split("\n").map((s) => {
      const n = parseInt(s, 10);
      console.log("inner", s, n);
      return n;
    }).filter((n) => !isNaN(n));
    if (ns.length < 1) return NaN;
    const n = ns.reduce((prev, cur) => prev + cur, 0);
    console.log("oter", p, n, ns);
    return n;
  }).filter((n) => !isNaN(n)).sort().reverse(),
);

console.log(71924 + 69893 + 68589);
