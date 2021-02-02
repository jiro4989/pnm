import streams
from strutils import parseUint, split
from sequtils import mapIt
import types, util

proc readPPMP3*(strm: Stream): seq[uint8] =
  var line: string
  while strm.readLine(line):
    result.add(line.split(" ").mapIt(it.parseUInt.uint8))

proc readPPM*(strm: Stream): PPM =
  result.header = strm.readHeader()
  case result.header.descriptor
  of P3:
    result.data = strm.readPPMP3()
  of P6:
    result.data = strm.readAll().mapIt(it.uint8)
  else:
    # TODO: raise error
    discard

proc readPPMFile*(file: string): PPM =
  var strm = newFileStream(file)
  defer: strm.close()
  result = strm.readPPM()
