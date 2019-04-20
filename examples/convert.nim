import pnm

from sequtils import mapIt
from strformat import `&`
from algorithm import reverse

# PBM
block:
  # switch 0 <--> 1
  let
    base = "examples"
    fn = "pbm_example"

  var p = readPBMFile(&"{base}/{fn}.pbm")
  p.data = p.data.mapIt(it xor 0b1111_1111)

  let outFn = &"{base}/{fn}.convert.pbm"
  writePBMFile(outFn, p)
  echo &"Success generating {outFn}"

# PGM
block:
  # reverse
  let
    base = "examples"
    fn = "pgm_example"

  var p = readPGMFile(&"{base}/{fn}.pgm")
  p.data.reverse

  let outFn = &"{base}/{fn}.convert.pgm"
  writePGMFile(outFn, p)
  echo &"Success generating {outFn}"

# PPM
block:
  for i in 1..2:
    # + 126
    let
      base = "examples"
      fn = &"ppm_example{i}"

    var p = readPPMFile(&"{base}/{fn}.ppm")
    p.data = p.data.mapIt(it+126)

    let outFn = &"{base}/{fn}.convert.ppm"
    writePPMFile(outFn, p)
    echo &"Success generating {outFn}"