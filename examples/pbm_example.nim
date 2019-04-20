import pnm
from pnm/util import toBin

import times
from sequtils import repeat, concat
from strformat import `&`

let
  fn = "examples/pbm_example.pbm"
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

let pbm = newPBM(pbmFileDiscriptorP4, col*blockSize, row, data.toBin)
writePBMFile fn, pbm

echo &"Success generating {fn}. times {cpuTime() - now} sec"
echo "--------------------------------"