# Package

version       = "1.0.1"
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

task examples, "Run example code":
  for d in ["write_pbm", "write_pgm", "write_ppm", "read_file"]:
    withDir &"examples/{d}":
      exec "nim c -d:release main.nim"
      exec "./main"
      exec "echo -----------------------------"

task convert, "PNM to PNG":
  exec "convert examples/write_pbm/out.pbm -scale 200x200 docs/pbm_example.png"
  exec "convert examples/write_pgm/out.pgm -scale 500x400 docs/pgm_example.png"
  exec "convert examples/write_ppm/out1.ppm -scale 512x512 docs/ppm_example1.png"
  exec "convert examples/write_ppm/out2.ppm -scale 512x512 docs/ppm_example2.png"
  exec "convert examples/read_file/out1.ppm -scale 512x512 docs/ppm_example1.convert.png"

task ci, "Run CI tasks":
  exec "nimble test"
  exec "nimble docs"
  exec "nimble examples"
