import pnm

import streams, unittest, os

const file = "tests"/"examples"/"p3.ppm"
check fileExists(file)

var strm = newFileStream(file, fmRead)
var p = strm.readPpm
var p2 = newPpm(P3, 5, 3, 255)
var i: int
for y in 0 ..< 3:
  for x in 0 ..< 5:
    p2[x, y] = newColorRgb(byte(i), byte(i+1), byte(i+2))
    inc i
check p[] == p2[]
strm.close
