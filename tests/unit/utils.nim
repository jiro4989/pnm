include pnm

import unittest

block:
  # newPbm
  block:
    let got = newPbm(P1, 5, 3)
    check got.data.len == 15

  # block:
  #   let got = newPbm(P4, 5, 3)
  #   check got.data.len == 3
  #   check got.data.len == 15

  block:
    expect IllegalFileDescriptorError: discard newPbm(P2, 5, 3)
    expect IllegalFileDescriptorError: discard newPbm(P3, 5, 3)
    expect IllegalFileDescriptorError: discard newPbm(P5, 5, 3)
    expect IllegalFileDescriptorError: discard newPbm(P6, 5, 3)

  block:
    expect IllegalDataWidthError: discard newPbm(P1, 0, 3)
    expect IllegalDataWidthError: discard newPbm(P1, -1, 3)

  block:
    expect IllegalDataHeightError: discard newPbm(P1, 5, 0)
    expect IllegalDataHeightError: discard newPbm(P1, 5, -1)
