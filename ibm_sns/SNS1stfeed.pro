FUNCTION SNS1stfeed, iday, nSNS, DVexfeed, Temp, SNS, SNSyoyHatched
; Function to determine the yolk-sac larval develpoment to the 1st exogenous feeding day

PRINT, 'SNS1stfeed Begins Here'

; Assign array structure
iSettle = FLTARR(2, nSNS)

; Develpment relationship for white sturgeon from Wang et al. 1985 Environ. Biol. Fish.
Yolksac = WHERE((SNS[58, SNSyoyHatched] LT 1.0), Yolksaccount, complement = Swimup, ncomplement = Swimupcount)
IF Yolksaccount GT 0. THEN BEGIN
  DVexfeed[SNSyoyHatched[Yolksac]] $
            = DVexfeed[SNSyoyHatched[Yolksac]] + 1. / ((1535.62 * EXP(-0.071 * Temp[SNSyoyHatched[Yolksac]]) - 1185.03 * EXP(-0.127 * Temp[SNSyoyHatched[Yolksac]]))/24.)
            ; cumulative daily fractional developmenttal rate (for white strgeon)
  SNS[74, SNSyoyHatched[Yolksac]] = iday
ENDIF
;IF Swimupcount GT 0.0 THEN DVexfeed[SNSyoyHatched[Swimup]] = 1.
;PRINT, 'DV =', DVy

iSettle[0, SNSyoyHatched] = DVexfeed[SNSyoyHatched]
iSettle[1, SNSyoyHatched] = SNS[74, SNSyoyHatched]
PRINT, 'SNS1stfeed Ends Here'
RETURN,  iSettle
END