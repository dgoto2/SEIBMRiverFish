FUNCTION SNSgrowthNSpwn, age, length, weight, stor, struc, gonad, sex, SNScmx, consumption, SNSres, Temp, nSNS, iday $
                       , nSNSNSpwn, SNSNSpwnArray 
; Function to determine growth of shovelnose sturgeon WITHOUT spwaning (immature and non-spawning adults)
; Growth for eggs and yolksac larvae is 0 (no adjustment is necessary as consumption and respiration are already 0).


;***TEST ONLY; TURN OFF when running with the full model**********************************************************************
;iDay = 243L
;nSNS = 50L
;m = 5L
;CONSUMPTION = FLTARR(m, nSNS)
;CONSUMPTION[0, *] = 4. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[1, *] = 4. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[2, *] = 6. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[3, *] = 8. + randomn(seed, nSNS)*.01; in G/DAY
;CONSUMPTION[4, *] = 8. + randomn(seed, nSNS)*.01; in G/DAY
;PRINT, 'Consumption per prey (CONSUMPTION, g)'
;PRINT, CONSUMPTION
;SNSres = 600. + randomn(seed, nSNS)* 50.; in J/DAY
;length = 650. + RANDOMN(SEED, nSNS) * 50.; SNS[1, *]; in mm
;Weight = 0.00002665*LENGTH^2.6991 + RANDOMN(SEED, nSNS) * 100.; SNS[2, *]; g
;STRUC = 2.5*0.00001 * (length)^(2.8403*0.91)
;STOR = Weight - struc

;; INITIAL TOTAL NUMBER OF FISH POPUALTION IN LOWER PLATTE RIVER
;NpopSNS =  ; number of SNS individuals
;NpopPLS = ; number of YEP individuals

