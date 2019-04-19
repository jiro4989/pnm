import unittest

include pnm/pgm

var pgm2 = new PGM
pgm2.fileDiscriptor = pbmFileDiscriptorP2
pgm2.col = 48
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

suite "usecase":
  test "write P2":
    discard