import pnm

import streams, unittest, os

const file = "tests"/"examples"/"p2.pgm"
check fileExists(file)

var strm = newFileStream(file, fmRead)
var p = strm.readPgm
var p2 = newPgm(P2, 5, 3, 255)
var i: int
for y in 0 ..< 3:
  for x in 0 ..< 5:
    p2[x, y] = ColorGray(i)
    inc i
check p[] == p2[]
strm.close
