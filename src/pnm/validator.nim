from sequtils import mapIt, filterIt
from strutils import join, Digits
from strformat import `&`

import errors

proc validateFileDiscriptor*(s: openArray[uint8], fds: varargs[string]) =
  let fd = s[0..1].mapIt(it.char).join("")
  if fd notin fds:
    raise newException(IllegalFileDiscriptorError, &"IllegalFileDiscriptor: file discriptor is {fd}")

proc validateColumnAndRow*(s: openArray[uint8], start: int) =
  # check column and row
  var whiteSpaceCount: int
  var lfExist: bool
  for i, b in s[start..^1]:
    let c = b.char
    if c == '\n':
      lfExist = true
      break
    if c == ' ':
      whiteSpaceCount.inc
      continue
    if c notin Digits:
      raise newException(IllegalColumnRowError, &"byteIndex is {i}, value is {c}")
  if whiteSpaceCount != 1:
    raise newException(IllegalColumnRowError, &"whitespace count is {whiteSpaceCount}")

proc validateMaxValue*(s: openArray[uint8], start: int) =
  for i, b in s[start..^1]:
    let c = b.char
    if c == '\n':
      break
    if c notin Digits:
      raise newException(IllegalMaxValueError, &"byteIndex is {i}, value is {c}")