import unittest

include pnm/ppm

let col = 3
let row = 2
let max = 255
let data = @[
  255'u8, 0, 0,
  0, 255, 0,
  0, 0, 255,
  255, 255, 0,
  255, 255, 255,
  0, 0, 0,
]

let p1 = newPPM(ppmFileDiscriptorP3, col, row, data)
let p2 = newPPM(ppmFileDiscriptorP6, col, row, data)

const p1str = """P3
3 2
255
255 0 0
0 255 0
0 0 255
255 255 0
255 255 255
0 0 0"""

let p2bin = @[
  'P'.uint8, '6'.uint8, '\n'.uint8,
  '3'.uint8, ' '.uint8, '2'.uint8, '\n'.uint8,
  '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
  255'u8, 0, 0,
  0, 255'u8, 0,
  0, 0, 255'u8,
  255, 255, 0,
  255, 255, 255,
  0, 0, 0,
]


suite "formatP3":
  test "normal":
    check p1.formatP3 == p1str
  test "column size is 1":
    check newPPM(ppmFileDiscriptorP3, 1, 2, @[128'u8, 128, 128, 0, 0, 0]).formatP3 == "P3\n1 2\n128\n128 128 128\n0 0 0"

suite "formatP6":
  test "normal":
    check p2.formatP6 == p2bin
  test "column size is 1":
    check newPPM(ppmFileDiscriptorP6, 1, 2, @[128'u8, 128, 128, 0, 0, 0]).formatP6 == @[
      'P'.uint8, '6'.uint8, '\n'.uint8,
      '1'.uint8, ' '.uint8, '2'.uint8, '\n'.uint8,
      '1'.uint8, '2'.uint8, '8'.uint8, '\n'.uint8,
      128'u8, 128, 128,
      0, 0, 0,
    ]

suite "validatePPM":
  test "NoError P3":
    @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8,].validatePPM
  test "NoError P6":
    @['P'.uint8, '6'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8,].validatePPM
  test "IllegalFileDiscriptorError":
    expect IllegalFileDiscriptorError:
      @['P'.uint8, '4'.uint8, '\n'.uint8].validatePPM
      @['P'.uint8, 'a'.uint8, '\n'.uint8].validatePPM
      @['P'.uint8].validatePPM
      @['\n'.uint8].validatePPM
      @[].validatePPM
  test "IllegalColumnRowError":
    expect IllegalColumnRowError:
      @['P'.uint8, '3'.uint8, '\n'.uint8, 'a'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, 'a'.uint8, '\n'.uint8, '1'.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, '1'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '\n'.uint8, '1'.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, ' '.uint8, '\n'.uint8, '1'.uint8, ].validatePPM
  test "IllegalMaxValueError":
    expect IllegalMaxValueError:
      @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, 'a'.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, ' '.uint8, ].validatePPM
      @['P'.uint8, '3'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, ].validatePPM

suite "parsePPM(string)":
  test "normal":
    discard

suite "parsePPM(openArray[uint8])":
  test "normal":
    discard

suite "usecase":
  test "write P3":
    writePPMFile("tests/out/p3.ppm", p1)
  test "write P6":
    writePPMFile("tests/out/p6.ppm", p2)
  test "read P2":
    check readPPMFile("tests/out/p3.ppm")[] == p1[]
  test "read P5":
    check readPPMFile("tests/out/p6.ppm")[] == p2[]
