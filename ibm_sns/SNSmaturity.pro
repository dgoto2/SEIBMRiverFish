FUNCTION SNSmaturity,  nSNS, YAOalive, age, length, maturity, sex, weight, GSI, AgeMaturity
; function to determine maturity of shvoelnose sturgeon
; maturity probablity is based onage-specific percent maturity from Tripp et al. 2009 NAJFM

PRINT, 'SNSmaturity Begins Here'

;>FOR TEST ONLY******************************************************
;nSNS = 500
;SEX = ROUND(RANDOMU(seed, nSNS)); randomly assign sex -> 1:1 ratio
;print, 'sex', sex
;AGE = ROUND(RANDOMU(seed, nSNS) * (MAX(31) - MIN(0)) + MIN(0))
;print, 'age', age
;*********************************************************************

; Assign array structure
maturityFunc = FLTARR(nSNS)
maturityprob = FLTARR(nSNS)
MinMatAge = FLTARR(nSNS)
maturitycheck = FLTARR(4, nSNS)

; Parameter values
MinMatAgeMale = 4.; minmimum age of mature male
MinMatAgeFemale = 6.; minmium age of mature female

;PRINT, 'age'
;PRINT, (age[0:199L])
;PRINT, 'maturity'
;PRINT, (maturity[0:199L])

; these logistic functions work only age >0
;IF YAOcount GT 0.THEN BEGIN
YAOMale = WHERE(SEX EQ 0., YAOmalecount, complement = YAOfemale, ncomplement = YAOfemalecount)
;print, yaomale
IF YAOmalecount GT 0. THEN maturityFunc[YAOalive[YAOMale]] = 0.9236/(1+ABS((length[YAOalive[YAOmale]]*1.02+43.14)/520.5735)^(-21.3815)); males
IF YAOfemalecount GT 0. THEN maturityFunc[YAOalive[YAOfemale]] = 1.0711/(1+ABS((length[YAOalive[YAOfemale]]*1.02+43.14)/624.6820)^(-15.8870))<1.; females
  ;PRINT, 'LiveIndiv2[YAO[YAOfemale]]', N_ELEMENTS(YAOalive[YAOfemale])
;ENDIF
;print, 'maturityfunc', maturityfunc


FOR iMature = 0L, nSNS-1L DO MaturityProb[iMature] = RANDOMN(seed, binomial=[nSNS, maturityfunc[iMature]], /DOUBLE)/nSNS
;print, 'maturityprob', maturityprob
; maturity = 'YAOalive'
; immaturity = 'YAOalive'

Mature = WHERE(maturity GT 0., Maturecount, complement = Immature, ncomplement = Immaturecount);     
; Maturity is evaluated only for immature individuals (maturity is not reversible)
IF Immaturecount GT 0. THEN BEGIN
  ;PRINT, 'YAOalive[Immature]', N_ELEMENTS(YAOalive[Immature])

  maturitystatus = WHERE((MaturityProb[YAOalive[Immature]] LT maturityFunc[YAOalive[Immature]]), maturitycount, complement = immaturestatus, ncomplement = immaturecount)
  IF maturitycount GT 0. THEN BEGIN
    maturity[Immature[maturitystatus]] = 1.
    AgeMaturity[Immature[maturitystatus]] = age[Immature[maturitystatus]]
    ;GSI[Immature[maturitystatus]] = 0.02 * weight[Immature[maturitystatus]]
  ENDIF
ENDIF

;>Assume shovelnose sturgeon cannot mature before minimum maturation age
IF YAOmalecount GT 0. THEN MinMatAge[YAOalive[YAOMale]] = MinMatAgeMale
IF YAOfemalecount GT 0. THEN MinMatAge[YAOalive[YAOfemale]] = MinMatAgeFemale
MaturityMinCheck = WHERE((age LT MinMatAge[YAOalive]), maturityMincheckcount)
IF maturityMincheckcount GT 0. THEN maturity[MaturityMinCheck] = 0.
;PRINT, 'maturity'
;PRINT, maturity

maturitycheck[0, YAOalive] = AgeMaturity
maturitycheck[1, YAOalive] = maturityfunc[YAOalive]
maturitycheck[2, YAOalive] = maturityprob[YAOalive]
maturitycheck[3, YAOalive] = maturity
;PRINT, 'maturitycheck'
;PRINT, transpose(maturitycheck[*, 0:199L])

PRINT, 'SNSmaturity Ends Here'
RETURN, maturitycheck; maturity
END