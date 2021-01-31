## pnm is parser/generator of PNM (Portable Anymap).
##
## Basic usage
## ===========
##
## PBM (Portable bitmap)
## ---------------------
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
##      let p = newPBM(pbmFileDescriptorP1, col, row, data)
##      writePBMFile("tests/out/p1.pbm", p)
##
##    block:
##      # P4
##      let p = newPBM(pbmFileDescriptorP4, col, row, data)
##      writePBMFile("tests/out/p4.pbm", p)
##
## PGM (Portable graymap)
## ----------------------
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
##      let p = newPGM(pgmFileDescriptorP2, col, row, data)
##      writePGMFile("tests/out/p2.pgm", p)
##
##    block:
##      # P5
##      let p = newPGM(pgmFileDescriptorP5, col, row, data)
##      writePGMFile("tests/out/p5.pgm", p)
##
## PPM (Portable pixmap)
## ----------------------
##
## Reading PPM file
## ^^^^^^^^^^^^^^^^
##
## `readPPMFile proc <#readPPMFile,string>`_ can read PPM (P3 and P6).
##
## .. code-block:: nim
##
##    import pnm
##
##    block:
##      # P3
##      let p = readPPMFile("tests/out/p3.ppm")
##      echo p
##
##    block:
##      # P6
##      let p = readPPMFile("tests/out/p6.ppm")
##      echo p
##
## Writing PPM file
## ^^^^^^^^^^^^^^^^
##
## `writePPMFile proc <#writePPMFile,string,PPM>`_ can write PPM (P3 and P6).
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
##      # P3
##      let p = newPPM(ppmFileDescriptorP3, col, row, data)
##      writePPMFile("tests/out/p3.ppm", p)
##
##    block:
##      # P6
##      let p = newPPM(ppmFileDescriptorP6, col, row, data)
##      writePPMFile("tests/out/p6.ppm", p)
##
## PNM format examples
## ===================
##
## PBM
## ----
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
##
## PGM
## ----
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
##
## PPM
## ----
##
## .. code-block::
##
##    P3
##    # The P3 means colors are in ASCII, then 3 columns and 2 rows, then 255 for max color, then RGB triplets
##    3 2
##    255
##    255 0 0
##    0 255 0
##    0 0 255
##    255 255 0
##    255 255 255
##    0 0 0
##
## See also
## ========
## * `(EN) Portable Anymap - Wikipedia <https://en.wikipedia.org/wiki/Netpbm_format>`_
## * `(JA) PNM(画像フォーマット) - Wikipedia <https://ja.wikipedia.org/wiki/PNM_(%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88)>`_

from strformat import `&`
from sequtils import mapIt, filterIt, concat
import strutils

import pnm/util

type
  PBMObj* = object
    ## PBM object.
    ## Don't directly use this type.
    fileDescriptor*: string ## File descriptor (P1 or P4)
    col*, row*: int         ## Column count
    data*: seq[uint8]       ## Byte (pixel) data
  PBM* = ref PBMObj
    ## PBM ref object.
    ## Procedures use this type. Not PBMobj.
  PGMObj* = object
    ## PGM object.
    ## Don't directly use this type.
    fileDescriptor*: string ## File descriptor (P2 or P5)
    col*, row*: int         ## Column count
    max*: uint8             ## Max value
    data*: seq[uint8]       ## Byte (pixel) data
  PGM* = ref PGMObj
    ## PGM ref object.
    ## Procedures use this type. Not PGMObj.
  PPMObj* = object
    ## PPM object.
    ## Don't directly use this type.
    fileDescriptor*: string ## File descriptor (P3 or P6)
    col*, row*: int         ## Column count
    max*: uint8             ## Max value
    data*: seq[uint8]       ## Byte (pixel) data
  PPM* = ref PPMObj
    ## PPM ref object.
    ## Procedures use this type. Not PPMObj.
  IllegalFileDescriptorError* = object of Defect
    ## Return this when file descriptor is wrong.
    ## filedescriptors are P1 or P2 or P3 or P4 or P5 or P6.
  IllegalColumnRowError* = object of Defect
    ## Return this when column or row value is wrong.
  IllegalMaxValueError* = object of Defect
    ## Return this when max value is wrong.

const
  pbmFileDescriptorP1* = "P1"
  pgmFileDescriptorP2* = "P2"
  ppmFileDescriptorP3* = "P3"
  pbmFileDescriptorP4* = "P4"
  pgmFileDescriptorP5* = "P5"
  ppmFileDescriptorP6* = "P6"

