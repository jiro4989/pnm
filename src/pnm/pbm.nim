import streams
import types, util
export types

proc readPBM*(strm: Stream): PBM =
  result.header = strm.readHeader()
  result.data = strm.readBinaryDataPart(result.header.descriptor)

proc readPBMFile*(file: string): PBM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPBM()
