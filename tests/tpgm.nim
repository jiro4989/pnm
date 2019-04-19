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

const pgm2str = """P2
6 12
2
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
1 1 1 1 1 1
1 1 1 1 1 1
1 1 1 1 1 1
1 1 1 1 1 1
2 2 2 2 2 2
2 2 2 2 2 2
2 2 2 2 2 2
2 2 2 2 2 2"""

var pgm5 = new PGM
pgm5.fileDiscriptor = pgmFileDiscriptorP5
pgm5.col = pgm2.col
pgm5.row = pgm2.row
pgm5.max = pgm2.max
pgm5.data = pgm2.data

let pgm5bin = @[
  'P'.uint8, '5'.uint8, '\n'.uint8,
  '6'.uint8, ' '.uint8, '1'.uint8, '2'.uint8, '\n'.uint8,
  '2'.uint8, '\n'.uint8,
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


suite "formatP2":
  test "normal":
    check pgm2.formatP2 == pgm2str

suite "formatP5":
  test "normal":
    check pgm5.formatP5 == pgm5bin

suite "validatePGM":
  test "NoError P2":
    @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8,].validatePGM
  test "NoError P5":
    @['P'.uint8, '5'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8,].validatePGM
  test "IllegalFileDiscriptorError":
    expect IllegalFileDiscriptorError:
      @['P'.uint8, '3'.uint8, '\n'.uint8].validatePGM
      @['P'.uint8].validatePGM
      @[].validatePGM
  test "IllegalColumnRowError":
    expect IllegalColumnRowError:
      @['P'.uint8, '2'.uint8, '\n'.uint8, 'a'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, 'a'.uint8, '\n'.uint8, '1'.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, '1'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '\n'.uint8, '1'.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, ' '.uint8, '\n'.uint8, '1'.uint8, ].validatePGM
  test "IllegalMaxValueError":
    expect IllegalMaxValueError:
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, 'a'.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, ' '.uint8, ].validatePGM
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, ].validatePGM

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
