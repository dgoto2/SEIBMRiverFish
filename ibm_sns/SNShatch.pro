FUNCTION SNShatch, iDAY, nSNS, dv, Temp, SNS, SNSyoy
; Function to determine a fractional embryonic development

PRINT, 'SNShatch Begins Here'

; Assign arra structure
iHatch = FLTARR(2, nSNS)

; DV = fltarr(nSNS); daily fractional development toward hatching
; SNStemp = randomly assinged hatching temperature...
; Develpment relationship for white sturgeon from Wang et al. 1985 Environ. Biol. Fish.
Embryo = WHERE((SNS[57, SNSyoy] LT 1.0), Embryocount, complement = Yolksac, ncomplement = Yolksaccount)
;IF vcount GT 0.0 THEN DV[v] = DV[v] + (1.0/(145.7 + 2.56 * T[v] - 63.8 * alog(T[v])))
IF Embryocount GT 0.0 THEN BEGIN
  DV[SNSyoy[Embryo]] = DV[SNSyoy[Embryo]] + 1./(1185.03 * EXP(-0.127 * Temp[SNSyoy[Embryo]])/24.)
  SNS[73, SNSyoy[Embryo]] = iday
ENDIF
; cumulative daily fractional developmenttal rate (for white strgeon)
;IF vvcount GT 0.0 THEN DV[vv] = DV[vv]
;PRINT, 'DV =', DV

PRINT, 'SNShatch Ends Here'
iHatch[0, SNSyoy] = DV[SNSyoy]
iHatch[1, SNSyoy] = SNS[73, SNSyoy]
RETURN, iHatch; DV
END