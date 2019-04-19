from algorithm import reverse
from sequtils import mapIt
from strutils import join

proc toBinSeq*(b: uint8): seq[uint8] =
  ## 2進数のビットをシーケンスに変換する
  ## 0b0000_1111 -> @[0'u8, 0, 0, 0, 1, 1, 1, 1]
  var c = b
  for i in 1..8:
    result.add uint8(c and 0b0000_0001)
    c = c shr 1
  result.reverse

proc toBinString*(data: openArray[uint8]): string =
  for b in data.mapIt(it.toBinSeq.mapIt(it.`$`[0].char)):
    for c in b:
      result.add c

proc toMatrixString*(data: openArray[uint8], col: int): string =
  var line: seq[string]
  var lines: seq[seq[string]]
  for i, c in data:
    line.add c.`$`
    if (i+1) mod col == 0:
      lines.add line
      line = @[]
  if 0 < line.len:
    lines.add line
  result = lines.mapIt(it.join(" ")).join("\n")

proc toMatrixString*(s: string, col: int): string =
  var line: seq[char]
  var lines: seq[seq[char]]
  for i, c in s:
    line.add c
    if (i+1) mod col == 0:
      lines.add line
      line = @[]
  if 0 < line.len:
    lines.add line
  result = lines.mapIt(it.join(" ")).join("\n")

proc toRGBMatrixString*(data: openArray[uint8], col: int): string =
  var line: seq[char]
  var lines: seq[seq[char]]
  for i, c in data:
    line.add c.`$`[0].char
    if (i+1) mod col == 0:
      lines.add line
      line = @[]
  if 0 < line.len:
    lines.add line
  result = lines.mapIt(it.join(" ")).join("\n")

proc toBin*(arr: openArray[uint8]): seq[uint8] =
  var data: uint8
  var i = 0
  for u in arr:
    data = data shl 1
    data += u
    i.inc
    if i mod 8 == 0:
      result.add data
      data = 0'u8
      i = 0
  if data != 0:
    result.add data shl (8 - i)

proc removeCommentLine*(s: openArray[uint8]): seq[uint8] =
  var commentLineFound: bool
  for b in s:
    if b == '#'.uint8:
      commentLineFound = true
      continue
    if commentLineFound and b == '\n'.uint8:
      commentLineFound = false
      continue
    if not commentLineFound:
      result.add b
