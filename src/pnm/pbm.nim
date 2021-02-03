import streams, sequtils, strutils
import types, util
export types

proc readTextDataPartOfPBM(strm: Stream): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  # P1は空白文字があってもなくても良い
  var line: string
  while strm.readLine(line):
    result.add(toSeq(line.replace(" ", "").items).mapIt(it.uint8))

proc toBitSeq(b: uint8): seq[uint8] =
  ## Return binary sequence from each bits of uint8.
  runnableExamples:
    from sequtils import repeat
    doAssert 0'u8.toBitSeq == 0'u8.repeat(8)
    doAssert 0b1010_1010.toBitSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]
  var c = b
  for i in 1..8:
    result.add (uint8(c and 0b1000_0000) shr 7)
    c = c shl 1

proc readBinaryDataPartOfPBM(strm: Stream, columnSize: int): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  # P1は空白文字があってもなくても良い
  var rowBin: seq[uint8]
  while not strm.atEnd:
    let bins = strm.readChar().uint8.toBitSeq()
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

func bitSeqToByteSeq(arr: openArray[uint8], col: int =  8): seq[uint8] =
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

func headTail[T](data: seq[T], size: int): (seq[T], seq[T]) =
  if data.len < size:
    result[0] = data
    return
  result[0] = data[0..<size]
  result[1] = data[size..^1]

proc writeBinaryDataPartOfPBM(strm: Stream, data: seq[uint8], columnSize: int) =
  var data = data
  while 0 < data.len:
    var head: seq[uint8]
    (head, data) = data.headTail(columnSize)
    for b in head.bitSeqToByteSeq(columnSize):
      strm.write(b)

proc writePBMFile*(fn: string, data: PBM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  case data.header.descriptor
  of P1: strm.writeTextDataPart(data.data, data.header.row, "")
  of P4: strm.writeBinaryDataPartOfPBM(data.data, data.header.col)
  else:
    raise newException(IllegalFileDescriptorError, "TODO")

when isMainModule:
  from sequtils import repeat
  doAssert 0'u8.toBitSeq == 0'u8.repeat(8)
  doAssert 0b1010_1010.toBitSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]

  doAssert @[1'u8, 1, 1, 1, 0, 0, 0, 0].bitSeqToByteSeq == @[0b1111_0000'u8]
  doAssert @[1'u8, 1, 1, 1, 1, 1].bitSeqToByteSeq == @[0b1111_1100'u8]

  doAssert @[1, 2, 3, 4].headTail(2) == (@[1, 2], @[3, 4])
  doAssert @[1, 2, 3, 4].headTail(4) == (@[1, 2, 3, 4], @[])
  doAssert @[1, 2, 3, 4].headTail(5) == (@[1, 2, 3, 4], @[])
