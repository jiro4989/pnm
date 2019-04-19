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
  IllegalFileDiscriptorError* = object of Defect
  IllegalColumnRowError* = object of Defect

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

proc removeCommentLine(s: seq[uint8]): seq[uint8] =
  var commentLineFound: bool
  for b in s:
    if b == '#'.uint8:
      commentLineFound = true
      continue
    if b == '\n'.uint8:
      commentLineFound = false
      continue
    if not commentLineFound:
      result.add b
    
proc validatePBM*(s: seq[uint8]) =
  ## 1. 先頭２バイトがP1またはP4である
  ## 2. 2行目のデータは行 列の整数値である
  ## 3. コメント行を無視した行数が３以上である
  # check filediscriptor
  let fd = s[0..1].mapIt(it.char).`$`
  case fd
  of pbmFileDiscriptorP1, pbmFileDiscriptorP4:
    discard
  else:
    var e = new(IllegalFileDiscriptorError)
    e.msg = &"IllegalFileDiscriptor: file discriptor is {fd}"
    raise e

  # check column and row
  var whiteSpaceCount: int
  var lfExist: bool
  for i, b in s[3..^1].removeCommentLine:
    if b == ' '.uint8:
      whiteSpaceCount.inc
      continue
    if b == '\n'.uint8:
      lfExist = true
      break
    if b.char notin Digits:
      var e = new(IllegalColumnRowError)
      e.msg = &"IllegalColumnRowError: byteIndex is {i}, value is {b}"
      raise e
  if whiteSpaceCount != 1:
    var e = new(IllegalColumnRowError)
    e.msg = &"IllegalColumnRowError: whitespace count is {whiteSpaceCount}"
    raise e

  # check line count
  if not lfExist:
    ## TODO
    raise

proc parsePBM*(s: seq[uint8]): PBM =
  ## 事前にバリデーションしておくこと
  new(result)
  var dataPos = 2
  var colRowLine: string
  for i, b in s[2..^1]:
    if b == '\n'.uint8:
      dataPos += i
      break
    colRowLine.add b.char
  let colRow = colRowLine.split(" ")
  result.fileDiscriptor = s[0..1].mapIt(it.char).`$`
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  for i, b in s[dataPos..^1]:
    var line: seq[uint8]
    if i mod result.col == 0:
      result.data.add line
      line = @[]
    line.add b

proc readPBMFile*(f: File): PBM =
  let fd = f.readLine
  f.setFilePos 0
  case fd
  of pbmFileDiscriptorP1:
    result = f.readAll.parsePBM
  of pbmFileDiscriptorP4:
    discard
  else: raise

proc `$`*(self: PBM): string =
  result = "{" & &"fileDiscriptor:{self.fileDiscriptor},col:{self.col},row:{self.row},data:{self.data}" & "}"