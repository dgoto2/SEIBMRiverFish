FUNCTION SNSmortYAO, age, length, stor, struc, gonad, no_inds, nSNS, YAO, TURB
; Determine daily mortality rates for shovelnose sturgeon

PRINT, 'SNSmort Begins Here'

; CONSTANT MORTALITY RATE  >>> XX %
; LETHAL TEMPERATURE THRESHOLD (LOWER AND UPPER)
; lethal temperature for shovelnose embryos 8C and 28C
; no survival difference between 12 and 24C, though highest survival rates are between 12 and 20C

; YOY with exogenous feeding and YAO
; >>>>>>>eggs & yolksac larvae have length & weight = 0<<<<<<<<<<
; size-based background predation mortality
;litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc. ;>>>>>>>NEED TO ADJUST FOR STURGEON  WITH A TURBIDITY FUNCITON <<<<<<<<


; Assign array strucutre
TurbFunc = FLTARR(nSNS); turbidity function
Z = FLTARR(nSNS); instantaneous mortality rate
p_pred = FLTARR(nSNS); probability of predation mortality
actrho = FLTARR(nSNS); actual rho
optrho = FLTARR(nSNS); optimal rho
Pred = FLTARR(nSNS)
Star = FLTARR(nSNS)
PredationProb = FLTARR(nSNS)
StavationProb = FLTARR(nSNS)
TotMort = FLTARR(4, nSNS)

; Parameter values
HarvestAge = 3.; minimum harvestable age
HarvestZ =  0.43/365. * 0.7; instantaneous fishing mortality rate
p_starveOldParam1 = 0.2
p_starveOldParam2 = 0.4
p_starveYAOParam1 = 0.1
p_starveYAOParam2 = 0.35
MaxAgeInt = 16.
MaxAgeLimit = 20.
ZParam1 = 0.4
Zparam2 = 0.08
OptRhoMin = 0.3

TurbFunc[YAO] = 1.2102/(1+EXP(-(TURB[YAO]-298.6103)/(-178.8772))) < 1.0; white sturgeon by Gadomski and Parsley 2005 TAFS

;z = 0.4 * EXP(-1.0*(length) * 0.06); High mort
;z = 0.4 * EXP(-(length) * 0.08); Low mort                   ;>>>>>>>NEED TO ADJUST FOR STURGEON<<<<<<<<   

; annual fising mortality of sturgoen in the Lower Platte River = 43%
; instantaneous mortality rate  = 0.547 (N=809) by Anderson 2010
Z[YAO] =  0.4 * EXP(-(length[YAO]) * 0.08)* TurbFunc[YAO]; 0.001; 0.574/365.; 0.001573;

; Fishing mortality
Harvest = WHERE(age[YAO] GE HarvestAge, Harvestcount)
Z[YAO[Harvest]] = HarvestZ
;z = z / td; subdaily mortality rate

v = WHERE(z LT 0., vcount)
IF (vcount GT 0.) THEN z[v] = 0.
p_pred[YAO] = 1. - EXP(-Z[YAO])
;PRINT, 'Z'
;PRINT, Z[YAO[0:199]]
;PRINT, 'p_pred'
;PRINT, p_pred[YAO] 


; Starvation mortality
optrho[YAO] = 1.35 * 0.0912 * ALOG10(length[YAO]); + 0.128 * 1.6; same as in SNSinitial and SNSgrowth
op = WHERE(optrho LT 0.3, opcount)
IF (opcount GT 0.0) THEN optrho[op] = 0.3
p_starve = FLTARR(nSNS)
OldAge = WHERE(age[YAO] GE MaxAgeInt, OldAgecount, complement = YoungAge, ncomplement = YoungAgecount)
IF (OldAgecount GT 0.0) THEN p_starve[YAO[OldAge]] = p_starveOldParam1 + p_starveOldParam2 * optrho[YAO[OldAge]]
IF (YoungAgecount GT 0.0) THEN p_starve[YAO[YoungAge]] = p_starveYAOParam1 + p_starveYAOParam2 * optrho[YAO[YoungAge]]
actrho[YAO] = (stor[YAO] + gonad[YAO]) / (stor[YAO] + gonad[YAO] + struc[YAO])
;PRINT, 'p_starve =', p_starve


