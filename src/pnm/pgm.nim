## pgm is PGM(Portable graymap) image encoder/decorder module.
##
## PGM example
## ===========
##
## .. code-block:: text
##
##    P2
##    # Shows the word "FEEP" (example from Netpgm man page on PGM)
##    24 7
##    15
##    0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
##    0  3  3  3  3  0  0  7  7  7  7  0  0 11 11 11 11  0  0 15 15 15 15  0
##    0  3  0  0  0  0  0  7  0  0  0  0  0 11  0  0  0  0  0 15  0  0 15  0
##    0  3  3  3  0  0  0  7  7  7  0  0  0 11 11 11  0  0  0 15 15 15 15  0
##    0  3  0  0  0  0  0  7  0  0  0  0  0 11  0  0  0  0  0 15  0  0  0  0
##    0  3  0  0  0  0  0  7  7  7  7  0  0 11 11 11 11  0  0 15  0  0  0  0
##    0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
##
## See also:
## * https://ja.wikipedia.org/wiki/PNM_(%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88)
## * http://tech.ckme.co.jp/pnm.shtml

from strformat import `&`
from sequtils import mapIt, filterIt
import strutils

import errors, util, validator

type
  PGMObj = object
    fileDiscriptor*: string ## P2
    col*, row*: int
    max*: uint8
    data*: seq[uint8]
  PGM* = ref PGMObj

const
  pgmFileDiscriptorP2* = "P2"
  pgmFileDiscriptorP5* = "P5"

proc formatP2*(self: PGM): string =
  let data = self.data.toMatrixString(self.col)
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc formatP5*(self: PGM): seq[uint8] =
  # header part
  # -----------
  # file discriptor
  result.add self.fileDiscriptor.mapIt(it.uint8)
  result.add '\n'.uint8
  # col and row
  result.add self.col.`$`.mapIt(it.uint8)
  result.add ' '.uint8
  result.add self.row.`$`.mapIt(it.uint8)
  result.add '\n'.uint8
  result.add self.max.`$`.mapIt(it.uint8)
  result.add '\n'.uint8
  # data part
  # ---------
  result.add self.data

proc validatePGM*(s: openArray[uint8]) =
  ## 1. 先頭２バイトがP1またはP4である
  ## 2. 2行目のデータは行 列の整数値である
  ## 3. 3行目のデータは最大値である
  ## 4. コメント行を無視した行数が３以上である
  let s2 = s.removeCommentLine
  s2.validateFileDiscriptor(pgmFileDiscriptorP2, pgmFileDiscriptorP5)
  s2.validateColumnAndRow 3
  var lfCnt: int
  var pos: int
  for i, v in s2:
    if v.char == '\n':
      lfCnt.inc
    if 2 <= lfCnt:
      pos = (i+1)
      break
  s2.validateMaxValue pos

proc parsePGM*(s: string): PGM =
  ## P2用
  new(result)
  var lines: seq[string]
  for line in s.splitLines:
    if not line.startsWith "#":
      lines.add line

  if lines.len < 3:
    return
  let colRow = lines[1].split(" ")
  if colRow.len < 2:
    return

  result.fileDiscriptor = lines[0]
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  result.max = lines[2].parseUint.uint8
  for line in lines[3..^1]:
    result.data.add line.split(" ").mapIt(it.parseUInt.uint8).toBin

proc parsePGM*(s: openArray[uint8]): PGM =
  ## 事前にバリデーションしておくこと
  new(result)
  var dataPos = 3
  var colRowLine: string
  for i, b in s[3..^1]:
    if b == '\n'.uint8:
      dataPos += (i+1)
      break
    colRowLine.add b.char
  let colRow = colRowLine.split(" ")
  result.fileDiscriptor = s[0..1].mapIt(it.char).join("")
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  var maxV: string
  for i, b in s[dataPos..^1]:
    if b == '\n'.uint8:
      dataPos += (i+1)
      break
    maxV.add b.char
  result.max = maxV.parseUint.uint8
  result.data = s[dataPos..^1]

proc readPGM*(f: File): PGM =
  let data = f.readAll.mapIt(it.uint8)
  f.setFilePos 0
  validatePGM(data)

  let fd = f.readLine
  f.setFilePos 0
  case fd
  of pgmFileDiscriptorP2:
    result = f.readAll.parsePGM
  of pgmFileDiscriptorP5:
    result = data.parsePGM
  else: discard

proc readPGMFile*(fn: string): PGM =
  var f = open(fn)
  defer: f.close
  result = f.readPGM

proc `$`*(self: PGM): string =
  result = $self[]