import pnm

import times
from sequtils import repeat, concat
from strformat import `&`

let blockSize = 2

block:
  let
    now = cpuTime()
    fn = "out1.ppm"
    col = 255
    row = 255
    b = 0'u8

  echo &"Generating {fn}..."

  var data: seq[uint8]
  for g in 0'u8..row.uint8:
    for r in 0'u8..col.uint8:
      for color in @[r, g, b].repeat(blockSize):
        data = data.concat color

  let ppm = newPPM(ppmFileDescriptorP6, col*blockSize, row, data)
  writePPMFile fn, ppm

  echo &"Success generating {fn}. times {cpuTime() - now} sec"
  echo "--------------------------------"

block:
  let
    fn = "out2.ppm"
    now = cpuTime()
    col = 255
    row = 255

  echo &"Generating {fn}..."

  var data: seq[uint8]
  for g in 0'u8..row.uint8:
    for r in 0'u8..col.uint8:
      for color in @[r, g, r*g].repeat(blockSize):
        data = data.concat color

  let ppm = newPPM(ppmFileDescriptorP6, col*blockSize, row, data)
  writePPMFile fn, ppm

  echo &"Success generating {fn}. times {cpuTime() - now} sec"
