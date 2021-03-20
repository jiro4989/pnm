## pnm is parser/generator of PNM (Portable Anymap).

import streams, strformat, strutils
from sequtils import map, mapIt, repeat, distribute

type
  Pnm* = ref PnmObj
  PnmObj* = object of RootObj
    descriptor: PnmFileDescriptor
    comment: string
    width, height, max: int

  Pbm* = ref PbmObj
  PbmObj* = object of PnmObj
    data: seq[ColorBit]

  Pgm* = ref PgmObj
  PgmObj* = object of PnmObj
    data: seq[ColorGray]

  Ppm* = ref PpmObj
  PpmObj* = object of PnmObj
    data: seq[ColorRgb]

  PnmFileDescriptor* {.pure.} = enum
    P1, P2, P3, P4, P5, P6

  ColorBit* = byte
  ColorGray* = byte
  ColorRgb* = array[3, byte]

  IllegalFileDescriptorError* = object of Defect
    ## Return this when file descriptor is wrong.
    ## filedescriptors are P1 or P2 or P3 or P4 or P5 or P6.

proc newColorRgb*(r, g, b: byte): ColorRgb =
  ColorRgb([r, g, b])

proc width*(p: Pnm): int = p.width
proc height*(p: Pnm): int = p.height

template validateDescriptorPbm(d: PnmFileDescriptor) =
  if d notin [P1, P4]:
    raise newException(IllegalFileDescriptorError, "the descriptor of PBM must be P1 or P4")

template validateDescriptorPgm(d: PnmFileDescriptor) =
  if d notin [P2, P5]:
    raise newException(IllegalFileDescriptorError, "the descriptor of PGM must be P2 or P5")

template validateRawStringDescriptorPbm(d: string) =
  if not (d.len == 3 and
     d[0] == 'P' and
     d[1] in ['1', '4'] and
     d[2] == '\n'):
    raise newException(IllegalFileDescriptorError, "the descriptor of PBM must be P1 or P4")

template validateRawStringDescriptorPgm(d: string) =
  if not (d.len == 3 and
     d[0] == 'P' and
     d[1] in ['2', '5'] and
     d[2] == '\n'):
    raise newException(IllegalFileDescriptorError, "the descriptor of PGM must be P2 or P5")

template validateDescriptorPpm(d: PnmFileDescriptor) =
  if d notin [P3, P6]:
    raise newException(IllegalFileDescriptorError, "the descriptor of PPM must be P3 or P6")

template validateRawStringDescriptorPpm(d: string) =
  if not (d.len == 3 and
     d[0] == 'P' and
     d[1] in ['3', '6'] and
     d[2] == '\n'):
    raise newException(IllegalFileDescriptorError, "the descriptor of PPM must be P3 or P6")

proc readDataPartOfTextData(strm: Stream, width, height, byteSize: int, rgb = false): seq[uint8] =
  ## for P1, P2, P3
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
      # 取得しうるデータ数以上取得する必要がないので早期リターン
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
    # 取得しうるデータ数以上取得する必要がないので早期リターン
    if maxDataCount <= dataCounter:
      return

func toDescriptor(str: string): PnmFileDescriptor =
  case str
  of "P1": P1
  of "P2": P2
  of "P3": P3
  of "P4": P4
  of "P5": P5
  of "P6": P6
  else:
    raise newException(IllegalFileDescriptorError, "IllegalFileDescriptor: file descriptor is " & str)

proc readDescriptor(strm: Stream): PnmFileDescriptor =
  strm.readLine().toDescriptor()

proc readComment(strm: Stream): string =
  let b = strm.peekChar
  if b == '#':
    discard strm.readChar # remove comment prefix
    result.add strm.readLine

proc readWidthHeight(strm: Stream): (int, int) =
  let
    sizeLine = strm.readLine
    wh = sizeLine.split(" ")
    width = wh[0].parseInt
    height = wh[1].parseInt
  return (width, height)

proc readMax(strm: Stream, d: PnmFileDescriptor): int =
  case d
  of P2, P3, P5, P6:
    return strm.readLine().parseInt
  else: discard

