import unittest
from sequtils import repeat

include pnm

## PBM

block:
  let col = 32
  let row = 12
  let data = @[
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

  let pbm1 = newPBM(pbmFileDescriptorP1, col, row, data)
  let pbm4 = newPBM(pbmFileDescriptorP4, col, row, data)

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

  suite "formatP1":
    test "normal":
      check pbm1.formatP1 == pbm1str
    test "column size is 1":
      check newPBM(pbmFileDescriptorP1, 1, 1, @[0b1000_0000'u8]).formatP1 == "P1\n1 1\n1"

  suite "formatP4":
    test "normal":
      check pbm1.formatP4 == pbm1bin
    test "column size is 1":
      check newPBM(pbmFileDescriptorP4, 1, 1, @[0b1000_0000'u8]).formatP4 == @[
        'P'.uint8, '4'.uint8, '\n'.uint8,
        '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
        0b1000_0000'u8, 
      ]

  suite "validatePBM":
    test "NoError":
      validatePBM(@['P'.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8])
      validatePBM(@['P'.uint8, '4'.uint8, '\n'.uint8,
                    '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
                    '1'.uint8])
    test "IllegalFileDescriptorError":
      expect IllegalFileDescriptorError:
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

  suite "usecase":
    test "write P1":
      writePBMFile("tests/out/p1.pbm", pbm1)
    test "write P4":
      writePBMFile("tests/out/p4.pbm", pbm4)
    test "read p1 file":
      check readPBMFile("tests/out/p1.pbm")[] == pbm1[]
    test "read p4 file":
      check readPBMFile("tests/out/p4.pbm")[] == pbm4[]

# PGM

block:
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

  let pgm2 = newPGM(pgmFileDescriptorP2, col, row, data)
  let pgm5 = newPGM(pgmFileDescriptorP5, col, row, data)
  let pgm2_2 = newPGM(pgmFileDescriptorP2, 6, 12, data2)
  let pgm2_3 = newPGM(pgmFileDescriptorP2, col, row, 255, data)
  let pgm5_2 = newPGM(pgmFileDescriptorP5, col, row, 255, data)

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

  const pgm2_2str_whitespace = """P2
6 12
20
0  0  0  0  0  0 
0  0  0  0  0  0 
0  0  0  0  0  0 
0  0  0  0  0  0 
10 10 10 10 10 10
10 10 10 10 10 10
10 10 10 10 10 10
10 10 10 10 10 10
20 20 20 20 20 20
20 20 20 20 20 20
20 20 20 20 20 20
20 20 20 20 20 20"""

  const pgm2_3str = """P2
6 12
255
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

  let pgm5_2bin = @[
    'P'.uint8, '5'.uint8, '\n'.uint8,
    '6'.uint8, ' '.uint8, '1'.uint8, '2'.uint8, '\n'.uint8,
    '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
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
    test "the maximum brightness is set":
      check pgm2_3.formatP2 == pgm2_3str
    test "column size is 1":
      check newPGM(pgmFileDescriptorP2, 1, 2, @[0b1000_0000'u8, 0b1000_0000'u8]).formatP2 == "P2\n1 2\n128\n128\n128"

  suite "formatP5":
    test "normal":
      check pgm5.formatP5 == pgm5bin
    test "the maximum brightness is set":
      check pgm5_2.formatP5 == pgm5_2bin
    test "column size is 1":
      check newPGM(pgmFileDescriptorP5, 1, 1, @[0b1000_0000'u8, 0b1000_0000'u8]).formatP5 == @[
        'P'.uint8, '5'.uint8, '\n'.uint8,
        '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8,
        '1'.uint8, '2'.uint8, '8'.uint8, '\n'.uint8,
        0b1000_0000'u8, 
        0b1000_0000'u8, 
      ]

  suite "validatePGM":
    test "NoError P2":
      @['P'.uint8, '2'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8,].validatePGM
    test "NoError P5":
      @['P'.uint8, '5'.uint8, '\n'.uint8, '1'.uint8, ' '.uint8, '1'.uint8, '\n'.uint8, '1'.uint8, '\n'.uint8, '1'.uint8,].validatePGM
    test "IllegalFileDescriptorError":
      expect IllegalFileDescriptorError:
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
      check pgm2str.parsePGM[] == pgm2[]
    test "multi whitespace":
      check pgm2_2str_whitespace.parsePGM[] == pgm2_2[]

  suite "parsePGM(openArray[uint8])":
    test "normal":
      check pgm5bin.parsePGM[] == pgm5[]

  suite "usecase":
    test "write P2":
      writePGMFile("tests/out/p2.pgm", pgm2)
    test "write P5":
      writePGMFile("tests/out/p5.pgm", pgm5)
    test "read P2":
      check readPGMFile("tests/out/p2.pgm")[] == pgm2[]
    test "read P5":
      check readPGMFile("tests/out/p5.pgm")[] == pgm5[]

block:
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

  let data2 = @[
    100'u8, 0, 0,
    0, 100, 0,
    0, 0, 100,
    100, 100, 0,
    100, 100, 100,
    0, 0, 0
  ]

  let p1 = newPPM(ppmFileDescriptorP3, col, row, data)
  let p2 = newPPM(ppmFileDescriptorP6, col, row, data)
  let p1_2 = newPPM(ppmFileDescriptorP3, col, row, 255, data2)
  let p2_2 = newPPM(ppmFileDescriptorP6, col, row, 255, data2)

  const p1str = """P3
3 2
255
255 0 0
0 255 0
0 0 255
255 255 0
255 255 255
0 0 0"""

  const p1str2 = """P3
3 2
255
255 0   0   0   255 0   0 0 255
255 255 0   255 255 255 0 0 0"""

  const p1str_whitespace = """P3
3 2
255
255 0   0  
0   255 0  
0   0   255
255 255 0  
255 255 255
0   0   0  """

  const p1_2str = """P3
3 2
255
100 0 0
0 100 0
0 0 100
100 100 0
100 100 100
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

  let p2_2bin = @[
    'P'.uint8, '6'.uint8, '\n'.uint8,
    '3'.uint8, ' '.uint8, '2'.uint8, '\n'.uint8,
    '2'.uint8, '5'.uint8, '5'.uint8, '\n'.uint8,
    100'u8, 0, 0,
    0, 100'u8, 0,
    0, 0, 100'u8,
    100, 100, 0,
    100, 100, 100,
    0, 0, 0,
  ]


  suite "formatP3":
    test "normal":
      check p1.formatP3 == p1str
    test "the maximum brightness is set":
      check p1_2.formatP3 == p1_2str
    test "column size is 1":
      check newPPM(ppmFileDescriptorP3, 1, 2, @[128'u8, 128, 128, 0, 0, 0]).formatP3 == "P3\n1 2\n128\n128 128 128\n0 0 0"

  suite "formatP6":
    test "normal":
      check p2.formatP6 == p2bin
    test "the maximum brightness is set":
      check p2_2.formatP6 == p2_2bin
    test "column size is 1":
      check newPPM(ppmFileDescriptorP6, 1, 2, @[128'u8, 128, 128, 0, 0, 0]).formatP6 == @[
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
    test "IllegalFileDescriptorError":
      expect IllegalFileDescriptorError:
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
      check p1str.parsePPM[] == p1[]
    test "multi column":
      check p1str2.parsePPM[] == p1[]
    test "multi whitespace":
      check p1str_whitespace.parsePPM[] == p1[]

  suite "parsePPM(openArray[uint8])":
    test "normal":
      check p2bin.parsePPM[] == p2[]

  suite "usecase":
    test "write P3":
      writePPMFile("tests/out/p3.ppm", p1)
    test "write P6":
      writePPMFile("tests/out/p6.ppm", p2)
    test "read P2":
      check readPPMFile("tests/out/p3.ppm")[] == p1[]
    test "read P5":
      check readPPMFile("tests/out/p6.ppm")[] == p2[]