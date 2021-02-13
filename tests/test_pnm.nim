import unittest, os

include pnm

const
  inputDataDir = "tests"/"in"
  outputDataDir = "tests"/"out"

suite "usecase":
  test "create pgm image and save file":
    var img = newImage(ColorGray, 50, 255)
    for y in 0..<img.h:
      for x in 0..<img.w:
        img[x, y] = ColorGray(gray: y.uint8)
    writeFile(outputDataDir/"p2.pgm", img, P2)
    writeFile(outputDataDir/"p5.pgm", img, P5)
