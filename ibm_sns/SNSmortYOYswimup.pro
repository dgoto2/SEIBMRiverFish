FUNCTION SNSmortYOYswimup, length, stor, struc, no_inds, nSNS, SNSyoySwimup, TURB
; This function determined daily mortality rates for shovelnose sturgeon
; YOY with exogenous feeding and YAO
; >>>>>>>eggs & yolksac larvae have length & weight = 0<<<<<<<<<<

PRINT, 'SNSmortYOYswimup Begins Here'

; Assign array structure
TurbFunc = FLTARR(nSNS)
Z = FLTARR(nSNS)
v = WHERE(z LT 0.0, vcount)
p_pred = FLTARR(nSNS)
optrho = FLTARR(nSNS)
p_starve = FLTARR(nSNS)
actrho = FLTARR(nSNS)
Pred = FLTARR(nSNS)
Star = FLTARR(nSNS)
PredationProb = FLTARR(nSNS)
StavationProb = FLTARR(nSNS)
TotMort = FLTARR(4, nSNS)

; Parameter values
;TurbFuncParam1
;TurbFuncParam2
;TurbFuncParam3
;DensFuncParam1
;DensFuncParam2
SwimupZParam = 0.675
p_starveParam1 = 0.1
p_starveParam2 = 0.8
OptRhoMin = 0.3
OptRhoParam1 = 1.4 * 0.0912
;OptRhoParam2 = 0.13


; no survival difference between 12 and 24C, though highest survival rates are between 12 and 20C

; size-based background predation mortality
;litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc. ;>>>>>>>NEED TO ADJUST FOR STURGEON  WITH A TURBIDITY FUNCITON <<<<<<<<

TurbFunc[SNSyoySwimup] = 1.2102/(1+EXP(-(TURB[SNSyoySwimup]-298.6103)/(-178.8772))) < 1.; white sturgeon by Gadomski and Parsley 2005 TAFS

;z = 0.4 * EXP(-1.0*(length) * 0.06); High mort
;z = 0.4 * EXP(-(length) * 0.08); Low mort      ;>>>>>>>NEED TO ADJUST FOR STURGEON<<<<<<<<  
; YOY sturgeon instantaneous mortality rate Z =0.25 - 0.64 by Phelps et al. 2010 
Z[SNSyoySwimup] = EXP(-length[SNSyoySwimup] * SwimupZParam) * TurbFunc[SNSyoySwimup] $
                                            * (0.7486*TOTAL(no_inds[SNSyoySwimup])/(55692.+TOTAL(no_inds[SNSyoySwimup])))                       
;Z[SNSyoySwimup] = 0.4 * EXP(-length[SNSyoySwimup] * 0.675)                         

;Z[SNSyoySwimup] = EXP(-length[SNSyoySwimup] * 0.86) * TurbFunc[SNSyoySwimup] $
;                                            * (0.2073/(1+EXP(-(TOTAL(no_inds[SNSyoySwimup])-10347.9)/4202.1)))
;PRINT, 'Swimup mortality rate'
;PRINT, Z[SNSyoySwimup]
;Z[SNSyoySwimup] = EXP(-length[SNSyoySwimup] * 0.7) * TurbFunc[SNSyoySwimup] * (0.6505*TOTAL(no_inds[SNSyoySwimup])/(14034.1+TOTAL(no_inds[SNSyoySwimup])))
;Z[SNSyoySwimup] = EXP(-length[SNSyoySwimup] * 0.7) * TurbFunc[SNSyoySwimup] * (0.6021/(1+EXP(-(TOTAL(no_inds[SNSyoySwimup])-18914.6)/12878.6)))
;Z[SNSyoySwimup] = EXP(-length[SNSyoySwimup] * 0.7) * TurbFunc[SNSyoySwimup] * (0.6101/(1+EXP(-(TOTAL(no_inds[SNSyoySwimup])-4263.3)/2192.2)))
;PRINT, 'Swimup mortality rate'
;PRINT, Z[SNSyoySwimup]
;z = z / td; subdaily mortality


IF (vcount GT 0.0) THEN z[v] = 0.
p_pred[SNSyoySwimup] = 1. - EXP(-Z[SNSyoySwimup]) 
;PRINT, 'z =', z
;PRINT, 'p_pred =', p_pred 


