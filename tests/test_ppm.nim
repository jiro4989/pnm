import unittest, os

include pnm/ppm

const
  inputDataDir = "tests"/"in"
  outputDataDir = "tests"/"out"

suite "proc readPPM":
  test "P3":
    var strm = newStringStream("""
P3
2 2
100
50 100
25  75
""")
    let got = strm.readPPM()
    check got.header.descriptor == P3
    check got.header.col == 2
    check got.header.row == 2
    check got.header.max == 100'u8
    check got.data == @[
      50'u8, 100,
      25, 75,
    ]

suite "proc readPPMFile":
  test "P3":
    let got = readPPMFile(inputDataDir/"p3.ppm")
    check got.header.descriptor == P3
    check got.header.col == 3
    check got.header.row == 1
    check got.header.max == 255'u8
    check got.data == @[
      255'u8, 0, 0,
      0, 255'u8, 0,
      0, 0, 255'u8,
    ]

suite "proc writePPMFile":
  test "0b1111_1111":
    discard
