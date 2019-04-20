## errors is error type definition for pnm.
## Types are used when validating PNM format.

type
  IllegalFileDiscriptorError* = object of Defect
    ## Return this when file discriptor is wrong.
    ## filediscriptors are P1 or P2 or P3 or P4 or P5 or P6.
  IllegalColumnRowError* = object of Defect
    ## Return this when column or row value is wrong.
  IllegalMaxValueError* = object of Defect
    ## Return this when max value is wrong.