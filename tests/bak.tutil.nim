import unittest
from sequtils import repeat

include pnm/util

suite "toBinSeq":
  test "0b0000_0000":
    check 0'u8.toBinSeq == 0'u8.repeat(8)
  test "0b1010_1010":
    check 0b1010_1010.toBinSeq == @[1'u8, 0, 1, 0, 1, 0, 1, 0]

suite "toBinString":
  test "normal":
    check @[0b0000_1111'u8, 0b1010_1010].toBinString(8) == "0000111110101010"
  test "column size is 1":
    check @[0b1000_0000'u8, 0b0000_0000].toBinString(1) == "10"

suite "toMatrixString(openArray[uint])":
  test "1 digit":
    check @[0'u8, 1, 8, 9].toMatrixString(2) == "0 1\n8 9"
  test "2 digit":
    check @[0'u8, 1, 10, 99].toMatrixString(2) == "0 1\n10 99"
  
suite "toMatrixString(string)":
  test "normal":
    check "1111111100000000".toMatrixString(8) == "1 1 1 1 1 1 1 1\n0 0 0 0 0 0 0 0"
    check "1111111100000000".toMatrixString(4) == "1 1 1 1\n1 1 1 1\n0 0 0 0\n0 0 0 0"
  
suite "toBin":
  test "1 1 1 1 0 0 0 0":
    check @[1'u8, 1, 1, 1, 0, 0, 0, 0].toBin == @[0b1111_0000'u8]
  test "1 1 1 1 1 1":
    check @[1'u8, 1, 1, 1, 1, 1].toBin == @[0b1111_1100'u8]
  test "2行のデータ。1行8bit":
    check @[1'u8, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1].toBin == @[0b1111_0000'u8, 0b0000_1111]
  test "2行のデータ。1行5bit":
    check @[1'u8, 1, 1, 0, 1,
            1,    1, 1, 0, 1].toBin(5) == @[0b1110_1000'u8, 0b1110_1000]
  test "2行のデータ。1行9bit":
    check @[1'u8, 1, 1, 1, 1, 1, 1, 0, 1,
            1,    1, 1, 1, 1, 1, 1, 0, 1].toBin(9) == @[0b1111_1110'u8, 0b1000_0000,
                                                     0b1111_1110,    0b1000_0000]
  test "2行のデータ。1行17bit":
    check @[1'u8, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 
            1,    1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1].toBin(17) ==
                @[0b1111_1110'u8, 0b1111_1110, 0b1000_0000,
                  0b1111_1110'u8, 0b1111_1110, 0b1000_0000]
  test "2行のデータ。1行25bit":
    check @[1'u8, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 
            1,    1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1].toBin(25) ==
                @[0b1111_1110'u8, 0b1111_1110, 0b1111_1110, 0b1000_0000,
                  0b1111_1110'u8, 0b1111_1110, 0b1111_1110, 0b1000_0000]
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

suite "replaceWhiteSpace":
  test "normal":
    check "a b  c            d".replaceWhiteSpace == "a b c d"
  test "line field":
    check "ab  cd  e   f\n1 2".replaceWhiteSpace == "ab cd e f\n1 2"
  test "no whitespace":
    check "abc".replaceWhiteSpace == "abc"
  test "single whitespace":
    check "a b c".replaceWhiteSpace == "a b c"