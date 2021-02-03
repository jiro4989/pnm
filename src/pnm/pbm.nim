import streams, sequtils, strutils
import types, util
export types

proc readTextDataPartOfPBM(strm: Stream): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  # P1は空白文字があってもなくても良い
  var line: string
  while strm.readLine(line):
    result.add(toSeq(line.replace(" ", "").items).mapIt(it.uint8))

proc readBinaryDataPartOfPBM(strm: Stream): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  # P1は空白文字があってもなくても良い
  while not strm.atEnd:
    let ch = strm.readChar()

proc readPBM*(strm: Stream): PBM =
  result.header = strm.readHeaderPart()
  result.data =
    case result.header.descriptor
    of P1: strm.readTextDataPartOfPBM()
    of P4: strm.readBinaryDataPartOfPBM()
    else:
      raise newException(IllegalFileDescriptorError, "TODO")

proc readPBMFile*(file: string): PBM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPBM()

proc writePBMFile*(fn: string, data: PBM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  strm.writeDataPart(data.header, data.data)
