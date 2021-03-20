import pnm

import unittest, streams

# illegal test cases

block:
  const inData = """
P2
"""
  var strm = newStringStream(inData)
  expect IllegalFileDescriptorError:
    discard strm.readPpm
  strm.close

block:
  const inData = """
P3 
"""
  var strm = newStringStream(inData)
  expect IllegalFileDescriptorError:
    discard strm.readPgm
  strm.close
