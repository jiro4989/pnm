import unittest

include pnm/ppm

var p1 = new PPM
p1.fileDiscriptor = ppmFileDiscriptorP3
p1.col = 3
p1.row = 2
p1.max = 255
p1.data = @[
  255'u8, 0, 0,
  0, 255, 0,
  0, 0, 255,
  255, 255, 0,
  255, 255, 255,
  0, 0, 0,
]

const p1str = """P3
3 2
255
255 0 0
0 255 0
0 0 255
255 255 0
255 255 255
0 0 0"""

var p2 = new PPM
p2.fileDiscriptor = ppmFileDiscriptorP6
p2.col = p1.col
p2.row = p1.row
p2.max = p1.max
p2.data = p1.data

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

suite "formatP6":
  test "normal":
    check p2.formatP6 == p2bin

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
    writeFile "tests/out/p3.ppm", p1.formatP3
  test "write P6":
    var f = open("tests/out/p6.ppm", fmWrite)
    let bin = p2.formatP6
    discard f.writeBytes(bin, 0, bin.len)
    f.close
  test "read P2":
    check readPPMFile("tests/out/p3.ppm")[] == p1[]
  test "read P5":
    check readPPMFile("tests/out/p6.ppm")[] == p2[]
