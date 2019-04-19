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

type
  PGMObj = object
    fileDiscriptor*: string ## P2
    col*, row*: int
    max*: uint8
    data*: seq[seq[uint8]]
  PGM* = ref PGMObj

const fileDiscriptor* = "P2"

proc encode*(data: seq[seq[uint8]]): PGM =
  new(result)
  if data.len < 1:
    return
  let col = data[0].len
  let row = data.len

  result.fileDiscriptor = fileDiscriptor
  result.row = row
  result.col = col
  result.max = data.mapIt(it.max).max
  result.data = data

proc format*(self: PGM): string =
  let data = self.data.mapIt(it.join(" ")).join("\n")
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc decode*(s: string): PGM =
  new(result)
  var lines: seq[string]
  for line in s.splitLines:
    if not line.startsWith "#":
      lines.add line

  if lines.len < 4:
    return
  let colRow = lines[1].split(" ")
  if colRow.len < 2:
    return
  
  result.fileDiscriptor = lines[0]
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  result.max = lines[2].parseUInt.uint8
  let rawData = lines[3..^1]
  result.data = rawData.mapIt(it.split(" ").mapIt(it.parseUInt.uint8))

proc decode*(f: File): PGM =
  result = f.readAll.decode

proc `$`*(self: PGM): string =
  result = "{" & &"fileDiscriptor:{self.fileDiscriptor},col:{self.col},row:{self.row},max:{self.max},data:{self.data}" & "}"