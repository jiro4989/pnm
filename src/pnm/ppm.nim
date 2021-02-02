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
