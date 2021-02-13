import streams
import types, util
export types

when false:
  proc readPPM*(strm: Stream): PPM =
    result.header = strm.readHeaderPart()
    result.data =
      case result.header.descriptor
      of P3: strm.readTextDataPart()
      of P6: strm.readBinaryDataPart()
      else:
        raise newException(IllegalFileDescriptorError, "TODO")

  proc readPPMFile*(file: string): PPM =
    var strm = newFileStream(file)
    defer: strm.close()
    result = strm.readPPM()

  proc writePPMFile*(fn: string, data: PPM) =
    var strm = newFileStream(fn, fmWrite)
    defer: strm.close()
    strm.writeHeaderPart(data.header)
    case data.header.descriptor
    of P3: strm.writeTextDataPart(data.data, data.header.row * 3, " ")
    of P6: strm.writeBinaryDataPart(data.data)
    else:
      raise newException(IllegalFileDescriptorError, "TODO")
