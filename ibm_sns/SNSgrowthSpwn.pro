FUNCTION SNSgrowthSpwn, length, weight, stor, struc, gonad, sex, tExpSpwn, tEndGrwth, GonadInt, SpwnStatus $
                      , SNScmx, consumption, SNSres, Temp, nSNS, iday, nSNSSpwn, SNSSpwnArray, iyear, LonLoc
; Function to determine growth of shovelnose sturgeon WITH SPAWNING

; Growth for eggs and yolksac larvae is 0 (no adjustment is necessary).
; shovelnose sturgeon lost weights at 8 and 10C in the experiments.
; highest weight was observed 24C, which is not significantly different from 16 or 28C.


;***TEST ONLY; TURN OFF when running with the full model**********************************************************************
;iDay = 300L
;nSNS = 50L
;m = 5L
;
;SEX = ROUND(RANDOMU(seed, nSNS)) ;randomly assign sex
;
;CONSUMPTION = FLTARR(m, nSNS)
;CONSUMPTION[0, *] = 4. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[1, *] = 4. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[2, *] = 5. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[3, *] = 6. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[4, *] = 6. + randomn(seed, nSNS)*.01; in G/DAY
;PRINT, 'Consumption per prey (CONSUMPTION, g)'
;PRINT, CONSUMPTION
;
;SNSres = 600. + randomn(seed, nSNS)* 50.; in J/DAY
;
;length = 650. + RANDOMN(SEED, nSNS) * 50.; SNS[1, *]; in mm
;Weight = 0.00002665*LENGTH^2.6991 + RANDOMN(SEED, nSNS) * 150.; SNS[2, *]; g
;STRUC = 2.5*0.00001 * (length)^(2.8403*0.91)
;STOR = Weight - struc
;GONAD = 3.
;
;tExpSpwn = 150. + 360.; the expected spawning day (DOY) + 1 YEAR(MINIMUM GONAD MATURATION TIME = 2 YEARS???)
; >>>> Fixed (?) ->>>>>> find an earliest day that sturgeon spawn
;;tlastgrowth= WHERE((iDay GT 150.) AND (energy_change GT 0.), tlastgrowthcount); check for DOY and this is done only once
;; >>>>>>> conditions for spawning <<<<<<<<<
;
;;>>>>> may need store DOY and energy in the gonad compartment at the end of growing season
;tEndGrwth = 280
;GonadtEndGrwth = 20; >>>SHOULD BE IN THE INITIALIZATION STATE VARIABLE
;;t1 = DOYlastgrowth; the end of growing season = the first day the net energy is < 0 ->>>>>> from the previous year's simulation
;;G1 = Ngonadt1; energy content in the gonad compartment at the end of growing season ->>>>>> from the previous year's simulation


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PLACE IT OUTSIDE THE GROWTH SUBROUTINE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                                                
;; If fish reach minimum length at maturity (different for males and females)-> from the literature
;; then age at maturity is determined

;; Estimate physiological condition using KS to determine energy allocaiton to gonad
;; At the beginning of each annual spwaning cycle, check (only once) 
;for maturity and physiological condition to initiate the spawning cycle...
;; Check if fish are in the spawning cycle (KS > KS2), if so, check for the physiological condition...
;; -> this state variable lasts for the whole annual spawning cycle 
;>>>> MAY NEED TO CREATE THEIR REPRODUCTIVE STATUS AS A STATE VARIABLE<<<<
;;IF AnnuSpawn EQ 1. THEN BEGIN; AnnuSpawn = 1.; spawning, AnnuSpawn = 0.; non-spawning
;;->>>> it might be better as WHERE funcitons<<<<<<
;;ENDIF
;; NEED TO CREATE AND CHECK FOR SPAWNING STATUS -> IF FISH SPAWN, FISH LOSE GONAD WEIGHT  
;
;;>>>>Estimate energy/weight allocation rates for soma, storage, and gonad...>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;; use monthly schedule for energy allocation to soma, storage, and gonad (?)
;
;; Check for maturity status...>>> body length-dependent
;;>>> Check if fish reached maturity at the end of the growing season (?)...
;; once fish have reased maturity, no need to check these individuals
;; >>>>>>NEED state variable for maturity status<<<<<
;; Maturity = ; immature = 0; mature = 1
;
;; The reproductive cycle is between the end of growing season and the spawning day.... 
;>>>> gonad maturation may be happening during the growing season
;; Spawning mature adults...
;; AND Check for the physiological codition


;; INITIAL TOTAL NUMBER OF FISH POPUALTION IN LOWER PLATTE RIVER
;NpopSNS = ; number of SNS individuals

;SNS = SNSinitial(NpopSNS, nSNS, TotBenBio, NewInput)
;length = SNS[1, *]; in mm
;Weight = SNS[2, *]; g
;stor = SNS[3, *]; g
;struc = SNS[4, *]; g
;Temp = SNS[26, *]; acclimated temperature
;SNScmx = SNScmax(weight, length, nSNS, temp); Cmax in g 

;Tamb = SNS[19, *]
;SNSres = SNSresp(Tamb, TacclC, Weight, Length, ts, DOa, DOacclR, DOcritR, nSNS)
;******************************************************************************************************************************

PRINT, 'SNSgrowth with Spawning Begins Here'
tstart = SYSTIME(/seconds)

; Assign array structure
;nSNS = nSNSSpwn
; Gexp = FLTARR(nSNS)
; gKSfunc = FLTARR(nSNS)
m = 5; a number of prey types   >>>>>>>>>>>>>>>> NEED TO ADJUST FOR THE LOWER PLATTE RIVER STURGEON <<<<<<<<<<<<<<<<<<
EDprey = FLTARR(m, nSNS)
ConsJ = FLTARR(m, nSNS) ;joules of prey consumed per time step
ConsJtot = FLTARR(nSNS)
StrucOpt = FLTARR(nSNSSpwn)
SomaExp = FLTARR(nSNSSpwn)
GonadExp = FLTARR(nSNSSpwn)
GonadAllocR = FLTARR(nSNSSpwn); daily rate of energy allocation to the gonad
GSImax = FLTARR(nSNSSpwn)
gKS = FLTARR(nSNSSpwn);
gKSwEDC = FLTARR(nSNSSpwn);
Nstor = FLTARR(nSNS)
Nstruc = FLTARR(nSNS)
Nstr = FLTARR(nSNS)
Nstrc = FLTARR(nSNS)
nLength = FLTARR(nSNS)
New_Stor = FLTARR(nSNS)
New_Struc = FLTARR(nSNS)
New_Weight = FLTARR(nSNS)
Pot_Length = FLTARR(nSNS)
New_Length = FLTARR(nSNS)
Ngonad = FLTARR(nSNS)
New_Gonad = FLTARR(nSNS)
GrowthAttribute = FLTARR(13, nSNS)


