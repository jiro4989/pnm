## util is internal utilities for pnm module.
##
## **You don't need to use directly this module for pnm module.**

from sequtils import mapIt
from strutils import join

proc toBinSeq*(b: uint8): seq[uint8] =
  ## Return binary sequence from each bits of uint8.
  runnableExamples:
    from sequtils import repeat
    doAssert 0'u8.toBinSeq == 0'u8.repeat(8)
    doAssert 0b1010_1010.toBinSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]
  var c = b
  for i in 1..8:
    result.add (uint8(c and 0b1000_0000) shr 7)
    c = c shl 1

proc toBinString*(data: openArray[uint8], col: int): string =
  ## Return binary string from each bits of uint8.
  runnableExamples:
    doAssert @[0b0000_1111'u8, 0b1010_1010].toBinString(8) == "0000111110101010"
    doAssert @[0b1000_0000'u8, 0b0000_0000].toBinString(1) == "10"
  for b in data.mapIt(it.toBinSeq.mapIt(it.`$`[0].char)):
    for i, c in b:
      if i < col:
        result.add c

proc toMatrixString*(data: openArray[uint8], col: int): string =
  ## Return matrix string from decimal sequence.
  ## Matrix string is joined by whitespace.
  ## And matrix string add new line when counter of column is reached `col`.
  runnableExamples:
    doAssert @[0'u8, 1, 8, 9].toMatrixString(2) == "0 1\n8 9"
    doAssert @[0'u8, 1, 10, 99].toMatrixString(2) == "0 1\n10 99"
  var line: seq[string]
  var lines: seq[seq[string]]
  for i, c in data:
    line.add $c
    if (i+1) mod col == 0:
      lines.add line
      line = @[]
  if 0 < line.len:
    lines.add line
  result = lines.mapIt(it.join(" ")).join("\n")

proc toMatrixString*(s: string, col: int): string =
  ## Return matrix string from decimal sequence.
  ## Matrix string is joined by whitespace.
  ## And matrix string add new line when counter of column is reached `col`.
  runnableExamples:
    doAssert "1111111100000000".toMatrixString(8) == "1 1 1 1 1 1 1 1\n0 0 0 0 0 0 0 0"
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

proc toBin*(arr: openArray[uint8], col: int =  8): seq[uint8] =
  ## Returns sequences that binary sequence is converted to uint8 every 8 bits.
  runnableExamples:
    doAssert @[1'u8, 1, 1, 1, 0, 0, 0, 0].toBin == @[0b1111_0000'u8]
    doAssert @[1'u8, 1, 1, 1, 1, 1].toBin == @[0b1111_1100'u8]
    var s: seq[uint8]
    doAssert s.toBin == s
  var data: uint8
  var i = 0
  for u in arr:
    data = data shl 1
    data += u
    i.inc
    if i mod 8 == 0:
      result.add data
      data = 0'u8
      continue
    if i mod col == 0:
      data = data shl (8 - (i mod 8))
      result.add data
      data = 0'u8
      i = 0
  if data != 0:
    result.add data shl (8 - (i mod 8))

proc removeCommentLine*(s: openArray[uint8]): seq[uint8] =
  ## Return sequence that removed comment line.
  ## Range of comment is from '#' to first '\n'.
  runnableExamples:
    doAssert @['a'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8, 'b'.uint8].removeCommentLine == @['a'.uint8, 'b'.uint8]
    doAssert @['a'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8].removeCommentLine == @['a'.uint8]
    var s: seq[uint8]
    doAssert @['#'.uint8, ' '.uint8, '\n'.uint8].removeCommentLine == s
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

proc replaceWhiteSpace*(s: string): string =
  ## Replace continued whitespace to simgle whitespace.
  var ignoreWhiteSpace = false
  for c in s:
    if ignoreWhiteSpace == false and c == ' ':
      ignoreWhiteSpace = true
      result.add c
      continue
    if ignoreWhiteSpace:
      if c == ' ':
        continue
    ignoreWhiteSpace = false
    result.add c
