FUNCTION SNScmax, weight, length, nSNS, TEMP, LiveIndiv
; function to determine cmax for shovelnose sturgeon (weight-based)
; Cmax for eggs and yolksac larvae is 0 (no adjustment is necessary)

PRINT, 'SNScmax Begins Here'

; Assign array structure
Cmx = FLTARR(nSNS)

; paramter values
; Parameters are for white sturgeon (Bevelhimer 2002. J Appl Ichthyol.- originally from Cui et al. 1996 J Fish Biol)
; The unit is in g/d (NOT g/g/d as the paper above indicated)
; Cmax parameters were adjusted by calibration uisng juveniule pallid sturgeon  feeding experiments
CA = 0.18; 0.41; 
CB = 0.75; 0.71; 
; >metabolic rate and feeding rate increased between 10 and 30C then sharply declined.


; Temperature-dependent function for C 
; Parameter values for energy loss
;CA = FLTARR(nSNS)
;CB = FLTARR(nSNS)
;;CTM = FLTARR(nSNS)
;;CTO = FLTARR(nSNS)
;Larva = WHERE(length LE 80.0, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
;IF (Larvacount GT 0.0) THEN BEGIN
;  CA[LiveIndiv[Larva]] = 0.125
;  CB[LiveIndiv[Larva]] = -0.15
;;  CTM = 28.0
;;  CTO = 25.0
;ENDIF
;;values are for juvenile and adult 
;IF (JuvAducount GT 0.0) THEN BEGIN 
;  CA[LiveIndiv[JuvAdu]] = 0.18
;  CB[LiveIndiv[JuvAdu]] = 0.75
;;  CTM[JuvAdu] = 28.0
;;  CTO[JuvAdu] = 22.0
;ENDIF


; Temperature-dependent function for food consumption; maximum consumption between 24-30C, 
fT = (3.83 - 0.1158 * TEMP)^1.09 * EXP(0.1453 * TEMP - 3.5052) < 1.

;Cmx[LiveIndiv] = CA[LiveIndiv] * weight^CB[LiveIndiv] * fT
Cmx[LiveIndiv] = CA * weight^CB * fT
;Cmx[LiveIndiv] = Cmx[LiveIndiv] * weight; g/d
;PRINT, 'Cmax =' Cmax ;units are g/d

PRINT, 'SNScmax Ends Here'
RETURN, Cmx
END