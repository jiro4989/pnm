import streams
import types, util
export types

proc readPPM*(strm: Stream): PPM =
  result.header = strm.readHeader()
  result.data = strm.readBinaryDataPart(result.header.descriptor)

proc readPPMFile*(file: string): PPM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPPM()

proc writePPMFile*(fn: string, data: PPM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  strm.writeDataPart(data.header, data.data)