; For YAO, individuals die and change #individual from 1 to 0.
; >>> #dead individual is simply 1.
;IF N_ELEMENTS(YAO) GT 0. THEN BEGIN
  FOR iPred = 0L, nSNS-1L DO BEGIN
    ;IF (no_inds[iPred] LE 1.0) THEN pred[iPred] = 0.;no_inds[i]
    ;IF (no_inds[iPred] GT 1.0) THEN BEGIN
      PredationProb[iPred] = RANDOMU(seed, /double); RANDOMN(seed, BINOMIAL = [nSNS, p_pred[iPred]], /double)/nSNS
;      Eaten = WHERE((PredationProb[YAO] LT p_pred[YAO]), Eatencount, complement = Escape, ncomplement = Escapecount)
;      IF Eatencount GT 0. THEN pred[YAO[Eaten]] = 1.
    ;ENDIF  
    IF (actrho[iPred] LT p_starve[iPred]) THEN BEGIN
        ;star[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], 0.3], /double))
        ;StavationProb[iPred] = RANDOMN(seed, BINOMIAL = [nSNS, p_starve[iPred]], /double)/nSNS
        StavationProb[iPred] = RANDOMU(seed, /double)            
    ENDIF ELSE BEGIN
        StavationProb[iPred] = p_starve[iPred]
    ENDELSE
  ENDFOR
  Eaten = WHERE((PredationProb[YAO] LT p_pred[YAO]), Eatencount, complement = Escape, ncomplement = Escapecount)
  IF Eatencount GT 0. THEN pred[YAO[Eaten]] = 1.  
  
  Starved = WHERE((StavationProb[YAO] LT p_starve[YAO]), Starvedcount, complement = NStarved, ncomplement = NStarvedcount)
  IF (Starvedcount GT 0.) THEN star[YAO[Starved]] = 1.
;ENDIF

; set maximum age for sturgeon 
MaxAge = WHERE(age[YAO] GT MaxAgeLimit, MaxAgecount, complement = NMaxAge, ncomplement = NMaxAgecount)
IF (MaxAgecount GT 0.) THEN star[YAO[MaxAge]] = 1.
;PRINT, 'Sturgeon dying from old age', MaxAgecount

; Check if individuals are already dead
DeadYAO = WHERE(no_inds[YAO] LT 1., DEADYAOcount)
IF (DEADYAOcount GT 0.) THEN BEGIN
  pred[YAO[DeadYAO]] = 0.
  star[YAO[DeadYAO]] = 0.
ENDIF
;PRINT, 'Predation + fishing (pred[YAO])'
;PRINT, pred[YAO[0:199]]
;PRINT, 'Starvation (star[YAO])'  
;PRINT, star[YAO]


;overwinter mortality component
;ranges based on mean fall length for YOY from Fielder et al. 2006, which ranged from 66.1 to 96.5
;if a eq 334.0 then begin
 ; if length(i) lt 40.0 then wint(i) = no_inds(i)
  ;if length(i) gt 120.0 then wint(i) = 0.0
  ;if length(i) ge 40.0 and length(i) le 120.0 then begin
   ; ;to use for baseline sims
   ; p_wint(i) = -172.67*(stor(i)/length(i))^2-3.0353*(stor(i)/length(i))+1.0258   
    ;;to use for more sever winters comment out when not in use
    ;;p_wint(i) = p_wint(i)+(0.05*p_wint(i))
    ;if p_wint(i) lt 0.0 then p_wint(i) =0.0
    ;if p_wint(i) gt 1.0 then p_wint(i) =1.0
    ;if no_inds(i) lt 1.0 then wint(i) = no_inds(i)
    ;if no_inds(i) ge 1.0 then wint(i) = (RANDOMN(seed, BINOMIAL=[no_inds(i),p_wint(i)],/double))
  ;endif
;endif  


TotMort[0, YAO] = pred[YAO]
TotMort[1, YAO] = star[YAO]
;TotMort[2, YAO] = pred[YAO]; fishing
PRINT, 'TotMort'
PRINT, TOTAL(TotMort[1, YAO])

PRINT, 'SNSmortYAO Ends Here'
RETURN, TotMort
END