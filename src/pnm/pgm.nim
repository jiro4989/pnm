import streams
import types, util
export types

proc readPGM*(strm: Stream): PGM =
  result.header = strm.readHeaderPart()
  result.data =
    case result.header.descriptor
    of P2: strm.readTextDataPart()
    of P5: strm.readBinaryDataPart()
    else:
      raise newException(IllegalFileDescriptorError, "TODO")

proc readPGMFile*(file: string): PGM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPGM()

proc writePGMFile*(fn: string, data: PGM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  case data.header.descriptor
  of P2: strm.writeTextDataPartOfPGMOrPPM(data.data, data.header.row, " ")
  of P5: strm.writeBinaryDataPart(data.data)
  else:
    raise newException(IllegalFileDescriptorError, "TODO")
