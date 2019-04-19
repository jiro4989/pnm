import unittest

import pnm/pgm as pgm

suite "encode":
  test "normal":
    check @[@[0'u8, 1, 2], @[3'u8, 4, 5]].encode()[] == 
      PGM(fileDiscriptor: fileDiscriptor,
            row: 2,
            col: 3,
            max: 5,
            data: @[@[0'u8, 1, 2], @[3'u8, 4, 5]])[]

suite "format":
  test "normal":
    check PGM(fileDiscriptor: fileDiscriptor,
            row: 2,
            col: 3,
            max: 5,
            data: @[@[0'u8, 1, 2], @[3'u8, 4, 5]]).format() ==
          """P2
3 2
5
0 1 2
3 4 5"""

suite "decode":
  test "normal":
    check pgm.decode("""P2
3 2
5
0 1 2
3 4 5""")[] == PGM(fileDiscriptor: fileDiscriptor,
                 row: 2,
                 col: 3,
                 max: 5,
                 data: @[@[0'u8, 1, 2], @[3'u8, 4, 5]])[]
  test "comment exists":
    check pgm.decode("""P2
# comment
3 2
5
0 1 2
3 4 5""")[] == PGM(fileDiscriptor: fileDiscriptor,
                 row: 2,
                 col: 3,
                 max: 5,
                 data: @[@[0'u8, 1, 2], @[3'u8, 4, 5]])[]
  test "illegal data":
    check pgm.decode("""P2
2 3
5""")[] == PGM()[]
    check pgm.decode("""P2
2 3""")[] == PGM()[]
    check pgm.decode("""P2
2""")[] == PGM()[]
    check pgm.decode("""P2
""")[] == PGM()[]
