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
