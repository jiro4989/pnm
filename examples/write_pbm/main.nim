import pnm
from pnm/util import toBin

import times
from sequtils import repeat, concat
from strformat import `&`

block:
  let
    fn = "out.pbm"
    blockSize = 20
    now = cpuTime()
    col = 20
    row = col * blockSize

  echo &"Generating {fn}..."

  var
    data: seq[uint8]
    bin: uint8

  for i in 1..row:
    for j in 1..col:
      bin = bin xor 1
      data = data.concat bin.repeat(blockSize)
    if i mod blockSize == 0:
      bin = bin xor 1

  let pbm = newPBM(pbmFileDescriptorP4, col*blockSize, row, data.toBin)
  writePBMFile fn, pbm

  echo &"Success generating {fn}. times {cpuTime() - now} sec"

block:
  let col = 5
  let row = 5
  let data = @[
    0'u8, 0, 1, 0, 0,
    0,    1, 1, 0, 0,
    0,    0, 1, 0, 0,
    0,    0, 1, 0, 0,
    0,    1, 1, 1, 0,
  ]
  let pbm = newPBM(pbmFileDescriptorP4, col, row, data.toBin(5))
  writePBMFile("1.pbm", pbm)
