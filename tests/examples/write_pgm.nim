discard """
  output: '''
P2
5 5
255
0 0 0 0 0
1 1 1 1 1
0 0 0 0 0
1 1 1 1 1
0 0 0 0 0
'''
"""

import pnm

import streams

var strm = newStringStream()
var p = newPgm(PnmFileDescriptor.P2, 5, 5, 255)

for y in 0 ..< p.height:
  for x in 0 ..< p.width:
    let b =
      if y mod 2 == 0: 0'u8
      else: 1'u8
    p[x, y] = ColorBit(b)

strm.writePgm p
strm.setPosition 0
echo strm.readAll
strm.close
