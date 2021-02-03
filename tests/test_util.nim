import unittest

include pnm/util

suite "proc readHeaderPart":
  test "P1":
    var strm = newStringStream("""
P1
5 3
""")
    let want = strm.readHeaderPart
    let got = Header(descriptor: P1, col: 5, row: 3)
    check want == got

  test "P2":
    var strm = newStringStream("""
P2
5 3
255
""")
    let want = strm.readHeaderPart
    let got = Header(descriptor: P2, col: 5, row: 3, max: 255'u8)
    check want == got

  test "P3":
    var strm = newStringStream("""
P3
5 3
255
""")
    let want = strm.readHeaderPart
    let got = Header(descriptor: P3, col: 5, row: 3, max: 255'u8)
    check want == got

suite "proc readTextDataPart":
  test "P2: single spaces":
    var strm = newStringStream("""
1 2 3 4 5
6 7 8 9 10
""")
    let want = strm.readTextDataPart
    let got = @[1'u8, 2, 3, 4, 5,
                6, 7, 8, 9, 10]
    check want == got

  test "P2: multi spaces":
    var strm = newStringStream("""
1 2 3 4 5
6    7     8 9  10
""")
    let want = strm.readTextDataPart
    let got = @[1'u8, 2, 3, 4, 5,
                6, 7, 8, 9, 10]
    check want == got

  test "P3: single spaces":
    var strm = newStringStream("""
0 0 255
0 255 0
255 0 0
""")
    let want = strm.readTextDataPart
    let got = @[0'u8, 0, 255,
                0, 255, 0,
                255, 0, 0]
    check want == got

  test "P3: multi spaces":
    var strm = newStringStream("""
  0   0   255
  0   255 0  
  255 0   0  
""")
    let want = strm.readTextDataPart
    let got = @[0'u8, 0, 255,
                0, 255, 0,
                255, 0, 0]
    check want == got

suite "proc readBinaryDataPart":
  test "read all binaries":
    var strm = newStringStream("fo")
    let want = strm.readBinaryDataPart
    let got = @['f'.uint8, 'o'.uint8]
    check want == got

suite "proc writeHeaderPart":
  test "P1":
    var strm = newStringStream("")
    let header = Header(descriptor: P1, col: 5, row: 3)
    strm.writeHeaderPart(header)
    strm.setPosition(0)
    let want = """P1
5 3
"""
    let got = strm.readAll()
    check want == got

  test "P1: but max is not 0":
    var strm = newStringStream("")
    let header = Header(descriptor: P1, col: 5, row: 3, max: 255'u8)
    strm.writeHeaderPart(header)
    strm.setPosition(0)
    let want = """P1
5 3
"""
    let got = strm.readAll()
    check want == got

  test "P2, P3, P5, P6":
    for descr in [P2, P3, P5, P6]:
      var strm = newStringStream("")
      let header = Header(descriptor: descr, col: 5, row: 3, max: 255'u8)
      strm.writeHeaderPart(header)
      strm.setPosition(0)
      let want = $descr & "\n5 3\n255\n"
      let got = strm.readAll()
      check want == got
