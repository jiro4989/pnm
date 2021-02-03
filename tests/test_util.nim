import unittest

include pnm/util

suite "proc readHeaderPart":
  test "P1":
    var strm = newStringStream("""P1
5 3
""")
    let want = strm.readHeaderPart
    let got = Header(descriptor: P1, col: 5, row: 3)
    check want == got

  test "P2":
    var strm = newStringStream("""P2
5 3
255
""")
    let want = strm.readHeaderPart
    let got = Header(descriptor: P2, col: 5, row: 3, max: 255'u8)
    check want == got

  test "P3":
    var strm = newStringStream("""P3
5 3
255
""")
    let want = strm.readHeaderPart
    let got = Header(descriptor: P3, col: 5, row: 3, max: 255'u8)
    check want == got

suite "proc readTextDataPart":
  test "P2: single spaces":
    var strm = newStringStream("""1 2 3 4 5
6 7 8 9 10
""")
    let want = strm.readTextDataPart
    let got = @[1'u8, 2, 3, 4, 5,
                6, 7, 8, 9, 10]
    check want == got

  test "P2: multi spaces":
    var strm = newStringStream("""1 2 3 4 5
6    7     8 9  10
""")
    let want = strm.readTextDataPart
    let got = @[1'u8, 2, 3, 4, 5,
                6, 7, 8, 9, 10]
    check want == got

