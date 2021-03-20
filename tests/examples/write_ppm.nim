discard """
  output: '''
P3
5 5
255
100 50 0 100 50 0 100 50 0 100 50 0 100 50 0
0 50 0 0 50 0 0 50 0 0 50 0 0 50 0
100 50 0 100 50 0 100 50 0 100 50 0 100 50 0
0 50 0 0 50 0 0 50 0 0 50 0 0 50 0
100 50 0 100 50 0 100 50 0 100 50 0 100 50 0
'''
"""

import pnm

import streams

var strm = newStringStream()
var p = newPpm(PnmFileDescriptor.P3, 5, 5, 255)

for y in 0 ..< p.height:
  for x in 0 ..< p.width:
    let b =
      if y mod 2 == 0: 100'u8
      else: 0'u8
    p[x, y] = newColorRgb(b, 50, 0)

strm.writePpm p
strm.setPosition 0
echo strm.readAll
strm.close
