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
