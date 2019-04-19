import unittest
from sequtils import repeat

include pnm/util

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

suite "toMatrixString(openArray[uint])":
  test "1 digit":
    check @[0'u8, 1, 8, 9].toMatrixString(2) == "0 1\n8 9"
  test "2 digit":
    check @[0'u8, 1, 10, 99].toMatrixString(2) == "0 1\n10 99"
  
suite "toMatrixString(string)":
  test "1 digit":
    discard
  test "2 digit":
    discard
  
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
