FUNCTION SNSspawn, iDay, DayCounter, SpwnDay, SpwnDay2, SpwnFreq, SpwnInt, weight, stor, struc, gonad, Sex, GSI, discharge, SNSSpwnArray, nSNS, Temp
; This funciton computes spawning events
;SNSSpwnArray = an array for potential spawning adults

PRINT, 'SNSspawn Begins Here'  
  
; Assign array structure
GSImin = FLTARR(nSNS)
SpwnProb = FLTARR(nSNS)
Fecundity = FLTARR(nSNS)
iSpawn = FLTARR(7, nSNS)

; Parameter values 
egg_energy = 45.72; 300.; J/egg ->>>>>>> NEED TO ADJUST FOR STURGEON EGGS. 
; sturgeon egg = 0.0105 g/egg
; 1.04 kcal/g for whitefish = 1.04*4186.8 *0.0105 = 45.72 J/egg
; Energy values assigned for storage and structure in J/g 
; gonadal tissue = 2200 cal/g, Wang et al. 1985, 1987 = storage (?)
gonad_energy = 2200. * 4.1868; in J/g, white sturgeon 
GSIminFemale = 0.15
GSIminMale =  0.03
;p_SpwnParam1 = 
;p_SpwnParam2 =
;p_SpwnParam3 = 


; Spawning occurs only when GSI  above the minimum threshold
Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
IF femalecount GT 0. THEN GSImin[female] = GSIminFemale; GSI of stage IV female
IF malecount GT 0. THEN GSImin[male] = GSIminMale; GSI of stage II male

;PRINT, 'minimum GSI threshold'
;PRINT, GSImin[SNSSpwnArray]
;PRINT, 'GSI',  MEAN(GSI[SNSSpwnArray]), MAX(GSI[SNSSpwnArray]), MIN(GSI[SNSSpwnArray])
SpwnAdlt = WHERE(GSI[SNSSpwnArray] GT GSImin[SNSSpwnArray], SpwnAdltcount, complement = NSpwnAdlt, ncomplement = NSpwnAdltcount)
PRINT, 'Number of adults with minimum GSI threshold', SpwnAdltcount


; Spawning probability
p_Spwn = 0.395 * EXP(-0.5 * ((Temp - 18.) / 3.055)^2.) < 1.; this function is based on Gaussian with peak temo at 17-19 C
;p_Spwn = 0.04; Railsback et al. 2006? for salmonids
;p_Spwn= (65.252 * EXP(-EXP(-(discharge - ALOG(ALOG(2.)) - 111.03)/63.3)))/100.

; Draw a random number from a uniform distribution for spawning
FOR iSpwn = 0L, nSNS-1L DO SpwnProb[iSpwn] = RANDOMU(seed, /double); RANDOMN(seed, BINOMIAL = [nSNS, p_pred[iPred]], /double)/nSNS

IF SpwnAdltcount GT 0. THEN BEGIN     
  Spwn = WHERE((SpwnProb[SNSSpwnArray[SpwnAdlt]] LT p_Spwn), Spwncount, complement = nonSpwn, ncomplement = nonSpwncount)
  PRINT, 'Number of actually spawning adults', Spwncount 

  IF Spwncount GT 0. THEN BEGIN; gonad energy-dependent fecundity
    SpwnAdltFemale = WHERE(SEX[SNSSpwnArray[SpwnAdlt[Spwn]]] EQ 1., SpwnAdltFemalecount, complement = NSpwnAdltMale $
                          , ncomplement = NSpwnAdltMalecount)
    PRINT, 'Number of actually spawning females', SpwnAdltFemalecount 
    IF SpwnAdltFemalecount GT 0. THEN BEGIN; gonad energy-dependent fecundity
      ; spawning females only
      Fecundity[SNSSpwnArray[SpwnAdlt[Spwn[SpwnAdltFemale]]]] = ROUND(gonad_energy $
        * (gonad[SNSSpwnArray[SpwnAdlt[Spwn[SpwnAdltFemale]]]])/ egg_energy)
     ;PRINT, 'Fecundity'
     ;PRINT, Fecundity[SNSSpwnArray[SpwnAdlt[Spwn[SpwnAdltFemale]]]] 
     ;PRINT, 'GIS'
     ;PRINT, GSI[SNSSpwnArray[SpwnAdlt[Spwn[SpwnAdltFemale]]]]
    ENDIF
    ; weight loss due to spawning
    gonad[SNSSpwnArray[SpwnAdlt[Spwn]]] = 0.02 * weight[SNSSpwnArray[SpwnAdlt[Spwn]]]; one-batch spawning for now
    Weight[SNSSpwnArray[SpwnAdlt[Spwn]]] = Struc[SNSSpwnArray[SpwnAdlt[Spwn]]] + Stor[SNSSpwnArray[SpwnAdlt[Spwn]]] $
                                          + gonad[SNSSpwnArray[SpwnAdlt[Spwn]]]
    
    SpwnInt[SNSSpwnArray[SpwnAdlt[Spwn]]] = (DayCounter - SpwnDay[SNSSpwnArray[SpwnAdlt[Spwn]]]) /365.                                                                    
    SpwnDay[SNSSpwnArray[SpwnAdlt[Spwn]]] = DayCounter
    SpwnDay2[SNSSpwnArray[SpwnAdlt[Spwn]]] = iday
    SpwnFreq[SNSSpwnArray[SpwnAdlt[Spwn]]] = SpwnFreq[SNSSpwnArray[SpwnAdlt[Spwn]]] + 1L
    NonRepSpwn = WHERE(SpwnFreq[SNSSpwnArray[SpwnAdlt[Spwn]]] LE 1., NonRepSpwncount)
    IF NonRepSpwncount GT 0. THEN SpwnInt[SNSSpwnArray[SpwnAdlt[Spwn[NonRepSpwn]]]] = 0.