#[
================================================================================
                                      PBM
================================================================================
]#

proc newPbm*(descriptor: PnmFileDescriptor, width, height: int, comment = ""): Pbm =
  validateDescriptorPbm(descriptor)

  new result
  result.descriptor = descriptor
  result.width = width
  result.height = height
  result.comment = comment
  result.data = repeat(ColorBit(0'u8), width*height)

template line(p: Pbm, y: int): seq[ColorBit] =
  let startPos = y * p.width
  p.data[startPos ..< startPos+p.width]

proc `[]`*(p: Pbm, x, y: int): ColorBit =
  p.data[x + y * p.width]

proc `[]=`*(p: Pbm, x, y: int, color: ColorBit) =
  p.data[x + y * p.width] = color

proc `descriptor=`*(p: Pbm, descriptor: PnmFileDescriptor) =
  validateDescriptorPbm(descriptor)
  p.descriptor = descriptor

proc readPbm*(strm: Stream): Pbm =
  # P1 ~ P6しか取り得ないので 3byte だけ読み取ってバリデーション
  block:
    var d: string
    strm.peekStr(3, d)
    validateRawStringDescriptorPbm d

  new result

  # header
  result.descriptor = strm.readDescriptor
  result.comment = strm.readComment
  let (width, height) = strm.readWidthHeight
  result.width = width
  result.height = height

  # body
  const byteSize = 1
  case result.descriptor
  of P1: result.data = strm.readDataPartOfTextData(width, height, byteSize)
  of P4: result.data = strm.readDataPartOfBinaryData(width, height, byteSize)
  else: discard

proc writePbm*(strm: Stream, data: Pbm) =
  # header
  strm.writeLine(data.descriptor)
  if data.comment != "":
    strm.writeLine("#" & data.comment)
  strm.writeLine($data.width & " " & $data.height)

  # body
  case data.descriptor
  of P1:
    # TODO
    discard
  of P4:
    for c in data.data:
      strm.write(c)
  else: discard

#[
================================================================================
                                      PGM
================================================================================
]#

proc newPgm*(descriptor: PnmFileDescriptor, width, height, max: int, comment = ""): Pgm =
  validateDescriptorPgm(descriptor)

  new result
  result.descriptor = descriptor
  result.width = width
  result.height = height
  result.max = max
  result.comment = comment
  result.data = repeat(ColorGray(0'u8), width*height)

template line(p: Pgm, y: int): seq[ColorGray] =
  let startPos = y * p.width
  p.data[startPos ..< startPos+p.width]

proc `[]`*(p: Pgm, x, y: int): ColorGray =
  p.data[x + y * p.width]

proc `[]=`*(p: Pgm, x, y: int, color: ColorGray) =
  p.data[x + y * p.width] = color

proc `descriptor=`*(p: Pgm, descriptor: PnmFileDescriptor) =
  validateDescriptorPgm(descriptor)
  p.descriptor = descriptor

proc readPgm*(strm: Stream): Pgm =
  # P1 ~ P6しか取り得ないので 3byte だけ読み取ってバリデーション
  block:
    var d: string
    strm.peekStr(3, d)
    validateRawStringDescriptorPgm d

  new result

  # header
  result.descriptor = strm.readDescriptor
  result.comment = strm.readComment
  let (width, height) = strm.readWidthHeight
  result.width = width
  result.height = height
  result.max = strm.readMax(result.descriptor)

  # body
  const byteSize = 1
  case result.descriptor
  of P2: result.data = strm.readDataPartOfTextData(width, height, byteSize)
  of P5: result.data = strm.readDataPartOfBinaryData(width, height, byteSize)
  else: discard

proc writePgm*(strm: Stream, data: Pgm) =
  # header
  strm.writeLine(data.descriptor)
  if data.comment != "":
    strm.writeLine("#" & data.comment)
  strm.writeLine($data.width & " " & $data.height)
  strm.writeLine($high(ColorGray))

  # body
  case data.descriptor
  of P2:
    for y in 0..<data.height:
      let line = data.line(y)
      let lineStr = line.mapIt($it).join(" ")
      strm.writeLine(lineStr)
  of P5:
    for c in data.data:
      strm.write(c)
  else: discard

#[
================================================================================
                                      PPM
================================================================================
]#

proc newPpm*(descriptor: PnmFileDescriptor, width, height, max: int, comment = ""): Ppm =
  validateDescriptorPpm(descriptor)

  new result
  result.descriptor = descriptor
  result.width = width
  result.height = height
  result.max = max
  result.comment = comment
  result.data = repeat(ColorRgb([0'u8, 0, 0]), width*height)

template line(p: Ppm, y: int): seq[ColorRgb] =
  let startPos = y * p.width
  p.data[startPos ..< startPos+p.width]

template r*(c: ColorRGB): byte = c[0]
template g*(c: ColorRGB): byte = c[1]
template b*(c: ColorRGB): byte = c[2]

template `r=`*(c: ColorRGB, b: byte) = c[0] = b
template `g=`*(c: ColorRGB, b: byte) = c[1] = b
template `b=`*(c: ColorRGB, b: byte) = c[2] = b

proc `[]`*(p: Ppm, x, y: int): ColorRgb =
  p.data[x + y * p.width]

proc `[]=`*(p: Ppm, x, y: int, color: ColorRgb) =
  p.data[x + y * p.width] = color

proc `descriptor=`*(p: Ppm, descriptor: PnmFileDescriptor) =
  validateDescriptorPpm(descriptor)
  p.descriptor = descriptor

proc toColorRgb(bytes: seq[uint8]): seq[ColorRgb] =
  var data: seq[ColorRgb]
  var arr: ColorRgb
  for i, b in bytes:
    let m = i mod 3
    arr[m] = b
    if (i+1) mod 3 == 0:
      data.add(arr)
      arr = [0'u8, 0, 0]
  return data

proc readPpm*(strm: Stream): Ppm =
  # P1 ~ P6しか取り得ないので 3byte だけ読み取ってバリデーション
  block:
    var d: string
    strm.peekStr(3, d)
    validateRawStringDescriptorPpm d

  new result

  # header
  result.descriptor = strm.readDescriptor
  result.comment = strm.readComment
  let (width, height) = strm.readWidthHeight
  result.width = width
  result.height = height
  result.max = strm.readMax(result.descriptor)

  # body
  const byteSize = 3
  case result.descriptor
  of P3: result.data = strm.readDataPartOfTextData(width, height, byteSize).toColorRgb
  of P6: result.data = strm.readDataPartOfBinaryData(width, height, byteSize).toColorRgb
  else: discard

proc writePpm*(strm: Stream, data: Ppm) =
  # header
  strm.writeLine(data.descriptor)
  if data.comment != "":
    strm.writeLine("#" & data.comment)
  strm.writeLine($data.width & " " & $data.height)
  strm.writeLine($high(byte))

  # body
  case data.descriptor
  of P3:
    for y in 0..<data.height:
      let line = data.line(y)
      let lineStr = line.mapIt(&"{it.r} {it.g} {it.b}").join(" ")
      strm.writeLine(lineStr)
  of P6:
    for c in data.data:
      strm.write(c.r)
      strm.write(c.g)
      strm.write(c.b)
  else: discard

when not defined js:
  # ============================================================
  # reader
  # ============================================================

  proc readPgmFile*(file: string): Pgm =
    var strm = newFileStream(file, fmRead)
    defer: strm.close
    strm.readPgm

  proc readPpmFile*(file: string): Ppm =
    var strm = newFileStream(file, fmRead)
    defer: strm.close
    strm.readPpm

  # ============================================================
  # writer
  # ============================================================

  proc writePgmFile*(file: string, data: Pgm) =
    var strm = newFileStream(file, fmWrite)
    defer: strm.close
    strm.writePgm(data)

  proc writePpmFile*(file: string, data: Ppm) =
    var strm = newFileStream(file, fmWrite)
    defer: strm.close
    strm.writePpm(data)