proc newPBM*(fileDescriptor: string, col, row: int, data: seq[uint8]): PBM =
  ## Return new PBM.
  runnableExamples:
    let p1 = newPBM(pbmFileDescriptorP1, 1, 1, @[1'u8])
    let p4 = newPBM(pbmFileDescriptorP4, 1, 1, @[1'u8])
  new result
  result.fileDescriptor = fileDescriptor
  result.col = col
  result.row = row
  result.data = data

proc newPGM*(fileDescriptor: string, col, row: int, max: uint8, data: seq[uint8]): PGM =
  ## Return new PGM.
  runnableExamples:
    let p2 = newPGM(pgmFileDescriptorP2, 1, 1, 255'u8, @[1'u8])
    let p5 = newPGM(pgmFileDescriptorP5, 1, 1, 255'u8, @[1'u8])
  new result
  result.fileDescriptor = fileDescriptor
  result.col = col
  result.row = row
  result.max = max
  result.data = data

proc newPGM*(fileDescriptor: string, col, row: int, data: seq[uint8]): PGM =
  ## Return a new PGM with the maximum brightness of the data as the maximum brightness of the image.
  runnableExamples:
    let p2 = newPGM(pgmFileDescriptorP2, 1, 1, @[1'u8])
    let p5 = newPGM(pgmFileDescriptorP5, 1, 1, @[1'u8])
  result = newPGM(fileDescriptor, col, row, data.max, data)

proc newPPM*(fileDescriptor: string, col, row: int, max: uint8, data: seq[uint8]): PPM =
  ## Return new PPM.
  runnableExamples:
    let p3 = newPPM(ppmFileDescriptorP3, 1, 1, 255'u8, @[255'u8, 255, 255])
    let p6 = newPPM(ppmFileDescriptorP6, 1, 1, 255'u8, @[255'u8, 255, 255])
  new result
  result.fileDescriptor = fileDescriptor
  result.col = col
  result.row = row
  result.max = max
  result.data = data

proc newPPM*(fileDescriptor: string, col, row: int, data: seq[uint8]): PPM =
  ## Return a new PPM with the maximum brightness of the data as the maximum brightness of the image.
  runnableExamples:
    let p3 = newPPM(ppmFileDescriptorP3, 1, 1, @[255'u8, 255, 255])
    let p6 = newPPM(ppmFileDescriptorP6, 1, 1, @[255'u8, 255, 255])
  result = newPPM(fileDescriptor, col, row, data.max, data)

proc formatP1*(self: PBM): string =
  ## Return formatted string for PBM P1.
  runnableExamples:
    let p1 = newPBM(pbmFileDescriptorP1, 1, 1, @[0b1000_0000'u8])
    doAssert p1.formatP1 == "P1\n1 1\n1"
  let data = self.data.toBinString(self.col).toMatrixString(self.col)
  result = &"""{self.fileDescriptor}
{self.col} {self.row}
{data}"""

proc formatP2*(self: PGM): string =
  ## Return formatted string for PGM P2.
  runnableExamples:
    let p = newPGM(pgmFileDescriptorP2, 1, 1, 255'u8, @[2'u8])
    doAssert p.formatP2 == "P2\n1 1\n255\n2"
  let data = self.data.toMatrixString(self.col)
  result = &"""{self.fileDescriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc formatP3*(self: PPM): string =
  ## Return formatted string for PPM P3.
  runnableExamples:
    let p = newPPM(ppmFileDescriptorP3, 1, 1, 255'u8, @[255'u8, 255, 255])
    doAssert p.formatP3 == "P3\n1 1\n255\n255 255 255"
  let data = self.data.toMatrixString 3
  result = &"""{self.fileDescriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc formatP4*(self: PBM): seq[uint8] =
  ## Return formatted byte data for PBM P4.
  runnableExamples:
    let p4 = newPBM(pbmFileDescriptorP4, 1, 1, @[0b1000_0000'u8])
    doAssert p4.formatP4 == @[
      'P'.uint8, '4'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
      0b10000000'u8,
    ]
  # header part
  # -----------
  # file descriptor
  result.add self.fileDescriptor.mapIt(it.uint8)
  result.add '\n'.uint8
  # col and row
  result.add self.col.`$`.mapIt(it.uint8)
  result.add ' '.uint8
  result.add self.row.`$`.mapIt(it.uint8)
  result.add '\n'.uint8
  # data part
  # ---------
  result.add self.data

proc formatP5*(self: PGM): seq[uint8] =
  ## Return formatted byte data for PGM P5.
  runnableExamples:
    let p = newPGM(pgmFileDescriptorP5, 1, 1, 255'u8, @[2'u8])
    doAssert p.formatP5 == @[
      'P'.uint8, '5'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
      '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
      2'u8,
    ]
  # header part
  # -----------
  # file descriptor
  result.add self.fileDescriptor.mapIt(it.uint8)
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

proc formatP6*(self: PPM): seq[uint8] =
  ## Return formatted byte data for PPM P6.
  runnableExamples:
    let p = newPPM(ppmFileDescriptorP6, 1, 1, 255'u8, @[255'u8, 255, 255])
    doAssert p.formatP6 == @[
      'P'.uint8, '6'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
      '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
      255'u8, 255, 255,
    ]
  # header part
  # -----------
  # file descriptor
  result.add self.fileDescriptor.mapIt(it.uint8)
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

proc parsePBM*(s: string): PBM =
  ## Return PBM that is parsed from string.
  ## This proc is function for PBM P1.
  ## You should validate string to use this proc with `validatePBM proc
  ## <#validatePBM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert "P1\n1 1\n1".parsePBM[] == newPBM(pbmFileDescriptorP1, 1, 1, @[0b1000_0000'u8])[]
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

  result.fileDescriptor = lines[0]
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  for line in lines[2..^1]:
    result.data.add line.split(" ").mapIt(it.parseUInt.uint8).toBin

proc parsePBM*(s: openArray[uint8]): PBM =
  ## Return PBM that is parsed from uint8 sequence.
  ## This proc is function for PBM P4.
  ## You should validate string to use this proc with `validatePBM proc
  ## <#validatePBM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert @[
      'P'.uint8, '4'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
      0b1000_0000'u8,
    ].parsePBM[] == newPBM(pbmFileDescriptorP4, 1, 1, @[0b1000_0000'u8])[]
  new(result)
  var dataPos = 3
  var colRowLine: string
  for i, b in s[3..^1]:
    if b == '\n'.uint8:
      dataPos += (i+1)
      break
    colRowLine.add b.char
  let colRow = colRowLine.split(" ")
  result.fileDescriptor = s[0..1].mapIt(it.char).join("")
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  result.data = s[dataPos..^1]

proc parsePGM*(s: string): PGM =
  ## Return PGM that is parsed from string.
  ## This proc is function for PGM P2.
  ## You should validate string to use this proc with `validatePGM proc
  ## <#validatePGM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert "P2\n1 1\n255\n2".parsePGM[] == newPGM(pgmFileDescriptorP2, 1, 1, 255'u8, @[2'u8])[]
    doAssert "P5\n1 1\n255\n2".parsePGM[] == newPGM(pgmFileDescriptorP5, 1, 1, 255'u8, @[2'u8])[]
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

  result.fileDescriptor = lines[0]
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
               '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
               2'u8,
    ].parsePGM[] == newPGM(pgmFileDescriptorP2, 1, 1, 255'u8, @[2'u8])[]
  new(result)
  var dataPos = 3
  var colRowLine: string
  for i, b in s[3..^1]:
    if b == '\n'.uint8:
      dataPos += (i+1)
      break
    colRowLine.add b.char
  let colRow = colRowLine.split(" ")
  result.fileDescriptor = s[0..1].mapIt(it.char).join("")
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

proc parsePPM*(s: string): PPM =
  ## Return PPM that is parsed from string.
  ## This proc is function for PPM P3.
  ## You should validate string to use this proc with `validatePPM proc
  ## <#validatePPM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert "P3\n1 1\n255\n255 255 255".parsePPM[] == newPPM(ppmFileDescriptorP3, 1, 1, 255'u8, @[255'u8, 255, 255])[]
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

  result.fileDescriptor = lines[0]
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  result.max = lines[2].parseUint.uint8
  for line in lines[3..^1]:
    result.data.add line.split(" ").mapIt(it.parseUInt.uint8)

proc parsePPM*(s: openArray[uint8]): PPM =
  ## Return PPM that is parsed from string.
  ## This proc is function for PPM P3.
  ## You should validate string to use this proc with `validatePPM proc
  ## <#validatePPM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert @['P'.uint8, '6'.uint8, '\n'.uint8,
               '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
               '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
               255'u8, 255, 255
    ].parsePPM[] == newPPM(ppmFileDescriptorP6, 1, 1, 255'u8, @[255'u8, 255, 255])[]
  new(result)
  var dataPos = 3
  var colRowLine: string
  for i, b in s[3..^1]:
    if b == '\n'.uint8:
      dataPos += (i+1)
      break
    colRowLine.add b.char
  let colRow = colRowLine.split(" ")
  result.fileDescriptor = s[0..1].mapIt(it.char).join("")
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

proc validateFileDescriptor(s: openArray[uint8], fds: varargs[string]) =
  ## Validate file descriptor of `s`.
  ## Validation targets are `fds`.
  ## Raise IllegalFileDescriptorError when illegal was found.
  let fd = s[0..1].mapIt(it.char).join("")
  if fd notin fds:
    raise newException(IllegalFileDescriptorError, &"IllegalFileDescriptor: file descriptor is {fd}")

proc validateColumnAndRow(s: openArray[uint8], start: int) =
  ## Validate column and row value of `s`.
  ## Column and row value must be Digits.
  ## Raise IllegalColumnRowError when illegal was found.
  # check column and row
  var whiteSpaceCount: int
  var lfExist: bool
  for i, b in s[start..^1]:
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

proc validateMaxValue(s: openArray[uint8], start: int) =
  ## Validate max value of `s`.
  ## Max value must be Digits.
  ## Raise IllegalMaxValueError when illegal was found.
  for i, b in s[start..^1]:
    let c = b.char
    if c == '\n':
      break
    if c notin Digits:
      raise newException(IllegalMaxValueError, &"byteIndex is {i}, value is {c}")

proc validatePBM*(s: openArray[uint8]) =
  ## Validate PBM data format.
  ##
  ## Validating contents are:
  ## 1. It is P1 or P4 that 2 byte data at the head.
  ## 2. It is decimal number that data on 2 line.
  ##
  ## Raise IllegalFileDescriptorError or IllegalColumnRowError when illegal was
  ## found.
  runnableExamples:
    ## No error
    validatePBM(@['P'.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
    validatePBM(@['P'.uint8, '4'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
  let s2 = s.removeCommentLine
  s2.validateFileDescriptor(pbmFileDescriptorP1, pbmFileDescriptorP4)
  s2.validateColumnAndRow 3

proc validatePGM*(s: openArray[uint8]) =
  ## Validate PGM data format.
  ##
  ## Validating contents are:
  ## 1. It is P2 or P5 that 2 byte data at the head.
  ## 2. It is decimal number that data on 2 line.
  ## 3. It is max value of data that data on 3 line.
  ##
  ## Raise IllegalFileDescriptorError or IllegalColumnRowError when illegal was
  ## found.
  runnableExamples:
    ## No error
    validatePGM(@['P'.uint8, '2'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
    validatePGM(@['P'.uint8, '5'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
  let s2 = s.removeCommentLine
  s2.validateFileDescriptor(pgmFileDescriptorP2, pgmFileDescriptorP5)
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

proc validatePPM*(s: openArray[uint8]) =
  ## Validate PPM data format.
  ##
  ## Validating contents are:
  ## 1. It is P3 or P6 that 2 byte data at the head.
  ## 2. It is decimal number that data on 2 line.
  ## 3. It is max value of data that data on 3 line.
  ##
  ## Raise IllegalFileDescriptorError or IllegalColumnRowError when illegal was
  ## found.
  runnableExamples:
    ## No error
    validatePPM(@['P'.uint8, '3'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8, '\n'.uint8,
                  '1'.uint8])
    validatePPM(@['P'.uint8, '6'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8, '\n'.uint8,
                  '1'.uint8])
  let s2 = s.removeCommentLine
  s2.validateFileDescriptor(ppmFileDescriptorP3, ppmFileDescriptorP6)
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

proc readPBM*(f: File): PBM =
  ## Return PBM (P1 or P4) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePBM proc <validatePBM,openArray[utin8]>`_
  runnableExamples:
    try:
      var f = open("p1.pbm")
      let p = f.readPBM
      ## do something...
      f.close
    except:
      stderr.writeLine getCurrentExceptionMsg()
  let data = f.readAll.mapIt(it.uint8)
  f.setFilePos 0
  validatePBM(data)

  let fd = f.readLine
  f.setFilePos 0
  case fd
  of pbmFileDescriptorP1:
    result = f.readAll.parsePBM
  of pbmFileDescriptorP4:
    result = data.parsePBM
  else: discard

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
  of pgmFileDescriptorP2:
    result = f.readAll.parsePGM
  of pgmFileDescriptorP5:
    result = data.parsePGM
  else: discard

proc readPPM*(f: File): PPM =
  ## Return PPM (P3 or P6) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePPM proc <validatePPM,openArray[utin8]>`_
  runnableExamples:
    try:
      var f = open("p3.ppm")
      let p = f.readPPM
      ## do something...
      f.close
    except:
      stderr.writeLine getCurrentExceptionMsg()
  let data = f.readAll.mapIt(it.uint8)
  f.setFilePos 0
  validatePPM(data)

  let fd = f.readLine
  f.setFilePos 0
  case fd
  of ppmFileDescriptorP3:
    result = f.readAll.parsePPM
  of ppmFileDescriptorP6:
    result = data.parsePPM
  else: discard

proc readPBMFile*(fn: string): PBM =
  ## Return PBM (P1 or P4) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePBM proc <validatePBM,openArray[utin8]>`_
  runnableExamples:
    try:
      let p = readPBMFile("p1.pbm")
      ## do something...
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn)
  defer: f.close
  result = f.readPBM

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

proc readPPMFile*(fn: string): PPM =
  ## Return PPM (P3 or P6) from file. This proc validates data before reading
  ## data. Raise errors when illegal was found. At seeing description of erros,
  ## see `validatePPM proc <validatePPM,openArray[utin8]>`_
  runnableExamples:
    try:
      let p = readPPMFile("p3.ppm")
      ## do something...
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn)
  defer: f.close
  result = f.readPPM

proc writePBM*(f: File, data: PBM) =
  ## Write PBM (P1 or P4) to file.
  ## Raise IllegalFileDescriptorError when illegal was found from file
  ## descriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPBM(pbmFileDescriptorP1, 1, 1, @[1'u8])
      var f = open("p1.pbm", fmWrite)
      f.writePBM p1
      f.close
      removeFile "p1.pbm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  let fd = data.fileDescriptor
  case fd
  of pbmFileDescriptorP1:
    f.write data.formatP1
  of pbmFileDescriptorP4:
    let bin = data.formatP4
    discard f.writeBytes(bin, 0, bin.len)
  else:
    raise newException(IllegalFileDescriptorError, &"file descriptor is {fd}")

proc writePGM*(f: File, data: PGM) =
  ## Write PGM (P2 or P5) to file.
  ## Raise IllegalFileDescriptorError when illegal was found from file
  ## descriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPGM(pgmFileDescriptorP2, 1, 1, 255'u8, @[1'u8])
      var f = open("p2.pgm", fmWrite)
      f.writePGM p1
      f.close
      removeFile "p2.pgm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  let fd = data.fileDescriptor
  case fd
  of pgmFileDescriptorP2:
    f.write data.formatP2
  of pgmFileDescriptorP5:
    let bin = data.formatP5
    discard f.writeBytes(bin, 0, bin.len)
  else:
    raise newException(IllegalFileDescriptorError, &"file descriptor is {fd}")

proc writePPM*(f: File, data: PPM) =
  ## Write PPM (P3 or P6) to file.
  ## Raise IllegalFileDescriptorError when illegal was found from file
  ## descriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPPM(ppmFileDescriptorP3, 1, 1, 255'u8, @[1'u8])
      var f = open("p3.ppm", fmWrite)
      f.writePPM p1
      f.close
      removeFile "p3.ppm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  let fd = data.fileDescriptor
  case fd
  of ppmFileDescriptorP3:
    f.write data.formatP3
  of ppmFileDescriptorP6:
    let bin = data.formatP6
    discard f.writeBytes(bin, 0, bin.len)
  else:
    raise newException(IllegalFileDescriptorError, &"file descriptor is {fd}")

proc writePBMFile*(fn: string, data: PBM) =
  ## Write PBM (P1 or P4) to file.
  ## Raise IllegalFileDescriptorError when illegal was found from file
  ## descriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPBM(pbmFileDescriptorP1, 1, 1, @[1'u8])
      writePBMFile "p1.pbm", p1
      removeFile "p1.pbm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePBM data

proc writePGMFile*(fn: string, data: PGM) =
  ## Write PGM (P2 or P5) to file.
  ## Raise IllegalFileDescriptorError when illegal was found from file
  ## descriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPGM(pgmFileDescriptorP2, 1, 1, 255'u8, @[1'u8])
      writePGMFile "p2.pgm", p1
      removeFile "p2.pgm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePGM data

proc writePPMFile*(fn: string, data: PPM) =
  ## Write PPM (P3 or P6) to file.
  ## Raise IllegalFileDescriptorError when illegal was found from file
  ## descriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPPM(ppmFileDescriptorP3, 1, 1, 255'u8, @[1'u8])
      writePPMFile "p3.ppm", p1
      removeFile "p3.ppm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePPM data

proc `$`*(self: PBM): string =
  result = $self[]

proc `$`*(self: PGM): string =
  result = $self[]

proc `$`*(self: PPM): string =
  result = $self[]
