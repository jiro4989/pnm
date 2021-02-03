## util is internal utilities for pnm module.
##
## **You don't need to use directly this module for pnm module.**

from sequtils import mapIt, distribute, toSeq
from strutils import join, split, parseInt, parseUint, replace
import streams

import types

proc readHeaderPart*(strm: Stream): Header =
  # read descriptor
  result.descriptor = strm.readLine().toDescriptor()

  # read comment line
  let b = strm.peekChar()
  if b == '#':
    # コメント行を読み取って破棄
    discard strm.readLine()

  # read column size and row size
  let sizeLine = strm.readLine()
  let colRow = sizeLine.split(" ")
  result.col = colRow[0].parseInt()
  result.row = colRow[1].parseInt()

  # read max data
  if result.descriptor.isPgmPnmDescriptor:
    result.max = strm.readLine().parseUint.uint8

proc readTextDataPart*(strm: Stream): seq[uint8] =
  ## P2, P3用のデータ部を取得する。
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  var line: string
  while strm.readLine(line):
    result.add(line.split(" ").mapIt(it.parseUInt.uint8))

proc readBinaryDataPart*(strm: Stream): seq[uint8] =
  ## **Note**: 事前にstrmからヘッダ部分の読み込みが完了していないといけない。
  result = strm.readAll().mapIt(it.uint8)

proc writeHeaderPart*(strm: Stream, header: Header) =
  strm.writeLine(header.descriptor)
  strm.writeLine($header.col & " " & $header.row)
  if header.descriptor.isPgmPnmDescriptor:
    strm.writeLine(header.max)

proc writeTextDataPart*(strm: Stream, data: seq[uint8], rowCount: int, delim: string) =
  for row in data.distribute(rowCount):
    strm.writeLine(row.mapIt($it).join(delim))

proc writeBinaryDataPart*(strm: Stream, data: seq[uint8]) =
  for b in data:
    strm.write(b)
