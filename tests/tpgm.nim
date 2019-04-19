import unittest

include pnm/pgm

var pgm2 = new PGM
pgm2.fileDiscriptor = pgmFileDiscriptorP2
pgm2.col = 6
pgm2.row = 12
pgm2.max = 2
pgm2.data = @[
  0'u8, 0, 0, 0, 0, 0,
  0'u8, 0, 0, 0, 0, 0,
  0'u8, 0, 0, 0, 0, 0,
  0'u8, 0, 0, 0, 0, 0,
  1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2,
]

var pgm5 = new PGM
pgm5.fileDiscriptor = pgmFileDiscriptorP5
pgm5.col = pgm2.col
pgm5.row = pgm2.row
pgm5.max = pgm2.max
pgm5.data = pgm2.data

suite "usecase":
  test "read P2":
    check readPGMFile("tests/out/p2.pgm")[] == pgm2[]
  test "read P5":
    check readPGMFile("tests/out/p5.pgm")[] == pgm5[]
  test "write P2":
    writeFile "tests/out/p2.pgm", pgm2.formatP2
  test "write P5":
    var f = open("tests/out/p5.pgm", fmWrite)
    let bin = pgm5.formatP5
    discard f.writeBytes(bin, 0, bin.len)
    f.close