;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell) 
;BottomCell = WHERE(Grid3D[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;Grid2D = GridCells2D()
;NewInput = EcoForeInputfiles()
;NewInput = NewInput[*, 77500L * ihour : 77500L * ihour + 77499L]
;TotBenBio = TotBenBio + NewInput[8, *]

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

PRINT, 'SNSgrowth1D Begins Here'
tstart = SYSTIME(/seconds)

; Assign array structure
m = 5; a number of prey types   >>>>>>>>>>>>>>>> NEED TO ADJUST FOR THE LOWER PLATTE RIVER STURGEON <<<<<<<<<<<<<<<<<<
EDprey = FLTARR(m, nSNS)
ConsJ = FLTARR(m, nSNS) ;joules of prey consumed per time step
ConsJtot = FLTARR(nSNS)
Optrho = FLTARR(nSNSNSpwn)
Opt_wt = FLTARR(nSNSNSpwn)
;; KS = state variable
;gKS = FLTARR(nSNS)
;g = FLTARR(nSNS); daily rate of energy allocation to the gonad
;;gonad = state variable
;Ngonad = FLTARR(nSNS)
;New_Gonad = FLTARR(nSNS)
;; Gexp = FLTARR(nSNS)
;;gKSfunc = FLTARR(nSNS)
KS = FLTARR(nSNSNSpwn)
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
GrowthAttribute = FLTARR(12L, nSNS)


; Parameter values
FA = 0.15; Egestion 
UA = 0.05; Excretion
SDA = 0.12; Specific dynamic action
; Energy values assigned for storage and structure in J/g 
; somatic tissue = 1050 cal/g, USDA 2001
; gonadal tissue = 2200 cal/g, Wang et al. 1985, 1987 = storage (?)
; 1 cal = 4.1868 J
stor_energy = 2200. * 4.1868; white sturgeon
struc_energy = 1050. * 4.1868; white sturgeon
; energy density of the prey (j/g wet)
ChironomidED = 3138.;j/g- benthos/chironomidae 
OptrhoParam = 0.2
;cG = 7.5; rate constant in the funciton for reallocation of energy from soma to gonad
;KSspawn = 0.7; minimum index of condition for spwaning
;KSmax = 1.3; estimate upper energy bounds >>>>>NEED TO ESIMATE FOR STURGEON
;KSmin = 0.5; 
;KSnorm = 1. ; =KS1, optimal physiological condition
;KS2 = 0.8; minimum index for initiating an annual spwawning cycle
;SomaExp = (0.00000031 * Lengthspwn[FEMALE]^3.39) * 4186.8
as = 0.00000031; parameter for the energy content of the structural compartment as a function of length
bs = 3.39; parameter for the energy content of the structural compartment as a function of length
;ag = 0.09; parameter for the upper bound of the gonad compartment as a function of 
;the expected energy content of the structural compartment
;bg = 1.10; parameter for the upper bound of the gonad compartment as a function of 
LengthStrucWYOYParam1 = 1.66*59.761
LengthStrucWYOYParam2 = 0.369
LengthStrucWYAOParam1 = 1.545*59.761
LengthStrucWYAOParam2 = 0.3038


LiveIndivYOY = WHERE((age LT 1.), LiveIndivYOYcount)
LiveIndivYAO = WHERE((age GE 1.), LiveIndivYAOcount)
;nSNS = nSNSNSpwn

;PRINT, 'Consumption per prey (Consumption, J)'
;IF LiveIndivYOYcount GT 0. THEN PRINT, Consumption[*, LiveIndivYOY]

; energy density of the prey (j/g wet)
EDprey[0, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[1, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[2, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[3, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
EDprey[4, *] = ChironomidED; RANDOMU(seed, nSNS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.); mean 1762.5 ;j/g- benthos/chironomidae 1047-2478
;EDprey[5, *] = 2478.; RANDOMU(seed, nSNS)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
;PRINT, 'Prey energy density (J)'
;PRINT, EDprey

; Convert the amount of consumed prey to energy
ConsJ[0, SNSNSpwnArray] = consumption[0, *] * EDprey[0, SNSNSpwnArray] ;converts consumption to J/ts
ConsJ[1, SNSNSpwnArray] = consumption[1, *] * EDprey[1, SNSNSpwnArray] ;converts consumption to J/ts
ConsJ[2, SNSNSpwnArray] = consumption[2, *] * EDprey[2, SNSNSpwnArray] ;converts consumption to J/ts
ConsJ[3, SNSNSpwnArray] = consumption[3, *] * EDprey[3, SNSNSpwnArray] ;converts consumption to J/ts
ConsJ[4, SNSNSpwnArray] = consumption[4, *] * EDprey[4, SNSNSpwnArray] ;converts consumption to J/ts
;ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/ts
;PRINT, 'Consumption per prey (ConsJ, J)'
;IF LiveIndivYOYcount GT 0. THEN PRINT, ConsJ[*, SNSNSpwnArray[LiveIndivYOY]]

ConsJtot[SNSNSpwnArray] = consJ[0, SNSNSpwnArray] + consJ[1, SNSNSpwnArray] + consJ[2, SNSNSpwnArray] $
                        + consJ[3, SNSNSpwnArray] + consJ[4, SNSNSpwnArray]
ConsJtot = TRANSPOSE(consJtot)
;PRINT, 'Total consumption (ConsJtot, J)'
;IF LiveIndivYOYcount GT 0. THEN PRINT, ConsJtot[SNSNSpwnArray[LiveIndivYOY]]


; Parameter values (for white sturgeon, Bevelhimer 2002. J Appl. Ichthyol.)
; >>>>>>IMPORT SWIMMING AND POSITION-HOLDING COSTS FROM THE FORAGING SUBMODEL<<<<<<<<<

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
;Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
;IF femalecount GT 0. THEN gonad_energy[SNSNSpwnArray[female]] = stor_energy; -> female gonad, find it for sturgeon
;IF malecount GT 0. THEN gonad_energy[SNSNSpwnArray[male]] = stor_energy; male gonad

gonad_energy = stor_energy
;PRINT, 'gonad_energy', gonad_energy

; Relative storage energy fraction
frac = stor_energy / (stor_energy + struc_energy); relative storage energy density = 0.8

; for mature individuals
; add gonad energy allocation
;frac = stor_energy / (stor_energy + struc_energy + gonad_energy); relative storage energy density = 0.8
;PRINT, 'Relative storage energy fraction (frac)'
;PRINT, frac

; Optimal weight allocated as storage
IF LiveIndivYOYcount GT 0. THEN BEGIN
  Optrho[LiveIndivYOY] = 1.4 * 0.0912 * ALOG10(length[LiveIndivYOY]); + 0.13;
  ; Don't allow opt_rho to drop below 0.2(?) -> CHECK FOR STURGEON
  CheckRho = WHERE(optrho[LiveIndivYOY] LT OptrhoParam, CheckRhocount)
  IF CheckRhocount GT 0 THEN optrho[LiveIndivYOY[CheckRho]] = OptrhoParam
ENDIF
IF LiveIndivYAOcount GT 0. THEN Optrho[LiveIndivYAO] = 1.4 * 0.0912 * ALOG10(length[LiveIndivYAO]); + 0.02

Optrho = 1.4 * 0.0912 * ALOG10(length); + 0.02

; optimal fractional storage weight based on energy data from Hanson 1997 and seasonal genetic component from rho function
IF LiveIndivYOYcount GT 0. THEN Opt_wt[LiveIndivYOY] = Optrho[LiveIndivYOY] * Weight[LiveIndivYOY]
IF LiveIndivYAOcount GT 0. THEN Opt_wt[LiveIndivYAO] = Optrho[LiveIndivYAO] * Weight[LiveIndivYAO]; * 1.2
; -> larger individuals allocate extra energy to storage.

;Opt_wt = Optrho * Weight
;PRINT, 'Optimal rho (Optrho)'
;PRINT, Optrho[0:199]
;PRINT, 'Optimal storage wieght (Opt_wt)'
;PRINT, Opt_wt[0:99]


; Bioenergetics
; >>>>****Energy demand for respiration must be met before energy allcoation to gonad<<<<<<<<<<<<
; >>>>>>>>>INCLUDE SWIMMING AND POSITION-HOLDING COSTS FROM THE FORAGING SUBROUTINE<<<<<<<<<<<<<
; determine total energy lost in J/ts
Energy_loss = Eges[SNSNSpwnArray] + Exc[SNSNSpwnArray] + SDA[SNSNSpwnArray] $
            + TRANSPOSE(SNSres[0, *]) + TRANSPOSE(SNSres[1, *]) + TRANSPOSE(SNSres[2, *]) 
;PRINT, 'CHECK ARRAY1', N_ELEMENTS(Exc[SNSNSpwnArray])
;PRINT, 'CHECK ARRAY2', N_ELEMENTS(SNSres[0, *])
Energy_gained = ConsJtot[SNSNSpwnArray]; energy consumed in J/ts
energy_change = energy_gained - energy_loss; energy available for growth and reprodction, J/ts


IF LiveIndivYOYcount GT 0. THEN PRINT, 'YOY energy_change', MEAN(energy_change[LiveIndivYOY]), MAX(energy_change[LiveIndivYOY]), MIN(energy_change[LiveIndivYOY])


;>>>>> NEED TO REALLOCATE GONAD ENERGY IN NON-REPRODUCTIVE INDIVIDUALS?????? <<<<<
ExtGonad = WHERE((Gonad/weight GT 0.02), ExtGonadcount); assuming GSI of vergins is <1%
;***When physiological condition is below the threshold, sturgeon abort a reproductive cycle 
;and reallocate its energy to storage ("atresia")  
IF (ExtGonadcount GT 0.) THEN BEGIN 
  Stor[ExtGonad] = Stor[ExtGonad] + (1. - 0.02) * Gonad[ExtGonad]; * gonad_energy / stor_energy; [SNSNSpwnArray[ExtGonad]]; 
  Gonad[ExtGonad] = Gonad[ExtGonad] - (1. - 0.02) * Gonad[ExtGonad]
ENDIF

;IF LiveIndivYOYcount GT 0. THEN BEGIN
;  PRINT, 'Energy loss (Energy_loss, J/ts)'
;  PRINT, Energy_loss[LiveIndivYOY]
;  PRINT, 'Energy gain (Energy_gained, J/ts)'
;  PRINT, Energy_gained[LiveIndivYOY]
;  PRINT, 'Energy change (energy_change, J/ts)'
;  PRINT, energy_change[LiveIndivYOY]
;ENDIF

; Determine change in growth with constraint on proportional weight

;tspawn = 150.; the expected spawning day (DOY) >>>> Fixed (?) -> find an earliest day that sturgeon spawn
;tlastgrowth= WHERE((DOY GT 150.) AND (energy_change GT 0.), tlastgrowthcount); check for DOY and this is done only once
; >>>>>>> conditions for spawning <<<<<<<<<

;>>>>> may need store DOY and energy in the gonad compartment at the end of growing season

;t1 = DOYlastgrowth; the end of growing season = the first day the net energy is < 0 ->>>>>> from the previous year's simulation
;G1 = Ngonadt1; energy content in the gonad compartment at the end of growing season ->>>>>> from the previous year's simulation

; Estimate length-dependent function for energy content
StrucOpt = as * length^bs * 4186.8; length-structural energy function for healthy fish ->>>> based on field data (?)
;PRINT, 'Optimal structural (somatic) energy (StrucOpt, J/ts)'
;PRINT, StrucOpt[0:99]

; Index of physiological condition (KS) -> NEED TO CHANGE TO OPTIMAL TOTAL OR STORAGE WEIGHT?
;KS = (struc_energy*Struc + stor_energy*Stor)/StrucOpt
OPT_WTnz = WHERE(OPT_WT GT 0., OPT_WTnzcount)
IF OPT_WTnzcount GT 0. THEN KS[OPT_WTnz] = (Gonad[OPT_WTnz] + STOR[OPT_WTnz]) / OPT_WT[OPT_WTnz]
;PRINT, 'Index of physiological condition (KS)'
;PRINT, KS[0:199]

; Proportional optimal energy allocation
;>>>>>>>> need to incorporate percent allocation to gonad (Fixed?)<<<<<<<<<
;optgonad = 0.0; optimal GSI -> DOY-sepecific
;percent_gonad = FracGoand
percent_stor = Optrho * frac; optimal energy allocaiton to storage
percent_struc = (1.0 - optrho) * (1.0 - frac); optimal energy allocaiton to structure
;PRINT, 'Proportion of optimal storage (percent_stor)'
;PRINT, percent_stor[0:99]
;PRINT, 'proportion of optimal structural weight (percent_struc)'
;PRINT, percent_struc[0:99]

;KSmax = 1.3
;KSmx = WHERE(KS GE KSmax, KSmxcount); above maximum physiological condition
;PRINT, 'KSmxcount', KSmxcount
;IF (KSmxcount GT 0.) THEN BEGIN
;  percent_stor[KSmx] = 0.
;  percent_struc[KSmx] = 1.
;;PRINT, 'Proportion of optimal storage (percent_stor)'
;;PRINT, percent_stor[KSmx]
;;PRINT, 'proportion of optimal structural weight (percent_struc)'
;;PRINT, percent_struc[KSmx]  
;ENDIF
; >>>>>>>On the spawning day, fish lose all gonadal energy/weight >>>>>>>>>
; need a state variable for spawning status
; SpntGnd = WHERE(SpwnStat EQ 1., SpntGndcount, complement = nSpntGnd, ncomplement = nSpntGndcount)
; IF SpntGndcount GT 0. THEN BEGIN
;   weight[SpntGnd] = weight[SpntGnd] - gonad[SpntGnd]
;   gonad[SpntGnd] = 0.
; ENDIF

; need a state variable for aborted spawning status
; -> energy in gonad will be reallocated to structural and storage tissues

;the expected energy content of the structural compartment

; >Then, fish enter non-reproductive cycle with other fish...

; No spawning cycle >>> immature and non-spawning mature adults... and all fish during the non-reproductive season
pot_stor =  stor + (energy_change / stor_energy)
;PRINT, 'Potential storage energy (pot_stor, J/ts)'
;PRINT, TRANSPOSE(pot_stor)

EngyGn = WHERE(energy_change GT 0., EngyGncount, complement = EngyLs, ncomplement = EngyLscount); ec = energy gain    
 
IF(EngyGncount GT 0.) THEN BEGIN; WHEN THERE IS NET ENERGY GAIN... 
  StorH = WHERE(stor[EngyGn] GT opt_wt[EngyGn], StorHcount, complement = StorL, ncomplement = StorLcount)
  
  IF (StorHcount GT 0.) THEN BEGIN; IF storage_weight > optimal storage weight
    ; Add to storage and structural tissues - pre-mature individuals
    Nstor[SNSNSpwnArray[EngyGn[StorH]]] = stor[EngyGn[StorH]] + (percent_stor[EngyGn[StorH]] $
                      / (percent_stor[EngyGn[StorH]] + percent_struc[EngyGn[StorH]]) * energy_change[EngyGn[StorH]] / stor_energy)
    Nstruc[SNSNSpwnArray[EngyGn[StorH]]] = struc[EngyGn[StorH]] + (percent_struc[EngyGn[StorH]] $
                      / (percent_stor[EngyGn[StorH]] + percent_struc[EngyGn[StorH]]) * energy_change[EngyGn[StorH]] / struc_energy)
;  PRINT, 'New storage weight1 (Nstor, g)'
;  PRINT, Nstor[0:99]  
  ENDIF        

  IF (StorLcount GT 0.) THEN BEGIN; IF storage weight < optimal storage weight... 
    StorLL = WHERE(Pot_stor[EngyGn[StorL]] LT opt_wt[EngyGn[StorL]], StorLLcount, complement = StorLH, ncomplement = StorLHcount) 
    
    IF(StorLLcount GT 0.) THEN BEGIN; IF potential storage < optimal storage...
      Nstr[SNSNSpwnArray[EngyGn[StorL[StorLL]]]] = pot_stor[EngyGn[StorL[StorLL]]]
      Nstrc[SNSNSpwnArray[EngyGn[StorL[StorLL]]]] = struc[EngyGn[StorL[StorLL]]]
    ENDIF
    IF (StorLHcount GT 0.) THEN BEGIN; IF potential storage > optimal storage...
      Nstr[SNSNSpwnArray[EngyGn[StorL[StorLH]]]] = stor[EngyGn[StorL[StorLH]]] + (percent_stor[EngyGn[StorL[StorLH]]] $
      / (percent_stor[EngyGn[StorL[StorLH]]] + percent_struc[EngyGn[StorL[StorLH]]]) * energy_change[EngyGn[StorL[StorLH]]] $
      / stor_energy)
      Nstrc[SNSNSpwnArray[EngyGn[StorL[StorLH]]]] = struc[EngyGn[StorL[StorLH]]] + (percent_struc[EngyGn[StorL[StorLH]]] $
      / (percent_stor[EngyGn[StorL[StorLH]]] + percent_struc[EngyGn[StorL[StorLH]]]) * energy_change[EngyGn[StorL[StorLH]]] $
      / struc_energy)    
    ENDIF
    
    Nstor[SNSNSpwnArray[EngyGn[StorL]]] = Nstr[SNSNSpwnArray[EngyGn[StorL]]]
    Nstruc[SNSNSpwnArray[EngyGn[StorL]]] = Nstrc[SNSNSpwnArray[EngyGn[StorL]]]
  ENDIF

;  PRINT, 'New storage weight2 (Nstor, g)'
;  PRINT, Nstor[0:99]     
 new_stor[SNSNSpwnArray[EngyGn]] = Nstor[SNSNSpwnArray[EngyGn]]
 new_struc[SNSNSpwnArray[EngyGn]] = Nstruc[SNSNSpwnArray[EngyGn]]
 new_weight[SNSNSpwnArray[EngyGn]] = Nstor[SNSNSpwnArray[EngyGn]] + Nstruc[SNSNSpwnArray[EngyGn]] + gonad[EngyGn]
; PRINT, 'New storage weight (new_stor, g)'
; PRINT, new_stor[SNSNSpwnArray[EngyGn]]
; PRINT, 'New structural weight (new_struc, g)'
; PRINT, new_struc[SNSNSpwnArray[EngyGn]]
; PRINT, 'New weight (new_weight, g)'
; PRINT, new_weight[SNSNSpwnArray[EngyGn]]
ENDIF


IF(EngyLscount GT 0.) THEN BEGIN; WHEN THERE IS NET ENERGY LOSS... 
 new_stor[SNSNSpwnArray[EngyLs]] = pot_stor[EngyLs]
 storNZ = WHERE(new_stor[SNSNSpwnArray[EngyLs]] GT 0., storNZcount, complement = storZ, ncomplement = storZcount)
 IF storNZcount GT 0. THEN new_stor[SNSNSpwnArray[EngyLs[storNZ]]] = new_stor[SNSNSpwnArray[EngyLs[storNZ]]]
 IF storZcount GT 0. THEN new_stor[[SNSNSpwnArray[EngyLs[storZ]]]] = 0.
 
 new_struc[SNSNSpwnArray[EngyLs]] = struc[EngyLs]
 new_weight[SNSNSpwnArray[EngyLs]] = new_stor[SNSNSpwnArray[EngyLs]] + new_struc[SNSNSpwnArray[EngyLs]] + gonad[EngyLs]
ENDIF
;PRINT, 'New storage weight (new_stor, g)'
;PRINT, new_stor[0:99]
;PRINT, 'New structural weight (new_struc, g)'
;PRINT, new_struc[0:99]
;PRINT, 'New weight (new_weight, g)'
;PRINT, new_weight[0:99]


; Determine growth in length for each time step
PtnLnghGrwth = WHERE((new_struc[SNSNSpwnArray] GT struc), PtnLnghGrwthcount, complement = NPtnLnghGrwth $
                    , ncomplement = NPtnLnghGrwthcount)

IF (PtnLnghGrwthcount GT 0.) THEN BEGIN; when net energy for struc is positive, fish grow
  GrwthYOY = WHERE((age[PtnLnghGrwth] LT 1.), GrwthYOYcount)
  GrwthYAO = WHERE((age[PtnLnghGrwth] GE 1.), GrwthYAOcount)
  IF (GrwthYOYcount GT 0.) THEN Pot_length[SNSNSpwnArray[PtnLnghGrwth[GrwthYOY]]] = 1.66*59.761 $
                                                                        * New_struc[SNSNSpwnArray[PtnLnghGrwth[GrwthYOY]]]^(0.369)
  IF (GrwthYAOcount GT 0.) THEN Pot_length[SNSNSpwnArray[PtnLnghGrwth[GrwthYAO]]] = 1.545*59.761 $
                                                                        * New_struc[SNSNSpwnArray[PtnLnghGrwth[GrwthYAO]]]^(0.3038) 

  LnghGrwth = WHERE(pot_length[SNSNSpwnArray[PtnLnghGrwth]] GT length[PtnLnghGrwth], LnghGrwthcount $
                   , complement = NLnghGrwth, ncomplement = NLnghGrwthcount)
  IF(LnghGrwthcount GT 0.) THEN nlength[SNSNSpwnArray[PtnLnghGrwth[LnghGrwth]]] = pot_length[SNSNSpwnArray[PtnLnghGrwth[LnghGrwth]]]
  IF(NLnghGrwthcount GT 0.) THEN nlength[SNSNSpwnArray[PtnLnghGrwth[NLnghGrwth]]] = length[PtnLnghGrwth[NLnghGrwth]]

  new_length[SNSNSpwnArray[PtnLnghGrwth]] = nlength[SNSNSpwnArray[PtnLnghGrwth]]
ENDIF

IF (NPtnLnghGrwthcount GT 0.) THEN new_length[SNSNSpwnArray[NPtnLnghGrwth]] = length[NPtnLnghGrwth]
; when net nergy for struc is negative, no chnage in length
;PRINT, 'New length (new_length, g)'
;PRINT, new_length[0:99]

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
;PRINT, 'pot_stor'
;PRINT, (pot_stor)
;PRINT, 'PROPORTIONAL CHNAGE IN ENERGY',(energy_change / stor_energy) 
;PRINT, 'new_stor'
;PRINT, new_stor

;PRINT, 'lenght (length, mm)'
;PRINT, length
;PRINT, 'weight (weight, g)'
;PRINT, weight
;PRINT, 'stor (stor, g)'
;PRINT, stor
;PRINT, 'struc (struc, g)'
;PRINT, struc
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


GrowthAttribute[0, SNSNSpwnArray] = new_weight[SNSNSpwnArray]
GrowthAttribute[1, SNSNSpwnArray] = new_length[SNSNSpwnArray]
GrowthAttribute[2, SNSNSpwnArray] = new_struc[SNSNSpwnArray]
GrowthAttribute[3, SNSNSpwnArray] = new_stor[SNSNSpwnArray]
GrowthAttribute[4, SNSNSpwnArray] = new_length[SNSNSpwnArray] - TRANSPOSE(length)
GrowthAttribute[5, SNSNSpwnArray] = new_weight[SNSNSpwnArray] - TRANSPOSE(weight)
GrowthAttribute[6, SNSNSpwnArray] = gonad; new_gonad
;GrowthAttribute[7, SNSNSpwnArray] = 0.;new_gonad - transpose(gonad)
;GrowthAttribute[8, SNSNSpwnArray] = SpwnStatus

; Update KS
Opt_wt = Optrho * new_weight[SNSNSpwnArray]
OPT_WTnz = WHERE(OPT_WT GT 0., OPT_WTnzcount)
IF OPT_WTnzcount GT 0. THEN KS[OPT_WTnz] = (gonad[OPT_WTnz]+new_stor[SNSNSpwnArray[OPT_WTnz]]) / OPT_WT[OPT_WTnz]
GrowthAttribute[9, SNSNSpwnArray] = KS; physiological condition, KS
;PRINT, GrowthAttribute 

; GSI
new_weightNZ = WHERE(new_weight[SNSNSpwnArray] GT 0., new_weightNZcount, complement = new_weightZ, ncomplement = new_weightZcount)
IF new_weightNZcount GT 0. THEN GrowthAttribute[10, SNSNSpwnArray[new_weightNZ]] = gonad[SNSNSpwnArray[new_weightNZ]] $
                                                                                 / new_weight[SNSNSpwnArray[new_weightNZ]]

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'SNSgrowth without Spawning Ends Here for DAY', iday; + 1L
RETURN, GrowthAttribute; TUEN OFF WHEN TESTING
END