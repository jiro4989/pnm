include pnm

import unittest

# ======
# newPbm
# ======

block:
  block:
    check newPbm(P1, 5, 3).data.len == 15
    check newPbm(P4, 5, 3).data.len == 15

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

# ======
# newPgm
# ======

block:
  block:
    check newPgm(P2, 5, 3, 255).data.len == 15
    check newPgm(P5, 5, 3, 255).data.len == 15
    check newPgm(P2, 5, 3, 0).data.len == 15 # no error
    check newPgm(P2, 5, 3, 1).data.len == 15 # no error

  block:
    expect IllegalFileDescriptorError: discard newPgm(P1, 5, 3, 255)
    expect IllegalFileDescriptorError: discard newPgm(P3, 5, 3, 255)
    expect IllegalFileDescriptorError: discard newPgm(P4, 5, 3, 255)
    expect IllegalFileDescriptorError: discard newPgm(P6, 5, 3, 255)

  block:
    expect IllegalDataWidthError: discard newPgm(P2, 0, 3, 255)
    expect IllegalDataWidthError: discard newPgm(P2, -1, 3, 255)

  block:
    expect IllegalDataHeightError: discard newPgm(P2, 5, 0, 255)
    expect IllegalDataHeightError: discard newPgm(P2, 5, -1, 255)

  block:
    expect IllegalDataMaxError: discard newPgm(P2, 5, 3, -1)
    expect IllegalDataMaxError: discard newPgm(P2, 5, 3, 256)
