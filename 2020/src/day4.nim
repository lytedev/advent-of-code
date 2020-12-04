import streams, strutils, sets, sequtils, sugar, re, tables

let validators = toTable({
  "hcl": (v: string) => v.match re"^#[0-9a-f]{6}$",
  "ecl": (v: string) => v.match re"^(amb|blu|brn|gry|grn|hzl|oth)$",
  "pid": (v: string) => v.match re"^\d{9}$",
  "byr": (v: string) => parseInt(v) in 1920..2002,
  "iyr": (v: string) => parseInt(v) in 2010..2020,
  "eyr": (v: string) => parseInt(v) in 2020..2030,
  "hgt": proc (v: string): bool =
    let (mn, mx) = if v.endsWith("cm"): (150, 193) else: (59, 76)
    v.match(re"^\d+(cm|in)$") and v.replace(re"[^0-9]").parseInt in mn..mx,
  "cid": (v: string) => true,
})

proc parsePassports(s: Stream): seq[Table[string, string]] =
  s.readAll().split("\n\n").mapIt(it.replace("\n", " ").split(' ')
    .filterIt(it != "").mapIt(it.split(':', 2)).mapIt((it[0], it[1])).toTable)

proc hasRequiredFields(p: Table[string, string]): bool =
  toSeq(validators.keys).toHashSet.difference(["cid"].toHashSet) <= toSeq(p.keys).toHashSet

proc part1*(s: Stream): int =
  s.parsePassports.countIt(it.hasRequiredFields)

proc part2*(s: Stream): int =
  s.parsePassports.countIt(it.hasRequiredFields and toSeq(it.pairs).allIt(validators[it[0]](it[1])))
