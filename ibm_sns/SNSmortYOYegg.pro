FUNCTION SNSmortYOYegg, length, stor, struc, no_inds, nSNS, SNSyoyEgg, TURB, temp
; This function determines daily mortality rates for shovelnose sturgeon

PRINT, 'SNSmortYOYegg Begins Here'
; eggs & yolksac larvae have length & weight = 0

; Egg and yolk sac larva (temperature-related) mortality    ;>>>>>>>NEED TO ADJUST FOR STURGEON<<<<<<<<   

; Assign array structure
HeatMort = FLTARR(nSNS)
p_thermo = FLTARR(nSNS)
TurbFunc = FLTARR(nSNS)
p_pred = FLTARR(nSNS)
Z = FLTARR(nSNS)
TotMort = FLTARR(4, nSNS)
Pred = FLTARR(nSNS)

; Parameter values
;p_thermoParam1 =
;p_thermoParam2 =
;p_thermoParam3 =
;TurbFuncParam1 =
;TurbFuncParam2 =
;TurbFuncParam3 =
EggZParam = 0.990



; CONSTANT MORTALITY RATE  >>> XX %
; LETHAL TEMPERATURE THRESHOLD (LOWER AND UPPER)
; lethal temperature for shovelnose embryos 8C and 28C
; no survival difference between 12 and 24C, though highest survival rates are between 12 and 20C


; Temperature-dependent mortality
;LethalHeat = WHERE(Temp[SNSyoyEgg] GE 24., HeatMortcount)
p_thermo[SNSyoyEgg] = 1.1564/(1+EXP(-(Temp[SNSyoyEgg]-28.2889)/1.0616)) <1.; probablity based on a sigmoidal function
;IF (HeatMortcount GT 0.) THEN BEGIN
  ;p_thermo[SNSyoyEgg[LethalHeat]] = 1.1564/(1+EXP(-(F4-28.2889)/1.0616)); 0.3
  FOR i = 0L, nSNS - 1 DO BEGIN
    ; thermal mortality
    IF (no_inds[i] LE 1.) THEN HeatMort[i] = 0.;no_inds[i]
    IF (no_inds[i] GT 1.) THEN BEGIN
      IF (p_thermo[i] LE 0.) THEN BEGIN
        HeatMort[i] = 0. 
      ENDIF ELSE BEGIN 
       HeatMort[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], p_thermo[i]], /double))
      ENDELSE 
    ENDIF
  ENDFOR
;ENDIF
;IF (HeatMortcount GT 0.) THEN HeatMort[SNSyoyEgg[LethalHeat]] = no_inds[SNSyoyEgg[LethalHeat]]

; Adjust mortality for eggs and yolksac larvae >>>>>>> NEED TO ADJUST FOR SHOVELNOSE STURGEON
; no starvation mortlity for eggs and yolksac larvae
;IF TOTAL(SNSyoyEgg) GT 0. THEN BEGIN
; daily mortality rate for YOY, 0.9996/365 = 0.00274(suvival rate from egg to age1 = 0.0004) by Pine et al., 2001
; size-based background predation mortality

;litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc. ;>>>>>>>NEED TO ADJUST FOR STURGEON  WITH A TURBIDITY FUNCITON <<<<<<<<
TurbFunc[SNSyoyEgg] = 1.2102/(1+EXP(-(TURB[SNSyoyEgg]-298.6103)/(-178.8772))) < 1.; white sturgeon by Gadomski and Parsley 2005 TAFS


;z = 0.4 * EXP(-1.0*(length) * 0.06); High mort
;z = 0.4 * EXP(-(length) * 0.08); Low mort                   ;>>>>>>>NEED TO ADJUST FOR STURGEON<<<<<<<<  
; YOY sturgeon instantaneous mortality rate Z =0.25 - 0.64 by Phelps et al. 2010 
Z[SNSyoyEgg] = EggZParam * TurbFunc[SNSyoyEgg]; 0.9996/10.          
;PRINT, 'Swimup mortality rate'
;PRINT, Z[SNSyoySwimup]
;z = z / td
;v = WHERE(z LT 0.0, vcount)
;IF (vcount GT 0.0) THEN z[v] = 0.0

p_pred[SNSyoyEgg] = 1. - EXP(-Z[SNSyoyEgg])
;PRINT, 'z =', z
;PRINT, 'p_pred =', p_pred 

; determine the realized number of individuals lost
FOR i = 0L, nSNS - 1 DO BEGIN
  IF (no_inds[i] LE 1.) THEN pred[i] = 0.
  IF (no_inds[i] GT 1.) THEN BEGIN
   IF (p_pred[i] LE 0.) THEN BEGIN 
     pred[i] = 0.
   ENDIF ELSE BEGIN
    pred[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], p_pred[i]], /double))
   ENDELSE
  ENDIF 
ENDFOR

;pred[SNSyoyEgg] = ROUND(no_inds[SNSyoyEgg] * 0.4 * TurbFunc[SNSyoyEgg]); CONSTANT FOR NOW 

; Check if individuals are alaready dead
DeadEgg = WHERE(no_inds[SNSyoyEgg] LT 1., DeadEggcount)
IF (DeadEggcount GT 0.) THEN pred[SNSyoyEgg[DeadEgg]] = 0.

TotMort[0, SNSyoyEgg] = ROUND(pred[SNSyoyEgg]); predation
;TotMort[1,*] = ROUND()
TotMort[2, SNSyoyEgg] = ROUND(HeatMort[SNSyoyEgg]); thermal mortality
;PRINT, 'TotMort'
;PRINT, TotMort
PRINT, 'SNSmortYOYegg Ends Here'
RETURN, TotMort
END