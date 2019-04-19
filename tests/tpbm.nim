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
var pbm4 = new PBM
pbm4.fileDiscriptor = pbmFileDiscriptorP4
pbm4.col = pbm1.col
pbm4.row = pbm1.row
pbm4.data = pbm1.data

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
  
suite "removeCommentLine":
  var s: seq[uint8]
  test "normal":
    check @['a'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8, 'b'.uint8].removeCommentLine == @['a'.uint8, 'b'.uint8]
    check @['a'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8].removeCommentLine == @['a'.uint8]
    check @['#'.uint8, ' '.uint8, '\n'.uint8].removeCommentLine == s
  test "no comment":
    check @['a'.uint8, '\n'.uint8,
            'b'.uint8, '\n'.uint8,
            'c'.uint8, 
            ].removeCommentLine == @['a'.uint8, '\n'.uint8, 'b'.uint8, '\n'.uint8, 'c'.uint8]
  test "3 line":
    check @['a'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8,
            'b'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8,
            'c'.uint8, '#'.uint8, ' '.uint8, '\n'.uint8,
            ].removeCommentLine == @['a'.uint8, 'b'.uint8, 'c'.uint8]
  test "empty":
    check s.removeCommentLine == s

suite "formatP1":
  test "normal":
    check pbm1.formatP1 == pbm1str

suite "formatP4":
  test "normal":
    check pbm1.formatP4 == pbm1bin

suite "validatePBM":
  test "NoError":
    validatePBM(@['P'.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
    validatePBM(@['P'.uint8, '4'.uint8, '\n'.uint8,
                  '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                  '1'.uint8])
  test "IllegalFileDiscriptorError":
    expect IllegalFileDiscriptorError:
      validatePBM(@['P'.uint8, '9'.uint8, '\n'.uint8,
                    '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8])
  test "IllegalColumnRowError":
    expect IllegalColumnRowError:
      validatePBM(@['P'.uint8, '1'.uint8, '\n'.uint8,
                    'a'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8])
      validatePBM(@['P'.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8])
      validatePBM(@['P'.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8, ' '.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8])

suite "parsePBM(string)":
  test "normal":
    check pbm1str.parsePBM[] == pbm1[]

suite "parsePBM(openArray[uint8])":
  test "normal":
    check pbm1bin.parsePBM[] == pbm1[]

suite "readPBMFile":
  test "read p1 file":
    check readPBMFile("tests/out/p1.pbm")[] == pbm1[]
  test "read p4 file":
    check readPBMFile("tests/out/p4.pbm")[] == pbm4[]

suite "usecase":
  test "write P1":
    writeFile("tests/out/p1.pbm", pbm1.formatP1)
  test "write P4":
    var f = open("tests/out/p4.pbm", fmWrite)
    let bin = pbm4.formatP4
    discard f.writeBytes(bin, 0, bin.len)
    f.close
