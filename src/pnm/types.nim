import streams, strformat
from sequtils import mapIt

type
  Header* = object
    descriptor*: Descriptor
    col*, row*: int
    max*: uint8
  PBM* = object
    header*: Header
    data*: seq[uint8]
  PGM* = object
    header*: Header
    data*: seq[uint8]
  PPM*[T: ColorRGB] = object
    header*: Header
    body*: Image[T]
  Descriptor* {.pure.} = enum
    P1, P2, P3, P4, P5, P6
  Image[T: Color] = object
    width*, height*: int
    data*: seq[T]
  Color* = ref object of RootObj # base class
  ColorComponent* = uint8
  ColorBit* = ref object of Color
    bit: uint8 # 0 or 1
  ColorGray* = ref object of Color
    gray: ColorComponent
  ColorRGB* = ref object of Color
    red*, green*, blue*: ColorComponent
  Point* = object
    x*, y*: int
  IllegalFileDescriptorError* = object of Defect
    ## Return this when file descriptor is wrong.
    ## filedescriptors are P1 or P2 or P3 or P4 or P5 or P6.

func newPBM*(descriptor: Descriptor, col, row: int): PBM =
  let h = Header(descriptor: descriptor, col: col, row: row)
  return PBM(header: h)

func newPGM*(descriptor: Descriptor, col, row: int, max: uint8): PGM =
  let h = Header(descriptor: descriptor, col: col, row: row, max: max)
  return PGM(header: h)

func newPPM*(descriptor: Descriptor, col, row: int, max: uint8): PPM =
  let h = Header(descriptor: descriptor, col: col, row: row, max: max)
  return PPM(header: h)

func isPgmPnmDescriptor*(d: Descriptor): bool =
  return d in @[P2, P3, P5, P6]

func toDescriptor*(str: string): Descriptor =
  case str
  of "P1": P1
  of "P2": P2
  of "P3": P3
  of "P4": P4
  of "P5": P5
  of "P6": P6
  else:
    raise newException(IllegalFileDescriptorError, "IllegalFileDescriptor: file descriptor is " & str)

template w*(img: Image): int =
  img.width

template h*(img: Image): int =
  img.height

template b*(c: ColorBit): uint8 = c.bit
template g*(c: ColorGray): ColorComponent = c.gray
template r*(c: ColorRGB): ColorComponent = c.red
template g*(c: ColorRGB): ColorComponent = c.green
template b*(c: ColorRGB): ColorComponent = c.blue
template line*[T: Color](img: Image[T], y: int): seq[T] =
  let startPos = y * img.w
  img.data[startPos ..< startPos+img.w]

template `[]`*(img: Image, x, y: int): Color =
  img.data[x + y * img.w]

template `[]`*(img: Image, p: Point): Color =
  img[p.x, p.y]

template `[]=`*(img: var Image, x, y: int, c: Color) =
  img.data[x + y * img.w] = c

template `[]=`*(img: var Image, p: Point, c: Color) =
  img[p.x, p.y] = c

method str(c: Color): string {.base.} = discard
method str(c: ColorBit): string = $c[]
method str(c: ColorGray): string = $c[]
method str(c: ColorRGB): string = &"{c.r} {c.g} {c.b}"

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

proc writeFile*(fn: string, data: Image, descr: Descriptor, comment = "") =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()

  # header
  strm.writeLine(descr)
  if comment != "":
    strm.writeLine("#" & comment)
  strm.writeLine($data.w & " " & $data.h)
  case descr
  of P2, P3, P5, P6:
    strm.writeLine($data[0, 0].high)
  else:
    discard

  # body
  case descr
  of P1, P2, P3:
    for y in 0..<data.y:
      let line = data.line[y]
      let lineStr = line.mapIt(it.str).join(" ")
      strm.writeLine(lineStr)
  else:
    discard

