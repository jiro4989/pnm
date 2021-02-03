import unittest

include pnm/pbm

suite "proc readTextDataPartOfPBM":
  test "P1":
    discard

suite "proc toBitSeq":
  test "0b0000_0000":
    check 0'u8.toBitSeq == @[0'u8, 0, 0, 0, 0, 0, 0, 0]

  test "0b1000_0001":
    check 0b1000_0001.toBitSeq == @[1'u8, 0, 0, 0, 0, 0, 0, 1]

  test "0b1010_1010":
    check 0b1010_1010.toBitSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]

  test "0b1111_1111":
    check 0b1111_1111.toBitSeq == @[1'u8, 1, 1, 1, 1, 1, 1, 1]

suite "proc readBinaryDataPartOfPBM":
  test "P1":
    discard

suite "proc readPBM":
  test "P1":
    discard

suite "proc readPBMFile":
  test "P1":
    discard

suite "proc bitSeqToByteSeq":
  test "1, 1, 1, 1, 1, 1":
    check @[1'u8, 1, 1, 1, 1, 1].bitSeqToByteSeq(8) == @[0b1111_1100'u8]

  test "1, 1, 1, 1, 0, 0, 0, 0":
    check @[1'u8, 1, 1, 1, 0, 0, 0, 0].bitSeqToByteSeq(8) == @[0b1111_0000'u8]

  test "1, 1, 1, 1, 0, 0, 0, 0, 1, 1":
    check @[1'u8, 1, 1, 1, 0, 0, 0, 0, 1, 1].bitSeqToByteSeq(8) == @[0b1111_0000'u8, 0b1100_0000]

suite "proc headTail":
  setup:
    var emptyData: seq[int]

  test "head 2, tail 2":
    check @[1, 2, 3, 4].headTail(2) == (@[1, 2], @[3, 4])

  test "data size and argument size is same":
    check @[1, 2, 3, 4].headTail(4) == (@[1, 2, 3, 4], emptyData)

  test "argument size is over data size":
    check @[1, 2, 3, 4].headTail(5) == (@[1, 2, 3, 4], emptyData)

suite "proc writeBinaryDataPartOfPBM":
  test "P1":
    discard

suite "proc writePBMFile":
  test "P1":
    discard
