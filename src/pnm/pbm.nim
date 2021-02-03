import streams, sequtils, strutils
import types, util
export types

proc readTextDataPartOfPBM(strm: Stream): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  # P1は空白文字があってもなくても良い
  var line: string
  while strm.readLine(line):
    result.add(toSeq(line.replace(" ", "").items).mapIt(it.uint8))

proc toBinSeq(b: uint8): seq[uint8] =
  ## Return binary sequence from each bits of uint8.
  runnableExamples:
    from sequtils import repeat
    doAssert 0'u8.toBinSeq == 0'u8.repeat(8)
    doAssert 0b1010_1010.toBinSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]
  var c = b
  for i in 1..8:
    result.add (uint8(c and 0b1000_0000) shr 7)
    c = c shl 1

proc readBinaryDataPartOfPBM(strm: Stream, columnSize: int): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  # P1は空白文字があってもなくても良い
  var rowBin: seq[uint8]
  while not strm.atEnd:
    let bins = strm.readChar().uint8.toBinSeq()
    for b in bins:
      rowBin.add(b)
      if columnSize <= rowBin.len:
        result.add(rowBin)
        rowBin = @[]
        break

proc readPBM*(strm: Stream): PBM =
  result.header = strm.readHeaderPart()
  result.data =
    case result.header.descriptor
    of P1: strm.readTextDataPartOfPBM()
    of P4: strm.readBinaryDataPartOfPBM(result.header.col)
    else:
      raise newException(IllegalFileDescriptorError, "TODO")

proc readPBMFile*(file: string): PBM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPBM()

proc writeBinaryDataPartOfPBM(strm: Stream, data: seq[uint8], columnSize: int) =
  discard

proc writePBMFile*(fn: string, data: PBM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  case data.header.descriptor
  of P1: strm.writeTextDataPart(data.data, data.header.row, "")
  of P4: strm.writeBinaryDataPartOfPBM(data.data, data.header.col)
  else:
    raise newException(IllegalFileDescriptorError, "TODO")
