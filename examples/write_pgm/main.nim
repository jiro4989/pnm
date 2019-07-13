import pnm

import times
from sequtils import repeat, concat
from strformat import `&`

let
  fn = "out.pgm"
  blockSize = 5
  now = cpuTime()
  col = 100
  row = 400

echo &"Generating {fn}..."

var data: seq[uint8]
for i in 1..row:
  for j in 1'u8..col.uint8:
    data = data.concat j.repeat(blockSize)

let pgm = newPGM(pgmFileDescriptorP5, col*blockSize, row, data)
writePGMFile fn, pgm

echo &"Success generating {fn}. times {cpuTime() - now} sec"
