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

proc toBin(arr: openArray[uint8]): seq[uint8] =
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

proc removeCommentLine(s: openArray[uint8]): seq[uint8] =
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
  # check filediscriptor
  let fd = s[0..1].mapIt(it.char).join("")
  case fd
  of pbmFileDiscriptorP1, pbmFileDiscriptorP4:
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

proc `$`*(self: PBM): string =
  result = $self[]