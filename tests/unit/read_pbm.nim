import pnm

import streams, unittest

# normal case
block:
  const inData = """
P1
5 3
0 1 0 1 0
1 0 1 0 1
0 1 0 1 0
"""
  const inData2 = """
P1
5 3
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0"""
  const inData3 = """
P1
# this is comment
5 3
0 1 0 1 0
1 0 1 0 1
0 1 0 1 0
"""
  const inIllegalData = """
P1
5 3
0 1 0 1 0
1 0 1 0 1
0 1 0 1 0
1 1 1 1 1
""" # too many data

  var want = newPbm(P1, 5, 3)
  const row1 = [0'u8, 1, 0, 1, 0]
  const row2 = [1'u8, 0, 1, 0, 1]
  proc setRow(y: int, row: array[5, byte]) =
    for x in 0..<5:
      want[x, y] = row[x]
  setRow(0, row1)
  setRow(1, row2)
  setRow(2, row1)

  # ============
  # normal cases
  # ============

  block:
    # multi line case
    var strm = newStringStream(inData)
    var got = strm.readPbm
    check got[] == want[]
    strm.close

  block:
    # 1 line case
    var strm = newStringStream(inData2)
    var got = strm.readPbm
    check got[] == want[]
    strm.close

  block:
    # has comment
    var strm = newStringStream(inData3)
    var got = strm.readPbm
    check got.comment == " this is comment"
    strm.close

  # ==============
  # illegal casses
  # ==============

  block:
    var strm = newStringStream(inIllegalData)
    var got = strm.readPbm
    check got[] == want[]
    strm.close

  block:
    const inIllegalData = """
P1
5 3
0 1 0 1 0
""" # too little data
    var strm = newStringStream(inIllegalData)
    expect IllegalDataSizeError:
      discard strm.readPbm
    strm.close

  block:
    const inIllegalData = """
P1
5 3
0 1 0 1 0
9 1 0 1 0
0 1 0 1 0
""" # too little data
    var strm = newStringStream(inIllegalData)
    expect IllegalPbmDataError:
      discard strm.readPbm
    strm.close

  block:
    const inIllegalData = """
P2
5 3
0 1 0 1 0
0 1 0 1 0
0 1 0 1 0
""" # illegal file descriptor
    var strm = newStringStream(inIllegalData)
    expect IllegalFileDescriptorError:
      discard strm.readPbm
    strm.close

  block:
    const inIllegalData = """
P1 
5 3
0 1 0 1 0
0 1 0 1 0
0 1 0 1 0
""" # illegal file descriptor
    var strm = newStringStream(inIllegalData)
    expect IllegalFileDescriptorError:
      discard strm.readPbm
    strm.close
