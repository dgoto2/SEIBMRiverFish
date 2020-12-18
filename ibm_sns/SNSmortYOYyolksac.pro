FUNCTION SNSmortYOYyolksac, length, stor, struc, no_inds, nSNS, SNSyoyYolksac, TURB, temp
; This funciton determines daily mortality rates for shovelnose sturgeon

PRINT, 'SNSmort Begins Here'

; Assign array structure
HeatMort = FLTARR(nSNS)
p_thermo = FLTARR(nSNS)
Z = FLTARR(nSNS)
TurbFunc = FLTARR(nSNS)
p_pred = FLTARR(nSNS)
TotMort = FLTARR(4, nSNS)
Pred = FLTARR(nSNS)

; Parameter values
;p_thermoParam1
;p_thermoParam2
;p_thermoParam3
;TurbFuncParam1
;TurbFuncParam2
;TurbFuncParam3
YolksacZParam = 0.553

; eggs & yolksac larvae have length & weight = 0

; Egg and yolk sac larva (temperature-related) mortality;>>>>>>>NEED TO ADJUST FOR STURGEON<<<<<<<<   

; CONSTANT MORTALITY RATE  >>> XX %
; LETHAL TEMPERATURE THRESHOLD (LOWER AND UPPER)
; lethal temperature for shovelnose embryos 8C and 28C
; no survival difference between 12 and 24C, though highest survival rates are between 12 and 20C

; Temperature-dependent mortality
;LethalHeat = WHERE(Temp[SNSyoyYolksac] GE 24., HeatMortcount)
; probablity based on a sigmoidal function
p_thermo[SNSyoyYolksac] = 1.1564/(1+EXP(-(Temp[SNSyoyYolksac]-28.2889)/1.0616)) <1.

;IF (HeatMortcount GT 0.) THEN BEGIN
  ;p_thermo[SNSyoyYolksac[LethalHeat]] = 0.3
  FOR i = 0L, nSNS - 1 DO BEGIN
    ; thermal mortality
    IF (no_inds[i] LE 1.0) THEN HeatMort[i] = 0.;no_inds[i]
    IF (no_inds[i] GT 1.0) THEN BEGIN
      IF (p_thermo[i] LE 0.0) THEN BEGIN
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
;IF TOTAL(SNSyoyYolksac) GT 0. THEN BEGIN
; daily mortality rate for YOY, 0.9996/365 = 0.00274(suvival rate from egg to age1 = 0.0004) by Pine et al., 2001

; size-based background predation mortality

;litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc. 
;;>>>>>>>NEED TO ADJUST FOR STURGEON  WITH A TURBIDITY FUNCITON <<<<<<<<
TurbFunc[SNSyoyYolksac] = 1.2102/(1+EXP(-(TURB[SNSyoyYolksac]-298.6103)/(-178.8772))) < 1.; white sturgeon by Gadomski and Parsley 2005 TAFS

;z = 0.4 * EXP(-1.0*(length) * 0.06); High mort
;z = 0.4 * EXP(-(length) * 0.08); Low mort                   
;>>>>>>>NEED TO ADJUST FOR STURGEON<<<<<<<<  
; YOY sturgeon instantaneous mortality rate Z =0.25 - 0.64 based on 5-day survey by Phelps et al. 2010 
Z[SNSyoyYolksac] = YolksacZParam * TurbFunc[SNSyoyYolksac]; 0.9996/10.

