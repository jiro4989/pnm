import unittest

include pnm/pbm

suite "proc readTextDataPartOfPBM":
  test "P1":
    discard

suite "proc toBitSeq":
  test "0b0000_0000": check 0'u8.toBitSeq == @[0'u8, 0, 0, 0, 0, 0, 0, 0]
  test "0b1000_0001": check 0b1000_0001.toBitSeq == @[1'u8, 0, 0, 0, 0, 0, 0, 1]
  test "0b1010_1010": check 0b1010_1010.toBitSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]
  test "0b1111_1111": check 0b1111_1111.toBitSeq == @[1'u8, 1, 1, 1, 1, 1, 1, 1]

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
  test "P1":
    discard

suite "proc headTail":
  test "P1":
    discard

suite "proc writeBinaryDataPartOfPBM":
  test "P1":
    discard

suite "proc writePBMFile":
  test "P1":
    discard
