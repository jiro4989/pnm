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

import streams, strformat, strutils
from sequtils import map, mapIt, repeat, distribute

type
  PNM* = object
    descriptor*: Descriptor
    comment: string
    max: int
    image: Image
  Image* = object
    width*, height*: int
    data*: seq[Color]
  Descriptor* {.pure.} = enum
    P1, P2, P3, P4, P5, P6

  Color* = ref object of RootObj # base class
  ColorComponent* = uint8
  ColorBit* = ref object of Color
    bit: uint8 # 0 or 1
  ColorGray* = ref object of Color
    gray: ColorComponent
  ColorRGB* = ref object of Color
    red*, green*, blue*: ColorComponent

  IllegalFileDescriptorError* = object of Defect
    ## Return this when file descriptor is wrong.
    ## filedescriptors are P1 or P2 or P3 or P4 or P5 or P6.

proc newImage*(t: typedesc, width, height: int): Image =
  result = Image(width: width, height: height)
  let c: Color = t()
  result.data = repeat(c, width * height)

func toDescriptor(str: string): Descriptor =
  case str
  of "P1": P1
  of "P2": P2
  of "P3": P3
  of "P4": P4
  of "P5": P5
  of "P6": P6
  else:
    raise newException(IllegalFileDescriptorError, "IllegalFileDescriptor: file descriptor is " & str)

func bitSeqToByteSeq(arr: openArray[uint8], col: int): seq[uint8] =
  ## Returns sequences that binary sequence is converted to uint8 every 8 bits.
  var data: uint8
  var i = 0
  for u in arr:
    data = data shl 1
    data += u
    i.inc
    if i mod 8 == 0:
      result.add data
      data = 0'u8
      continue
    if i mod col == 0:
      data = data shl (8 - (i mod 8))
      result.add data
      data = 0'u8
      i = 0
  if data != 0:
    result.add data shl (8 - (i mod 8))

template w*(img: Image): int =
  img.width

template h*(img: Image): int =
  img.height

template b*(c: ColorBit): uint8 = c.bit
template g*(c: ColorGray): ColorComponent = c.gray
template r*(c: ColorRGB): ColorComponent = c.red
template g*(c: ColorRGB): ColorComponent = c.green
template b*(c: ColorRGB): ColorComponent = c.blue
template line*(img: Image, y: int): seq[Color] =
  let startPos = y * img.w
  img.data[startPos ..< startPos+img.w]

template `[]`*(img: Image, x, y: int): Color =
  img.data[x + y * img.w]

template `[]=`*(img: var Image, x, y: int, c: Color) =
  img.data[x + y * img.w] = c

method str(c: Color): string {.base.} = discard
method str(c: ColorBit): string = $c.b
method str(c: ColorGray): string = $c.g
method str(c: ColorRGB): string = &"{c.r} {c.g} {c.b}"

method bit(c: Color): uint8 {.base.} = discard
method bit(c: ColorBit): uint8 = c.b

method write(c: Color, strm: Stream) {.base.} =
  discard

method write(c: ColorBit, strm: Stream) =
  discard

method write(c: ColorGray, strm: Stream) =
  strm.write(c.g)

method write(c: ColorRGB, strm: Stream) =
  strm.write(c.r)
  strm.write(c.g)
  strm.write(c.b)

method high(c: Color): int {.base.} = int.high
method high(c: ColorBit): int = 1
method high(c: ColorGray): int = ColorComponent.high.int
method high(c: ColorRGB): int = ColorComponent.high.int

proc readDataPartOfTextData(strm: Stream, width, height, byteSize: int, rgb = false): seq[uint8] =
  ## for P2 or P3.
  let singleDataSize = width * height * byteSize
  let maxDataCount =
    if rgb: singleDataSize * 3
    else: singleDataSize
  var line: string
  var dataCounter: int
  while strm.readLine(line):
    for b in line.splitWhitespace().mapIt(it.parseUInt.uint8):
      result.add(b)
      inc(dataCounter)
      if maxDataCount <= dataCounter:
        return

proc readDataPartOfBinaryData(strm: Stream, width, height, byteSize: int, rgb = false): seq[uint8] =
  ## for P5 or P6.
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  let singleDataSize = width * height * byteSize
  let maxDataCount =
    if rgb: singleDataSize * 3
    else: singleDataSize
  var dataCounter: int
  while not strm.atEnd():
    result.add(strm.readUint8())
    inc(dataCounter)
    if maxDataCount <= dataCounter:
      return

