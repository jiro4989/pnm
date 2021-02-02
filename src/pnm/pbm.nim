import streams
import types, util
export types

proc readPBM*(strm: Stream): PBM =
  result.header = strm.readHeaderPart()
  result.data = strm.readDataPart(result.header.descriptor)

proc readPBMFile*(file: string): PBM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPBM()

proc writePBMFile*(fn: string, data: PBM) =
  var strm = newFileStream(fn, fmWrite)
  defer: strm.close()
  strm.writeHeaderPart(data.header)
  strm.writeDataPart(data.header, data.data)
