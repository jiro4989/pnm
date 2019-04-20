## ppm
## ====
##
## ppm is PPM(Portable graymap) image encoder/decorder module.
##
## PPM example
## ===========
##
## .. code-block:: text
##
##    P2
##    # Shows the word "FEEP" (example from NetPPM man page on PPM)
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
  PPMObj = object
    fileDiscriptor*: string ## P2
    col*, row*: int
    max*: uint8
    data*: seq[uint8]
  PPM* = ref PPMObj

const
  ppmFileDiscriptorP3* = "P3"
  ppmFileDiscriptorP6* = "P6"

proc newPPM*(fileDiscriptor: string, col, row: int, data: seq[uint8]): PPM =
  new result
  result.fileDiscriptor = fileDiscriptor
  result.col = col
  result.row = row
  result.max = data.max
  result.data = data

proc formatP3*(self: PPM): string =
  let data = self.data.toMatrixString 3
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc formatP6*(self: PPM): seq[uint8] =
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

proc validatePPM*(s: openArray[uint8]) =
  ## 1. 先頭２バイトがP3またはP6である
  ## 2. 2行目のデータは行 列の整数値である
  ## 3. 3行目のデータは最大値である
  ## 4. コメント行を無視した行数が３以上である
  let s2 = s.removeCommentLine
  s2.validateFileDiscriptor(ppmFileDiscriptorP3, ppmFileDiscriptorP6)
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

proc parsePPM*(s: string): PPM =
  ## P3用
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
    result.data.add line.split(" ").mapIt(it.parseUInt.uint8)

proc parsePPM*(s: openArray[uint8]): PPM =
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

proc readPPM*(f: File): PPM =
  let data = f.readAll.mapIt(it.uint8)
  f.setFilePos 0
  validatePPM(data)

  let fd = f.readLine
  f.setFilePos 0
  case fd
  of ppmFileDiscriptorP3:
    result = f.readAll.parsePPM
  of ppmFileDiscriptorP6:
    result = data.parsePPM
  else: discard

proc readPPMFile*(fn: string): PPM =
  var f = open(fn)
  defer: f.close
  result = f.readPPM

proc writePPM*(f: File, data: PPM) =
  let fd = data.fileDiscriptor
  case fd
  of ppmFileDiscriptorP3:
    f.write data.formatP3
  of ppmFileDiscriptorP6:
    let bin = data.formatP6
    discard f.writeBytes(bin, 0, bin.len)
  else:
    raise newException(IllegalFileDiscriptorError, &"file discriptor is {fd}")

proc writePPMFile*(fn: string, data: PPM) =
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePPM data

proc `$`*(self: PPM): string =
  result = $self[]