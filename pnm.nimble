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
