type
  Header* = object
    descriptor*: string
    col*, row*: int
    max*: uint8
  Descriptor* = enum
    P1, P2, P3, P4, P5, P6

var descriptors* = @[P1, P2, P3, P4, P5, P6]
