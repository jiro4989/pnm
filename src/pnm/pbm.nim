## pbm
## ====
##
## pbm is parser/generator of PBM(Portable bitmap).
##
## Basic usage
## -----------
##
## Reading PBM file
## ^^^^^^^^^^^^^^^^
##
## `readPBMFile proc <#readPBMFile,string>`_ can read PBM (P1 and P4).
##
## .. code-block:: nim
##
##    import pnm
##
##    block:
##      # P1
##      let pbm = readPBMFile("tests/out/p1.pbm")
##      echo pbm
##
##    block:
##      # P4
##      let pbm = readPBMFile("tests/out/p4.pbm")
##      echo pbm
##
## Writing PBM file
## ^^^^^^^^^^^^^^^^
##
## `writePBMFile proc <#writePBMFile,string,PBM>`_ can write PBM (P1 and P4).
##
## .. code-block:: nim
##
##    import pnm
##
##    let col = 32 # 8 (bit) x 4 (column) == 32
##    let row = 12
##    let data = @[
##      0b11111111'u8, 0b00000000, 0b11111111, 0b00000000,
##      0b11111111, 0b00000000, 0b11111111, 0b00000000,
##      0b11111111, 0b00000000, 0b11111111, 0b00000000,
##      0b11111111, 0b00000000, 0b11111111, 0b00000000,
##      0b11111111, 0b11111111, 0b11111111, 0b11111111,
##      0b11111111, 0b11111111, 0b11111111, 0b11111111,
##      0b11111111, 0b11111111, 0b11111111, 0b11111111,
##      0b11111111, 0b11111111, 0b11111111, 0b11111111,
##      0b00000000, 0b00000000, 0b00000000, 0b00000000,
##      0b00000000, 0b00000000, 0b00000000, 0b00000000,
##      0b00000000, 0b00000000, 0b00000000, 0b00000000,
##      0b00000000, 0b00000000, 0b00000000, 0b00000000,
##    ]
##
##    block:
##      # P1
##      let p = newPBM(pbmFileDiscriptorP1, col, row, data)
##      writePBMFile("tests/out/p1.pbm", p)
##
##    block:
##      # P4
##      let p = newPBM(pbmFileDiscriptorP4, col, row, data)
##      writePBMFile("tests/out/p4.pbm", p)
##
## PBM format example
## ------------------
##
## .. code-block::
##
##    P1
##    # comment
##    5 6
##    0 0 1 0 0
##    0 1 1 0 0
##    0 0 1 0 0
##    0 0 1 0 0
##    0 0 1 0 0
##    1 1 1 1 1

from strformat import `&`
from sequtils import mapIt, filterIt, concat
import strutils

import errors, util, validator

const
  pbmFileDiscriptorP1* = "P1"
  pbmFileDiscriptorP4* = "P4"

type
  PBMObj = object
    fileDiscriptor*: string
    col*, row*: int
    data*: seq[uint8]
  PBM* = ref PBMObj

proc newPBM*(fileDiscriptor: string, col, row: int, data: seq[uint8]): PBM =
  new result
  result.fileDiscriptor = fileDiscriptor
  result.col = col
  result.row = row
  result.data = data

proc formatP1*(self: PBM): string =
  let data = self.data.toBinString.toMatrixString(self.col)
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{data}"""

proc formatP4*(self: PBM): seq[uint8] =
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
  # data part
  # ---------
  result.add self.data

proc parsePBM*(s: string): PBM =
  ## P1用
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
  for line in lines[2..^1]:
    result.data.add line.split(" ").mapIt(it.parseUInt.uint8).toBin

proc validatePBM*(s: openArray[uint8]) =
  ## 1. 先頭２バイトがP1またはP4である
  ## 2. 2行目のデータは行 列の整数値である
  ## 3. コメント行を無視した行数が３以上である
  let s2 = s.removeCommentLine
  s2.validateFileDiscriptor(pbmFileDiscriptorP1, pbmFileDiscriptorP4)
  s2.validateColumnAndRow 3

proc parsePBM*(s: openArray[uint8]): PBM =
  ## P4用
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
  result.data = s[dataPos..^1]

proc readPBM*(f: File): PBM =
  let data = f.readAll.mapIt(it.uint8)
  f.setFilePos 0
  validatePBM(data)

  let fd = f.readLine
  f.setFilePos 0
  case fd
  of pbmFileDiscriptorP1:
    result = f.readAll.parsePBM
  of pbmFileDiscriptorP4:
    result = data.parsePBM
  else: discard

proc readPBMFile*(fn: string): PBM =
  var f = open(fn)
  defer: f.close
  result = f.readPBM

proc writePBM*(f: File, data: PBM) =
  let fd = data.fileDiscriptor
  case fd
  of pbmFileDiscriptorP1:
    f.write data.formatP1
  of pbmFileDiscriptorP4:
    let bin = data.formatP4
    discard f.writeBytes(bin, 0, bin.len)
  else:
    raise newException(IllegalFileDiscriptorError, &"file discriptor is {fd}")

proc writePBMFile*(fn: string, data: PBM) =
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePBM data

proc `$`*(self: PBM): string =
  result = $self[]