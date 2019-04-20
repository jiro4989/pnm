import unittest

include pnm/pgm

let col = 6
let row = 12
let max = 2
let data = @[
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

let data2 = @[
  0'u8, 0, 0, 0, 0, 0,
  0'u8, 0, 0, 0, 0, 0,
  0'u8, 0, 0, 0, 0, 0,
  0'u8, 0, 0, 0, 0, 0,
  10, 10, 10, 10, 10, 10,
  10, 10, 10, 10, 10, 10,
  10, 10, 10, 10, 10, 10,
  10, 10, 10, 10, 10, 10,
  20, 20, 20, 20, 20, 20,
  20, 20, 20, 20, 20, 20,
  20, 20, 20, 20, 20, 20,
  20, 20, 20, 20, 20, 20,
]

let pgm2 = newPGM(pgmFileDiscriptorP2, col, row, data)
let pgm5 = newPGM(pgmFileDiscriptorP5, col, row, data)
let pgm2_2 = newPGM(pgmFileDiscriptorP2, 6, 12, data2)

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

const pgm2_2str = """P2
6 12
20
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
10 10 10 10 10 10
10 10 10 10 10 10
10 10 10 10 10 10
10 10 10 10 10 10
20 20 20 20 20 20
20 20 20 20 20 20
20 20 20 20 20 20
20 20 20 20 20 20"""

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
  test "number of data part is over 10":
    check pgm2_2.formatP2 == pgm2_2str

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

suite "parsePGM(string)":
  test "normal":
    discard

suite "parsePGM(openArray[uint8])":
  test "normal":
    discard

suite "usecase":
  test "write P2":
    writePGMFile("tests/out/p2.pgm", pgm2)
  test "write P5":
    writePGMFile("tests/out/p5.pgm", pgm5)
  test "read P2":
    check readPGMFile("tests/out/p2.pgm")[] == pgm2[]
  test "read P5":
    check readPGMFile("tests/out/p5.pgm")[] == pgm5[]