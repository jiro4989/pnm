## pgm is PGM(Portable graymap) image encoder/decorder module.
##
## PGM example
## ===========
##
## .. code-block:: text
##
##    P2
##    # Shows the word "FEEP" (example from Netpbm man page on PGM)
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

from strformat import `&`
from sequtils import mapIt, filterIt
import strutils

import errors
include util

type
  PGMObj = object
    fileDiscriptor*: string ## P2
    col*, row*: int
    max*: uint8
    data*: seq[uint8]
  PGM* = ref PGMObj

const
  pbmFileDiscriptorP2* = "P2"
  pbmFileDiscriptorP5* = "P5"

proc formatP2*(self: PGM): string =
  let data = self.data.toBinString.toMatrixString(self.col)
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
  # check filediscriptor
  let fd = s[0..1].mapIt(it.char).join("")
  case fd
  of pbmFileDiscriptorP2, pbmFileDiscriptorP5:
    discard
  else:
    raise newException(IllegalFileDiscriptorError, &"IllegalFileDiscriptor: file discriptor is {fd}")

  # check column and row
  var whiteSpaceCount: int
  var lfExist: bool
  for i, b in s[3..^1].removeCommentLine:
    let c = b.char
    if c == '\n':
      lfExist = true
      break
    if c == ' ':
      whiteSpaceCount.inc
      continue
    if c notin Digits:
      raise newException(IllegalColumnRowError, &"byteIndex is {i}, value is {c}")
  if whiteSpaceCount != 1:
    raise newException(IllegalColumnRowError, &"whitespace count is {whiteSpaceCount}")

  when false:
    # check line count
    if not lfExist:
      ## TODO
      raise

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

proc `$`*(self: PGM): string =
  result = $self[]