; paramerter values that worked on desktop
;      final population size
;.426 : 115931    
;.428 : 33721;DID NOT WORK (w/ YAO mort-0.3- too high)
;.429 :                    
;.430 : 73026
;.431
;.432 : ~50800; too high
;.433 :
;.434 :
;.435 :
;.436 : 28327; 81937; too high(w/ YAO mort-0.3- too high); 282356(w/ YAO mort-0.3 & gonad & F mature age=7 -too high) 
;.437 : 42882; 81953 (ml: 500/550)
;.438 : ~84300
;.439
;.440
;.441 : 75297
;.442 : 17125; DID NOT WORK (???)
;.443 : too high
;.444 : 111083
;.445 : ~85000; ~74500; too high(w/ YAO mort-0.3); 214732(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)      
;.448 : ~88000;
;.449 : 22593; DID NOT WORK (???- too high)
;.450 : 55113; DID NOT WORK (???)
;.451
;.452 : 74361;DID NOT WORK (w/ YAO mort-0.3- too high)
;.453 : 103924(a little too high)
;.454 : 22753(too low); DID NOT WORK (???- too high)
;.455 : 52301 DID NOT WORK(w/ 510/560 YAO mort-0.35)
;.456
;.457 : too low; too high w/ correct rho
;.458 : 64561; 46436; too high(123203 w/ YAO mort-0.3); 152043(w/ YAO mort-0.3 & gonad & F mature age=7 - too high) 
;.460 : 90368;
;.463 : 66203(w/ 510/560 YAO mort-0.35);
;.465 : 73821(w/ 510/560 YAO mort-0.35);DID NOT WORK (w/ YAO mort-0.3- too high)
;.468
;
;.470
;.471 : 82384(w/ 510/560 YAO mort-0.35)
;.472 : 115791(w/ YAO mort-0.3 & gonad & F mature age=7 -ok); --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;.473 : too high(w/ YAOmort-0.3 & 0.9 fishing=X0.4 gonad & Fmature age=7, Fspwn=0.16) 
;.474 : --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;.475 : 107011(w/ YAO mort-0.3 & gonad & F mature age=7 -ok-ish)
;.476 : --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)                        
;.477 :--(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;.478 : 188328(w/ YAO mort-0.3 & gonad -  too high); 121227(w/ YAO mort-0.3 & gonad & F mature age=7 -ok-ish, bit too high)
;.479 :                        
;.480 : 139273(w/ YAO mort-0.3 & gonad & F mature age=7 -OK-ish)
;.481
;.482
;.483
;.484 : --(w/ YAOmort-0.3 & 0.9 fishing=X0.4 gonad & Fmature age=7, Fspwn=0.16,)
;.485 : too high(w/ YAO mort-0.3 & gonad & F mature age=7)
;.486 : 110197(w/ YAO mort-0.3 & gonad & F mature age=7 -ok-ish); a little too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16) 
;.488 : --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;
;.491 : too high(w/ YAOmort-0.3 & 0.9 fishing=X0.4 gonad & Fmature age=7, Fspwn=0.16) 
;.492
;.493 : --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;.494 : --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;.495 : 81382(w/ YAO mort-0.3 & gonad & F mature age=7 -ok); --(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & Fmature age=7, Fspwn=0.16)
;.496 : 74824(w/ YAO mort-0.3 & gonad & F mature age=7 - ok-ish, little low in 2005) 
;.497 : too low(w/ YAOmort-0.3 & FIXED fishing=X0.4 gonad & Fmature age=7, Fspwn=0.16)
;.498 : 6278; 177823(w/ YAO mort-0.3 & gonad - too high); too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;.499 : 21726; 123203(w/ YAO mort-0.3); 56122(w/ YAO mort-0.3 & gonad???); 133258(w/ YAO mort-0.3 & gonad)
;.500 :                         
;.501
;.502
;.503 :                   
;.504
;.505
;
;.511 : too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)                  
;.513 : 39486(w/ 510/560 YAO mort-0.35); 71132(w/ 510/560 YAO mort-0.35)
;.514 : too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)                    
;.516 : 93766(w/ YAO mort-0.3)
;
;.520 : 30584
;.521 : too low; 170894(w/ YAO mort-0.3 & gonad -  too high); too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)
;.522 :                    
;.523 : too low; 92139(w/ YAO mort-0.3 & gonad)***; 60725(w/ YAO mort-0.3 & gonad & F mature age=7 -too low)
;.524 : too low; 108050(w/ YAO mort-0.3 & gonad); 
;.525 : 49813; 9778(w/ 510/560 YAO mort-0.35 - too low); 111754, 174105(w/ YAO mort-0.3 & gonad - too high); too low(w/ YAO mort-0.3 & gonad & F mature age=7) 
;       ; too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)
;.526 : 37257
;.527 : 34334; 89285(w/ YAO mort-0.3 & gonad)***
;.528 :                    
;.529 : 49817; 98537(w/ YAO mort-0.3 & gonad)**
;.530 : 2203; too high(w/ YAO mort-0.3 & gonad)
;.531 : too high(w/ YAO mort-0.3 & gonad); too low(w/ YAO mort-0.3 & gonad & F mature age=7) 
;.532 
;.533 : 63100(w/ 510/560 YAO mort-0.35); 80948(w/ YAO mort-0.3 & gonad)***; too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)
;.534 : 60081(w/ YAO mort-0.3 & gonad)**
;.535 : 122000(w/ YAO mort-0.3 & gonad -too high); 
;.536 : >110000(w/ YAO mort-0.3 & gonad -too high)
;.537 : 121720(w/ YAO mort-0.3 & gonad -too high); too high(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)
;.538 : 39590(w/ YAO mort-0.3 & gonad & F mature age=7- too low)
;.539 : too high(w/ YAO mort-0.3 & gonad)
;.540 : 33075(w/ YAO mort-0.3 & gonad & F mature age=7- too low)
;.541 : 77565(w/ YAO mort-0.3 & gonad)***; 37657(w/ YAO mort-0.3 & gonad & F mature age=7- too low)too high in 2001(w/ YAOmort-0.35 & FIXED fishing=X0.5 gonad & M,Fmature age=4,6, Fspwn=0.16)
;.542 : 87468(w/ YAO mort-0.3 & gonad)***; 49280(w/ YAO mort-0.3 & gonad & F mature age=7 -too low)
;.543 : >110000(w/ YAO mort-0.3 & gonad -too high) ;--(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)                
;.544 : 86505(w/ YAO mort-0.3 & gonad)***; 42736(w/ YAO mort-0.3 & gonad & F mature age=7 -too low)
;.545 : 137990(w/ YAO mort-0.3 & gonad -too high)
      ; 52424-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
