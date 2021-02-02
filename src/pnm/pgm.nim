import streams
import types, util
export types

proc readPGM*(strm: Stream): PGM =
  result.header = strm.readHeader()
  result.data = strm.readPGMPPMData(result.header.descriptor)

proc readPGMFile*(file: string): PGM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPGM()
