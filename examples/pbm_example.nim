import pnm
from pnm/util import toBin

from sequtils import repeat, concat
from strformat import `&`
import times

const blockSize = 20

let now = cpuTime()
const fn = "examples/pbm_example.pbm"
echo &"Generating {fn}..."

let col = 20
let row = col * blockSize
var data: seq[uint8]
var bin: uint8
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