; Parameter values
ChironomidED = 3138.;j/g- benthos/chironomidae 
; >IMPORT SWIMMING AND POSITION-HOLDING COSTS FROM THE FORAGING SUBMODEL
FA = 0.15; Egestion ; Parameter values (for white sturgeon, Bevelhimer 2002. J Appl. Ichthyol.)
UA = 0.05; Excretion
SDA = 0.12; Specific dynamic action
; Energy values assigned for storage and structure in J/g 
; somatic tissue = 1050 cal/g, USDA 2001
; gonadal tissue = 2200 cal/g, Wang et al. 1985, 1987 = storage (?)
stor_energy = 2200. * 4.1868; white sturgeon
struc_energy = 1050. * 4.1868; white sturgeon

;***Some of the following paramters are modified to to reduce penalty for lower physiological condition 
; and limit maximum spawning interval (<~5 years when KS >0.7)
cG = 18.5; 7.5; rate constant in the funciton for reallocation of energy from soma to gonad
KSspawn = 0.7; minimum index of condition to continue a spwaning cycle
KSmax = 1.3; estimate upper energy bounds >>>>>NEED TO ESIMATE FOR STURGEON <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
KSmin = 0.5; minimum index for starvation
KSnorm = 1.; =KS1, optimal physiological condition
;KS2 = 0.8; minimum index for initiating an annual spwawning cycle

; ***Calibrated with Lower Platte River shovelnose sturgeon data in 2009-2011
Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
asF = 0.00000031; parameter for the energy content of the somatic/structural compartment as a function of length
bsF = 3.39; parameter for the energy content of the somatic/structural compartment as a function of length
asM = 0.00000031; parameter for the energy content of the somatic/structural compartment as a function of length
bsM = 3.39; parameter for the energy content of the somatic/structural compartment as a function of length
agF = 0.22; 0.09; parameter for the upper bound of the gonad compartment as a function of the expected energy content of the structural compartment
bgF = 1.05; 1.10; parameter for the upper bound of the gonad compartment as a function of the expected energy content of the structural compartment
agM = 0.001; 0.09; parameter for the upper bound of the gonad compartment as a function of the expected energy content of the structural compartment
bgM = 1.29; 1.10; parameter for the upper bound of the gonad compartment as a function of the expected energy content of the structural compartment
SpwnIntF = 3.; minimum spawning interval in years for female
SpwnIntM = 1.; minimum spawning interval in years for male
tExpSpwn = 82.; expected spawning date = ~March 23rd (DLH = 12h) 
IF femalecount GT 0. THEN GSImax[female] = 0.27
IF malecount GT 0. THEN GSImax[male] = 0.04

EDCIntYear = 1995L
EDCRecovYear = 2021L
;EDCIntDay = 121L; the initial day for the EDC effect (the beginning of the growing season)
;EDCFinDay = 304L; the final day for the EDC effect (th end of the growing season)

VTGtoGonadCF = 1.
IF (iyear GE EDCIntYear) AND (iyear LE EDCRecovYear) THEN VTGtoGonadCF = 1.; BEGIN
  ;IF (iday GE EDCIntDay) AND (iday LE EDCFinDay) THEN VTGtoGonadCF = 1.
;ENDIF

LengthStrucWYAOParam1 = 1.545*59.761
LengthStrucWYAOParam2 = 0.3038


