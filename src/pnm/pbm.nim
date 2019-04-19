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
from algorithm import reverse
import strutils

const
  pbmFileDiscriptorP1* = "P1"
  pbmFileDiscriptorP4* = "P4"

type
  PBMObj = object
    fileDiscriptor*: string
    col*, row*: int
    data*: seq[uint8]
  PBM* = ref PBMObj
  IllegalFileDiscriptorError* = object of Defect
  IllegalColumnRowError* = object of Defect

proc toBinSeq(b: uint8): seq[uint8] =
  ## 2進数のビットをシーケンスに変換する
  ## 0b0000_1111 -> @[0'u8, 0, 0, 0, 1, 1, 1, 1]
  var c = b
  for i in 1..8:
    result.add uint8(c and 0b0000_0001)
    c = c shr 1
  result.reverse

proc formatP1*(self: PBM): string =
  var chars: seq[char]
  for b in self.data.mapIt(it.toBinSeq.mapIt(it.`$`[0].char)):
    for c in b:
      chars.add c
  var line: seq[char]
  var lines: seq[seq[char]]
  for i, c in chars:
    line.add c
    if (i+1) mod self.col == 0:
      lines.add line
      line = @[]
  if 0 < line.len:
    lines.add line
  let data = lines.mapIt(it.join(" ")).join("\n")
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
  # for row in self.data:
  #   var data = 0'u8
  #   var bitCnt = 0
  #   for b in row:
  #     if 8 <= bitCnt:
  #       result.add data
  #       data = 0
  #       bitCnt = 0
  #     data = data shl 1
  #     data += b
  #     bitCnt.inc
  #   if 0 < bitCnt:
  #     let diff = 8 - bitCnt
  #     data = data shl diff
  #     result.add data

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
    result.data = result.data.concat line.split(" ").mapIt(it.parseUInt.uint8)

proc removeCommentLine(s: openArray[uint8]): seq[uint8] =
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
    
proc validatePBM*(s: openArray[uint8]) =
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

proc parsePBM*(s: openArray[uint8]): PBM =
  ## P4用
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

proc `$`*(self: PBM): string =
  result = "{" & &"fileDiscriptor:{self.fileDiscriptor},col:{self.col},row:{self.row},data:{self.data}" & "}"