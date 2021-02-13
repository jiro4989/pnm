import unittest, os

include pnm

const
  inputDataDir = "tests"/"in"
  outputDataDir = "tests"/"out"

suite "usecase":
  test "create PBM image and save file":
    var img = newImage(ColorBit, 64, 255)
    for y in 0..<img.h:
      for x in 0..<img.w:
        let b =
          if y div 10 mod 2 == 0: 0'u8
          else: 1'u8
        img[x, y] = ColorBit(bit: b)
    writeFile(outputDataDir/"p1.pbm", img, P1)
    writeFile(outputDataDir/"p4.pbm", img, P4)

  test "create PGM image and save file":
    var img = newImage(ColorGray, 50, 255)
    for y in 0..<img.h:
      for x in 0..<img.w:
        img[x, y] = ColorGray(gray: y.uint8)
    writeFile(outputDataDir/"p2.pgm", img, P2)
    writeFile(outputDataDir/"p5.pgm", img, P5)

  test "create PPM image and save file":
    var img = newImage(ColorRGB, 50, 255)
    for y in 0..<img.h:
      for x in 0..<img.w:
        img[x, y] = ColorRGB(red: y.uint8, green: 25'u8, blue: 0'u8)
    writeFile(outputDataDir/"p3.ppm", img, P3)
    writeFile(outputDataDir/"p6.ppm", img, P6)

suite "bitSeqToByteSeq":
  test "0 * 8":
    check bitSeqToByteSeq([0'u8, 0, 0, 0, 0, 0, 0, 0], 8) == @[0'u8]

  test "1 * 8":
    check bitSeqToByteSeq([1'u8, 1, 1, 1, 1, 1, 1, 1], 8) == @[255'u8]

  test "0 * 4, 1 * 4":
    check bitSeqToByteSeq([0'u8, 0, 0, 0, 1, 1, 1, 1], 8) == @[15'u8]

  test "1 * 7":
    check bitSeqToByteSeq([1'u8, 1, 1, 1, 1, 1, 1, 0], 8) == @[254'u8]