proc toColorBitImage(bytes: seq[uint8], width, height: int): Image =
  result = newImage(ColorBit, width, height)
  result.data = bytes.map(proc(n: uint8): Color =
    var c: Color = ColorBit(bit: n)
    return c)

proc toColorGrayImage(bytes: seq[uint8], width, height: int): Image =
  result = newImage(ColorGray, width, height)
  result.data = bytes.map(proc(n: uint8): Color =
    var c: Color = ColorGray(gray: n)
    return c)

proc toColorRGBImage(bytes: seq[uint8], width, height: int): Image =
  result = newImage(ColorRGB, width, height)
  var data: seq[array[3, uint8]]
  var arr: array[3, uint8]
  for i, b in bytes:
    let m = i mod 3
    arr[m] = b
    if (i+1) mod 3 == 0:
      data.add(arr)
      arr = [0'u8, 0, 0]
  result.data = data.map(proc(n: array[3, uint8]): Color =
    var c: Color = ColorRGB(red: n[0], green: n[1], blue: n[2])
    return c)

proc readPNM*(strm: Stream): PNM =
  # read descriptor
  result.descriptor = strm.readLine().toDescriptor()

  # read comment line
  let b = strm.peekChar()
  if b == '#':
    discard strm.readChar() # remove comment prefix
    result.comment = strm.readLine()

  # read column size and row size
  let
    sizeLine = strm.readLine()
    wh = sizeLine.split(" ")
    width = wh[0].parseInt()
    height = wh[1].parseInt()

  # read max data
  case result.descriptor
  of P2, P3, P5, P6:
    result.max = strm.readLine().parseInt
  else: discard

  # body
  const byteSize = 1
  case result.descriptor
  of P1:
    let bytes = strm.readDataPartOfTextData(width, height, byteSize)
    result.image = bytes.toColorBitImage(width, height)
  of P2:
    let bytes = strm.readDataPartOfTextData(width, height, byteSize)
    result.image = bytes.toColorGrayImage(width, height)
  of P3:
    let bytes = strm.readDataPartOfTextData(width, height, byteSize, true)
    result.image = bytes.toColorRGBImage(width, height)
  of P4:
    # TODO
    # let bytes = strm.readDataPartOfTextData()
    # result.image = bytes.toColorBitImage(width, height)
    discard
  of P5:
    let bytes = strm.readDataPartOfBinaryData(width, height, byteSize)
    result.image = bytes.toColorGrayImage(width, height)
  of P6:
    let bytes = strm.readDataPartOfBinaryData(width, height, byteSize, true)
    result.image = bytes.toColorRGBImage(width, height)

proc writePNM*(strm: Stream, data: PNM) =
  let image = data.image
  # header
  strm.writeLine(data.descriptor)
  if data.comment != "":
    strm.writeLine("#" & data.comment)
  strm.writeLine($image.w & " " & $image.h)
  case data.descriptor
  of P2, P3, P5, P6:
    strm.writeLine($image[0, 0].high)
  else:
    discard

  # body
  case data.descriptor
  of P1, P2, P3:
    for y in 0..<image.h:
      let line = image.line(y)
      let lineStr = line.mapIt(it.str).join(" ")
      strm.writeLine(lineStr)
  of P4:
    let bits = image.data.mapIt(it.bit)
    var rows: seq[seq[uint8]]
    var row: seq[uint8]
    for bit in bits:
      row.add(bit)
      if image.w <= row.len:
        rows.add(row)
        row = @[]
    if 0 < row.len:
      rows.add(row)
    for row in rows:
      for b in row.bitSeqToByteSeq(8):
        strm.write(b)
  of P5, P6:
    for c in image.data:
      c.write(strm)

when not defined js:
  proc readPNMFile*(fn: string): PNM =
    var strm = newFileStream(fn, fmRead)
    defer: strm.close()
    result = strm.readPNM()

  proc writePNMFile*(fn: string, data: PNM) =
    var strm = newFileStream(fn, fmWrite)
    defer: strm.close()
    strm.writePNM(data)