;.546 : 122677(w/ YAO mort-0.3 & gonad -too high)
      ; 50142-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
;.547 : ~93000(w/ YAO mort-0.3 & gonad)**
      ; 33687-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
;.548 : 44240(w/ YAO mort-0.3 & gonad)**; 37680-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)  
;.549 : 56214(w/ YAO mort-0.3 & gonad)***
      ; 36299(w/ YAO mort-0.3 & gonad & F mature age=7 -too low)
;       --(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
;.550 : 68907(w/ YAO mort-0.3 & gonad)**
      ; bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)*
;       187533
;.551 : 99890(w/ YAO mort-0.3 & gonad)*
      ; 64093(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)***
      ; 39946-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
      ; 37303-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, sex reasigned)
      ; 37303(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, sex reasigned)
      ; 114961(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.145, from 1991, sex reasigned, intpop=40000)
      ; 326659- too high(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, sex reasigned, intpop=50000)
      ; 83085-low in 2004 and too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000)
      ; 60007-low in 2004 and too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000, swimupstarv=0.6)**
      ; 54087(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000, EggPred=0.992)
      ; 60091(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8)****
      ; 71226-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8)
      ; 80923-too high in 2008(w/ YAOmort-0.34 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8)
      ; 71818-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.7,0.674)
      ; 71706- bit too high in 2008(w/ YAOmort-0.34 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.7)
      ; 
      ; 
      ; 
;.552 : 77287(w/ YAO mort-0.3 & gonad)**
      ; 39425-too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
      ; 85608-too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000)
