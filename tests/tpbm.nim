import unittest
from sequtils import repeat

include pnm/pbm

var pbm1 = new PBM
pbm1.fileDiscriptor = pbmFileDiscriptorP1
pbm1.col = 32
pbm1.row = 12
pbm1.data = @[
  0b11111111'u8, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
]

let pbm1str = """P1
32 12
1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"""

let pbm1bin = @[
  'P'.uint8, '1'.uint8, '\n'.uint8,
  '3'.uint8, '2'.uint8, ' '.uint8, '1'.uint8, '2'.uint8, '\n'.uint8,
  0b11111111'u8, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b00000000, 0b11111111, 0b00000000,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b11111111, 0b11111111, 0b11111111, 0b11111111,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
  0b00000000, 0b00000000, 0b00000000, 0b00000000,
]

suite "toBinSeq":
  test "0b0000_0000":
    check 0'u8.toBinSeq == 0'u8.repeat(8)
  test "0b1010_1010":
    check 0b1010_1010.toBinSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]

suite "toBin":
  test "1 1 1 1 0 0 0 0":
    check @[1'u8, 1, 1, 1, 0, 0, 0, 0].toBin == @[0b1111_0000'u8]
  test "1 1 1 1 1 1":
    check @[1'u8, 1, 1, 1, 1, 1].toBin == @[0b1111_1100'u8]
  test "empty":
    var s: seq[uint8]
    check s.toBin == s

suite "formatP1":
  test "normal":
    check pbm1.formatP1 == pbm1str

suite "formatP4":
  test "normal":
    check pbm1.formatP4 == pbm1bin

suite "parsePBM(string)":
  test "normal":
    check pbm1str.parsePBM[] == pbm1[]

suite "parsePBM(openArray[uint8])":
  test "normal":
    check pbm1bin.parsePBM[] == pbm1[]

suite "usecase":
  test "write P1":
    writeFile("tests/out/p1.pbm", pbm1.formatP1)
  test "write P4":
    pbm1.fileDiscriptor = pbmFileDiscriptorP4
    var f = open("tests/out/p4.pbm", fmWrite)
    let bin = pbm1.formatP4
    discard f.writeBytes(bin, 0, bin.len)
    f.close