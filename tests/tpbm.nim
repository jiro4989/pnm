import unittest
from sequtils import repeat

import pnm/pbm as pbm

suite "newPBM":
  test "normal":
    check @[@[0'u8, 0'u8, 0'u8], @[0'u8, 1'u8, 0'u8]].newPBM()[] == 
      PBM(row: 2,
          col: 3,
          data: @[@[0'u8, 0'u8, 0'u8], @[0'u8, 1'u8, 0'u8]])[]

suite "format":
  test "normal":
    check PBM(fileDiscriptor: pbmFileDiscriptorP1,
            row: 2,
            col: 3,
            data: @[@[0'u8, 0'u8, 0'u8], @[0'u8, 1'u8, 0'u8]]).formatP1() ==
          """P1
3 2
0 0 0
0 1 0"""

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