;.553 : 78045(w/ YAO mort-0.3 & gonad)**; 
      ; might work need to tty again(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000)
      ; 54203(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000)****
      ; too high in 2008(w/ YAOmort-0.34 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.145, from 1991, intpop=45000, swimupstarv=0.6)
      ; 68051-too high in 2008(w/ YAOmort-0.34 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.6)
      ; 66266-too high in 2008(w/ YAOmort-0.34 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.5)
      ; 66404-too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000, swimupstarv=0.6)
      ; 72847-too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.5)
      ; 73783-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.5)
      ; 64440(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.7)**
      ; >100000-too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.7)

      ; 82185-bit high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8,W/ sex reasign)
      ; 85406-bit high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=49000, swimupstarv=0.8,W/ sex reasign)
      ; 76412-bit high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=50000, swimupstarv=0.8,W/ sex reasign)
      ; 69327-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=49000, swimupstarv=0.8,W/ sex reasign)
      ; 81987-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8,W/ sex reasign)
      ; 97382-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8,W/ sex reasign)
      ; 74897-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=44000, swimupstarv=0.8,W/ sex reasign)
      ; 70227-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000, swimupstarv=0.8,W/ sex reasign)
      ; 59838(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.8,W/ sex reasign)**
      ; 67486(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000, swimupstarv=0.8,W/ sex reasign)**
      ; 
      ; 
      ; 64877-too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8, W/O sex reasign)
      ; 50806(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8, W/O sex reasign)***
      ; 58795-(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.8, W/O sex reasign)***
      ; 77572-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=49000, swimupstarv=0.8, W/O sex reasign)
      ; 83864-bit too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign)
      ; 109723-too high in 2008(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=48000, swimupstarv=0.9, W/O sex reasign)**
      ;      
      ; 55402(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.8, W/O sex reasign)***     
      ; 66811(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8,W/ sex reasign)**
      ; 62828(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8,W/ sex reasign)***

      ; 
      ; 
      ; 
      ; 59977(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000, swimupstarv=0.6)**
      ; <60000(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=46000, swimupstarv=0.7)**

      ; 50816(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign, pimmig = 0.004)***  
      ; 66592(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign, pimmig = 0.003)***  
      ; 124393(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign, pimmig = 0.002)***  
      ; 60175(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign, pimmig = 0.001)***  
      ; 88103(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign, pimmig = 0.000)***  
      ; 66596(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=47000, swimupstarv=0.8, W/O sex reasign, pimmig = 0.004, drift habitat = 0.1)***  
      


;.554 : 56973(w/ YAO mort-0.3 & gonad)**
      ; 72164(w/ YAOmort-0.35 & FIXED fishing=X0.7 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991, intpop=45000)
;.555 : too low(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)                   
;.556 : too low(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
;.560 : 52201, bit too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1991)
;       too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1990)
; 561 : 54535, too low in 2004(w/ YAOmort-0.35 & FIXED fishing=X0.8 gonad & M,Fmature age=4,6, Fspwn=0.15, from 1990)  
;________________________________________________________________________________________________________________________________________________
 
