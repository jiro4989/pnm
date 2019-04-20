import pnm

from sequtils import repeat, concat
from strformat import `&`
import times

const blockSize = 2

block:
  let now = cpuTime()
  const fn = "examples/ppm_example1.ppm"
  echo &"Generating {fn}..."

  var data: seq[uint8]
  const b = 0'u8
  for g in 0'u8..255:
    for r in 0'u8..255:
      for color in @[r, g, b].repeat(blockSize):
        data = data.concat color

  let
    col = 255 * blockSize
    row = 255
    ppm = newPPM(ppmFileDiscriptorP6, col, row, data)

  writePPMFile fn, ppm

  echo &"Success generating {fn}. times {cpuTime() - now} sec"
  echo "--------------------------------"

block:
  let now = cpuTime()
  const fn = "examples/ppm_example2.ppm"
  echo &"Generating {fn}..."

  var data: seq[uint8]
  for g in 0'u8..255:
    for r in 0'u8..255:
      for color in @[r, g, r*g].repeat(blockSize):
        data = data.concat color

  let
    col = 255 * blockSize
    row = 255
    ppm = newPPM(ppmFileDiscriptorP6, col, row, data)

  writePPMFile fn, ppm

  echo &"Success generating {fn}. times {cpuTime() - now} sec"
  echo "--------------------------------"
