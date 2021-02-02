type
  Header* = object
    descriptor*: Descriptor
    col*, row*: int
    max*: uint8
  PBM* = object
    header*: Header
    data*: seq[uint8]
  PGM* = object
    header*: Header
    data*: seq[uint8]
  PPM* = object
    header*: Header
    data*: seq[uint8]
  Descriptor* {.pure.} = enum
    P1, P2, P3, P4, P5, P6
  IllegalFileDescriptorError* = object of Defect
    ## Return this when file descriptor is wrong.
    ## filedescriptors are P1 or P2 or P3 or P4 or P5 or P6.

func isPgmPnmDescriptor*(d: Descriptor): bool =
  return d in @[P2, P3, P5, P6]

func toDescriptor*(str: string): Descriptor =
  case str
  of "P1": P1
  of "P2": P2
  of "P3": P3
  of "P4": P4
  of "P5": P5
  of "P6": P6
  else:
    raise newException(IllegalFileDescriptorError, "IllegalFileDescriptor: file descriptor is " & str)
