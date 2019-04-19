# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "pnm is library for PNM (Portable AnyMap)."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 0.19.4"

task docs, "Generate documents":
  exec "nimble doc src/pnm/pbm.nim -o:docs/pbm.html"
  exec "nimble doc src/pnm/pgm.nim -o:docs/pgm.html"