; paramerter values that worked on laptop (W/ tempearture-dependent spawning function)
;param: Final population size
;.427 :
;.429 : ~41000
;.431 : ~40000
;.433 : ~79000
;.436 : ~117000
;.437 : ~33000
;.440 : ~72000
;
;.445 : 
; 
;.455 : >150000(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)
;.457 :
;.459 :
;.460 : >170000(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)
;.461 :
;,463
;.464 : too high(w/ YAO mort-0.3 & gonad & F mature age=7)
;.465
;.466 : 
;.467 : >130000(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)
;.469 :
;.470 : >130000(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)
;.471 :
;.472 : --(w/ YAOmort-0.3 & 0.9 fishing=X0.4 gonad & Fmature age=7, Fspwn=0.16,) 
;.473 : --(w/ YAOmort-0.3 & 0.9 fishing=X0.4 gonad & Fmature age=7, Fspwn=0.16,)                   
;.474 : 
;.475 : ~113000(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)
;.476 : >130000(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)            
;.477 : ~120000(w/ YAO mort-0.3 & gonad & F mature age=7)
;.478 : 85554(w/ YAOmort=0.3); 134300(w/ YAO mort-0.3 & gonad & F mature age=7 -too high)
;.479 :                   
;.480 : 79434(w/ YAOmort=0.3); too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;.481 : 71072; 
;.482 :
;.483 :
;.484 : too high(w/YAOmort=0.3),
;
;
;.503 : 82040
;.504 : too high(w/ YAOmort=0.3 & goand)
;.505 : too high(w/ YAOmort=0.3 & goand)
;
;
;.513 : too high(w/ YAOmort=0.3 & gonad)
;
;
;.523 : 87493(w/ YAOmort=0.3 & gonad)***; too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;
;.525 : 77797(w/ YAOmort=0.3 & gonad)***
;.526 : too high(w/ YAOmort=0.3 & gonad)
;.527 : 110932(w/ YAOmort=0.3 & gonad - too high); too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;.528
;.529 : 83288(w/ YAOmort=0.3 & gonad)**
;.530
;.531 : too high(w/ YAOmort=0.3 & gonad)
;.532
;.533 : 125544(w/ YAOmort=0.3 & gonad -too high)
;.534
;.535 : too high(w/ YAOmort=0.3 & gonad)
;.536
;.537 : 134170(w/ YAOmort=0.3 & gonad -too high)
;.538
;.539 : 70653(w/ YAOmort=0.3 & gonad)***; too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;.540 : too high(w/ YAOmort=0.3 & gonad)
;.541 : 95775(w/ YAOmort=0.3 & gonad)**; too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;.542 
;.543 : too high(w/ YAOmort=0.3 & gonad); too low(w/ YAO mort-0.3 & gonad & F mature age=7)
;.544
;.545 : too low(w/ YAOmort=0.3 & gonad)
;.546
;.547 : 78722(w/ YAOmort=0.3 & gonad)***
;.548
;.549
;.550
;.551
;.552 : 56156(w/ YAOmort=0.3 & gonad)*
;.553 : 58633(w/ YAOmort=0.3 & gonad)*
;.554 : 37851(w/ YAOmort=0.3 & gonad)*
;.555
 
 
; paramerter values that worked on laptop (W/O tempearture-dependent spawning function)
;.? ->final population size: ~

; No - 

; paramerter values that worked on desktop
;.605 -> //
;
;.6 -
;.627 -> //                    work w/ old params not w/ new params
;.635 -> //                    73287
;.639 -> //                    59475
;.641 -> //                    45883
;.655 -> //                    38072 
;.663 -> //                    33812 
;.669 ->  //                   35874
;.673 -> final population size: 43818     

;                              
; NO - .585, .625(too high),.626(too high), .637(too high?), .640(too low)
 
;PRINT, 'Swimup mortality rate'
;PRINT, Z[SNSyoySwimup]
;z = z / td
;v = WHERE(z LT 0.0, vcount)
;IF (vcount GT 0.0) THEN z[v] = 0.0

p_pred[SNSyoyYolksac] = 1.0 - EXP(-Z[SNSyoyYolksac])
;PRINT, 'z =', z
;PRINT, 'p_pred =', p_pred 

; determine the realized number of individuals lost
FOR i = 0L, nSNS - 1 DO BEGIN
  IF (no_inds[i] LE 1.0) THEN pred[i] = 0.
  IF (no_inds[i] GT 1.0) THEN BEGIN
   IF (p_pred[i] LE 0.0) THEN BEGIN 
     pred[i] = 0.0  
   ENDIF ELSE BEGIN
    pred[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], p_pred[i]], /double))
   ENDELSE
  ENDIF 
ENDFOR

;pred[SNSyoyYolksac] = ROUND(no_inds[SNSyoyYolksac]* 0.4 * TurbFunc[SNSyoyYolksac]); CONSTANT FOR NOW

; Check if individuals are already dead
DeadYorksac = WHERE(no_inds[SNSyoyYolksac] LT 1.0, DeadYorksaccount)
IF (DeadYorksaccount GT 0.) THEN pred[SNSyoyYolksac[DeadYorksac]] = 0.


TotMort[0, SNSyoyYolksac] = ROUND(pred[SNSyoyYolksac]); predation
;TotMort[1,*] = ROUND()
TotMort[2, SNSyoyYolksac] = ROUND(HeatMort[SNSyoyYolksac]); thermal mortality
;PRINT, 'TotMort'
;PRINT, TotMort

PRINT, 'SNSmort Ends Here'
RETURN, TotMort
END