;    PRINT, 'SpwnInt'
;    PRINT, SpwnInt[SNSSpwnArray[SpwnAdlt[Spwn]]] 
;    PRINT, 'SpwnDay'
;    PRINT, SpwnDay[SNSSpwnArray[SpwnAdlt[Spwn]]]
  ENDIF
ENDIF

; if (JD eq 91) and (Wt[i] ge 250) then begin;JD=91->Apr-1 spawning event
; if (sex[i] eq 1) then begin; sex=1, females
; Wt=Wt-Wt*0.2; GSI=20%, weight loss for spawning
; endif
; endif else begin Wt=Wt
; endelse
;  
; ;recruitment
; P=round(total(Wt[where(sex eq 1)] ge 250));number of spawners
; a=8.5; from walleye in Lake Erie, Madenjian et al. (1996)
; b=0.0085
; Re=round(P*a*exp((-b)*p)); number of recruits with Ricker spawner-recruitment model
;   
; ;mortality
; N_dead=round(randomu(x,ni,BINOMIAL=[1,0.0005])); annual 20% mortality-> 0.2/365=0.0005 per day, 1=dead, 0=alive
; dead=where(N_dead eq 1, dead_fish)
; alive=where(N_dead eq 0, alive_fish)
; Wt=Wt[alive]  
; ni=1000-total(N_dead)
;
;;adding new recruits 
; for yr=2, i-1 do begin
; if yr eq yr+1 then begin
; n2=Re; number of new individuals
; Wt_re=randomu(seed,n2)*(max(150)-min(50))+min(50); randomly assigned weights (g) between 50 and 150
; Sex_re=round(randomu(x,n2)); 1=female, 0=male
; 
;  ;weight loss due to spawning
;  if (JD eq 91) and (Wt_re[i] ge 250) then begin;JD=91=>Apr-1
;  if (sex_re[i] eq 1) then begin; sex_re=1, females
;  Wt_re=Wt_re[where(sex eq 1)]-Wt_re[where(sex eq 1)]*0.2; GSI=20%, weight loss for spawning
;  endif
;  endif else begin Wt_re=Wt_re
;  endelse
; 
;  ;recruitment
;  P_re=round(total(Wt_re[where(sex eq 1)] ge 250));number of perch spawners
;  a=8.5; from walleye in Lake Erie,Madenjian et al. (1996)
;  b=0.0085
;  Re_re=round(P_re*a*exp((-b)*P_re)); number of recruits with Ricker spawner-recruitment model 
; 
;  ;mortality
;  N_dead=round(randomu(x,Re,BINOMIAL=[1,0.0005])); annual 20% mortality-> 0.2/365=0.0005 per day, 1=dead, 0=alive
;  dead=where(N_dead eq 1, dead_fish)
;  alive=where(N_dead eq 0, alive_fish)
;  Wt_re=Wt_re[alive] 
;  
;  endfor
;  Wt=[Wt[*], Wt_re[*]]
;  Re=Re+Re_re 
; endif
 
iSpawn[0, SNSSpwnArray] = fecundity[SNSSpwnArray]
iSpawn[1, SNSSpwnArray] = weight[SNSSpwnArray]
iSpawn[2, SNSSpwnArray] = gonad[SNSSpwnArray]
iSpawn[3, SNSSpwnArray] = SpwnInt[SNSSpwnArray]
iSpawn[4, SNSSpwnArray] = SpwnDay[SNSSpwnArray]
iSpawn[5, SNSSpwnArray] = SpwnDay2[SNSSpwnArray]
iSpawn[6, SNSSpwnArray] = SpwnFreq[SNSSpwnArray]
;PRINT, 'iSpawn'
;PRINT, iSpawn
PRINT, 'SNSspawn Ends Here'
RETURN, iSpawn
END