## ppm
## ====
##
## ppm is PPM(Portable graymap) image encoder/decorder module.
##
## Basic usage
## -----------
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
##      let p = newPPM(ppmFileDiscriptorP3, col, row, data)
##      writePPMFile("tests/out/p3.ppm", p)
##
##    block:
##      # P6
##      let p = newPPM(ppmFileDiscriptorP6, col, row, data)
##      writePPMFile("tests/out/p6.ppm", p)
##
## PPM format example
## ==================
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

from strformat import `&`
from sequtils import mapIt, filterIt
import strutils

import errors, util, validator

type
  PPMObj* = object
    ## PPM object.
    ## Don't directly use this type.
    fileDiscriptor*: string ## File discriptor (P3 or P6)
    col*, row*: int         ## Column count
    max*: uint8             ## Max value
    data*: seq[uint8]       ## Byte (pixel) data
  PPM* = ref PPMObj
    ## PPM ref object.
    ## Procedures use this type. Not PPMObj.

const
  ppmFileDiscriptorP3* = "P3"
  ppmFileDiscriptorP6* = "P6"

proc newPPM*(fileDiscriptor: string, col, row: int, data: seq[uint8]): PPM =
  ## Return new PPM.
  runnableExamples:
    let p3 = newPPM(ppmFileDiscriptorP3, 1, 1, @[255'u8, 255, 255])
    let p6 = newPPM(ppmFileDiscriptorP6, 1, 1, @[255'u8, 255, 255])
  new result
  result.fileDiscriptor = fileDiscriptor
  result.col = col
  result.row = row
  result.max = data.max
  result.data = data

proc formatP3*(self: PPM): string =
  ## Return formatted string for PPM P3.
  runnableExamples:
    let p = newPPM(ppmFileDiscriptorP3, 1, 1, @[255'u8, 255, 255])
    doAssert p.formatP3 == "P3\n1 1\n255\n255 255 255"
  let data = self.data.toMatrixString 3
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{self.max}
{data}"""

proc formatP6*(self: PPM): seq[uint8] =
  ## Return formatted byte data for PPM P6.
  runnableExamples:
    let p = newPPM(ppmFileDiscriptorP6, 1, 1, @[255'u8, 255, 255])
    doAssert p.formatP6 == @[
      'P'.uint8, '6'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
      '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
      255'u8, 255, 255,
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

proc parsePPM*(s: string): PPM =
  ## Return PPM that is parsed from string.
  ## This proc is function for PPM P3.
  ## You should validate string to use this proc with `validatePPM proc
  ## <#validatePPM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert "P3\n1 1\n255\n255 255 255".parsePPM[] == newPPM(ppmFileDiscriptorP3, 1, 1, @[255'u8, 255, 255])[]
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
  ## Return PPM that is parsed from string.
  ## This proc is function for PPM P3.
  ## You should validate string to use this proc with `validatePPM proc
  ## <#validatePPM,openArray[uint8]>`_ .
  runnableExamples:
    doAssert @['P'.uint8, '6'.uint8, '\n'.uint8,
               '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
               '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
               255'u8, 255, 255
    ].parsePPM[] == newPPM(ppmFileDiscriptorP6, 1, 1, @[255'u8, 255, 255])[]
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

proc validatePPM*(s: openArray[uint8]) =
  ## Validate PPM data format.
  ##
  ## Validating contents are:
  ## 1. It is P3 or P6 that 2 byte data at the head.
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
    validatePPM(@['P'.uint8, '3'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8, '\n'.uint8,
                  '1'.uint8])
    validatePPM(@['P'.uint8, '6'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8, '\n'.uint8,
                  '1'.uint8])
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
  of ppmFileDiscriptorP3:
    result = f.readAll.parsePPM
  of ppmFileDiscriptorP6:
    result = data.parsePPM
  else: discard

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

proc writePPM*(f: File, data: PPM) =
  ## Write PPM (P3 or P6) to file.
  ## Raise IllegalFileDiscriptorError when illegal was found from file
  ## discriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPPM(ppmFileDiscriptorP3, 1, 1, @[1'u8])
      var f = open("p3.ppm", fmWrite)
      f.writePPM p1
      f.close
      removeFile "p3.ppm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
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
  ## Write PPM (P3 or P6) to file.
  ## Raise IllegalFileDiscriptorError when illegal was found from file
  ## discriptor.
  runnableExamples:
    from os import removeFile
    try:
      let p1 = newPPM(ppmFileDiscriptorP3, 1, 1, @[1'u8])
      writePPMFile "p3.ppm", p1
      removeFile "p3.ppm"
    except:
      stderr.writeLine getCurrentExceptionMsg()
  var f = open(fn, fmWrite)
  defer: f.close
  f.writePPM data

proc `$`*(self: PPM): string =
  result = $self[]