## pbm is PBM(Portable bitmap) image encoder/decorder module.
##
## PBM example
## ===========
##
## .. code-block:: text
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
##
## See also:
## * https://ja.wikipedia.org/wiki/PNM_(%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88)

from strformat import `&`
from sequtils import mapIt, filterIt, concat
import strutils

const
  pbmFileDiscriptorP1* = "P1"
  pbmFileDiscriptorP4* = "P4"

type
  PBMObj = object
    fileDiscriptor*: string
    col*, row*: int
    data*: seq[seq[uint8]]
  PBM* = ref PBMObj

proc newPBM*(data: seq[seq[uint8]]): PBM =
  new(result)
  if data.len < 1:
    return
  let col = data[0].len
  let row = data.len

  result.row = row
  result.col = col
  result.data = data

proc newPBM*(data: seq[seq[uint8]], fileDiscriptor: string): PBM =
  result = newPBM(data)
  result.fileDiscriptor = fileDiscriptor

proc formatP1*(self: PBM): string =
  let data = self.data.mapIt(it.mapIt(it.ord).join(" ")).join("\n")
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
  for row in self.data:
    var data = 0'u8
    var bitCnt = 0
    for b in row:
      if 8 <= bitCnt:
        result.add data
        data = 0
        bitCnt = 0
      data = data shl 1
      data += b
      bitCnt.inc
    if 0 < bitCnt:
      let diff = 8 - bitCnt
      data = data shl diff
      result.add data

proc parsePBM*(s: string): PBM =
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
  let rawData = lines[2..^1]
  result.data = rawData.mapIt(it.split(" ").mapIt(it.parseUInt.uint8))

proc parsePBM*(s: seq[uint8]): PBM =
  new(result)
  discard

proc readPBMFile*(f: File): PBM =
  result = f.readAll.parsePBM

proc `$`*(self: PBM): string =
  result = "{" & &"fileDiscriptor:{self.fileDiscriptor},col:{self.col},row:{self.row},data:{self.data}" & "}"