; energy density of the prey (j/g wet)
EDprey[0, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[1, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[2, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[3, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[4, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
;EDprey[5, *] = 3138.; RANDOMU(seed, nSNS)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);
;PRINT, 'Prey energy density (J)'
;PRINT, EDprey

;PRINT, 'Consumption per prey (Consumption, J)'
;PRINT, Consumption[0:4, 0:99]
;PRINT, 'Respiration (SNSres, J)'
;PRINT, SNSres[*, 0:99]
;PRINT, 'structural weight (struc, g)'
;PRINT, struc[0:99]


; Convert the amount of consumed prey to energy
ConsJ[0, SNSSpwnArray] = consumption[0, *] * EDprey[0, SNSSpwnArray] ;converts consumption to J/ts
ConsJ[1, SNSSpwnArray] = consumption[1, *] * EDprey[1, SNSSpwnArray] ;converts consumption to J/ts
ConsJ[2, SNSSpwnArray] = consumption[2, *] * EDprey[2, SNSSpwnArray] ;converts consumption to J/ts
ConsJ[3, SNSSpwnArray] = consumption[3, *] * EDprey[3, SNSSpwnArray] ;converts consumption to J/ts
ConsJ[4, SNSSpwnArray] = consumption[4, *] * EDprey[4, SNSSpwnArray] ;converts consumption to J/ts
;ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/ts
;PRINT, 'Consumption per prey (ConsJ, J)'
;PRINT, ConsJ[*, 0:99]


ConsJtot[SNSSpwnArray] = consJ[0, SNSSpwnArray] + consJ[1, SNSSpwnArray] + consJ[2, SNSSpwnArray] $
                       + consJ[3, SNSSpwnArray] + consJ[4, SNSSpwnArray]; + consJ[5,*] 
ConsJtot = TRANSPOSE(consJtot)
;PRINT, 'Total consumption (ConsJtot, J)'
;PRINT, ConsJtot[0:99]


Eges = FA * ConsJtot; calculate egestion -> Make temp-dependent function??? 
Exc = UA * (ConsJtot - Eges); calculate excretion
SDA = SDA * (ConsJtot - Eges); calculate SDA
;PRINT, 'Feces (FA, J)'
;PRINT, Eges[0:99]
;PRINT, 'Urine (UA, J)'
;PRINT, Exc[0:99]
;PRINT, 'SDA (SDA, J)'
;PRINT, SDA[0:99]


; Determine proportions of energy allocated to gonad -> different for males and females
;gonad_energy = FLTARR(nSNS)
;IF femalecount GT 0. THEN gonad_energy[SNSSpwnArray[female]] = stor_energy; -> female gonad, find it for sturgeon
;IF malecount GT 0. THEN gonad_energy[SNSSpwnArray[male]] = stor_energy; male gonad

gonad_energy = stor_energy 

; relative energy fraction
frac = stor_energy / (stor_energy + struc_energy); relative storage energy density = 0.8
; for mature individuals
; add gonad energy allocation
;frac = stor_energy / (stor_energy + struc_energy + gonad_energy); relative storage energy density = 0.8
;PRINT, 'Relative storage energy fraction (frac)'
;PRINT, frac

; Optimal weight allocated as storage
OptRho = 1.4*0.0912 * ALOG10(length); + 0.02 
; optimal fractional storage weight based on energy data from Hanson 1997 and seasonal genetic component from rho function
Opt_wt = Optrho * Weight
;PRINT, 'Optimal rho (Optrho)'
;PRINT, Optrho[0:99]
;PRINT, 'Optimal storage wieght (Opt_wt)'
;PRINT, Opt_wt[0:99]


; Bioenergetics
; >>>>****Energy demand for respiration must be met before energy allcoation to gonad<<<<<<<<<<<<
Energy_loss = Eges[SNSSpwnArray] + Exc[SNSSpwnArray] + SDA[SNSSpwnArray] $
            + TRANSPOSE(SNSres[0, *]) + TRANSPOSE(SNSres[1, *]) + TRANSPOSE(SNSres[2, *]) 
;PRINT, 'CHECK ARRAY1', N_ELEMENTS(Exc[nSNSSpwnArray])
;PRINT, 'CHECK ARRAY2', N_ELEMENTS(SNSres[0, *])

; determine total energy lost in J/ts
Energy_gained = ConsJtot[SNSSpwnArray];*1000.; energy consumed in J/ts
energy_change = energy_gained - energy_loss; energy available for growth and reprodction, J/ts
;PRINT, 'Energy loss (Energy_loss, J/ts)'
;PRINT, Energy_loss[0:99]
;PRINT, 'Energy gain (Energy_gained, J/ts)'
;PRINT, Energy_gained[0:99]
;PRINT, 'Energy change (energy_change, J/ts)'
;PRINT, energy_change[0:99]

; Determine change in growth with constraint on proportional weight

; Estimate length-dependent function for energy content
IF femalecount GT 0. THEN StrucOpt[FEMALE] = asF * length[FEMALE]^bsF; length-structural energy function for healthy fish 
;-> based on field data
IF malecount GT 0. THEN StrucOpt[MALE] = asM * length[MALE]^bsM; length-structural energy function for healthy fish 
;->>>> based on field data
; Weight = 0.00002665*length^2.6991; lower Platter River shovelnose sturgeon

;PRINT, 'Optimal structural (somatic) energy (StrucOpt, J/ts)'
;PRINT, StrucOpt[0:99]

; Index of physiological condition (KS) -> NEED TO CHANGE TO OPTIMAL TOTAL OR STORAGE WEIGHT?
;KS = (struc_energy*Struc + percent_stor*Stor)/StrucOpt
KS = (Stor + gonad) / OPT_WT
;PRINT, 'Index of physiological condition (KS)'
;PRINT, KS[0:99]

; Estimate expected soma energy content at spawning
Lengthspwn = length
IF femalecount GT 0. THEN SomaExp[FEMALE] = (asF * Lengthspwn[FEMALE]^bsF) * 4186.8
; Sexp on the DAY of spawning based on expected length of healthy fish
IF malecount GT 0. THEN SomaExp[MALE] = (asM * Lengthspwn[MALE]^bsM) * 4186.8
; Sexp on the DAY of spawning based on expected length of healthy fish

;PRINT, 'Expected soma energy content at spawning (Sexp, J)'
;PRINT, Sexp[0:99]

; Estimate expected gonad energy content at spawning
IF femalecount GT 0. THEN GonadExp[FEMALE] = (agF * SomaExp[FEMALE]^bgF); * 1.2
IF malecount GT 0. THEN GonadExp[MALE] = (agM * SomaExp[MALE]^bgM)
;PRINT, 'Expected gonad energy content at spawning (Gexp, J)'
;PRINT, Gexp[0:99]

; daily rate of energy allocation to the gonad
; Compute expected daily gonad energy allocation rate - currently annual spawning         
; >>>> NEED TO ADJUST FOR MULTIYEAR GONAD DEVELOPMENT PROCESS OF SHOVELNOSE STURGEON <<<<<<<<<<<<<<<<<<            
;IF femalecount GT 0. THEN GonadAllocR[FEMALE] = GonadExp[FEMALE] / (tExpSpwn + 365.* SpwnIntF)
;IF malecount GT 0. THEN GonadAllocR[MALE] = GonadExp[MALE] / (tExpSpwn + 365.* SpwnIntM)  
IF femalecount GT 0. THEN GonadAllocR[FEMALE] = (GonadExp[FEMALE] - GonadInt[FEMALE] * gonad_energy) $
                                    / (tExpSpwn + 365.* SpwnIntF)
IF malecount GT 0. THEN GonadAllocR[MALE] = (GonadExp[MALE] - GonadInt[MALE] * gonad_energy) $
                                    / (tExpSpwn + 365.* SpwnIntM)
                                    
; Set the max thresholds for GSI
GSImx = WHERE(gonad / weight GE GSImax, GSImxcount, complement = NGSImx, NCOMPLEMENT = NGSImxcount)                         
IF GSImxcount GT 0. THEN GonadAllocR[GSImx] = 0.                   
;PRINT, 'GonadAllocR', MEAN(GonadAllocR), MAX(GonadAllocR), MIN(GonadAllocR)

;tExpSpwn: 78 (March 15); male spawning cycle = 1-2yrs, female spawning cycle = 3-4yrs
;>>>>>> the minimum time is set as 1yrs for males and 3yrs for females
;tEndGrwth: 288 (October 15)
gKSfunc = 1. - EXP(-cG *(KS - KSspawn))
; a multiplication factor for gonad energy allocation in fish with less than optimal conditions
;>>>> NEED TO ADJUST FOR SHOVELNOSE STURGEON <<<<<<<<<<<<<<<<<<
;
;PRINT, 'Expected daily gonad energy allocation rate (GonadAllocR, J/d)'
;PRINT, GonadAllocR[0:99]
;PRINT, 'Multiplier for gonad energy allocation (gKSfunc)'
;PRINT, gKSfunc[0:99]

; Determine physiologial condition (KS)-based daily rate of energy allocation to gonad (gKS, kcal/d)
KSmx = WHERE(KS GE KSmax, KSmxcount); above maximum physiological condition
; Proportional optimal energy allocation
;>>>>>>>> need to incorporate percent allocation to gonad (Fixed?)<<<<<<<<<
;optgonad = 0.0; optimal GSI -> DOY-sepecific
;percent_gonad = FracGoand
percent_stor = Optrho * frac; * 1.2; optimal energy allocaiton to storage
percent_struc = (1. - optrho) * (1. - frac); optimal energy allocaiton to structure
;IF (KSmxcount GT 0.) THEN BEGIN
;  PRINT, 'KSmxcount', KSmxcount
;  percent_stor[KSmx] = 0.
;  percent_struc[KSmx] = 1.
;  
;;PRINT, 'Proportion of optimal storage (percent_stor)'
;;PRINT, percent_stor[KSmx]
;;PRINT, 'proportion of optimal structural weight (percent_struc)'
;;PRINT, percent_struc[KSmx]  
;ENDIF
;PRINT, 'Proportion of optimal storage (percent_stor)'
;PRINT, percent_stor[0:99]
;PRINT, 'proportion of optimal structural weight (percent_struc)'
;PRINT, percent_struc[0:99]

KSnrm = WHERE(KS GE KSnorm, KSnrmcount); normal physiological condition
KSspwn = WHERE((KS GT KSspawn) AND (KS LT KSnorm), KSspwncount); above the minimum threshold for continuing a reproductive cycle
KSnospwn = WHERE((KS GE KSmin) AND (KS LE KSspawn), KSnonspwncount); below the minimum threshold for continuing a reproductive cycle 
IF (KSnrmcount GT 0.) THEN gKS[KSnrm] = GonadAllocR[KSnrm] ; the physiological conditon is above normal... 
IF (KSspwncount GT 0.) THEN gKS[KSspwn] = gKSfunc[KSspwn] * GonadAllocR[KSspwn]


; Anti-estrogenic EDC effects (proportional change in VTG production)
IF femalecount GT 0. THEN BEGIN
;  EDCfemale = WHERE((LonLoc[female] GE 112.) AND (LonLoc[female] LE 137.) , EDCfemalecount, COMPLEMENT = nonEDCfemale, NCOMPLEMENT = nonEDCfemalecount)
  EDCfemale = WHERE((LonLoc[female] GE 112.), EDCfemalecount, COMPLEMENT = nonEDCfemale, NCOMPLEMENT = nonEDCfemalecount)
  IF EDCfemalecount GT 0. THEN gKSwEDC[female[EDCfemale]] = gKS[female[EDCfemale]] * VTGtoGonadCF
  IF nonEDCfemalecount GT 0. THEN gKSwEDC[female[nonEDCfemale]] = gKS[female[nonEDCfemale]]  
ENDIF

; the physiological conditon is below normal and above the minimal spawning threshold... 
IF (KSnonspwncount GT 0.) THEN BEGIN
  gKS[KSnospwn] = 0.
  ; the physiological conditon is below the minimal threshold to continue a spawning cycle
  ; once they abort the cycle, no spawning for that year.
  ;***When physiological condition is below the threshold, sturgeon abort a reproductive cycle.
;IF (KSnonspwncount GT 0.) THEN BEGIN 
  SpwnStatus[KSnospwn] = 0.; energy in gonad is reallocated to structural and sotrage 
  Stor[KSnospwn] = Stor[KSnospwn] + (Gonad[KSnospwn] - Weight[KSnospwn] * 0.02) * gonad_energy / stor_energy;  [SNSSpwnArray[KSnospwn]]
  Gonad[KSnospwn] = Gonad[KSnospwn] - (Gonad[KSnospwn] - Weight[KSnospwn] * 0.02)
ENDIF
;PRINT, 'Daily rate of energy allocation to gonad (gKS, J/d)'
;PRINT, gKS[0:99]


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PLACE IT OUTSIDE THE GROWTH SUBROUTINE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                                                
; If fish reach minimum length at maturity (different for males and females)-> from the literature
; then age at maturity is determined
; mgonad_density = ; energy density of gonad - male
; fgonad_density = ; energy density of gonad - female

; Estimate physiological condition using KS to determine energy allocaiton to gonad
; At the beginning of each annual spwaning cycle, check (only once) for maturity 
; and physiological condition to initiate the spawning cycle...
;IF (DOY GT 150.) AND (TEMP GT 16.) AND (KS GT KS2) THEN BEGIN; >>>>check for the thresholds<<<<<<

;ENDIF

; Check if fish are in the spawning cycle (KS > KS2), if so, check for the physiological condition...
; -> this state variable lasts for the whole annual spawning cycle 
; >>>> MAY NEED TO CREATE THEIR REPRODUCTIVE STATUS AS A STATE VARIABLE<<<<
;IF AnnuSpawn EQ 1. THEN BEGIN; AnnuSpawn = 1.; spawning, AnnuSpawn = 0.; non-spawning
;->>>> it might be better as WHERE funcitons<<<<<<
;ENDIF
; NEED TO CREATE AND CHECK FOR SPAWNING STATUS -> IF FISH SPAWN, FISH LOSE GONAD WEIGHT  

;>>>>Estimate energy/weight allocation rates for soma, storage, and gonad...>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; use monthly schedule for energy allocation to soma, storage, and gonad (?)

; Check for maturity status...>>> body length-dependent
;>>> Check if fish reached maturity at the end of the growing season (?)...
; once fish have reased maturity, no need to check these individuals
; >>>>>>NEED state variable for maturity status<<<<<
; Maturity = ; immature = 0; mature = 1

; The reproductive cycle is between the end of growing season and the spawning day....
; Spawning mature adults...
;IF maturity EQ 1. THEN BEGIN;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; Need to code for maturity status-based conditional statement
  
  ; Check for the physiological codition
  ; IF KS GT KSspawn THEN ; continue the spawning cycle
  
  ; IF KS LE KSspawn THEN ; terminate the spwaning cycle -> enter the non-spawning cycle and reallocate energy from gonad
  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                     

  ; >>>>>>NEED MATURITY STATUS- AND SPAWNING SEASON- BASED ENERGY ALLOCATION for shovelnose/pallid sturgeon
  ; State variables needed: gKS, KS, energy_change, stor, struc, gonad, 
  ; Parameteres needed: percent_stor, percent_struc, struc_energy, stor_energy, gonad_energy


;PRINT, 'New structural weight (new_struc, g)'
;PRINT, new_struc[0:99]               

EngyGn = WHERE(energy_change GT 0., EngyGncount, complement = EngyLs, ncomplement = EngyLscount); ec = energy gain    
     
;> CORRECT SUBSCRIPTS INF THE FOLLOWING ARRAYS
IF(EngyGncount GT 0.) THEN BEGIN; WHEN THERE IS NET ENERGY GAIN...
  GonadH = WHERE(energy_change[EngyGn] GT gKS[EngyGn], GonadHcount, complement = GonadL, ncomplement = GonadLcount); 
  
  IF GonadHcount GT 0. THEN BEGIN; net energy gain > expected energy allocated to gonad
    ;GonadMale = WHERE(SEX[[EngyGn[GonadH]]] EQ 0., Gonadmalecount, complement = Gonadfemale, ncomplement = Gonadfemalecount)
    
    ;Ngonad[SNSSpwnArray[EngyGn[GonadH]]] = gonad[[[EngyGn[GonadH]]]] + gKS[[EngyGn[GonadH]]] / gonad_energy;[SNSSpwnArray[[EngyGn[GonadH]]]]; allocate all gKS to gonad
    
    Ngonad[SNSSpwnArray[EngyGn[GonadH]]] = gonad[[[EngyGn[GonadH]]]] + gKSwEDC[[EngyGn[GonadH]]] / gonad_energy; Anti-estrogenic EDC effects (proportional change in VTG production)
    
    
    Nstor[SNSSpwnArray[[EngyGn[GonadH]]]] = stor[[EngyGn[GonadH]]] + (percent_stor[[EngyGn[GonadH]]] $
                                          / (percent_stor[[EngyGn[GonadH]]] + percent_struc[[EngyGn[GonadH]]])) $
                                          * (energy_change[[EngyGn[GonadH]]] - gKS[[EngyGn[GonadH]]]) / stor_energy
                                          ; allocate leftover to storage weight
    Nstruc[SNSSpwnArray[[EngyGn[GonadH]]]] = struc[[EngyGn[GonadH]]] + (percent_struc[[EngyGn[GonadH]]] $
                                          / (percent_stor[[EngyGn[GonadH]]] + percent_struc[[EngyGn[GonadH]]])) $
                                          * (energy_change[[EngyGn[GonadH]]] - gKS[[EngyGn[GonadH]]]) / struc_energy
                                          ; allocate fraction of (energy_change - gKS) to sturctural weight
  ENDIF               
  IF GonadLcount GT 0. THEN BEGIN; net energy gain < expected energy allocated to gonad
;    Ngonad[SNSSpwnArray[[EngyGn[GonadL]]]] = gonad[[EngyGn[GonadL]]] + energy_change[[EngyGn[GonadL]]] / gonad_energy $
;                                           + (gKS[[EngyGn[GonadL]]] - energy_change[[EngyGn[GonadL]]]) / gonad_energy;[SNSSpwnArray[[EngyGn[GonadL]]]]; [SNSSpwnArray[[EngyGn[GonadL]]]]
;                                           ; allocate all energy_change to gonad and reallocate (gKS - energy_change) from storage to gonad
                                                    
    Ngonad[SNSSpwnArray[[EngyGn[GonadL]]]] = gonad[[EngyGn[GonadL]]] + energy_change[[EngyGn[GonadL]]] / gonad_energy $
                                       + (gKSwEDC[[EngyGn[GonadL]]] - energy_change[[EngyGn[GonadL]]]) / gonad_energy;[SNSSpwnArray[[EngyGn[GonadL]]]]; [SNSSpwnArray[[EngyGn[GonadL]]]]
                                       ; allocate all energy_change to gonad and reallocate (gKS - energy_change) from storage to gonad                 
                     
                                           
    Nstor[SNSSpwnArray[[EngyGn[GonadL]]]] = stor[[EngyGn[GonadL]]] - (gKS[[EngyGn[GonadL]]] - energy_change[[EngyGn[GonadL]]]) / stor_energy
                                           ; reallocate energy from storage to gonad
    ; need to check for storage is not <0
    Nstruc[SNSSpwnArray[[EngyGn[GonadL]]]] = struc[[EngyGn[GonadL]]]; no reallocation from strucural to gonad               
  ENDIF
    ; >>>>>need to code for gKS = 0<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;  PRINT, 'New structural weight (nstruc, g)'
;  PRINT, nstruc[0:99]  
;    A = WHERE(stor GT opt_wt, Acount, complement = AA, ncomplement = AAcount); >>>>>>optimal weight = KS1 (?)<<<<<<<
;    IF (Acount GT 0.) THEN BEGIN; ->IF storage_weight > optimal storage weight
;      ; Add to storage, structural, and goandal tissues 
;      ; >>>>NEED TO ADJUST ENERGY ALLOCATION PROPORTIONS<<<<<<
;      Nstor[A] = stor[A] + (percent_stor[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / stor_energy[A])
;      Nstruc[A] = struc[A] + (percent_struc[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / struc_energy[A])
;      Ngonad[A] = gonad[A] + (percent_gonad[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / gonad_energy[A])    
;      ; Add to storage, structural, and gonadal tissues - mature individuals       
;    ENDIF; >>>>>>>>>NEED TO ADD ENERGY ALLOCATION TO GONAD
    
;    IF (AAcount GT 0.0) THEN BEGIN; ->IF storage weight < optimal storage weight...
;      B = WHERE(Pot_stor LT opt_wt, Bcount, complement = BB, ncomplement = BBcount)
;      IF(Bcount GT 0.0) THEN BEGIN; ->IF potential storage < optimal storage...
;          Nstr[B] = pot_stor[B]; 
;          Nstrc[B] = struc[B]; 
;      ENDIF
;      IF (BBcount GT 0.0) THEN BEGIN; ->IF potential storage > optimal storage...
;          Nstr[BB] = stor[BB] + (percent_stor[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB] / stor_energy[BB])
;          Nstrc[BB] = struc[BB] + (percent_struc[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB] / struc_energy[BB])
;      ENDIF 
;      Nstor[AA] = Nstr[AA]
;      Nstruc[AA] = Nstrc[AA]
;    ENDIF     
    
 new_stor[SNSSpwnArray[EngyGn]] = Nstor[SNSSpwnArray[EngyGn]]
 storNZ = WHERE(new_stor[SNSSpwnArray[EngyGn]] GT 0., storNZcount, complement = storZ, ncomplement = storZcount)
 IF storNZcount GT 0. THEN new_stor[SNSSpwnArray[EngyGn[storNZ]]] = new_stor[SNSSpwnArray[EngyGn[storNZ]]]
 IF storZcount GT 0. THEN new_stor[SNSSpwnArray[EngyGn[storZ]]] = 0.  
 
 new_struc[SNSSpwnArray[EngyGn]] = Nstruc[SNSSpwnArray[EngyGn]]
 new_gonad[SNSSpwnArray[EngyGn]] = Ngonad[SNSSpwnArray[EngyGn]]  
 new_weight[SNSSpwnArray[EngyGn]] = new_stor[SNSSpwnArray[EngyGn]] + new_struc[SNSSpwnArray[EngyGn]] $
                                  + new_gonad[SNSSpwnArray[EngyGn]]
ENDIF
;PRINT, 'New storage weight (new_stor, g)'
;PRINT, new_stor[0:99]
;PRINT, 'New structural weight (new_struc, g)'
;PRINT, new_struc[0:99]
;PRINT, 'New gonadal weight (new_gonad, g)'
;PRINT, new_gonad[0:99]
;PRINT, 'New weight (new_weight, g)'
;PRINT, new_weight[0:99]

;PRINT, 'structural weight (struc, g)'
;PRINT, struc[0:99]
;PRINT, '(gKS, J)'
;PRINT, gKS[0:99]
;PRINT, '(stor*stor_energy, J)'
;PRINT, stor[0:99]*stor_energy

IF(EngyLscount GT 0.) THEN BEGIN; >>>WHEN THERE IS NET ENERGY LOSS...(ecc = energy loss) 
; when net energy is negative, energy is transferred from storage first, then soma, and finally gonad (for mature individuals)
; when net energy is negative, energy is trasnferred from storage first then soma to gonad 
;-> some fractional enregy loss due to catabolism
  Stor2GonadH = WHERE(stor[EngyLs]*stor_energy GT gKS[EngyLs], Stor2GonadHcount, complement = Stor2GonadL $
                     , ncomplement = Stor2GonadLcount)
  ; this conditional statement also includes non-reproductive sturgeon with gKS = 0
  IF Stor2GonadHcount GT 0. THEN BEGIN; storage > expected energy allocated to gonad
    Ngonad[SNSSpwnArray[EngyLs[Stor2GonadH]]] = gonad[EngyLs[Stor2GonadH]] + gKS[EngyLs[Stor2GonadH]] / gonad_energy;[SNSSpwnArray[EngyLs[Stor2GonadH]]]; reallocate all gKS from storage to gonad
    Nstor[SNSSpwnArray[EngyLs[Stor2GonadH]]] = stor[EngyLs[Stor2GonadH]] - gKS[EngyLs[Stor2GonadH]] / stor_energy
    ; reallocate gKS from storage to gonad
    Nstruc[SNSSpwnArray[EngyLs[Stor2GonadH]]] = struc[EngyLs[Stor2GonadH]]; no reallocation from strucural
;  PRINT, 'New storage weight1 (Nstor, g)'
;  PRINT, Nstor[0:99]  
  ENDIF    
           
  IF Stor2GonadLcount GT 0. THEN BEGIN; storage =< expected energy allocated to gonad
    Ngonad[SNSSpwnArray[EngyLs[Stor2GonadL]]] = gonad[EngyLs[Stor2GonadL]] + stor[EngyLs[Stor2GonadL]]*stor_energy / gonad_energy;[SNSSpwnArray[EngyLs[Stor2GonadL]]]; reallocate all storage to gonad 
    Nstor[SNSSpwnArray[EngyLs[Stor2GonadL]]] = stor[EngyLs[Stor2GonadL]] - stor[EngyLs[Stor2GonadL]]
    ; all storage energy is reallocated to gonad
    Nstruc[SNSSpwnArray[EngyLs[Stor2GonadL]]] = struc[EngyLs[Stor2GonadL]]; no reallocation from strucural                
;  PRINT, 'New storage weight2 (Nstor, g)'
;  PRINT, Nstor[0:99]
  ENDIF

   new_stor[SNSSpwnArray[EngyLs]] = Nstor[SNSSpwnArray[EngyLs]]
   storNZ = WHERE(new_stor[SNSSpwnArray[EngyLs]] GT 0., storNZcount, complement = storZ, ncomplement = storZcount)
   IF storNZcount GT 0. THEN new_stor[SNSSpwnArray[EngyLs[storNZ]]] = new_stor[SNSSpwnArray[EngyLs[storNZ]]]
   IF storZcount GT 0. THEN new_stor[SNSSpwnArray[EngyLs[storZ]]] = 0.  
   
   new_struc[SNSSpwnArray[EngyLs]] = Nstruc[SNSSpwnArray[EngyLs]]
   new_gonad[SNSSpwnArray[EngyLs]] = Ngonad[SNSSpwnArray[EngyLs]]   
   new_weight[SNSSpwnArray[EngyLs]] = new_stor[SNSSpwnArray[EngyLs]] + new_struc[SNSSpwnArray[EngyLs]] $
                                    + new_gonad[SNSSpwnArray[EngyLs]]
ENDIF

;PRINT, 'New storage weight (new_stor, g)'
;PRINT, new_stor[0:99]
;PRINT, 'New structural weight (new_struc, g)'
;PRINT, new_struc[0:99]
;PRINT, 'New gonadal weight (new_gonad, g)'
;PRINT, new_gonad[0:99]
;PRINT, 'New weight (new_weight, g)'
;PRINT, new_weight[0:99]
 
 
; Determine growth in length
PtnLnghGrwth = WHERE((new_struc[SNSSpwnArray] GT struc), PtnLnghGrwthcount, complement = NPtnLnghGrwth $
                    , ncomplement = NPtnLnghGrwthcount)

IF (PtnLnghGrwthcount GT 0.) THEN BEGIN; when net Energy for struc is positive
  Pot_length[SNSSpwnArray[PtnLnghGrwth]] = 1.545*59.761 * New_struc[SNSSpwnArray[PtnLnghGrwth]]^(0.3038); 
   
  LnghGrwth = WHERE(pot_length[SNSSpwnArray[PtnLnghGrwth]] GT length[PtnLnghGrwth], LnghGrwthcount $
                    , complement = NLnghGrwth, ncomplement = NLnghGrwthcount)
  IF(LnghGrwthcount GT 0.) THEN nlength[SNSSpwnArray[PtnLnghGrwth[LnghGrwth]]] = pot_length[SNSSpwnArray[PtnLnghGrwth[LnghGrwth]]]
  IF(NLnghGrwthcount GT 0.) THEN nlength[SNSSpwnArray[PtnLnghGrwth[NLnghGrwth]]] = length[PtnLnghGrwth[NLnghGrwth]]
   
  new_length[SNSSpwnArray[PtnLnghGrwth]] = nlength[SNSSpwnArray[PtnLnghGrwth]]   
ENDIF

IF (NPtnLnghGrwthcount GT 0.) THEN new_length[SNSSpwnArray[NPtnLnghGrwth]] = length[NPtnLnghGrwth]
; when net nergy for struc is negative   
;PRINT, 'New length (new_length, g)'
;PRINT, new_length[0:99]                                                       
;ENDIF;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SPAWNING>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;; >>>>>>>On the spawning day, fish lose all gonadal energy/weight >>>>>>>>>
;
;; >>>>>>>Then, fish enter non-reproductive cycle with other fish...
;; No spawning cycle >>> immature and non-spawning mature adults... and all fish during the non-reproductive season
;pot_stor =  stor + (energy_change / stor_energy) 
;
;IF maturity EQ 0. THEN BEGIN;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;  IF(ECcount GT 0.0) THEN BEGIN; WHEN THERE IS NET ENERGY GAIN...
;  
;    A = WHERE(stor GT opt_wt, Acount, complement = AA, ncomplement = AAcount)
;    IF (Acount GT 0.0) THEN BEGIN; IF storage_weight > optimal storage weight
;      ; Add to storage and structural tissues - pre-mature individuals
;      Nstor[A] = stor[A] + (percent_stor[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / stor_energy[A])
;      Nstruc[A] = struc[A] + (percent_struc[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / struc_energy[A])
;    ENDIF        
;    
;    IF (AAcount GT 0.0) THEN BEGIN; IF storage weight < optimal storage weight...
;      B = WHERE(Pot_stor LT opt_wt, Bcount, complement = BB, ncomplement = BBcount) 
;      IF(bcount GT 0.0) THEN BEGIN; IF potential storage < optimal storage...
;        Nstr[B] = pot_stor[B]
;        Nstrc[B] = struc[B]
;      ENDIF
;      IF (BBcount GT 0.0) THEN BEGIN; IF potential storage > optimal storage...
;        Nstr[BB] = stor[BB] + (percent_stor[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB]/stor_energy[BB])
;        Nstrc[BB] = struc[BB] + (percent_struc[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB]/struc_energy[BB])
;      ENDIF
;      Nstor[AA] = Nstr[AA]
;      Nstruc[AA] = Nstrc[AA]
;    ENDIF
;       
;   new_stor[EC] = Nstor[EC]
;   new_struc[EC] = Nstruc[EC]
;   new_weight[EC] = Nstor[EC] + Nstruc[EC]
;  ENDIF
;  
;  IF(ECccount GT 0.0) THEN BEGIN; WHEN THERE IS NET ENERGY LOSS... 
;  ; ecc = -energy gain
;   new_stor[ecc] = pot_stor[ecc]
;   storNZ = WHERE(new_stor GT 0., storNZcount, complement = storZ, ncomplement = storZcount)
;   IF storNZcount GT 0. THEN new_stor[storNZ] = new_stor[storNZ]
;   IF storZcount GT 0. THEN new_stor[storZ] = 0.
;   new_struc[ecc] = struc[ecc]
;   new_weight[ecc] = new_stor[ecc] + new_struc[ecc]
;  ENDIF
;    
;  ; Determine growth in length for each time step
;  G = WHERE(new_struc GT struc, gcount, complement = GG, ncomplement = GGcount)
;  IF (Gcount GT 0.0) THEN BEGIN; when net nergy for struc is positive
;     Pot_length[G] = 59.761 * (New_struc[G]^0.3401)
;     ; aLength * (New_weight[g]^bLength); weight-length equation ->>>>>> find a funciton for sturgeon
;     
;     PL = WHERE(pot_length GT length, plcount, complement = PPL, ncomplement = PPLcount)
;     IF(PLcount GT 0.0) THEN nlength[PL] = pot_length[PL]
;     IF(PPLcount GT 0.0) THEN nlength[PPL] = length[PPL]
;     
;     new_length[G] = nlength[G]
;  ENDIF
;  
;  IF (GGcount GT 0.0) THEN new_length[GG] = length[GG]; when net nergy for struc is negative
;ENDIF;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>NO SPAWNING>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;PRINT, 'Digested prey (g)'
;PRINT, consumption[0:9, *]
;PRINT, 'Prey-specific energy intake (ConJ, J)'
;PRINT, ConsJ
;PRINT, 'Total energy intake (J)'
;PRINT, consJtot
;
;PRINT, 'Optrho'
;PRINT, TRANSPOSE(Optrho)
;PRINT, 'Opt_wt'
;PRINT, TRANSPOSE(Opt_wt)
;PRINT, 'percent_stor'
;PRINT, TRANSPOSE(percent_stor)
;PRINT, 'percent_struc'
;PRINT, TRANSPOSE(percent_struc)
;PRINT, 'energy_gained'
;PRINT, (energy_gained)
;PRINT, 'Respiration'
;PRINT, TRANSPOSE(SNSres)
;PRINT, 'Respiration%'
;energyNZ = where(energy_gained >0.)
;PRINT, (SNSres[energyNZ])/energy_gained[energyNZ]

;PRINT, 'Egestion'
;PRINT, Eges
;PRINT, 'Excretion'
;PRINT, Exc
;PRINT, 'SDA'
;PRINT, S
;PRINT, 'energy_loss'
;PRINT, (energy_loss)

;PRINT, 'energy_change'
;PRINT, (energy_change)
;PRINT, 'LENGTH'
;PRINT, (LENGTH)
;;PRINT, 'SNS[1:4, *]'
;;PRINT, SNS[1:4, *]
;;PRINT, 'pot_stor'
;;PRINT, (pot_stor)
;;PRINT, 'PROPORTIONAL CHNAGE IN ENERGY',(energy_change / stor_energy) 
;PRINT, 'new_stor'
;PRINT, new_stor

;PRINT, 'struc'
;PRINT, (struc)
;PRINT, 'new_struc'
;PRINT, new_struc
;PRINT, 'new_weight'
;PRINT, new_weight 
;PRINT, 'new_length'
;PRINT, new_length
;PRINT, 'growth_length'
;PRINT, new_length - (length)
;PRINT, 'growth_weight'
;PRINT, new_weight - (weight)
;PRINT, 'growth_gonad'
;PRINT, new_gonad - (gonad)
;PRINT, 'growth_stor'
;PRINT, new_stor - (stor)


GrowthAttribute[0, SNSSpwnArray] = new_weight[SNSSpwnArray] 
GrowthAttribute[1, SNSSpwnArray] = new_length[SNSSpwnArray] 
GrowthAttribute[2, SNSSpwnArray] = new_struc[SNSSpwnArray] 
GrowthAttribute[3, SNSSpwnArray] = new_stor[SNSSpwnArray] 
GrowthAttribute[4, SNSSpwnArray] = new_length[SNSSpwnArray] - TRANSPOSE(length)
GrowthAttribute[5, SNSSpwnArray] = new_weight[SNSSpwnArray]  - TRANSPOSE(weight)

GrowthAttribute[6, SNSSpwnArray] = new_gonad[SNSSpwnArray] 
GrowthAttribute[7, SNSSpwnArray] = new_gonad[SNSSpwnArray]  - TRANSPOSE(gonad)
GrowthAttribute[8, SNSSpwnArray] = SpwnStatus
;PRINT, 'new_gonad[nSNSSpwnArray]'
;PRINT, new_gonad[nSNSSpwnArray[0:199]] 
;PRINT, 'new_weight[nSNSSpwnArray]'
;PRINT, new_weight[nSNSSpwnArray[0:199]] 

new_weightNZ = WHERE(new_weight[SNSSpwnArray] GT 0., new_weightNZcount, complement = new_weightZ, ncomplement = new_weightZcount)
;PRINT,'new_weightZcount'
;PRINT, new_weightZcount

IF new_weightNZcount GT 0. THEN BEGIN
  Opt_wt[new_weightNZ] = Optrho[new_weightNZ] * new_weight[SNSSpwnArray[new_weightNZ]] 
  KS[new_weightNZ] = (new_stor[SNSSpwnArray[new_weightNZ]] + new_gonad[SNSSpwnArray[new_weightNZ]]) / OPT_WT[new_weightNZ]
ENDIF
GrowthAttribute[9, SNSSpwnArray] = KS; physiological condition, KS
;IF femalecount GT 0. THEN PRINT,'GrowthAttribute[9, nSNSSpwnArray]', MEAN(GrowthAttribute[9, SNSSpwnArray[FEMALE]]) $
;                               , MAX(GrowthAttribute[9, SNSSpwnArray[FEMALE]]), MIN(GrowthAttribute[9, SNSSpwnArray[FEMALE]])  

; GSI
IF new_weightNZcount GT 0. THEN GrowthAttribute[10, SNSSpwnArray[new_weightNZ]] = new_gonad[SNSSpwnArray[new_weightNZ]] $
                                                                                / new_weight[SNSSpwnArray[new_weightNZ]]
;PRINT,'GrowthAttribute[10, nSNSSpwnArray]'
;IF femalecount GT 0. THEN PRINT, MEAN(GrowthAttribute[10, SNSSpwnArray[FEMALE]]), MAX(GrowthAttribute[10, SNSSpwnArray[FEMALE]]) $
;                                     , MIN(GrowthAttribute[10, SNSSpwnArray[FEMALE]])  
;IF malecount GT 0. THEN PRINT, MEAN(GrowthAttribute[10, SNSSpwnArray[MALE]]), MAX(GrowthAttribute[10, SNSSpwnArray[MALE]]) $
;                                   , MIN(GrowthAttribute[10, SNSSpwnArray[MALE]])  

IF KSnonspwncount GT 0. THEN GrowthAttribute[12, SNSSpwnArray[KSnospwn]] = 1.                            
;PRINT, GrowthAttribute 



t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'SNSgrowth with Spawning Ends Here for DAY', iday
RETURN, GrowthAttribute; TUEN OFF WHEN TESTING
END