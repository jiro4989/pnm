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

suite "toBinSeq":
  test "0b0000_0000":
    check 0'u8.toBinSeq == 0'u8.repeat(8)
  test "0b1010_1010":
    check 0b1010_1010.toBinSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]

suite "formatP1":
  test "normal":
    check pbm1.formatP1 == """P1
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

when false:
  suite "parsePBMASCII":
    test "normal":
      check pbm.parsePBM("""P1
  3 2
  0 0 0
  0 1 0""")[] == PBM(fileDiscriptor: pbmFileDiscriptorP1,
                  row: 2,
                  col: 3,
                  data: @[@[0'u8, 0'u8, 0'u8], @[0'u8, 1'u8, 0'u8]])[]
    test "comment exists":
      check pbm.parsePBM("""P1
  # comment
  3 2
  0 0 0
  0 1 0""")[] == PBM(fileDiscriptor: pbmFileDiscriptorP1,
                  row: 2,
                  col: 3,
                  data: @[@[0'u8, 0'u8, 0'u8], @[0'u8, 1'u8, 0'u8]])[]
    test "illegal data":
      check pbm.parsePBM("""P1
  2 3""")[] == PBM()[]
      check pbm.parsePBM("""P1
  2""")[] == PBM()[]
      check pbm.parsePBM("""P1
  """)[] == PBM()[]

  suite "generate PBM file":
    let p = newPBM(@[
      0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64),
      1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64),
      0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64),
      1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64),
      0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64),
      1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64),
      0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64), 0'u8.repeat(64),
      1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64), 1'u8.repeat(64),
      ])
    test "ASCII (P1)":
      writeFile("tests/out/ascii.pbm", p.formatP1)
    test "Binary (P4)":
      var f = open("tests/out/binary.pbm", fmWrite)
      let bin = p.formatP4
      echo bin
      discard f.writeBytes(bin, 0, len(bin))
      f.close