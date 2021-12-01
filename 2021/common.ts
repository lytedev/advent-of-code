import { ensureDir, path, readAll, readLines } from "./deps.ts";

export const HOME = Deno.env.get("HOME") || "/tmp";
export const XDG_CACHE_HOME = Deno.env.get("XDG_CACHE_HOME") ||
  path.join(HOME, ".config");

const INPUT_CACHE_DIR = path.join(XDG_CACHE_HOME, "aoc2021");

async function fileExists(filePath: string) {
  try {
    await Deno.lstat(filePath);
    return true;
  } catch (e) {
    if (e instanceof Deno.errors.NotFound) {
      return false;
    }
    throw e;
  }
}

function inputFilePath(day: string) {
  return path.join(INPUT_CACHE_DIR, `${day}.input`);
}

async function ensureInput(day: string) {
  const filePath = inputFilePath(day);
  await ensureDir(INPUT_CACHE_DIR);
  if (await fileExists(filePath)) return;
  const cookieFile = path.join(HOME, ".advent-of-code-2021-auth-cookie");
  let cookie = "";
  try {
    cookie = Deno.env.get("ADVENT_OF_CODE_2021_AUTH_COOKIE") ||
      new TextDecoder().decode(
        await readAll(await Deno.open(cookieFile)),
      );
  } catch (e) {
    console.error(
      `Failed to load adventofcode.com cookie from ADVENT_OF_CODE_2021_AUTH_COOKIE environment variable or from file ${cookieFile}`,
    );
    throw e;
  }
  const url = `https://adventofcode.com/2021/day/${day}/input`;
  const response = await fetch(url, { headers: { cookie } });
  await Deno.writeTextFile(filePath, await response.text());
}

async function fileLines(
  filePath: string,
): Promise<AsyncIterableIterator<string>> {
  return readLines(await Deno.open(filePath));
}

export async function inputLines(
  day: string,
): Promise<AsyncIterableIterator<string>> {
  await ensureInput(day);
  return fileLines(inputFilePath(day));
}

async function* readStringsAsNumbers(
  input: AsyncIterableIterator<string>,
): AsyncIterableIterator<number> {
  for await (const s of input) {
    yield parseInt(s);
  }
}

export async function inputNumbers(
  day: string,
): Promise<AsyncIterableIterator<number>> {
  return readStringsAsNumbers(await inputLines(day));
}
