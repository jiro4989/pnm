## pgm
## ====
##
## pgm is PGM(Portable graymap) image encoder/decorder module.
##
## Basic usage
## -----------
##
## Reading PGM file
## ^^^^^^^^^^^^^^^^
##
## `readPGMFile proc <#readPGMFile,string>`_ can read PGM (P2 and P5).
##
## .. code-block:: nim
##
##    import pnm
##
##    block:
##      # P2
##      let p = readPGMFile("tests/out/p2.pgm")
##      echo p
##
##    block:
##      # P5
##      let p = readPGMFile("tests/out/p5.pgm")
##      echo p
##
## Writing PGM file
## ^^^^^^^^^^^^^^^^
##
## `writePGMFile proc <#writePGMFile,string,PGM>`_ can write PGM (P2 and P5).
##
## .. code-block:: nim
##
##    import pnm
##
##    let col = 6
##    let row = 12
##    let max = 2
##    let data = @[
##      0'u8, 0, 0, 0, 0, 0,
##      0'u8, 0, 0, 0, 0, 0,
##      0'u8, 0, 0, 0, 0, 0,
##      0'u8, 0, 0, 0, 0, 0,
##      1, 1, 1, 1, 1, 1,
##      1, 1, 1, 1, 1, 1,
##      1, 1, 1, 1, 1, 1,
##      1, 1, 1, 1, 1, 1,
##      2, 2, 2, 2, 2, 2,
##      2, 2, 2, 2, 2, 2,
##      2, 2, 2, 2, 2, 2,
##      2, 2, 2, 2, 2, 2,
##    ]
##
##    block:
##      # P2
##      let p = newPGM(pgmFileDiscriptorP2, col, row, data)
##      writePGMFile("tests/out/p2.pgm", p)
##
##    block:
##      # P5
##      let p = newPGM(pgmFileDiscriptorP5, col, row, data)
##      writePGMFile("tests/out/p5.pgm", p)
##
## PGM format example
## ==================
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

from strformat import `&`
from sequtils import mapIt, filterIt
import strutils

import errors, util, validator

type
  PGMObj* = object
    ## PGM object.
    ## Don't directly use this type.
    fileDiscriptor*: string ## File discriptor (P2 or P5)
    col*, row*: int         ## Column count
    max*: uint8             ## Max value
    data*: seq[uint8]       ## Byte (pixel) data
  PGM* = ref PGMObj
    ## PGM ref object.
    ## Procedures use this type. Not PGMObj.

const
  pgmFileDiscriptorP2* = "P2"
  pgmFileDiscriptorP5* = "P5"

proc newPGM*(fileDiscriptor: string, col, row: int, data: seq[uint8]): PGM =
  ## Return new PGM.
  runnableExamples:
    let p1 = newPGM(pgmFileDiscriptorP2, 1, 1, @[1'u8])
    let p4 = newPGM(pgmFileDiscriptorP5, 1, 1, @[1'u8])
  new result
  result.fileDiscriptor = fileDiscriptor
  result.col = col
  result.row = row
  result.max = data.max
  result.data = data

proc formatP2*(self: PGM): string =
  ## Return formatted string for PGM P2.
  runnableExamples:
    let p = newPGM(pgmFileDiscriptorP2, 1, 1, @[2'u8])
    doAssert p.formatP2 == "P2\n1 1\n2\n2"
  let data = self.data.toMatrixString(self.col)
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc formatP5*(self: PGM): seq[uint8] =
  ## Return formatted byte data for PGM P5.
  runnableExamples:
    let p = newPGM(pgmFileDiscriptorP5, 1, 1, @[2'u8])
    doAssert p.formatP5 == @[
      'P'.uint8, '5'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
      '2'.uint8, '\n'.uint8,
      2'u8,
    ]
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

proc parsePGM*(s: string): PGM =
  ## Return PGM that is parsed from string.
  ## This proc is function for PGM P2.
  ## You should validate string to use this proc with `validatePGM proc
  ## <#validatePGM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert "P2\n1 1\n2\n2".parsePGM[] == newPGM(pgmFileDiscriptorP2, 1, 1, @[2'u8])[]
    doAssert "P5\n1 1\n2\n2".parsePGM[] == newPGM(pgmFileDiscriptorP5, 1, 1, @[2'u8])[]
  new(result)
  var lines: seq[string]
  for line in s.replaceWhiteSpace.splitLines.mapIt(it.strip):
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

proc parsePGM*(s: openArray[uint8]): PGM =
  ## Return PGM that is parsed from string.
  ## This proc is function for PGM P2.
  ## You should validate string to use this proc with `validatePGM proc
  ## <#validatePGM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert @['P'.uint8, '2'.uint8, '\n'.uint8,
               '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
               '2'.uint8, '\n'.uint8,
               2'u8,
    ].parsePGM[] == newPGM(pgmFileDiscriptorP2, 1, 1, @[2'u8])[]
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

proc validatePGM*(s: openArray[uint8]) =
  ## Validate PGM data format.
  ##
  ## Validating contents are:
  ## 1. It is P2 or P5 that 2 byte data at the head.
  ## 2. It is decimal number that data on 2 line.
  ## 3. It is max value of data that data on 3 line.
  ##
  ## Raise IllegalFileDiscriptorError or IllegalColumnRowError when illegal was
  ## found.
  ##
  ## See also:
  ## * `errors module <errors.html>`_
  runnableExamples:
    ## No error
    validatePGM(@['P'.uint8, '2'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
    validatePGM(@['P'.uint8, '5'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
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

proc readPGM*(f: File): PGM =
  ## Return PGM (P2 or P5) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePGM proc <validatePGM,openArray[utin8]>`_
  runnableExamples:
    try:
      var f = open("p2.pgm")
      let p = f.readPGM
      ## do something...
      f.close
    except:
      stderr.writeLine getCurrentExceptionMsg()
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
  ## Return PGM (P2 or P5) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePGM proc <validatePGM,openArray[utin8]>`_
  runnableExamples:
    try:
      let p = readPGMFile("p2.pgm")
      ## do something...
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn)
  defer: f.close
  result = f.readPGM

proc writePGM*(f: File, data: PGM) =
  ## Write PGM (P2 or P5) to file.
  ## Raise IllegalFileDiscriptorError when illegal was found from file
  ## discriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPGM(pgmFileDiscriptorP2, 1, 1, @[1'u8])
      var f = open("p2.pgm", fmWrite)
      f.writePGM p1
      f.close
      removeFile "p2.pgm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  let fd = data.fileDiscriptor
  case fd
  of pgmFileDiscriptorP2:
    f.write data.formatP2
  of pgmFileDiscriptorP5:
    let bin = data.formatP5
    discard f.writeBytes(bin, 0, bin.len)
  else:
    raise newException(IllegalFileDiscriptorError, &"file discriptor is {fd}")

proc writePGMFile*(fn: string, data: PGM) =
  ## Write PGM (P2 or P5) to file.
  ## Raise IllegalFileDiscriptorError when illegal was found from file
  ## discriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPGM(pgmFileDiscriptorP2, 1, 1, @[1'u8])
      writePGMFile "p2.pgm", p1
      removeFile "p2.pgm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePGM data

proc `$`*(self: PGM): string =
  result = $self[]