import streams
import types, util
export types

proc readPGM*(strm: Stream): PGM =
  result.header = strm.readHeaderPart()
  result.data = strm.readDataPart(result.header.descriptor)

proc readPGMFile*(file: string): PGM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPGM()

proc writePGMFile*(fn: string, data: PGM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  strm.writeDataPart(data.header, data.data)
