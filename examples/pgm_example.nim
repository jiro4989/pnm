import pnm

from sequtils import repeat, concat
from strformat import `&`
import times

const blockSize = 5

let now = cpuTime()
const fn = "examples/ppm_example1.ppm"
echo &"Generating {fn}..."

let row = 400
let col = 100
var data: seq[uint8]
for i in 1..row:
  for j in 1'u8..col.uint8:
    data = data.concat j.repeat(blockSize)

var pgm = newPGM(pgmFileDiscriptorP5, col*blockSize, row, data)
writePGMFile fn, pgm

echo &"Success generating {fn}. times {cpuTime() - now} sec"
echo "--------------------------------"