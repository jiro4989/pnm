import pnm

from sequtils import mapIt
from strformat import `&`
from algorithm import reverse

# PBM
block:
  # switch 0 <--> 1
  let
    base = "../write_pbm"
    fn = "out.pbm"

  var p = readPBMFile(&"{base}/{fn}")
  p.data = p.data.mapIt(it xor 0b1111_1111)

  writePBMFile(fn, p)
  echo &"Success generating {fn}"

# PGM
block:
  # reverse
  let
    base = "../write_pgm"
    fn = "out.pgm"

  var p = readPGMFile(&"{base}/{fn}")
  p.data.reverse

  writePGMFile(fn, p)
  echo &"Success generating {fn}"

# PPM
block:
  for i in 1..2:
    # + 126
    let
      base = "../write_ppm"
      fn = &"out{i}.ppm"

    var p = readPPMFile(&"{base}/{fn}")
    p.data = p.data.mapIt(it+126)

    writePPMFile(fn, p)
    echo &"Success generating {fn}"
