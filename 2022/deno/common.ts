import { copy } from "https://deno.land/std@0.167.0/streams/copy.ts";
import * as path from "https://deno.land/std@0.167.0/path/mod.ts";
import { readLines } from "https://deno.land/std@0.167.0/io/buffer.ts";
import { readerFromStreamReader } from "https://deno.land/std@0.167.0/streams/reader_from_stream_reader.ts";

const YEAR: number = parseInt(Deno.env.get("AOC_YEAR") || "2022");
const HOME = Deno.env.get("HOME");
if (!HOME) throw new Error("HOME not set");
const COOKIE_PATH = path.resolve(`${HOME}/.advent-of-code-session-cookie`);
const CACHE_DIR = path.resolve(`${HOME}/.cache/aoc${YEAR}`);

async function loadSessionCookie() {
  const td = new TextDecoder();
  const bytes = await Deno.readFile(COOKIE_PATH);
  return td.decode(bytes);
}

function inputFilePath(day: number): string {
  return path.resolve(path.join(CACHE_DIR, `${day}.input`));
}

async function fetchAndCacheInput(day: number): Promise<void> {
  const req = new Request(`https://adventofcode.com/${YEAR}/day/${day}/input`);
  req.headers.set("Cookie", await loadSessionCookie());
  const resp = await fetch(req);
  const f = await Deno.open(inputFilePath(day), { write: true });
  if (!resp.body) {
    throw new Error("Response had empty body");
  }
  await copy(readerFromStreamReader(resp.body.getReader()), f);
}

export async function inputLines(
  day: number,
  fetched = false,
): Promise<AsyncIterableIterator<string>> {
  try {
    return readLines(await Deno.open(inputFilePath(day), { read: true }));
  } catch (e) {
    if (!fetched) {
      await fetchAndCacheInput(day);
      return await inputLines(day, true);
    } else {
      throw e;
    }
  }
}

export async function inputLinesArray(day: number) {
  const lines = [];
  for await (const l of await inputLines(day)) {
    lines.push(l);
  }
  return lines;
}
