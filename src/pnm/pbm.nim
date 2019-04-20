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
##      let p = readPBMFile("tests/out/p1.pbm")
##      echo p
##
##    block:
##      # P4
##      let p = readPBMFile("tests/out/p4.pbm")
##      echo p
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

type
  PBMObj* = object
    ## PBM object.
    ## Don't directly use this type.
    fileDiscriptor*: string ## File discriptor (P1 or P4)
    col*, row*: int         ## Column count
    data*: seq[uint8]       ## byte (pixel) data
  PBM* = ref PBMObj
    ## PBM ref object.
    ## Procedures use this type. Not PBMobj.

const
  pbmFileDiscriptorP1* = "P1"
  pbmFileDiscriptorP4* = "P4"

proc newPBM*(fileDiscriptor: string, col, row: int, data: seq[uint8]): PBM =
  ## Return new PBM.
  runnableExamples:
    let p1 = newPBM(pbmFileDiscriptorP1, 1, 1, @[1'u8])
    let p4 = newPBM(pbmFileDiscriptorP4, 1, 1, @[1'u8])
  new result
  result.fileDiscriptor = fileDiscriptor
  result.col = col
  result.row = row
  result.data = data

proc formatP1*(self: PBM): string =
  ## Return formatted string for PBM P1.
  runnableExamples:
    let p1 = newPBM(pbmFileDiscriptorP1, 1, 1, @[1'u8])
    ## TODO
    #doAssert p1.formatP1 == "P1\n1 1\n1"
  let data = self.data.toBinString.toMatrixString(self.col)
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{data}"""

proc formatP4*(self: PBM): seq[uint8] =
  ## Return formatted byte data for PBM P4.
  runnableExamples:
    let p4 = newPBM(pbmFileDiscriptorP4, 1, 1, @[1'u8])
    ## TODO
    # doAssert p4.formatP4 == @[
    #   'P'.uint8, '4'.uint8, '\n'.uint8,
    #   '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
    #   0b10000000'u8,
    # ]
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
  ## Return PBM that is parsed from string.
  ## This proc is function for PBM P1.
  ## You should validate string to use this proc with `validatePBM proc
  ## <#validatePBM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert "P1\n1 1\n1".parsePBM[] == newPBM(pbmFileDiscriptorP1, 1, 1, @[0b1000_0000'u8])[]
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

proc parsePBM*(s: openArray[uint8]): PBM =
  ## Return PBM that is parsed from uint8 sequence.
  ## This proc is function for PBM P4.
  ## You should validate string to use this proc with `validatePBM proc
  ## <#validatePBM,openArray[uint8]>`_ .
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

proc validatePBM*(s: openArray[uint8]) =
  ## Validate PBM data format.
  ##
  ## Validating contents are:
  ## 1. It is P1 or P4 that 2 byte data at the head.
  ## 2. It is decimal number that data on 2 line.
  ##
  ## Raise IllegalFileDiscriptorError or IllegalColumnRowError when illegal was
  ## found.
  ##
  ## See also:
  ## * `errors module <errors.html>`_
  let s2 = s.removeCommentLine
  s2.validateFileDiscriptor(pbmFileDiscriptorP1, pbmFileDiscriptorP4)
  s2.validateColumnAndRow 3

proc readPBM*(f: File): PBM =
  ## Return PBM (P1 or P4) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePBM proc <validatePBM,openArray[utin8]>`_
  runnableExamples:
    try:
      var f = open("p1.pbm")
      echo f.readPBM
      f.close
    except:
      stderr.writeLine getCurrentExceptionMsg()
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
  ## Return PBM (P1 or P4) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePBM proc <validatePBM,openArray[utin8]>`_
  runnableExamples:
    try:
      echo readPBMFile("p1.pbm")
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn)
  defer: f.close
  result = f.readPBM

proc writePBM*(f: File, data: PBM) =
  ## Write PBM (P1 or P4) to file.
  ## Raise IllegalFileDiscriptorError when illegal was found from file
  ## discriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPBM(pbmFileDiscriptorP1, 1, 1, @[1'u8])
      var f = open("p1.pbm", fmWrite)
      f.writePBM p1
      f.close
      removeFile "p1.pbm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
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
  ## Write PBM (P1 or P4) to file.
  ## Raise IllegalFileDiscriptorError when illegal was found from file
  ## discriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPBM(pbmFileDiscriptorP1, 1, 1, @[1'u8])
      writePBMFile "p1.pbm", p1
      removeFile "p1.pbm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePBM data

proc `$`*(self: PBM): string =
  result = $self[]