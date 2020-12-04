import streams, strutils, sets, sequtils, sugar, re, tables

proc matchingHeightRange(v: string): (int, int) =
  if v.endsWith("cm"): return (150, 193)
  elif v.endsWith("in"): return (59, 76)

proc isBetween(x: int, r: (int, int)): bool = x >= r[0] and x <= r[1]
proc validBirthYear(y: int): bool = y >= 1920 and y <= 2002
proc validIssuedYear(y: int): bool = y >= 2010 and y <= 2020
proc validExpiryYear(y: int): bool = y >= 2020 and y <= 2030

let nonDecimal = re"[^0-9]"
let hgt = re"\d+(cm|in)"
let hcl = re"#[0-9a-f]{6}"
let ecl = re"(amb|blu|brn|gry|grn|hzl|oth)"
let pid = re"^\d{9}$"

let validators = {
  "hgt": (v: string) =>
    v.match(hgt) and
      v.replace(nonDecimal).parseInt().isBetween(v.matchingHeightRange),
  "hcl": (v: string) => v.match hcl,
  "ecl": (v: string) => v.match ecl,
  "pid": (v: string) => v.match pid,
  "byr": (v: string) => validBirthYear parseInt v,
  "iyr": (v: string) => validIssuedYear parseInt v,
  "eyr": (v: string) => validExpiryYear parseInt v,
  "cid": (v: string) => true,
}.toTable

proc passportTable(passport: string): Table[string, string] =
  passport.split(' ').filterIt(it != "").mapIt(it.split(':', 2)).mapIt((it[0], it[1])).toTable

iterator asPassports(s: Stream): Table[string, string] =
  var p = ""
  for l in s.lines:
    p &= l & " "
    if l == "" or s.atEnd:
      yield p.passportTable
      p = ""

proc hasRequiredFields(p: Table[string, string]): bool =
  let optionalFields = ["cid"].toHashSet()
  toSeq(p.keys).toHashSet.difference(optionalFields) ==
    toSeq(validators.keys).toHashSet.difference(optionalFields)

proc isValid(p: Table[string, string]): bool =
  toSeq(p.pairs).mapIt(validators[it[0]](it[1])).foldl(a and b)

proc part1*(s: Stream): int =
  toSeq(s.asPassports).filterIt(it.hasRequiredFields).len

proc part2*(s: Stream): int =
  toSeq(s.asPassports).filterIt(it.hasRequiredFields and it.isValid).len
