# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "pnm is library for PNM (Portable AnyMap)."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.4"

import strformat

task docs, "Generate documents":
  for f in ["errors", "pbm", "pgm", "ppm", "util", "validator"]:
    exec &"nimble doc src/pnm/{f}.nim -o:docs/{f}.html"
  exec "nimble doc src/pnm.nim -o:docs/pnm.html"

task examples, "Execute example code":
  exec "nim c -d:release examples/pbm_example.nim"
  exec "./examples/pbm_example"

  exec "nim c -d:release examples/pgm_example.nim"
  exec "./examples/pgm_example"

  exec "nim c -d:release examples/ppm_example.nim"
  exec "./examples/ppm_example"

  exec "nim c -d:release examples/convert.nim"
  exec "./examples/convert"

task convert, "PNM to PNG":
  exec "convert examples/pbm_example.pbm -scale 200x200 docs/pbm_example.png"
  exec "convert examples/pgm_example.pgm -scale 500x400 docs/pgm_example.png"
  exec "convert examples/ppm_example1.ppm -scale 512x512 docs/ppm_example1.png"
  exec "convert examples/ppm_example2.ppm -scale 512x512 docs/ppm_example2.png"
  exec "convert examples/ppm_example1.convert.ppm -scale 512x512 docs/ppm_example1.convert.png"