; Starvation mortality
optrho[SNSyoySwimup] = OptRhoParam1 * ALOG10(length[SNSyoySwimup]); + OptRhoParam2; same as in SNSinitial and SNSgrowth
op = WHERE(optrho LT OptRhoMin, opcount)
IF (opcount GT 0.0) THEN optrho[op] = OptRhoMin
p_starve[SNSyoySwimup] = p_starveParam1 + p_starveParam2 * (optrho[SNSyoySwimup])
actrho[SNSyoySwimup] = stor[SNSyoySwimup] / (stor[SNSyoySwimup] + struc[SNSyoySwimup])
;PRINT, 'p_starve =', p_starve


;; Suffocaiton mortality from accumulation of DOstress which is converted into MORTinc = proportion of population
;PrMORT = FLTARR(nSNS)
;;DOstressR = DOa - DOacclR; FOR TEST ONLY
;;DOstressR = YEPacclDO(DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, nYP)
;MORTINC = FLTARR(nSNS)
;;PRINT, 'DOstressR =', DOstressR
;DOs = WHERE(DOstressR LT -2.45, DOscount,complement = DOSC, ncomplement = DOSccount)
;IF (DOscount GT 0.0) THEN MORTinc[DOS] = -0.023 * DOstressR[DOS] ELSE MORTinc[DOSC] = 0.0
;PrMORT = MORTinc / 60.0 * ts; each time step for bluegill from Neil et al. 2004 
;;PRINT, 'PrMort =', prmort


; For YOY with exogenous feeding, determine the realized number of individuals lost
FOR i = 0L, nSNS - 1L DO BEGIN
  ; predation
  IF (no_inds[i] LE 1.0) THEN BEGIN; pred[i] = 0.
      PredationProb[i] = RANDOMU(seed, /double);
  ENDIF
  
  IF (no_inds[i] GT 1.0) THEN BEGIN
    IF (p_pred[i] LE 0.0) THEN BEGIN
      pred[i] = 0.0  
    ENDIF ELSE BEGIN
      pred[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], p_pred[i]], /double))
    ENDELSE
  ENDIF 
      
  ; starvation
  IF (no_inds[i] LE 1.0) THEN BEGIN; star[i] = 0.;no_inds[i]
      IF (actrho[i] LT p_starve[i]) THEN BEGIN
          StavationProb[i] = RANDOMU(seed, /double)            
      ENDIF
  ENDIF
  
  IF (no_inds[i] GT 1.0) THEN BEGIN    
    IF (actrho[i] LT p_starve[i]) THEN BEGIN
      star[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], 0.3], /double))
    ENDIF ELSE BEGIN
      star[i] = 0.0
    ENDELSE
  ENDIF  
ENDFOR
;PRINT, 'pred[SNSyoySwimup]'
;PRINT, pred[SNSyoySwimup]
;PRINT, 'star[SNSyoySwimup]'  
;PRINT, star[SNSyoySwimup]  


; For INDS<0, individuals die and change #individual from 1 to 0.
;; >>> #dead individual is simply 1.
YOYtruind = WHERE(no_inds[SNSyoySwimup] LE 1.0, YOYtruindcount) 
IF YOYtruindcount GT 0. THEN BEGIN
  Eaten = WHERE((PredationProb[SNSyoySwimup[YOYtruind]] LT p_pred[SNSyoySwimup[YOYtruind]]), Eatencount $
                , complement = Escape, ncomplement = Escapecount)
  IF Eatencount GT 0. THEN pred[SNSyoySwimup[YOYtruind[Eaten]]] = 1.  
  
  Starved = WHERE((StavationProb[SNSyoySwimup[YOYtruind]] LT p_starve[SNSyoySwimup[YOYtruind]]), Starvedcount $
                  , complement = NStarved, ncomplement = NStarvedcount)
  IF (Starvedcount GT 0.) THEN star[SNSyoySwimup[YOYtruind[Starved]]] = 1.
ENDIF

DeadSNSyoySwimup = WHERE(no_inds[SNSyoySwimup] LT 1.0, DEADSNSyoySwimupcount)
IF (DEADSNSyoySwimupcount GT 0.) THEN BEGIN
  pred[YAO[DeadSNSyoySwimup]] = 0.
  star[YAO[DeadSNSyoySwimup]] = 0.
ENDIF
; overwinter mortality component
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

PRINT, 'Total predation moratlity', TOTAL(pred[SNSyoySwimup])
PRINT, 'Total starvation moraltity', TOTAL(star[SNSyoySwimup])  

TotMort[0, SNSyoySwimup] = ROUND(pred[SNSyoySwimup]); predation
TotMort[1, SNSyoySwimup] = ROUND(star[SNSyoySwimup]); starvation
;PRINT, 'TotMort'
;PRINT, TotMort

PRINT, 'SNSmortYOYswimup Ends Here'
RETURN, TotMort
END