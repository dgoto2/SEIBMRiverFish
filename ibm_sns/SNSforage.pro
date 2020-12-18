FUNCTION SNSforage, Age, Length, Weight, Temp, Turb, Discharge, Width, Depth, DepthSE, Daylighthour, SNSpbio, SNScmx, nSNS $
                  , SNS, LiveIndiv;
; This function calculates total consumption (g) by shovelnose sturgeon
; NEED to change SOME PARAMETERS for sturgeon
; This foraging model is derived from a drift-feeding model for trout by Gourshe (sp?) et al., 2007(?)
 
; Consumption for eggs and yolksac larvae is 0 (adjustment in subscript is necessary).

; >>>DAILY FOOD CONSUMPTION MAY NEED TO BE ADJUSTED WITH A DIGESTION RATE <<<<<<<<<
; ->>>>> IF NOT DIGESTED IN ONE DAY, THE FISH HAVE PARTIALLY DIGESTED FOOD IN THEIR STOMACH

;***********TEST ONLY******************************************************************
;; Parameter values needed to test the function
;; TURN OFF when running with the full model
;nSNS = 50L; the numbner of shovelnose sturgeon superindividuals
;TURB = 500.+ randomn(seed, nSNS);
;TEMP = 15.+ randomn(seed, nSNS); 
;Vwater = .4+ randomn(seed, nSNS)*.01; in m/s
;PreyVel = Vwater
;DEPTHSE = .1
;DEPTH = 1.2 + randomn(seed, nSNS)*DEPTHSE; m
;Width = 12 + randomn(seed, nSNS)*1; m
;
;Lat = 41.
;JD = 180.
;delta = (23.45/180) * !pi * cos((2.* !pi / 365.) * (173. - JD))
;daylighthour = 24. - 2. * ((12./!pi) * acos(tan(!pi * Lat/180) * tan(delta)))
;PRINT, 'Daylight hours (h)'
;PRINT, daylighthour
;
;;Nindividuals = WAE[0, *]
;length = 250. + RANDOMN(SEED, nSNS) * 20.; SNS[1, *]; in mm
;Weight = 450. + RANDOMN(SEED, nSNS) * 50.; SNS[2, *]; g

;SNScmx = SNScmax(weight, length, nSNS, TEMP); Cmax in g 

; Steady swimming cost (SC, J/h)
; from Stewawrt (1980)
;Vmean = mean water velocity (cm/s)
;SwimCost = 1.4905 * Weight^0.784 * EXP(0.068 * Temp) * EXP(0.0259 - 0.0005 * Temp) ^ (Vwater / 30.48)
;PRINT, 'Steady swimming cost (SC, J/h)'
;PRINT, SC
;SNS = SNSinitial(NpopSNS, nSNS, TotBenBio, NewInput); MOVEMENT PARAMETER
;********************************************************************************************

PRINT, 'SNSForage Begins Here'
tstart = SYSTIME(/seconds)

; Assign array structure
m = 5L; the number of prey & competitor types
PL = FLTARR(m+2L, nSNS); prey length
PW = FLTARR(m+2L, nSNS); prey weight
dens = FLTARR(m+2L, nSNS); prey density
Calpha = FLTARR(m, nSNS); chesson's alpha
RD = FLTARR(m+2L, nSNS); reactive distance
Vmax = FLTARR(nSNS); maximal sustainable fish velocity
MCD = FLTARR(m+2L, nSNS); maximal capture distance
prop = FLTARR(nSNS); proportion of larval visual acuity
MCA = FLTARR(m+2L, nSNS); maximal capture area
nINC = 10.; the number of increments in MCA
nellipse = FINDGEN(nINC) + 1.; an array to create increamented angles
dtheta = 3.14 / nellipse; an incremental angle perpendicular to flow vectors
;PRINT, 'Incremental angle perpendicular to flow vectors (dtheta)', dtheta
MCAinc0 = FLTARR(nINC, nSNS)
MCAinc1 = FLTARR(nINC, nSNS)
MCAinc2 = FLTARR(nINC, nSNS)
MCAinc3 = FLTARR(nINC, nSNS)
MCAinc4 = FLTARR(nINC, nSNS)
MCAinc5 = FLTARR(nINC, nSNS)
MCAinc6 = FLTARR(nINC, nSNS)
MCAinc7 = FLTARR(nINC, nSNS)
MCAinc8 = FLTARR(nINC, nSNS)
MCAinc9 = FLTARR(nINC, nSNS)
ERdrift = FLTARR(m, nSNS); prey encounter rate
HT = FLTARR(m, nSNS) 
SumHT = FLTARR(nSNS) 
PreyCapT = FLTARR(m, nSNS)
ERP = FLTARR(5, nSNS); 
ERPintra = FLTARR(nSNS); conspecific encounter rate
TOT = FLTARR(nSNS); total number of all prey atacked and captured
t = FLTARR(m, nSNS); total number of each prey atacked and captured
Q = FLTARR(m, nSNS); Probability of attack and capture -> 1.0 for drift-feeding fishes
E = FLTARR(m, nSNS); encounter rate in individuals/ts
EPintra = FLTARR(nSNS); encounter rate in individuals
EPinter = FLTARR(nSNS); encounter rate in individuals
;E = FLTARR(m, N_ELEMENTS(LiveIndiv))
;EPintra = FLTARR(m, N_ELEMENTS(LiveIndiv))
;EPinter = FLTARR(m, N_ELEMENTS(LiveIndiv))
NumP = FLTARR(m, nSNS); total number consumed per time step   
SD = FLTARR(m, nSNS); handling time (HT) > ts, then no conumption during each time step >>>>>>>Change to size-based categories for sturgeon(?)<<<<<<<<<<
SumDen = FLTARR(nSNS)
cons = FLTARR(m, nSNS)
densPintra = FLTARR(nSNS)
densPinter = FLTARR(nSNS)
Cratio = FLTARR(m, nSNS); PROPORTIONS OF PREY-SPECIFIC CONSUMPTION
;  Nstom = FLTARR(nSNS)
Premove = FLTARR(nSNS)
;  TotCAftDig = FLTARR(nSNS)
;  RemCAftDig = FLTARR(nSNS)
;  RemCAftDig0 = FLTARR(nSNS)
;  RemCAftDig1 = FLTARR(nSNS)
;  RemCAftDig2 = FLTARR(nSNS)
;  RemCAftDig3 = FLTARR(nSNS)
;  RemCAftDig4 = FLTARR(nSNS)
;  RemCAftDig5 = FLTARR(nSNS)
CmaxProp = FLTARR(nSNS)
TotC = FLTARR(m, nSNS); daily cumulative consumption of each prey item 
TotCts = FLTARR(nSNS); total daily consumption
C = FLTARR(m, nSNS); the amount of each prey item consumed per time step 
consumption = FLTARR(30, nSNS)


; Parameter values
MaxLarvaL = 43.
PredPreyRatio = 0.3
Dp1 = 0.2; proportional vertical location>>>>>>>>NEED TO ADJUST<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Dp2 = 0.2; proportional vertical location>>>>>>>>NEED TO ADJUST<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
HTint = 0.264; for LARVAL YELLOW PERCH
HTsl = 7.0151; for LARVAL YELLOW PERCH 
CmaxPropLarva = 0.5
CmaxPropJuvAdu = 0.56


YOY = WHERE(AGE LT 1., YOYcount, complement = YAO, ncomplement = YAOcount)

;>Determine prey density in the environment*************************************************************************
; Determine prey length for each prey type (m) in the model 
; -> ***PREY TYPE NEEDS TO BE UPDATED FOR STURGEON; BENTHIC AND DRIFTING AQUATIC INSETC PREY***
;***shovelnose sturgeon starts exogeous feeding by 16mm (with up to 12 days drifting) and exclusively feed 
;on benthic aquatic insect larvae and nymphs on sand substrate
; (no planktovorous phase) between 16-140mm (larvae and YOY)

;***Diptera larvae: 0-6mm; chironbomoidae are the most common prey items
;   Ephmeroptera: 0-9mm
;***sturgeon are an opportunitic feeder.
;***for adults (450-720mm) mainly drifting insects
;***DISCHARGE IS AN IMPORTNAT FACTOR FOR FORAGING STURGEON***
;***adult PALLID STURGEON IS PRIMARILY PISCIVORES -> shovelnose sturgeon may not be an appropriate surrograte.

; Prey & conspecifics length (mm) >>>>> NEED TO ADJUST FOR DRIFT PREY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; from 1 to 11 mm -> Should this be changed to 0 -11 mm???
PL[0, *] = RANDOMU(seed, nSNS)*(MAX(3.) - MIN(1.)) + MIN(1.); length for benthic insects(chironmoidae) size class 1
PL[1, *] = RANDOMU(seed, nSNS)*(MAX(5.) - MIN(3.)) + MIN(3.); length for benthic insects(chironmoidae) size class 2
PL[2, *] = RANDOMU(seed, nSNS)*(MAX(7.) - MIN(5.)) + MIN(5.); length for benthic insects(chironmoidae) size class 3
PL[3, *] = RANDOMU(seed, nSNS)*(MAX(9.) - MIN(7.)) + MIN(7.); length for benthic insects(chironmoidae) size class 4
PL[4, *] = RANDOMU(seed, nSNS)*(MAX(11.) - MIN(9.)) + MIN(9.); length for benthic insects(chironmoidae) size class 5

PL[5, *] = SNSpbio[11, *]; YAO sturgeon length for intraspecific competitions
PL[6, *] = SNSpbio[15, *]; YOY sturgeon length for intraspecific competitions
;PRINT, 'Prey length (PL, mm)'
;PRINT, PL[*, 0:99]

; Prey & conspecifics weight (g, wet)
; weight of each prey type
; Assign weights to each prey type in g
PW[0, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.145 / 1000.); chironomids in g from Nalepa for 2005 Lake Erie data
PW[1, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.145 / 1000.)
PW[2, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.145 / 1000.)
PW[3, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.145 / 1000.)
PW[4, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.145 / 1000.)

PW[5, *] = SNSpbio[12, *]; YAO sturgeon weight for intraspecific competitions
PW[6, *] = SNSpbio[16, *]; YOY sturgeon weight for intraspecific competitions
;PRINT, 'Prey weight (PW, g wet)'
;PRINT, PW[*, 0:99]
  

; Convert prey biomass (g/m^2) into numbers/m^2
pbio0 = WHERE(SNSpbio[0, *] GT 0.0, pbio0count, complement = pbio0c, ncomplement = pbio0ccount)
IF pbio0count GT 0.0 THEN dens[0, pbio0] = SNSpbio[0, pbio0] / Pw[0, pbio0] 
IF pbio0ccount GT 0.0 THEN dens[0, pbio0c] = 0.0; for chironmoid

pbio1 = WHERE(SNSpbio[1, *] GT 0.0, pbio1count, complement = pbio1c, ncomplement = pbio1ccount)
IF pbio1count GT 0.0 THEN dens[1, pbio1] = SNSpbio[3, pbio1] / Pw[1, pbio1] 
IF pbio1ccount GT 0.0 THEN dens[1, pbio1c] = 0.0; for 

pbio2 = WHERE(SNSpbio[2, *] GT 0.0, pbio2count, complement = pbio2c, ncomplement = pbio2ccount)
IF pbio2count GT 0.0 THEN dens[2, pbio2] = SNSpbio[2, pbio2] / Pw[2, pbio2] 
IF pbio2ccount GT 0.0 THEN dens[2, pbio2c] = 0.0; for chironmoid

pbio3 = WHERE(SNSpbio[3,*] GT 0.0, pbio3count, complement = pbio3c, ncomplement = pbio3ccount)
IF pbio3count GT 0.0 THEN dens[3, pbio3] = SNSpbio[3, pbio3] / Pw[3, pbio3] 
IF pbio3ccount GT 0.0 THEN dens[3, pbio3c] = 0.0; for chironmoid

pbio4 = WHERE(SNSpbio[4,*] GT 0.0, pbio4count, complement = pbio4c, ncomplement = pbio4ccount)
IF pbio4count GT 0.0 THEN dens[4, pbio4] = SNSpbio[4, pbio4] / Pw[4, pbio4] 
IF pbio4ccount GT 0.0 THEN dens[4, pbio4c] = 0.0; 

dens[5, *] =  SNSpbio[13, *]; total YAO sturgeon density in each grid cell 
dens[6, *] =  SNSpbio[17, *]; total YOY sturgeon density in each grid cell 
;PRINT, 'Prey density (dens)'
;IF YOYcount GT 0.0 THEN PRINT, TRANSPOSE(dens[*, LiveIndiv[YOY]])
;*********************************************************************************************************************************************************


;********************************************************************************************************************
; Determine if the acclimated DO level is below the critical DO level -> Needed in the river model?
;fDOfc2 = FLTARR(nSNS)
;DOc = WHERE(2.*DOcritC GE DOacclC, DOccount, complement = DOcc, ncomplement = DOcccount)
;IF (DOccount GT 0.0) THEN fDOfc2[DOc] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclC[DOc] + (4. - 2*DOcritC[DOc])) + 6.5916))
;IF (DOcccount GT 0.0) THEN fDOfc2[DOcc] = 1.0
;***Hypoxia effect is incorporated in the digestion process (physiological) -> slows digestion -> lowers foraging***
;PRINT, 'Number of fish in hypoxic cells (DOccount) =', DOccount
;PRINT,'fDOfc2'
;PRINT, fDOfc2
;********************************************************************************************************************

;>>>NEED A FUNCTION FOR EDC EFFECTS (A DOSE-RESPOSE SIGMOIDAL RESPONSE?)<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Length threshold for some parameters
LengthGT225 = WHERE(length GT 225., LengthGT225count, complement = LengthLE225, ncomplement = LengthLE225count)

; Calculate predator size-based prey selectivity (Chesson's alpha) for each prey type -> NEED TO BE UPDATED FOR STRUGEON<<<<<<<<<
; NEED TO BE ADJUSTED FOR STURGEON; SIZE-DEPENDENT???
; for benthic prey for flounder by Rose et al. 1996 
PL0 = WHERE((PL[0, LiveIndiv] / Length) LE PredPreyRatio, PL0count, complement = PL0c, ncomplement = pl0ccount)
IF (PL0count GT 0.0) THEN Calpha[0, LiveIndiv[PL0]] = ABS(0.5 - 1.75 * (PL[0, LiveIndiv[PL0]] / Length[PL0]))
IF (PL0ccount GT 0.0) THEN Calpha[0, LiveIndiv[PL0c]] = 0. 
;IF (LengthGT225count GT 0) THEN Calpha[0, LiveIndiv[LengthGT225]] = 0.01; ABS(1./m - 1.75 * (PL[0, LiveIndiv[LengthGT225]] / Length[LengthGT225])); 
 
PL1 = WHERE((PL[1, LiveIndiv] / Length) LE PredPreyRatio, PL1count, complement = PL1c, ncomplement = pl1ccount)
IF (PL1count GT 0.0) THEN Calpha[1, LiveIndiv[PL1]] = ABS(0.5 - 1.75 * (PL[1, LiveIndiv[PL1]] / Length[PL1]))
IF (PL1ccount GT 0.0) THEN Calpha[1, LiveIndiv[PL1c]] = 0. ; for benthic prey for flounder by Rose et al. 1996 
;IF (LengthGT225count GT 0) THEN Calpha[1, LiveIndiv[LengthGT225]] = 0.01; ABS(1./m - 1.75 * (PL[1, LiveIndiv[LengthGT225]] / Length[LengthGT225])); 

PL2 = WHERE((PL[2, LiveIndiv] / Length) LE PredPreyRatio, PL2count, complement = PL2c, ncomplement = pl2ccount)
IF (PL2count GT 0.0) THEN Calpha[2, LiveIndiv[PL2]] = ABS(0.5 - 1.75 * (PL[2, LiveIndiv[PL2]] / Length[PL2]))
IF (PL2ccount GT 0.0) THEN Calpha[2, LiveIndiv[PL2c]] = 0. ; for benthic prey for flounder by Rose et al. 1996 

PL3 = WHERE((PL[3, LiveIndiv] / Length) LE PredPreyRatio, PL3count, complement = PL3c, ncomplement = pl3ccount)
IF (PL3count GT 0.0) THEN Calpha[3, LiveIndiv[PL3]] = ABS(0.5 - 1.75 * (PL[3, LiveIndiv[PL3]] / Length[PL3]))
IF (PL3ccount GT 0.0) THEN Calpha[3, LiveIndiv[PL3c]] = 0. ; for benthic prey for flounder by Rose et al. 1996 
  
PL4 = WHERE((PL[4, LiveIndiv] / Length) LE PredPreyRatio, PL4count, complement = PL4c, ncomplement = pl4ccount)
IF (PL4count GT 0.0) THEN Calpha[4, LiveIndiv[PL4]] = ABS(0.5 - 1.75 * (PL[4, LiveIndiv[PL4]] / Length[PL4]))
IF (PL4ccount GT 0.0) THEN Calpha[4, LiveIndiv[PL4c]] = 0. ; for benthic prey for flounder by Rose et al. 1996 
;PRINT, 'Chessons alpha'
;IF YOYcount GT 0.0 THEN PRINT, Calpha[*, LiveIndiv[YOY]]

  
; Compute reactive distance (RD) of predator based on pred and prey lengths
;-> NEED TO BE ADJUSTED FOR STURGEON WITH DRIFT-FEEDING

;>Reactive distance (RD, m) (for DRIFT-FEEDING trout, Hayes et al. 2003 CJFAS)
; In the original equation, length in m, PL in mm
;->> In the model, length in mm, PL in mm
; Use fork length (cm)-> convert with fork length-weight & weigh-total length functions 
RD[0, LiveIndiv] = 0.12 * (PL[0, LiveIndiv]) * (1. - EXP(-0.02 * length))
RD[1, LiveIndiv] = 0.12 * (PL[1, LiveIndiv]) * (1. - EXP(-0.02 * length))
RD[2, LiveIndiv] = 0.12 * (PL[2, LiveIndiv]) * (1. - EXP(-0.02 * length))
RD[3, LiveIndiv] = 0.12 * (PL[3, LiveIndiv]) * (1. - EXP(-0.02 * length))
RD[4, LiveIndiv] = 0.12 * (PL[4, LiveIndiv]) * (1. - EXP(-0.02 * length))

RD[5, LiveIndiv] = 0.12 * (PL[5, LiveIndiv]) * (1. - EXP(-0.02 * length))
RD[6, LiveIndiv] = 0.12 * (PL[6, LiveIndiv]) * (1. - EXP(-0.02 * length))
;PRINT, 'Reactive distance (RD, m)'
;;PRINT, TRANSPOSE(RD[*, 0:99])
;IF YOYcount GT 0.0 THEN PRINT, (RD[*, LiveIndiv[YOY]])


;; Reactive distance for active search foraging  
;; ;***Reactive distance may be used for the movement decision***
;; Calculate reactive distance in mm (from cm), Breck and Gitter. 1983.
;;****Reactive distance may be used for the movement decision***********************
;; Calculate alpha = fish length function in reactive distance, RD
;;alphaDig = FLTARR(nSNS)
;;alpha = (0.0167 * exp(9.14 - 2.4 * alog(length) + 0.229 * (alog(length))^2));*!pi/180*(1/60)
;; from Breck and Gitter, 1983
;;ln(alpha) = 9.14 - 2.4*alog(length) + 0.229*(alog(length))^2
;alphaDig = EXP(9.14 - 2.4 * ALOG(length) + 0.229*(ALOG(length))^2.0) / 60.0
;; alphaRad = alphaDig*2*!PI/360
;; PRINT, 'alphaDig'
;; PRINT, TRANSPOSE(alphaDig)
;RD2 = FLTARR(m+2L, nSNS); RD = 0.5*PL/tan(2.0*!PI*(1.0/360.0)*alphaDig/2.0)
;RD2[0, LiveIndiv] = 0.5 * PL[0, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993
;RD2[1, LiveIndiv] = 0.5 * PL[1, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993
;RD2[2, LiveIndiv] = 0.5 * PL[2, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993 
;RD2[3, LiveIndiv] = 0.5 * PL[3, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993
;RD2[4, LiveIndiv] = 0.5 * PL[4, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993 
;
;RD2[5, LiveIndiv] = 0.5 * PL[5, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993 
;RD2[6, LiveIndiv] = 0.5 * PL[6, LiveIndiv] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * 0.36; for benthic prey from Breck 1993 
;;PRINT, 'Reactive distance (RD, mm)'
;;PRINT, TRANSPOSE(RD[*, 0:99])
;*********************************************************************************************************************************
  
  
;>Add the turbidity effect into reactive distance >>>>>>>need to find a function for shovelnose sturgeon >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;IF RD LT 15 THEN Frd = 0.8 - 0.025 * RD; Rose et al. 1996 for founder
;IF RD GE 15 THEN Frd = 0.4  
; TURB = turbidity
; from Brrrett et al. (1992) (cited in Guesnsch et al. (2001)) >>>> THIS FUNCTION WORKS ONLY BETWEEN 5 TO 49 NTU!!!!!!!
;  RD[0, LiveIndiv] = RD[0, LiveIndiv] * ((-2.27 * TURB[*]/100. + 111.98) / 100.); for a drift-feeding salmonid 
;  RD[1, LiveIndiv] = RD[1, LiveIndiv] * ((-2.27 * TURB[*]/100. + 111.98) / 100.); for a drift-feeding salmonid 
;  RD[2, LiveIndiv] = RD[2, LiveIndiv] * ((-2.27 * TURB[*]/100. + 111.98) / 100.); for a drift-feeding salmonid 
;  RD[3, LiveIndiv] = RD[3, LiveIndiv] * ((-2.27 * TURB[*]/100. + 111.98) / 100.); for a drift-feeding salmonid 
;  RD[4, LiveIndiv] = RD[4, LiveIndiv] * ((-2.27 * TURB[*]/100. + 111.98) / 100.); for a drift-feeding salmonid 
  
;  ; Using a turbidity function derived from Gadomski and Parsley 2005 TAFS >>>> Same as the turbidity effect on mortality
;  RD[0, LiveIndiv] = RD[0, LiveIndiv] * 1.2102/(1+EXP(-(TURB[*]-298.6103)/(-178.8772))); for a drift-feeding salmonid 
;  RD[1, LiveIndiv] = RD[1, LiveIndiv] * 1.2102/(1+EXP(-(TURB[*]-298.6103)/(-178.8772))); for a drift-feeding salmonid 
;  RD[2, LiveIndiv] = RD[2, LiveIndiv] * 1.2102/(1+EXP(-(TURB[*]-298.6103)/(-178.8772))); for a drift-feeding salmonid 
;  RD[3, LiveIndiv] = RD[3, LiveIndiv] * 1.2102/(1+EXP(-(TURB[*]-298.6103)/(-178.8772))); for a drift-feeding salmonid 
;  RD[4, LiveIndiv] = RD[4, LiveIndiv] * 1.2102/(1+EXP(-(TURB[*]-298.6103)/(-178.8772))); for a drift-feeding salmonid 
;  
;  RD[5, LiveIndiv] = RD[5, LiveIndiv] * 1.2102/(1+EXP(-(TURB[*]-298.6103)/(-178.8772))); for a drift-feeding salmonid 
;  PRINT, 'Reactive distance (RD, m)'
;  PRINT, RD[*, 0:99]  


;  ; Fish swimming speed calculation, S, in body lengths/sec>>>>> NEEDS TO BE UPDATED FOR STUREGOEN<<<<<<<<<<<<<<<<<
;  SS = FLTARR(nSNS)
;  S = FLTARR(nSNS)
;  ;L = WHERE(length LT 20.0, Lcount, complement = LL, ncomplement = LLcount)
;  IF (Lcount GT 0.0) THEN S[L] = 3.0227 * ALOG(length[L]) - 4.6273; for walleye <20mm; Houde, 1969  
;   ;SS equation based on data from Houde 1969 in body lengths/sec
;  IF (LLcount GT 0.0) THEN S[LL] = 1000 * (0.263 + 0.72 * length[LL] + 0.012 * Temp[LL])
;  ; for walleye >20mm; Peake et al., 2000
;  ; Converts SS into mm/s
;  IF (Lcount GT 0.0) THEN SS[L] = S[L] * SNS[1, L]
;  IF (LLcount GT 0.0) THEN SS[LL] = S[LL]
;;  PRINT, 'Swimming speed (mm/s)'
;;  PRINT, SS


; Maximum sustained fish velocity (m/s)
; In the original equation, Vmax in ft/s, length in cm
; Vmax for salmon from Brett and Glass (1973) 
;  1 ft = 0.31 m
; In the model, length = total length in mm
; The following is modified for higher temperature 
Larva = WHERE(length LE MaxLarvaL, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
 ;IF (Larvacount GT 0.0) THEN Vmax[Larva] = 
 ;IF (JuvAducount GT 0.0) THEN Vmax[JuvAdu] = 1.5*13.86 * (((30.5 - Temp[JuvAdu])/3.92)^0.43) * EXP(0.24 *(1 - ((30.5 - Temp[JuvAdu])/3.52))) * (Length[JuvAdu]/10.)^0.63 * 0.0031;

; Individuals <225mm
IF LengthLE225count GT 0. THEN Vmax[LiveIndiv[LengthLE225]] = 5.4 * 0.0031 * 13.86 * (((30.5 - Temp[LengthLE225])/3.92)^0.23) $
                                         * EXP(0.24 *(1 - ((30.5 - Temp[LengthLE225])/3.52))) * (Length[LengthLE225]/10.)^0.18
                                         
; Individuals >=225mm, derived from white sturgeon study by 
IF LengthGT225count GT 0. THEN Vmax[LiveIndiv[LengthGT225]] = 2. * (25.512 + (0.214 * Length[LengthGT225]/10.) $
                                     - (0.762 * Temp[LengthGT225]) + (0.0342 * Temp[LengthGT225] * Length[LengthGT225]/10.))/100.                           
;PRINT, 'Max sustainable fish velocity (Vmax, m/s)'
;;PRINT, Vmax[0:99]
;IF YOYcount GT 0.0 THEN PRINT, (Vmax[LiveIndiv[YOY]])
  

; Maximal capture distance (MCD, m)
;Vmean = FLTARR(nSNS); mean water velocity (m/s) FROM INPUTS
;Vprey = FLTARR(nSNS)
Vwater = Discharge / (Width * (Depth + ABS(DepthSE*RANDOMN(SEED, N_ELEMENTS(LiveIndiv)))))
;PRINT, 'Water velocity (Vwater, m/s)'
;PRINT, Vwater[0:99]
    
;Vmean = Vwater; mean water velocity (m/s) FROM INPUTS
;Vprey = Vwater; mean prey velocity (m/s) FROM INPUTS
; from Guesnsch et al. (2001)
;depth[*] = depth; river depth FROM INPUTS

Vp1 =  Vwater * 0.919 * (Dp1/depth)^0.23; depth-specific velocity; >>>> WHERE THIS SHOULD BE PLACED???
Vp2 =  Vwater * 0.919 * (Dp2/depth)^0.23; depth-specific velocity; >>>> WHERE THIS SHOULD BE PLACED???

;***Larval sturgeon had highest gut contents when water velocity is intermediate = 0.3-0.9 m/s

Vmean = Vp1;
Vprey = Vp2;
;PRINT, 'Depth-specific velocity (Vmean, m/s)'
;;PRINT, (Vmean[0:99])
;IF YOYcount GT 0.0 THEN PRINT, (Vmean[LiveIndiv[YOY]])

;Vwater2 = 0.1176+0.4031*Vwater
;PRINT, 'bottom water velocity (Vwater2, m/s)'
;PRINT, Vwater2[0:199]
  

OptVel = WHERE(Vmax[LiveIndiv] GT Vmean, OptVelcount, complement = HighVel, ncomplement = HighVelcount); CHANGE THIS TO SIZE-BASED FUNCTION >>> NEED A FUNCTION FOR YOY
PRINT, 'Number of non-feeding fish due to high velocity (HighVelcount)', HighVelcount 
IF OptVelcount GT 0. THEN BEGIN
  MCD[0, LiveIndiv[OptVel]] = ((RD[0, LiveIndiv[OptVel]]^2.) - (RD[0, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
  MCD[1, LiveIndiv[OptVel]] = ((RD[1, LiveIndiv[OptVel]]^2.) - (RD[1, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
  MCD[2, LiveIndiv[OptVel]] = ((RD[2, LiveIndiv[OptVel]]^2.) - (RD[2, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
  MCD[3, LiveIndiv[OptVel]] = ((RD[3, LiveIndiv[OptVel]]^2.) - (RD[3, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
  MCD[4, LiveIndiv[OptVel]] = ((RD[4, LiveIndiv[OptVel]]^2.) - (RD[4, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
  
  MCD[5, LiveIndiv[OptVel]] = ((RD[5, LiveIndiv[OptVel]]^2.) - (RD[5, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
  MCD[6, LiveIndiv[OptVel]] = ((RD[6, LiveIndiv[OptVel]]^2.) - (RD[6, LiveIndiv[OptVel]] * Vmean[OptVel] / Vmax[LiveIndiv[OptVel]])^2.)^(1./2.)
ENDIF
;PRINT, 'Max capture distance (MCD, m)'
;IF YOYcount GT 0.0 THEN PRINT, (MCD[*, LiveIndiv[YOY]])

;Larva = WHERE(length LE 43., Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
;IF Larvacount GT 0. THEN BEGIN
;  MCD[0, LiveIndiv[Larva]] = RD2[0, LiveIndiv[Larva]]; 
;  MCD[1, LiveIndiv[Larva]] = RD2[1, LiveIndiv[Larva]];
;  MCD[2, LiveIndiv[Larva]] = RD2[2, LiveIndiv[Larva]];
;  MCD[3, LiveIndiv[Larva]] = RD2[3, LiveIndiv[Larva]];
;  MCD[4, LiveIndiv[Larva]] = RD2[4, LiveIndiv[Larva]];
;  
;  MCD[5, LiveIndiv[Larva]] = RD2[5, LiveIndiv[Larva]];    
;ENDIF

;  MCD[0, LiveIndiv[Larva]] = (((RD[0, LiveIndiv[Larva]]^2.) * (Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.)) / (Vprey[Larva]^2. + Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.))^(1./2.)
;  MCD[1, LiveIndiv[Larva]] = (((RD[1, LiveIndiv[Larva]]^2.) * (Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.)) / (Vprey[Larva]^2. + Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.))^(1./2.)
;  MCD[2, LiveIndiv[Larva]] = (((RD[2, LiveIndiv[Larva]]^2.) * (Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.)) / (Vprey[Larva]^2. + Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.))^(1./2.)
;  MCD[3, LiveIndiv[Larva]] = (((RD[3, LiveIndiv[Larva]]^2.) * (Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.)) / (Vprey[Larva]^2. + Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.))^(1./2.)
;  MCD[4, LiveIndiv[Larva]] = (((RD[4, LiveIndiv[Larva]]^2.) * (Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.)) / (Vprey[Larva]^2. + Vmax[Larva]^2. - (Vmean[Larva]*.5)^2.))^(1./2.)
;    
;  MCD[0, LiveIndiv[JuvAdu]] = (((RD[0, LiveIndiv[JuvAdu]]^2.) * (Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.)) / (Vprey[JuvAdu]^2. + Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.))^(1./2.)
;  MCD[1, LiveIndiv[JuvAdu]] = (((RD[1, LiveIndiv[JuvAdu]]^2.) * (Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.)) / (Vprey[JuvAdu]^2. + Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.))^(1./2.)
;  MCD[2, LiveIndiv[JuvAdu]] = (((RD[2, LiveIndiv[JuvAdu]]^2.) * (Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.)) / (Vprey[JuvAdu]^2. + Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.))^(1./2.)
;  MCD[3, LiveIndiv[JuvAdu]] = (((RD[3, LiveIndiv[JuvAdu]]^2.) * (Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.)) / (Vprey[JuvAdu]^2. + Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.))^(1./2.)
;  MCD[4, LiveIndiv[JuvAdu]] = (((RD[4, LiveIndiv[JuvAdu]]^2.) * (Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.)) / (Vprey[JuvAdu]^2. + Vmax[JuvAdu]^2. - Vmean[JuvAdu]^2.))^(1./2.)
;PRINT, 'Max capture distance (MCD, m)'
;IF YOYcount GT 0.0 THEN PRINT, (MCD[*, LiveIndiv[YOY]])
;PRINT, TRANSPOSE(dtheta[*] /2.) * MCD[0, *]


; For larval fish (less than 20mm) that can perceive one half of the circle defined by reactive distance
Larva = WHERE(length LE MaxLarvaL, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
IF (Larvacount GT 0.0) THEN prop[LiveIndiv[Larva]] = 0.5
IF (JuvAducount GT 0.0) THEN prop[LiveIndiv[JuvAdu]] = 1. 
;  PRINT, 'Proporton of reactive distance'
;  PRINT, prop

; Maximal capture area (MCA, m2)
MCAinc0[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc0[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[0, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCA[0, LiveIndiv] = MCAinc0[0, LiveIndiv] + MCAinc0[1, LiveIndiv] + MCAinc0[2, LiveIndiv] + MCAinc0[3, LiveIndiv] + MCAinc0[4, LiveIndiv] + MCAinc0[5, LiveIndiv] + MCAinc0[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc0[7, LiveIndiv] + MCAinc0[8, LiveIndiv] + MCAinc0[9, LiveIndiv]                                             

MCAinc1[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc1[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[1, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCA[1, LiveIndiv] = MCAinc1[0, LiveIndiv] + MCAinc1[1, LiveIndiv] + MCAinc1[2, LiveIndiv] + MCAinc1[3, LiveIndiv] + MCAinc1[4, LiveIndiv] + MCAinc1[5, LiveIndiv] + MCAinc1[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc1[7, LiveIndiv] + MCAinc1[8, LiveIndiv] + MCAinc1[9, LiveIndiv]
                          
MCAinc2[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc2[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[2, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCA[2, LiveIndiv] = MCAinc2[0, LiveIndiv] + MCAinc2[1, LiveIndiv] + MCAinc2[2, LiveIndiv] + MCAinc2[3, LiveIndiv] + MCAinc2[4, LiveIndiv] + MCAinc2[5, LiveIndiv] + MCAinc2[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc2[7, LiveIndiv] + MCAinc2[8, LiveIndiv] + MCAinc2[9, LiveIndiv]

MCAinc3[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[3, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc3[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[3, LiveIndiv]^2.);* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion 
MCA[3, LiveIndiv] = MCAinc3[0, LiveIndiv] + MCAinc3[1, *] + MCAinc3[2, LiveIndiv] + MCAinc3[3, LiveIndiv] + MCAinc3[4, LiveIndiv] + MCAinc3[5, LiveIndiv] + MCAinc3[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc3[7, LiveIndiv] + MCAinc3[8, LiveIndiv] + MCAinc3[9, LiveIndiv]
                          
MCAinc4[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc4[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[4, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCA[4, LiveIndiv] = MCAinc4[0, LiveIndiv] + MCAinc4[1, LiveIndiv] + MCAinc4[2, LiveIndiv] + MCAinc4[3, LiveIndiv] + MCAinc4[4, LiveIndiv] + MCAinc4[5, LiveIndiv] + MCAinc4[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc4[7, LiveIndiv] + MCAinc4[8, LiveIndiv] + MCAinc4[9, LiveIndiv]
                          
MCAinc5[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc5[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[5, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCA[5, LiveIndiv] = MCAinc5[0, LiveIndiv] + MCAinc5[1, LiveIndiv] + MCAinc5[2, LiveIndiv] + MCAinc5[3, LiveIndiv] + MCAinc5[4, LiveIndiv] + MCAinc5[5, LiveIndiv] + MCAinc5[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc5[7, LiveIndiv] + MCAinc5[8, LiveIndiv] + MCAinc5[9, LiveIndiv]    
                     
MCAinc6[0, LiveIndiv] = ((dtheta[0] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[1, LiveIndiv] = ((dtheta[1] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[2, LiveIndiv] = ((dtheta[2] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[3, LiveIndiv] = ((dtheta[3] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[4, LiveIndiv] = ((dtheta[4] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[5, LiveIndiv] = ((dtheta[5] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[6, LiveIndiv] = ((dtheta[6] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[7, LiveIndiv] = ((dtheta[7] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[8, LiveIndiv] = ((dtheta[8] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCAinc6[9, LiveIndiv] = ((dtheta[9] /2.) * MCD[6, LiveIndiv]^2.)* prop[LiveIndiv]; sum over all the increments -> check for the TOTAL fucntion
MCA[6, LiveIndiv] = MCAinc6[0, LiveIndiv] + MCAinc6[1, LiveIndiv] + MCAinc6[2, LiveIndiv] + MCAinc6[3, LiveIndiv] + MCAinc6[4, LiveIndiv] + MCAinc6[5, LiveIndiv] + MCAinc6[6, LiveIndiv] $; sum over all the increments -> check for the TOTAL fucntion
                    + MCAinc6[7, LiveIndiv] + MCAinc6[8, LiveIndiv] + MCAinc6[9, LiveIndiv]                                            
;PRINT, 'Max capture area (MCA, m2)'
;;PRINT, MCA[*, 0:99]
;IF YOYcount GT 0.0 THEN PRINT, (MCA[*, LiveIndiv[YOY]])

;IF Larvacount GT 0. THEN BEGIN; m2
;  MCA[0, LiveIndiv[Larva]] = 2. *  RD2[0, LiveIndiv[Larva]] * SIN(!PI/3.) * 10.00^(-6.); Area for benthos from Breck 1993; 
;  MCA[1, LiveIndiv[Larva]] = 2. *  RD2[1, LiveIndiv[Larva]] * SIN(!PI/3.) * 10.00^(-6.); Area for benthos from Breck 1993; 
;  MCA[2, LiveIndiv[Larva]] = 2. *  RD2[2, LiveIndiv[Larva]] * SIN(!PI/3.) * 10.00^(-6.); Area for benthos from Breck 1993; 
;  MCA[3, LiveIndiv[Larva]] = 2. *  RD2[3, LiveIndiv[Larva]] * SIN(!PI/3.) * 10.00^(-6.); Area for benthos from Breck 1993; 
;  MCA[4, LiveIndiv[Larva]] = 2. *  RD2[4, LiveIndiv[Larva]] * SIN(!PI/3.) * 10.00^(-6.); Area for benthos from Breck 1993; 
;
;  MCA[5, LiveIndiv[Larva]] = 2. *  RD2[5, LiveIndiv[Larva]] * SIN(!PI/3.) * 10.00^(-6.); Area for benthos from Breck 1993; 
;ENDIF
;;PRINT, 'Max capture area (MCA, m2)'
;;IF YOYcount GT 0.0 THEN PRINT, TRANSPOSE(MCA[*, YOY])
;PRINT, 'Max capture area (MCA, m2)'
;;PRINT, MCA[*, 0:99]
;IF YOYcount GT 0.0 THEN PRINT, (MCA[*, LiveIndiv[YOY]])
  
  
; Encounter rate (# prey) for drift-feeding
ERdrift[0, LiveIndiv] = CEIL(MCA[0, LiveIndiv] * Vmax[LiveIndiv] * dens[0, LiveIndiv])
ERdrift[1, LiveIndiv] = CEIL(MCA[1, LiveIndiv] * Vmax[LiveIndiv] * dens[1, LiveIndiv])
ERdrift[2, LiveIndiv] = CEIL(MCA[2, LiveIndiv] * Vmax[LiveIndiv] * dens[2, LiveIndiv])
ERdrift[3, LiveIndiv] = CEIL(MCA[3, LiveIndiv] * Vmax[LiveIndiv] * dens[3, LiveIndiv])
ERdrift[4, LiveIndiv] = CEIL(MCA[4, LiveIndiv] * Vmax[LiveIndiv] * dens[4, LiveIndiv])

;ERdrift[5, LiveIndiv] = MCA[5, LiveIndiv] * Vmax[*] * dens[5, LiveIndiv]  
;PRINT, 'Drift encounter rate (ERdrift, #)'
;;PRINT, TRANSPOSE(ERdrift[*, 0:99])
;IF YOYcount GT 0.0 THEN PRINT, (ERdrift[*, LiveIndiv[YOY]])


;>Calculate handling time in sec<<<<<<<<<<<<NEED OT BE ADJUSTED FOR STURGEON WITH DRIFT-FEEDING-> INCLUDE SWIMMING TIME FOR PREY CAPTURE 
;***HandLing time should not exceed ts***
;
; Foraging time-> NEED TO CALCULATE BY USING DIGESTION AND STOMACH CAPACITY
; tss = FLTARR(nSNS) 
;LengthGT120 = WHERE(length GT 120., LengthGT120count, complement = LengthLE120, ncomplement = LengthLE120count)
;IF LengthLE120count GT 0. THEN tss[LiveIndiv[LengthLE120]] = 60. * 60. * daylighthour[LengthLE120]; in sec 
;IF LengthGT120count GT 0. THEN tss[LiveIndiv[LengthGT120]] = 60. * 60. * daylighthour[LengthGT120]; * 0.15; in sec 
tss = 60. * 60. * daylighthour

;***Handling time parameters are calibrated for LARVAL YELLOW PERCH***
;***NEED TO FIND PARAMTERS FOR LARGE FISH AND OTEHR SPECIES***
L = TRANSPOSE(length)
HT[0, LiveIndiv] = EXP(HTint * 10.0^(HTsl * (PL[0, LiveIndiv]/L)))
HT0 = WHERE(HT[0, LiveIndiv] GT tss, HT0count, complement = HT0c, ncomplement = HT0ccount)
IF (HT0count GT 0.0) THEN HT[0, LiveIndiv[HT0]] = tss[HT0]
IF (HT0ccount GT 0.0) THEN HT[0, LiveIndiv[HT0c]] = HT[0, LiveIndiv[HT0c]]

HT[1, LiveIndiv] = EXP(HTint * 10.0^(HTsl * (PL[1, LiveIndiv]/L))) 
HT1 = WHERE(HT[1, LiveIndiv] GT tss, HT1count, complement = HT1c, ncomplement = HT1ccount)
IF (HT1count GT 0.0) THEN HT[1, LiveIndiv[HT1]] = tss[HT1]
IF (HT1ccount GT 0.0) THEN HT[1, LiveIndiv[HT1c]] = HT[1, LiveIndiv[HT1c]]

HT[2, LiveIndiv] = EXP(HTint * 10.0^(HTsl * (PL[2, LiveIndiv]/L))) 
HT2 = WHERE(HT[2, LiveIndiv] GT tss, HT2count, complement = HT2c, ncomplement = HT2ccount)
IF (HT2count GT 0.0) THEN HT[2, LiveIndiv[HT2]] = tss[HT2]
IF (HT2ccount GT 0.0) THEN HT[2, LiveIndiv[HT2c]] = HT[2, LiveIndiv[HT2c]]  
  
HT[3, LiveIndiv] = EXP(HTint * 10.0^(HTsl * (PL[3, LiveIndiv]/L)))
HT3 = WHERE(HT[3, LiveIndiv] GT tss, HT3count, complement = HT3c, ncomplement = HT3ccount)
IF (HT3count GT 0.0) THEN HT[3, LiveIndiv[HT3]] = tss[HT3]
IF (HT3ccount GT 0.0) THEN HT[3, LiveIndiv[HT3c]] = HT[3, LiveIndiv[HT3c]]

HT[4, LiveIndiv] = EXP(HTint * 10.^(HTsl * (PL[4, LiveIndiv]/L))) 
HT4 = WHERE(HT[4, LiveIndiv] GT tss, HT4count, complement = HT4c, ncomplement = HT4ccount)
IF (HT4count GT 0.0) THEN HT[4, LiveIndiv[HT4]] = tss[HT4]
IF (HT4ccount GT 0.0) THEN HT[4, LiveIndiv[HT4c]] = HT[4, LiveIndiv[HT4c]]
  
;>Energetic costs for foraging>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Swimming time requried to caputre prey wihtin 1 MCD for drift-feeding trout (TC, s/prey) 
IF OptVelcount GT 0. THEN BEGIN 
  PreyCapT[0, LiveIndiv[OptVel]] = 2. * MCD[0, LiveIndiv[OptVel]] / (Vmax[LiveIndiv[OptVel]]^2. - Vmean[OptVel]^2.)^(1./2.)
  PreyCapT[1, LiveIndiv[OptVel]] = 2. * MCD[1, LiveIndiv[OptVel]] / (Vmax[LiveIndiv[OptVel]]^2. - Vmean[OptVel]^2.)^(1./2.)
  PreyCapT[2, LiveIndiv[OptVel]] = 2. * MCD[2, LiveIndiv[OptVel]] / (Vmax[LiveIndiv[OptVel]]^2. - Vmean[OptVel]^2.)^(1./2.)
  PreyCapT[3, LiveIndiv[OptVel]] = 2. * MCD[3, LiveIndiv[OptVel]] / (Vmax[LiveIndiv[OptVel]]^2. - Vmean[OptVel]^2.)^(1./2.)
  PreyCapT[4, LiveIndiv[OptVel]] = 2. * MCD[4, LiveIndiv[OptVel]] / (Vmax[LiveIndiv[OptVel]]^2. - Vmean[OptVel]^2.)^(1./2.)
ENDIF
; IF HighVelcount GT 0. THEN BEGIN
;    PreyCapT[0, LiveIndiv] = 0.5 * RD[0, LiveIndiv] / Vmax + 0.5 * RD[0, LiveIndiv] / Vmean
;    PreyCapT[1, LiveIndiv] = 0.5 * RD[1, LiveIndiv] / Vmax + 0.5 * RD[1, LiveIndiv] / Vmean
;    PreyCapT[2, LiveIndiv] = 0.5 * RD[2, LiveIndiv] / Vmax + 0.5 * RD[2, LiveIndiv] / Vmean
;    PreyCapT[3, LiveIndiv] = 0.5 * RD[3, LiveIndiv] / Vmax + 0.5 * RD[3, LiveIndiv] / Vmean
;    PreyCapT[4, LiveIndiv] = 0.5 * RD[4, LiveIndiv] / Vmax + 0.5 * RD[4, LiveIndiv] / Vmean
;    
;    PreyCapT[5, LiveIndiv] = 0.5 * RD[5, LiveIndiv] / Vmax + 0.5 * RD[5, LiveIndiv] / Vmean
; ENDIF
;IF Larvacount GT 0. THEN BEGIN
;  PreyCapT[0, LiveIndiv[Larva]] = 1.
;  PreyCapT[1, LiveIndiv[Larva]] = 1. 
;  PreyCapT[2, LiveIndiv[Larva]] = 1. 
;  PreyCapT[3, LiveIndiv[Larva]] = 1. 
;  PreyCapT[4, LiveIndiv[Larva]] = 1. 
;ENDIF
;PRINT, 'Swimming time to capture (TC, s/prey)'
;PRINT, TRANSPOSE(PreyCapT[*, 0:199])
;PRINT, 'ERROR CHECK', WHERE( ~FINITE(PreyCapT[*, *]))

HT[0, LiveIndiv] = PreyCapT[0, LiveIndiv]; for drift-feeding
HT[1, LiveIndiv] = PreyCapT[1, LiveIndiv]; for drift-feeding
HT[2, LiveIndiv] = PreyCapT[2, LiveIndiv]; for drift-feeding
HT[3, LiveIndiv] = PreyCapT[3, LiveIndiv]; for drift-feeding
HT[4, LiveIndiv] = PreyCapT[4, LiveIndiv]; for drift-feeding
;PRINT, 'Expected handling time per prey (HT, s)'
;IF YOYcount GT 0.0 THEN PRINT, TRANSPOSE(HT[*, LiveIndiv[YOY]])

SumHT[LiveIndiv] = HT[0,LiveIndiv] + HT[1,LiveIndiv] + HT[2,LiveIndiv] + HT[3,LiveIndiv] + HT[4,LiveIndiv]
;  PRINT, 'Expected total handling time (SumHT, s)'
;  PRINT, SumHT[0:99]
;HTdrift = 1.; -> need to make it prey-size dependent


;Foraging frequency per prey per day   
;  PreyCapFreq = FLTARR(m, nSNS)
;  PreyCapTNZ0 = WHERE(PreyCapT[0, LiveIndiv] GT 0., PreyCapTNZ0count)
;  PreyCapTNZ1 = WHERE(PreyCapT[1, LiveIndiv] GT 0., PreyCapTNZ1count)
;  PreyCapTNZ2 = WHERE(PreyCapT[2, LiveIndiv] GT 0., PreyCapTNZ2count)
;  PreyCapTNZ3 = WHERE(PreyCapT[3, LiveIndiv] GT 0., PreyCapTNZ3count)
;  PreyCapTNZ4 = WHERE(PreyCapT[4, LiveIndiv] GT 0., PreyCapTNZ4count)
;    
;  IF PreyCapTNZ0count GT 0. THEN PreyCapFreq[0, LiveIndiv[PreyCapTNZ0]] = tss[PreyCapTNZ0] / PreyCapT[0, LiveIndiv[PreyCapTNZ0]]
;  IF PreyCapTNZ1count GT 0. THEN PreyCapFreq[1, LiveIndiv[PreyCapTNZ1]] = tss[PreyCapTNZ1] / PreyCapT[1, LiveIndiv[PreyCapTNZ1]] 
;  IF PreyCapTNZ2count GT 0. THEN PreyCapFreq[2, LiveIndiv[PreyCapTNZ2]] = tss[PreyCapTNZ2] / PreyCapT[2, LiveIndiv[PreyCapTNZ2]]
;  IF PreyCapTNZ3count GT 0. THEN PreyCapFreq[3, LiveIndiv[PreyCapTNZ3]] = tss[PreyCapTNZ3] / PreyCapT[3, LiveIndiv[PreyCapTNZ3]] 
;  IF PreyCapTNZ4count GT 0. THEN PreyCapFreq[4, LiveIndiv[PreyCapTNZ4]] = tss[PreyCapTNZ4] / PreyCapT[4, LiveIndiv[PreyCapTNZ4]] 
;PRINT, 'Foraging frequency per prey per day (PreyCapFreq, #)'
;PRINT, PreyCapFreq[*, 0:99]  
;
;PRINT, 'Foraging frequency per prey (PreyCapFreq, #)'
;PRINT, PreyCapFreqTot = PreyCapFreq[0, LiveIndiv] + PreyCapFreq[1, LiveIndiv] + PreyCapFreq[2, LiveIndiv]+ PreyCapFreq[3, LiveIndiv]   
                        ;+ PreyCapFreq[4, LiveIndiv]
                                      
; Steady swimming cost (SC, J/h)
; from Stewawrt (1980)
;Vwater = mean water velocity (cm/s)
;Vwater = Discarge / (Width * (Depth + DepthSE*RANDOMN(SEED, nSNS)))
;SwimCost = FLTARR(nSNS)
;SwimCost = 1.4905 * Weight^0.784 * EXP(0.068 * Temp) * EXP(0.0259 - 0.0005 * Temp) ^ (Vmean / 30.48)
SwimCost = (1.4905 * Weight^0.784 * EXP(0.068 * Temp) * EXP(0.0259 - 0.0005 * Temp) * Vmax[LiveIndiv] * 0.6 * 100.)/24. * 4.1868 / (60. * 60.)  
;  PRINT, 'Steady swimming cost (SwimCost, J/s)'
;  PRINT, SwimCost[0:99]

; Prey caputrue cost (CC, J/prey) >>>>> THIS NEEDS TO BE MULTIPLIED BY #PREY
; from Hughes and Kelly (1996)
;PreyCapCost = FLTARR(m, nSNS)
;PreyCapCost[0, LiveIndiv] = 6./3600. * SwimCost * Vmax[LiveIndiv] * PreyCapT[0, LiveIndiv]
;; The unit of Swimcost is converted to J/s
;PreyCapCost[1, LiveIndiv] = 6./3600. * SwimCost * Vmax[LiveIndiv] * PreyCapT[1, LiveIndiv]
;PreyCapCost[2, LiveIndiv] = 6./3600. * SwimCost * Vmax[LiveIndiv] * PreyCapT[2, LiveIndiv]
;PreyCapCost[3, LiveIndiv] = 6./3600. * SwimCost * Vmax[LiveIndiv] * PreyCapT[3, LiveIndiv]
;PreyCapCost[4, LiveIndiv] = 6./3600. * SwimCost * Vmax[LiveIndiv] * PreyCapT[4, LiveIndiv]
  
;PreyCapCost = (1.4905 * Weight^0.784 * EXP(0.068 * Temp) * EXP(0.0259 - 0.0005 * Temp) $
;            * Vmax[LiveIndiv] * 100)/24. * 4.1868 / (60.*60.)
  ;PRINT, 'Prey capture cost (CC, J/prey)'
;  PRINT, 'Prey capture cost (CC, J/s)'  
;  PRINT, PreyCapCost[0:99]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  
 
  ; Reactive area (mm2)-> NEED TO BE UPDATED FOR STURGEON WITH DRIFT-FEEDING
;  RA = FLTARR(m, nSNS)
;  RA[0, *] = ((RD[0, *])^2.0 * !PI * prop)
;  RA[1, *] = ((RD[1, *])^2.0 * !PI * prop)
;  RA[2, *] = ((RD[2, *])^2.0 * !PI * prop)
;  RA[3, *] = ((RD[3, *])^2.0 * !PI * prop)
;  RA[4, *] = ((RD[4, *])^2.0 * !PI * prop)
;  ; RA = (RD * Frd)^2 * !PI * prop with turbidity
;  PRINT, 'Reactive area (RA, mm2)'
;  PRINT, RA

; Volume (zooplankton) or area (benthos) searched in L or m^2 PER SECOUND-> ***CHANGE IN UNIT BECAUSE OF UNIT FOR DENSITY INPUTS
;  VS = FLTARR(m, nSNS); MULTIPLY BY 10.00^(-6.00) from mm3 to L OR mm2 to m2 
;  VS[0,*] = DOUBLE(SS * RA[0,*] * 10.00^(-6.00))
;  VS[1,*] = DOUBLE(SS * RA[1,*] * 10.00^(-6.00))
;   VS[3,*] = DOUBLE(SS * 2.0 * RD[3, *] * SIN(!PI/3.0) * 10.00^(-6.00)); Area for benthos from Breck 1993
 ; VS[3,*] = SS * 2.0 * Frd * RD[3,*]; with turbidity ->NEED OT BE UPDATED FOR STURGEON*****
;  VS[4,*] = DOUBLE(SS * RA[4,*] * 10.00^(-6.00))    
;  VS[5,*] = DOUBLE(SS * RA[5,*] * 10.00^(-9.00)); mm3 to m3 for fish prey
;  PRINT, 'Volume searched (VS, L or m2 or m3 /s)'
;  PRINT, VS
  
; Calculate potential encounter rate # per secound
;  ER = FLTARR(m, nSNS); uint
;  ER[0,*] = CEIL(VS[0,*] * dens[0,*]); 
;  ER[1,*] = CEIL(VS[1,*] * dens[1,*]); 
;  ER[2,*] = CEIL(VS[2,*] * dens[2,*]); 
  ;ER[3,*] = CEIL(VS[3,*] * dens[3,*]); 
;  ER[4,*] = CEIL(VS[4,*] * dens[4,*]); 
;  ER[5,*] = CEIL(VS[5,*] * dens[5,*]); 
  ;PRINT, 'Encounter rate (ER, #/s)'
  ;PRINT, ER
  
 
;***size-based inter-/intra-specific interactions and density dependence***
; ENCOUNTER RATE FOR COMPETITORS
; ALL
Age1plus = WHERE(AGE GE 1., Age1pluscount, complement = Age0, ncomplement = Age0count)
IF Age1pluscount GT 0. THEN ERP[0, LiveIndiv[Age1plus]] = MCA[5, LiveIndiv[Age1plus]] * Vmax[LiveIndiv[Age1plus]] $
                                                        * dens[5, LiveIndiv[Age1plus]]
IF Age0count GT 0. THEN ERP[0, LiveIndiv[Age0]] = MCA[6, LiveIndiv[Age0]] * Vmax[LiveIndiv[Age0]] * dens[6, LiveIndiv[Age0]]
;IF Age0count GT 0. THEN ERP[1, LiveIndiv[Age0]] = MCA[6, LiveIndiv[Age0]] * Vmax[LiveIndiv[Age0]] * dens[6, LiveIndiv[Age0]]

ERPintra[LiveIndiv] = ERP[0, LiveIndiv]; + ERP[1, LiveIndiv] 
;  PRINT, 'Intraspecific competitor encounter rate (ERPintra, #/s)'
;  IF Age0count GT 0. THEN PRINT, (ERPintra[LiveIndiv[YOY]])
  
    
  ;ERPinter = FLTARR(nSNS)
;  Age1plus = WHERE(length GE 100., Age1pluscount, complement = Age0, ncomplement = Age0count)
;  IF Age0count GT 0. THEN BEGIN; larvl and juvenile YOY
    ;ERPintra[Age0] = ERP[4, Age0] 
;    ERPintra[*] = ERP[0, *] 
;    ERPinter[Age0] = ERP[1, Age0] + ERP[2, Age0] + ERP[3, Age0] + ERP[0, Age0]
;  ENDIF
;  IF Age1pluscount GT 0. THEN BEGIN; Age1+ -> Not competing with forage fishes
;    ERPintra[Age1plus] = ERP[4, Age1plus] - ERP[9, Age1plus]
;    ERPinter[Age1plus] = ERP[0, Age1plus] - ERP[5, Age1plus]
;  ENDIF
;  PRINT, 'Competitor encounter rate (ERP, #/s)'
;  PRINT, ERP
;  PRINT, 'Intraspecific competitor encounter rate (ERPintra, #/s)'
;  PRINT, (ERPintra[0:99])
;  PRINT, 'Interspecific competitor encounter rate (ERPinter, #/s)'
;  PRINT, TRANSPOSE(ERPinter)
  
  
; Calculate attack probability using chesson's alpha = capture efficiency -> 1.0 for drift-feeding fishes
t[0, LiveIndiv] = Calpha[0, LiveIndiv] * dens[0, LiveIndiv] * PW[0, LiveIndiv]; weighted by prey body size
t[1, LiveIndiv] = Calpha[1, LiveIndiv] * dens[1, LiveIndiv] * PW[1, LiveIndiv]
t[2, LiveIndiv] = Calpha[2, LiveIndiv] * dens[2, LiveIndiv] * PW[2, LiveIndiv]
t[3, LiveIndiv] = Calpha[3, LiveIndiv] * dens[3, LiveIndiv] * PW[3, LiveIndiv]
t[4, LiveIndiv] = Calpha[4, LiveIndiv] * dens[4, LiveIndiv] * PW[4, LiveIndiv]

TOT[LiveIndiv] = t[0, LiveIndiv] + t[1, LiveIndiv] + t[2, LiveIndiv] + t[3, LiveIndiv] + t[4, LiveIndiv]
;  PRINT, 'Adjusted density of each prey item attcked and captured (t)'
;  PRINT, t[*, 0:99]
;  PRINT, 'Adjusted density of all prey items attcked and captured (tot)'
;  PRINT, TOT[0:99]
      

; Probability of attack and capture -> 1.0 for drift-feeding fishes
TOTNZ = WHERE(TOT[LiveIndiv] GT 0.0, TOTNZcount, complement = TOTZ, ncomplement = TOTZcount)
; If no prey is available in a cell, Q = 0
IF TOTNZcount GT 0.0 THEN BEGIN
  Q[0, LiveIndiv[TOTNZ]] = DOUBLE(t[0, LiveIndiv[TOTNZ]] / TOT[LiveIndiv[TOTNZ]]) 
  Q[1, LiveIndiv[TOTNZ]] = DOUBLE(t[1, LiveIndiv[TOTNZ]] / TOT[LiveIndiv[TOTNZ]])
  Q[2, LiveIndiv[TOTNZ]] = DOUBLE(t[2, LiveIndiv[TOTNZ]] / TOT[LiveIndiv[TOTNZ]])
  Q[3, LiveIndiv[TOTNZ]] = DOUBLE(t[3, LiveIndiv[TOTNZ]] / TOT[LiveIndiv[TOTNZ]])
  Q[4, LiveIndiv[TOTNZ]] = DOUBLE(t[4, LiveIndiv[TOTNZ]] / TOT[LiveIndiv[TOTNZ]])
ENDIF 
IF TOTZcount GT 0.0 THEN BEGIN
  Q[0, LiveIndiv[TOTZ]] = 0.
  Q[1, LiveIndiv[TOTZ]] = 0.
  Q[2, LiveIndiv[TOTZ]] = 0.
  Q[3, LiveIndiv[TOTZ]] = 0.
  Q[4, LiveIndiv[TOTZ]] = 0.
ENDIF
;PRINT, 'Probability of attack and cature (Q)'
;IF YOYcount GT 0.0 THEN  PRINT, Q[*, LiveIndiv[YOY]]
  
;t_elapsed = SYSTIME(/seconds) - tstart
;PRINT, 'Elapesed time (seconds):', t_elapsed   

; Calculate the number of each prey consumed (with stochasticity)
FOR ind = 0L, nSNS - 1L DO BEGIN 
  ; Calculate realized encounter rate, E, based on a poisson distribution in individuals/ts
  IF ERdrift[0, ind] GT 0. THEN E[0, ind] = RANDOMU(seed, POISSON = [ERdrift[0, ind]], /double)
  IF ERdrift[1, ind] GT 0. THEN E[1, ind] = RANDOMU(seed, POISSON = [ERdrift[1, ind]], /double)
  IF ERdrift[2, ind] GT 0. THEN E[2, ind] = RANDOMU(seed, POISSON = [ERdrift[2, ind]], /double)
  IF ERdrift[3, ind] GT 0. THEN E[3, ind] = RANDOMU(seed, POISSON = [ERdrift[3, ind]], /double)    
  IF ERdrift[4, ind] GT 0. THEN E[4, ind] = RANDOMU(seed, POISSON = [ERdrift[4, ind]], /double)
  
  IF ERPintra[ind] GT 0. THEN EPintra[ind] = RANDOMU(seed, POISSON = [ERPintra[ind]], /double)
  ;IF ERPinter[ind] GT 0. THEN EPinter[ind] = RANDOMU(seed, POISSON = [ERPinter[ind]], /double)
ENDFOR
;t_elapsed = SYSTIME(/seconds) - tstart
;PRINT, 'Elapesed time (seconds):', t_elapsed
;PRINT, 'Realized encounter rate (E, #/ts)'
;IF YOYcount GT 0.0 THEN PRINT, EPintra[LiveIndiv[YOY]]

;; Calculate realized encounter rate, E, based on a poisson distribution in individuals/ts
;FOR ind = 0L, nSNS - 1L DO IF ERdrift[0, ind] GT 0. THEN E[0, ind] = RANDOMU(seed, POISSON = [ERdrift[0, ind]], /double)
;FOR ind = 0L, nSNS - 1L DO IF ERdrift[1, ind] GT 0. THEN E[1, ind] = RANDOMU(seed, POISSON = [ERdrift[1, ind]], /double)
;FOR ind = 0L, nSNS - 1L DO IF ERdrift[2, ind] GT 0. THEN E[2, ind] = RANDOMU(seed, POISSON = [ERdrift[2, ind]], /double)
;FOR ind = 0L, nSNS - 1L DO IF ERdrift[3, ind] GT 0. THEN E[3, ind] = RANDOMU(seed, POISSON = [ERdrift[3, ind]], /double)    
;FOR ind = 0L, nSNS - 1L DO IF ERdrift[4, ind] GT 0. THEN E[4, ind] = RANDOMU(seed, POISSON = [ERdrift[4, ind]], /double)
;  
;FOR ind = 0L, nSNS - 1L DO IF ERPintra[ind] GT 0. THEN EPintra[ind] = RANDOMU(seed, POISSON = [ERPintra[ind]], /double)
;;t_elapsed = SYSTIME(/seconds) - tstart
;;PRINT, 'Elapesed time (seconds):', t_elapsed  

;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF ERdrift[0, LiveIndiv[ind]] GT 0. THEN E[0, LiveIndiv[ind]] = RANDOMU(seed, POISSON = [ERdrift[0, LiveIndiv[ind]]], /double)
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF ERdrift[1, LiveIndiv[ind]] GT 0. THEN E[1, LiveIndiv[ind]] = RANDOMU(seed, POISSON = [ERdrift[1, LiveIndiv[ind]]], /double)
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF ERdrift[2, LiveIndiv[ind]] GT 0. THEN E[2, LiveIndiv[ind]] = RANDOMU(seed, POISSON = [ERdrift[2, LiveIndiv[ind]]], /double)
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF ERdrift[3, LiveIndiv[ind]] GT 0. THEN E[3, LiveIndiv[ind]] = RANDOMU(seed, POISSON = [ERdrift[3, LiveIndiv[ind]]], /double)    
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF ERdrift[4, LiveIndiv[ind]] GT 0. THEN E[4, LiveIndiv[ind]] = RANDOMU(seed, POISSON = [ERdrift[4, LiveIndiv[ind]]], /double)
;  
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF ERPintra[LiveIndiv[ind]] GT 0. THEN EPintra[LiveIndiv[ind]] = RANDOMU(seed, POISSON = [ERPintra[LiveIndiv[ind]]], /double)


; total number consumed per time step   
FOR ind = 0L, nSNS - 1L DO BEGIN ; for each superindividual    
  ; Stochastic estimates for the number and type of prey based on E from binomial distriution
  IF E[0, ind] GT 0. THEN NumP[0, ind] = (RANDOMU(seed, BINOMIAL = [E[0, ind], Q[0, ind]], /double))
  IF E[1, ind] GT 0. THEN NumP[1, ind] = (RANDOMU(seed, BINOMIAL = [E[1, ind], Q[1, ind]], /double))
  IF E[2, ind] GT 0. THEN NumP[2, ind] = (RANDOMU(seed, BINOMIAL = [E[2, ind], Q[2, ind]], /double))
  IF E[3, ind] GT 0. THEN NumP[3, ind] = (RANDOMU(seed, BINOMIAL = [E[3, ind], Q[3, ind]], /double))
  IF E[4, ind] GT 0. THEN NumP[4, ind] = (RANDOMU(seed, BINOMIAL = [E[4, ind], Q[4, ind]], /double))    
ENDFOR

; Stochastic estimates for the number and type of prey based on E from binomial distriution
;FOR ind = 0L, nSNS - 1L DO IF E[0, ind] GT 0. THEN NumP[0, ind] = (RANDOMU(seed, BINOMIAL = [E[0, ind], Q[0, ind]], /double))
;FOR ind = 0L, nSNS - 1L DO IF E[1, ind] GT 0. THEN NumP[1, ind] = (RANDOMU(seed, BINOMIAL = [E[1, ind], Q[1, ind]], /double))
;FOR ind = 0L, nSNS - 1L DO IF E[2, ind] GT 0. THEN NumP[2, ind] = (RANDOMU(seed, BINOMIAL = [E[2, ind], Q[2, ind]], /double))
;FOR ind = 0L, nSNS - 1L DO IF E[3, ind] GT 0. THEN NumP[3, ind] = (RANDOMU(seed, BINOMIAL = [E[3, ind], Q[3, ind]], /double))
;FOR ind = 0L, nSNS - 1L DO IF E[4, ind] GT 0. THEN NumP[4, ind] = (RANDOMU(seed, BINOMIAL = [E[4, ind], Q[4, ind]], /double))  

;NumP = FLTARR(m, N_ELEMENTS(LiveIndiv)); total number consumed per time step 
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF E[0, LiveIndiv[ind]] GT 0. THEN NumP[0, LiveIndiv[ind]] = (RANDOMU(seed, BINOMIAL = [E[0, LiveIndiv[ind]], Q[0, LiveIndiv[ind]]], /double))
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF E[1, LiveIndiv[ind]] GT 0. THEN NumP[1, LiveIndiv[ind]] = (RANDOMU(seed, BINOMIAL = [E[1, LiveIndiv[ind]], Q[1, LiveIndiv[ind]]], /double))
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF E[2, LiveIndiv[ind]] GT 0. THEN NumP[2, LiveIndiv[ind]] = (RANDOMU(seed, BINOMIAL = [E[2, LiveIndiv[ind]], Q[2, LiveIndiv[ind]]], /double))
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF E[3, LiveIndiv[ind]] GT 0. THEN NumP[3, LiveIndiv[ind]] = (RANDOMU(seed, BINOMIAL = [E[3, LiveIndiv[ind]], Q[3, LiveIndiv[ind]]], /double))
;FOR ind = 0L, N_ELEMENTS(LiveIndiv) - 1L DO IF E[4, LiveIndiv[ind]] GT 0. THEN NumP[4, LiveIndiv[ind]] = (RANDOMU(seed, BINOMIAL = [E[4, LiveIndiv[ind]], Q[4, LiveIndiv[ind]]], /double))   
;PRINT, 'Realized encounter rate (E, #/ts)'
;IF YOYcount GT 0.0 THEN PRINT, E[*, LiveIndiv[YOY]]
;PRINT, 'Stochastic potential number of prey consumed (NumP)'
;IF YOYcount GT 0.0 THEN PRINT, NumP[*, LiveIndiv[YOY]]

;t_elapsed = SYSTIME(/seconds) - tstart
;PRINT, 'Elapesed time (seconds):', t_elapsed   


; handling time (HT) > ts, then no conumption during each time step >>>>>>>Change to size-based categories for sturgeon(?)<<<<<<<<<<
;  SD[0,LiveIndiv] =  E[0,LiveIndiv] * Q[0, LiveIndiv] * HT[0, LiveIndiv];
;  SD[1,*] =  E[1,*] * Q[1,*] * HT[1,*]; 
;  SD[2,*] =  E[2,*] * Q[2,*] * HT[2,*];   
HT0sd = WHERE(HT[0, LiveIndiv] EQ tss, HT0sdcount, complement = HT0sdc, ncomplement = HT0sdccount)
IF (HT0sdcount GT 0.0) THEN SD[0, LiveIndiv[HT0sd]] = 0.0 
IF (HT0sdccount GT 0.0) THEN SD[0, LiveIndiv[HT0sdc]] =  E[0, LiveIndiv[HT0sdc]] * Q[0, LiveIndiv[HT0sdc]] * HT[0, LiveIndiv[HT0sdc]];    
 
HT1sd = WHERE(HT[1, LiveIndiv] EQ tss, HT1sdcount, complement = HT1sdc, ncomplement = HT1sdccount)
IF (HT1sdcount GT 0.0) THEN SD[1, LiveIndiv[HT1sd]] = 0.0 
IF (HT1sdccount GT 0.0) THEN SD[1, LiveIndiv[HT1sdc]] =  E[1, LiveIndiv[HT1sdc]] * Q[1, LiveIndiv[HT1sdc]] * HT[1, LiveIndiv[HT1sdc]];  

HT2sd = WHERE(HT[2, LiveIndiv] EQ tss, HT2sdcount, complement = HT2sdc, ncomplement = HT2sdccount)
IF (HT2sdcount GT 0.0) THEN SD[2, LiveIndiv[HT2sd]] = 0.0 
IF (HT2sdccount GT 0.0) THEN SD[2, LiveIndiv[HT2sdc]] =  E[2, LiveIndiv[HT2sdc]] * Q[2, LiveIndiv[HT2sdc]] * HT[2, LiveIndiv[HT2sdc]]; 
   
HT3sd = WHERE(HT[3, LiveIndiv] EQ tss, HT3sdcount, complement = HT3sdc, ncomplement = HT3sdccount)
IF (HT3sdcount GT 0.0) THEN SD[3, LiveIndiv[HT3sd]] = 0.0 
IF (HT3sdccount GT 0.0) THEN SD[3, LiveIndiv[HT3sdc]] =  E[3, LiveIndiv[HT3sdc]] * Q[3, LiveIndiv[HT3sdc]] * HT[3, LiveIndiv[HT3sdc]]; 
;SD[3, *] =  E[3, *] * Q[3, *] * HT[3, *]; 
HT4sd = WHERE(HT[4, LiveIndiv] EQ tss, HT4sdcount, complement = HT4sdc, ncomplement = HT4sdccount)
IF (HT4sdcount GT 0.0) THEN SD[4, LiveIndiv[HT4sd]] = 0.0 
IF (HT4sdccount GT 0.0) THEN SD[4, LiveIndiv[HT4sdc]] =  E[4, LiveIndiv[HT4sdc]] * Q[4, LiveIndiv[HT4sdc]] * HT[4, LiveIndiv[HT4sdc]]; 
  
;  HT5 = WHERE(HT[5, *] EQ tss, HT5count, complement = HT5c, ncomplement = HT5ccount)
;  IF (HT5count GT 0.0) THEN SD[5, HT5] = 0.0 
;  IF (HT5ccount GT 0.0) THEN SD[5, HT5c] =  E[5, HT5c] * Q[5, HT5c] * HT[5, HT5c];
;PRINT, 'SD'
;PRINT, SD[*, 0:99]

SumDen[LiveIndiv] = SD[0, LiveIndiv] + SD[1, LiveIndiv] + SD[2, LiveIndiv] + SD[3, LiveIndiv] + SD[4, LiveIndiv]; 
;PRINT, 'SumDen'
;IF YOYcount GT 0.0 THEN PRINT, SumDen[LiveIndiv[YOY]]


; Calculate total grams for each prey type consumed 
 ; IF handlign time is greater than ts, no consumption
cons[0, LiveIndiv] = DOUBLE(pw[0, LiveIndiv] * Nump[0, LiveIndiv])  
cons[1, LiveIndiv] = DOUBLE(pw[1, LiveIndiv] * Nump[1, LiveIndiv])  
cons[2, LiveIndiv] = DOUBLE(pw[2, LiveIndiv] * Nump[2, LiveIndiv]) 

;  HT3 = WHERE(HT[3, *] EQ tss, HT3count, complement = HT3c, ncomplement = HT3ccount)
;  IF (HT3count GT 0.0) THEN cons[3, HT3] = 0.0 
;  IF (HT3ccount GT 0.0) THEN cons[3, HT3c] = DOUBLE(PW[3, HT3c] * Nump[3,HT3c]) 
cons[3, LiveIndiv] = DOUBLE(PW[3, LiveIndiv] * Nump[3, LiveIndiv])  
  
;  HT4 = WHERE(HT[4, *] EQ tss, HT4count, complement = HT4c, ncomplement = HT4ccount)
;  IF (HT4count GT 0.0) THEN cons[4, HT4] = 0.0 
;  IF (HT4ccount GT 0.0) THEN cons[4, HT4c] = DOUBLE(PW[4, HT4c] * Nump[4, HT4c])   
cons[4, LiveIndiv] = DOUBLE(PW[4, LiveIndiv] * Nump[4, LiveIndiv])  
  
;  HT5 = WHERE(HT[5, *] EQ tss, HT5count, complement = HT5c, ncomplement = HT5ccount)
;  IF (HT5count GT 0.0) THEN cons[5, HT5] = 0.0 
;  IF (HT5ccount GT 0.0) THEN cons[5, HT5c] = DOUBLE(PW[5, HT5c] * Nump[5, HT5c]) 
;PRINT, 'Potential amount of each prey type consumed (cons, g)'
;IF YOYcount GT 0.0 THEN PRINT, cons[*, LiveIndiv[YOY]]        
        
; consumption for each prey type accounting for foraging in g in time step from HT
;  PRINT, 'Realised intraspecific competitor encounter rate (EPintra, #/s)'
;  PRINT, (EPintra[0:100])
;  PRINT, 'Realised interspecific competitor encounter rate (EPinter, #/s)'
;  PRINT, (EPinter[0:100])  


;; WITHOUT competition********** NO DENSITY-DEPENDENCE**************************
;C[0, LiveIndiv] = (Cons[0, LiveIndiv] / (1.0 + SumDen[LiveIndiv])) * tss;[LiveIndiv]
;C[1, LiveIndiv] = (Cons[1, LiveIndiv] / (1.0 + SumDen[LiveIndiv])) * tss;[LiveIndiv]
;C[2, LiveIndiv] = (Cons[2, LiveIndiv] / (1.0 + SumDen[LiveIndiv])) * tss;[LiveIndiv]
;C[3, LiveIndiv] = (Cons[3, LiveIndiv] / (1.0 + SumDen[LiveIndiv])) * tss;[LiveIndiv]
;C[4, LiveIndiv] = (Cons[4, LiveIndiv] / (1.0 + SumDen[LiveIndiv])) * tss;[LiveIndiv]
;C[5, LiveIndiv] = (Cons[5, LiveIndiv] / (1.0 + SumDen[LiveIndiv])) * tss;[LiveIndiv]


; Use biomass for inter- and intra- specific interactions
IF Age1pluscount GT 0. THEN densPintra[LiveIndiv[Age1plus]] = SNSpbio[14, LiveIndiv[Age1plus]]
IF Age0count GT 0. THEN densPintra[LiveIndiv[Age0]] = SNSpbio[18, LiveIndiv[Age0]]
;IF Age0count GT 0. THEN PRINT, 'densPintra[LiveIndiv[Age0]]', densPintra[LiveIndiv[Age0]]

;densPintra[LiveIndiv] = SNSpbio[18, LiveIndiv] + SNSpbio[14, LiveIndiv[Age1plus]]

;  IF Age0count GT 0. THEN BEGIN; YOY
 ;   densPintra[*] = SNSpbio[34, Age0]
     ;densPintra[*] = SNSpbio[34, *]
     ;densPinter[*] = SNSpbio[30, *]; + SNSpbio[31, Age0] + SNSpbio[32, Age0] + SNSpbio[33, Age0]
;  ENDIF 
;  IF Age1pluscount GT 0. THEN BEGIN; Age1+
;    densPintra[*] = SNSpbio[34, Age1plus] - SNSpbio[44, Age1plus]
;    densPinter[*] = SNSpbio[30, Age1plus] - SNSpbio[40, Age1plus]
;  ENDIF 
  
; WITH low competition - Beddington-DeAngelis model********DENSITY-DEPENDENCE**************************
C[0, LiveIndiv] = (Cons[0, LiveIndiv] / (1.0 + SumDen[LiveIndiv] + EPintra[LiveIndiv] * densPintra[LiveIndiv] $
                  + EPinter[LiveIndiv] * densPinter[LiveIndiv]))* tss;[LiveIndiv]
C[1, LiveIndiv] = (Cons[1, LiveIndiv] / (1.0 + SumDen[LiveIndiv] + EPintra[LiveIndiv] * densPintra[LiveIndiv] $
                  + EPinter[LiveIndiv] * densPinter[LiveIndiv]))* tss;[LiveIndiv]
C[2, LiveIndiv] = (Cons[2, LiveIndiv] / (1.0 + SumDen[LiveIndiv] + EPintra[LiveIndiv] * densPintra[LiveIndiv] $
                  + EPinter[LiveIndiv] * densPinter[LiveIndiv]))* tss;[LiveIndiv]
C[3, LiveIndiv] = (Cons[3, LiveIndiv] / (1.0 + SumDen[LiveIndiv] + EPintra[LiveIndiv] * densPintra[LiveIndiv] $
                  + EPinter[LiveIndiv] * densPinter[LiveIndiv]))* tss;[LiveIndiv]
C[4, LiveIndiv] = (Cons[4, LiveIndiv] / (1.0 + SumDen[LiveIndiv] + EPintra[LiveIndiv] * densPintra[LiveIndiv] $
                  + EPinter[LiveIndiv] * densPinter[LiveIndiv]))* tss;[LiveIndiv]
;PRINT, 'Consumption per prey (C, g/ts)'
;IF YOYcount GT 0.0 THEN PRINT, C[*, LiveIndiv[YOY]]

TotCts[LiveIndiv] = DOUBLE(C[0, LiveIndiv] + C[1, LiveIndiv] + C[2, LiveIndiv] + C[3, LiveIndiv] + C[4, LiveIndiv])                
;  PRINT, 'Total consumption (TotCts, g/ts)'
;  PRINT, TotCts[0:99]


; PROPORTIONS OF PREY-SPECIFIC CONSUMPTION
;>  NOT NEEDED IF THERE IS ONLY ONE PREY CATEROGORY <<<<<<<<<<<<<<<<<<<<<<<
TotCtsNZ = WHERE(TotCts[LiveIndiv] NE 0., TotCtsNZcount)
IF TotCtsNZcount GT 0. THEN BEGIN
  Cratio[0, LiveIndiv[TotCtsNZ]] = DOUBLE(C[0, LiveIndiv[TotCtsNZ]] / TotCts[LiveIndiv[TotCtsNZ]])
  Cratio[1, LiveIndiv[TotCtsNZ]] = DOUBLE(C[1, LiveIndiv[TotCtsNZ]] / TotCts[LiveIndiv[TotCtsNZ]])
  Cratio[2, LiveIndiv[TotCtsNZ]] = DOUBLE(C[2, LiveIndiv[TotCtsNZ]] / TotCts[LiveIndiv[TotCtsNZ]])
  Cratio[3, LiveIndiv[TotCtsNZ]] = DOUBLE(C[3, LiveIndiv[TotCtsNZ]] / TotCts[LiveIndiv[TotCtsNZ]])
  Cratio[4, LiveIndiv[TotCtsNZ]] = DOUBLE(C[4, LiveIndiv[TotCtsNZ]] / TotCts[LiveIndiv[TotCtsNZ]])
ENDIF
;  PRINT, 'Proportions of prey-specific consuption (Cratio)'
;  PRINT, Cratio[*, 0:99]
  
  ; Determine potential stomach weight in g after the current time step
;  potst = FLTARR(m, nSNS)
;  TotPotSt = FLTARR(nSNS)
;  Potst[0, tds] = C[0, tds] + CAftDig0[tds]
;  Potst[1, tds] = C[1, tds] + CAftDig1[tds]
;  Potst[2, tds] = C[2, tds] + CAftDig2[tds]
;  Potst[3, tds] = C[3, tds] + CAftDig3[tds]
;  Potst[4, tds] = C[4, tds] + CAftDig4[tds]
;  Potst[5, tds] = C[5, tds] + CAftDig5[tds]
  
;  TotPotSt[tds] = DOUBLE(PotSt[0,tds] + Potst[1, tds] + potst[2, tds] + potst[3, tds] + potst[4, tds] + potst[5, tds])  ;possible cons + what is left in the stomach
;  PRINT, 'Potential stomach weight per prey (g)'
;  PRINT, Potst
;  PRINT, 'Potential total stomach weight (g)'
;  PRINT, TotPotSt
  
  
  ; Check if potential stomach weight is greater than stomach capacity                           >>>>>NOT NECESSARY FOR A DAILY TIME STEP<<<<<<<<<<<<
;    PRINT, 'Stomach capacity'
;    PRINT, TRANSPOSE(StCap)

  ;PT = WHERE(TotPotSt LT StCap, PTcount, complement = P, ncomplement = Pcount)
;    ; If less than stomach capacity, fish keep its potential
;  PRINT, 'Number of fish with overconsumption =', Pcount
;  IF (PTcount GT 0.) THEN Nstom[PT] = TotPotSt[PT]; no change in consumption
;  
;    ; If more than stomach capacity, fish can eat to capacity
;  IF (Pcount GT 0.0) THEN BEGIN
;    ; AND need to remove biomass from diet so that nstom = stcap
;    Premove[P] = DOUBLE(stcap[P] / TotPotSt[P])
;  ;    PRINT, 'Premove'
;  ;    PRINT, (premove)


;Larva = WHERE(length LE 43.0, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
IF (Larvacount GT 0.) THEN BEGIN
  ;PRINT, N_ELEMENTS(CmaxProp[LiveIndiv[Larva]])
  ;PRINT, LiveIndiv[Larva]
  CmaxProp[LiveIndiv[Larva]] = CmaxPropLarva
ENDIF
IF (JuvAducount GT 0.) THEN CmaxProp[LiveIndiv[JuvAdu]] = CmaxPropJuvAdu
;IF (YOYcount GT 0.) THEN PRINT, CmaxProp[LiveIndiv[JuvAdu]]


PT = WHERE(TotCts[LiveIndiv] LT SNScmx * CmaxProp[LiveIndiv], PTcount, complement = P, ncomplement = Pcount)
;   PRINT, 'SNScmx'
;   PRINT, SNScmx[0:99]
  ; If less than Cmax, fish keep its potential
PRINT, 'Number of fish with overconsumption =', Pcount
IF (PTcount GT 0.) THEN TotCts[LiveIndiv[PT]] = TotCts[LiveIndiv[PT]]; no change in consumption
  ; If more than Cmax, fish can eat to capacity
IF (Pcount GT 0.0) THEN BEGIN
  ; AND need to remove biomass from diet so that nstom = stcap
  Premove[LiveIndiv[P]] = DOUBLE(SNScmx[P] * CmaxProp[LiveIndiv[P]] / TotCts[LiveIndiv[P]])
;  PRINT, 'Premove'
;  PRINT, premove[0:99]
     
  ; Determine additional amount needed to remove for previously undigested food
;    TotCAftDig[P] = CAftDig0[p] + CAftDig1[p] + CAftDig2[p] + CAftDig3[p]; $
;               ;+ CAftDig4[p] + CAftDig5[p] + CAftDig6[p] + CAftDig7[p] + CAftDig8[p] + CAftDig9[p]
;    RemC[LiveIndiv[P]] = TotCts[LiveIndiv[P]] - TotCts[LiveIndiv[P]] * Premove[LiveIndiv[P]]; ***SUBSCRIPT P ONLY**** 
;    ; the total amount of food needed to remove for previously undigested food 
;    RemC0[LiveIndiv[P]] = RemC[LiveIndiv[P]] * Cratio[0, LiveIndiv[P]]
;    RemC1[LiveIndiv[P]] = RemC[LiveIndiv[P]] * Cratio[1, LiveIndiv[P]]
;    RemC2[LiveIndiv[P]] = RemC[LiveIndiv[P]] * Cratio[2, LiveIndiv[P]]
;    RemC3[LiveIndiv[P]] = RemC[LiveIndiv[P]] * Cratio[3, LiveIndiv[P]]
;    RemC4[LiveIndiv[P]] = RemC[LiveIndiv[P]] * Cratio[4, LiveIndiv[P]]

  ; remove the additional amount of consumed food for the previously undigested
  ; excess food can be removed only from the food consumed in the current time step
;    C[0, p] = DOUBLE(Premove[P] * C[0, p] - RemCAftDig0[P]) ;new g of prey after removing specific prey item...
;    C[1, p] = DOUBLE(Premove[P] * C[1, p] - RemCAftDig1[P])
;    C[2, p] = DOUBLE(Premove[P] * C[2, p] - RemCAftDig2[P])
;    C[3, p] = DOUBLE(Premove[P] * C[3, p] - RemCAftDig3[P])
;    C[4, p] = DOUBLE(Premove[P] * C[4, p] - RemCAftDig4[P])
;    C[5, p] = DOUBLE(Premove[P] * C[5, p] - RemCAftDig5[P])

  C[0, LiveIndiv[p]] = DOUBLE(Premove[LiveIndiv[P]] * C[0, LiveIndiv[p]]) ;new g of prey after removing specific prey item...
  C[1, LiveIndiv[p]] = DOUBLE(Premove[LiveIndiv[P]] * C[1, LiveIndiv[p]])
  C[2, LiveIndiv[p]] = DOUBLE(Premove[LiveIndiv[P]] * C[2, LiveIndiv[p]])
  C[3, LiveIndiv[p]] = DOUBLE(Premove[LiveIndiv[P]] * C[3, LiveIndiv[p]])
  C[4, LiveIndiv[p]] = DOUBLE(Premove[LiveIndiv[P]] * C[4, LiveIndiv[p]])

  TotCts[LiveIndiv[P]]= DOUBLE(C[0,LiveIndiv[P]] + C[1, LiveIndiv[P]] + C[2, LiveIndiv[P]] + C[3, LiveIndiv[P]] + C[4, LiveIndiv[P]])               
  ;    PRINT, 'Consumption per prey after adjusting for overconsumption (C, g/ts)'
  ;    PRINT, TRANSPOSE(C)
  ;    PRINT, 'Total consumption after adjusting for overconsumption (TotCts, g/ts)'
  ;    PRINT, (TotCts)
  
    ; determine prey-specific weight adjusted for overconsumption
;    Potst[0, p] = C[0, P] + CAftDig0[P]
;    Potst[1, p] = C[1, P] + CAftDig1[P]
;    Potst[2, p] = C[2, P] + CAftDig2[P]
;    Potst[3, P] = C[3, P] + CAftDig3[P]
;    Potst[4, P] = C[4, P] + CAftDig4[P]
;    Potst[5, P] = C[5, P] + CAftDig5[P]
;    
;    Potst[0, p] = C[0, P] 
;    Potst[1, p] = C[1, P] 
;    Potst[2, p] = C[2, P] 
;    Potst[3, P] = C[3, P] 
;    Potst[4, P] = C[4, P] 
;    Potst[5, P] = C[5, P] 
    
;    TotPotSt[P] = DOUBLE(PotSt[0,P] + Potst[1, P] + potst[2, P] + potst[3, P] + potst[4, P]); + potst[5, P])
;    Nstom[P] = TotPotSt[P]
;    PRINT, 'Potential stomach weight per prey (g) AFTER adjusting for overconsumption'
;    PRINT, Potst
;    PRINT, 'Potential total stomach weight (g) AFTER adjusting for overconsumption'
;    PRINT, TotPotSt
ENDIF
;PRINT, 'New stomach content (g) before digestion'
;PRINT, Nstom
;PRINT, 'Consumption per prey after adjusting for overconsumption (C, g/ts)'
;IF YOYcount GT 0.0 THEN  PRINT, (C[*, LiveIndiv[YOY]])
;PRINT, 'Total consumption after adjusting for overconsumption (TotCts, g/ts)'
;IF YOYcount GT 0.0 THEN PRINT, TotCts[LiveIndiv[YOY]]
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  

; Temperature-dependent digestion and gut evacuation -> NEED TO UPDATED FOR STURGEON     >>>>>NOT NECESSARY FOR A DAILY TIME STEP<<<<<<<<<<<<
  ;Gut evacuation rate, R, for Walleye from walleye larvae from Johnston and Mathias, Journal of Fish Biology (1996) 49, 375–389
;  SNSGutEvacR = EXP(-14.5 + 1.33 * Temp - 0.0329 * Temp^2.- 0.0157*Temp * ALOG(SNS[2, *])) / 60. * fDOfc2; in g/min temperature-dependent
  ;WAE[2, *] = WEIGHT-> dry weight mg ( * 0.1 * 1000.)

  ; Food digeseted over time step
;  PRINT, 'Prey specific stomach content before Digestion'
;  PRINT, PotSt[*, tds]

  ; Digestion and evacuation of each prey from current and previous ts
;  CAftDig[0, tds] = (CAftDig0[tds] * EXP(-SNSGutEvacR[tds] * ts) + (C[0, tds]) * EXP(-SNSGutEvacR[tds] * ts));
;  CAftDig[1, tds] = (CAftDig1[tds] * EXP(-SNSGutEvacR[tds] * ts) + (C[1, tds]) * EXP(-SNSGutEvacR[tds] * ts)); 
;  CAftDig[2, tds] = (CAftDig2[tds] * EXP(-SNSGutEvacR[tds] * ts) + (C[2, tds]) * EXP(-SNSGutEvacR[tds] * ts));
;  CAftDig[3, tds] = (CAftDig3[tds] * EXP(-SNSGutEvacR[tds] * ts) + (C[3, tds]) * EXP(-SNSGutEvacR[tds] * ts)); 
;  CAftDig[4, tds] = (CAftDig4[tds] * EXP(-SNSGutEvacR[tds] * ts) + (C[4, tds]) * EXP(-SNSGutEvacR[tds] * ts)); 
;  CAftDig[5, tds] = (CAftDig5[tds] * EXP(-SNSGutEvacR[tds] * ts) + (C[5, tds]) * EXP(-SNSGutEvacR[tds] * ts)); 

;  DigestedFood[0, tds] = DOUBLE(potst[0, tds] - CAftDig[0, tds])
;  DigestedFood[1, tds] = DOUBLE(potst[1, tds] - CAftDig[1, tds])
;  DigestedFood[2, tds] = DOUBLE(potst[2, tds] - CAftDig[2, tds])
;  DigestedFood[3, tds] = DOUBLE(potst[3, tds] - CAftDig[3, tds])
;  DigestedFood[4, tds] = DOUBLE(potst[4, tds] - CAftDig[4, tds])
;  DigestedFood[5, tds] = DOUBLE(potst[5, tds] - CAftDig[5, tds])

  ; Determine total non-digested stomach weight in g after each time step
;  potstAftDig[tds] = DOUBLE(CAftDig[0,tds] + CAftDig[1,tds] + CAftDig[2,tds] + CAftDig[3,tds] + CAftDig[4,tds] + CAftDig[5,tds]$
;                   + CAftDig[6,tds] + CAftDig[7,tds] + CAftDig[8,tds] + CAftDig[9,tds]);
;  NewStom[tds] = (PotStAftDig[tds]); tds = TotCday < YPcmx
  ; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  
  ; Determine daily cumulative food consumption 
;  TotCday[tds] = TotCday[tds] + TotCts[tds]
;  TotC[0, tds] = C[0, tds] + TotC0[tds]
;  TotC[1, tds] = C[1, tds] + TotC1[tds]
;  TotC[2, tds] = C[2, tds] + TotC2[tds]
;  TotC[3, tds] = C[3, tds] + TotC3[tds]
;  TotC[4, tds] = C[4, tds] + TotC4[tds]
;  TotC[5, tds] = C[5, tds] + TotC5[tds]
;  PRINT, 'Total daily cumulative consumption (TotCday, g/day)'
;  PRINT, TRANSPOSE(totcday)
;  PRINT, 'Daily cumulative consumption for each prey (TotC, g/day)'
;  PRINT, (TotC)

  ;ENDIF
;ENDIF;****************************************************************************************************************************


;*********If the previous stomach content is larger than CMAX -> No consumption - digestion/evacuation only***********************
;PRINT, 'Number of fish with full stomach or Cmax =', dcount;                          >>> MAY NOT BE NEEDED FOR SIMULATIONS WITH A DAILY TIME STEP <<<<<<

;IF (dcount GT 0.0) THEN BEGIN; dcount = totcday > YPcmx 
; OR ((iHour LT 4L) AND (iHour GT 15L)) OR ((iHour LT 4L) AND (iHour GT 20L))

  ; Digestion and evacuation for each prey item
  ;SNSGutEvacR = EXP(-14.5+1.33*Temp-0.0329*Temp^2-0.0157*Temp * ALOG(SNS[2, *]))/60. * fDOfc2; in g/min temperature-dependent
  
;  CAftDig[0,d] = DOUBLE(CAftDig0[d] * EXP(-SNSGutEvacR[d] * ts)); 
;  CAftDig[1,d] = DOUBLE(CAftDig1[d] * EXP(-SNSGutEvacR[d] * ts)); 
;  CAftDig[2,d] = DOUBLE(CAftDig2[d] * EXP(-SNSGutEvacR[d] * ts)); 
;  CAftDig[3,d] = DOUBLE(CAftDig3[d] * EXP(-SNSGutEvacR[d] * ts)); 
;  CAftDig[4,d] = DOUBLE(CAftDig4[d] * EXP(-SNSGutEvacR[d] * ts)); 
;  CAftDig[5,d] = DOUBLE(CAftDig5[d] * EXP(-SNSGutEvacR[d] * ts)); 


  ; Determine total non-digested stomach content in g after time step
;  PotStAftDig[d] = DOUBLE(CAftDig[0,d] + CAftDig[1,d] + CAftDig[2,d] + CAftDig[3,d] + CAftDig[4,d] + CAftDig[5,d]$
;                   + CAftDig[6,d] + CAftDig[7,d] + CAftDig[8,d]+ CAftDig[9,d]);
;  NewStom[d] = PotStAftDig[d]


  ; DigestedFood per time step
;  DigestedFood[0,d] = DOUBLE(CAftDig0[d] - CAftDig[0,d])
;  DigestedFood[1,d] = DOUBLE(CAftDig1[d] - CAftDig[1,d])
;  DigestedFood[2,d] = DOUBLE(CAftDig2[d] - CAftDig[2,d])
;  DigestedFood[3,d] = DOUBLE(CAftDig3[d] - CAftDig[3,d])
;  DigestedFood[4,d] = DOUBLE(CAftDig4[d] - CAftDig[4,d])
;  DigestedFood[5,d] = DOUBLE(CAftDig5[d] - CAftDig[5,d])


;  TotCday[d] = TotCday[d]; No consumption during this time step
;  TotC[0, d] = TotC0[d]
;  TotC[1, d] = TotC1[d]
;  TotC[2, d] = TotC2[d]
;  TotC[3, d] = TotC3[d]
;  TotC[4, d] = TotC4[d]
;  TotC[5, d] = TotC5[d]
;ENDIF;****************************************************************************************************************************

;PRINT, 'New Digested prey item (DigestedFood, g)'
;PRINT, (DigestedFood[*, *])
;PRINT, 'Undigested prey items (CAftDig, g)'
;PRINT, CAftDig[*, *]  
;PRINT, 'Total non-digested stomach content (potstAftDig, g)'
;PRINT, (potstAftDig[*])
;PRINT, 'New Stomach content (NewStom, g)'
;PRINT, (NewStom[*])
;PRINT, 'Total daily cumulative consumption (g/day)'
;PRINT, (TotCday[*])


; Make arrays for state variables
; Consumed food items used for growth subroutine   >>>>> MAY NOT BE NEEDED FOR SIMULATIONS WITH A DAILY TIME STEP <<<<<<
consumption[0, LiveIndiv] = C[0, LiveIndiv]; drift prey 1 in g   
consumption[1, LiveIndiv] = C[1, LiveIndiv]; drift prey 2 in g   
consumption[2, LiveIndiv] = C[2, LiveIndiv]; drift prey 3 in g   
consumption[3, LiveIndiv] = C[3, LiveIndiv]; drift prey 4 in g   
consumption[4, LiveIndiv] = C[4, LiveIndiv]; drift prey 5 in g   
;consumption[5,*] = C[5,*]; drift prey 6 in g  

; Number of each prey consumed per time step
Non0Prey0 = WHERE((PW[0, LiveIndiv] GT 0.), Non0Prey0count)
IF Non0Prey0count GT 0. THEN consumption[6, LiveIndiv[Non0Prey0]] = ROUND(C[0, LiveIndiv[Non0Prey0]]/PW[0, LiveIndiv[Non0Prey0]]);
Non0Prey1 = WHERE((PW[1, LiveIndiv] GT 0.), Non0Prey1count)
IF Non0Prey1count GT 0. THEN consumption[7, LiveIndiv[Non0Prey1]] = ROUND(C[1, LiveIndiv[Non0Prey1]]/PW[1, LiveIndiv[Non0Prey1]]);
Non0Prey2 = WHERE((PW[2, LiveIndiv] GT 0.), Non0Prey2count)
IF Non0Prey2count GT 0. THEN consumption[8, LiveIndiv[Non0Prey2]] = ROUND(C[2, LiveIndiv[Non0Prey2]]/PW[2, LiveIndiv[Non0Prey2]]); 
Non0Prey3 = WHERE((PW[3, LiveIndiv] GT 0.), Non0Prey3count)
IF Non0Prey3count GT 0. THEN consumption[9, LiveIndiv[Non0Prey3]] = ROUND(C[3, LiveIndiv[Non0Prey3]]/PW[3, LiveIndiv[Non0Prey3]]); 
Non0Prey4 = WHERE((PW[4, LiveIndiv] GT 0.), Non0Prey4count)
IF Non0Prey4count GT 0. THEN consumption[10, LiveIndiv[Non0Prey4]] = ROUND(C[4, LiveIndiv[Non0Prey4]]/PW[4, LiveIndiv[Non0Prey4]]); 
;Non0Prey5 = WHERE((PW[5, *] GT 0.), Non0Prey5count)
;IF Non0Prey5count GT 0. THEN consumption[12, Non0Prey5] = ROUND(C[5, Non0Prey5]/PW[5, Non0Prey5]); 

;consumption[10,*] = NewStom[*]; new weight of stomach content
consumption[11, LiveIndiv] = TotCts[LiveIndiv]; new total consumption after time step need to be updated every 24h
consumption[25, LiveIndiv] = TotCts[LiveIndiv] / SNScmx; relative to Cmax

; Foraging metabolic cost
;consumption[12, LiveIndiv] = SwimCost
;consumption[13, LiveIndiv] = PreyCapCost * consumption[6, LiveIndiv] * PreyCapT[0, LiveIndiv]; *0.6; * Cratio[0, LiveIndiv] * tss; 
;consumption[14, LiveIndiv] = PreyCapCost * consumption[7, LiveIndiv] * PreyCapT[1, LiveIndiv]; *0.6; * Cratio[1, LiveIndiv] * tss; 
;consumption[15, LiveIndiv] = PreyCapCost * consumption[8, LiveIndiv] * PreyCapT[2, LiveIndiv]; *0.6; * Cratio[2, LiveIndiv] * tss; 
;consumption[16, LiveIndiv] = PreyCapCost * consumption[9, LiveIndiv] * PreyCapT[3, LiveIndiv]; *0.6; * Cratio[3, LiveIndiv] * tss; 
;consumption[17, LiveIndiv] = PreyCapCost * consumption[10, LiveIndiv] * PreyCapT[4, LiveIndiv]; *0.6; * Cratio[4, LiveIndiv] * tss;

consumption[20, LiveIndiv] = Cratio[0, LiveIndiv]; drift prey 1 in g   
consumption[21, LiveIndiv] = Cratio[1, LiveIndiv]; drift prey 2 in g   
consumption[22, LiveIndiv] = Cratio[2, LiveIndiv]; drift prey 3 in g   
consumption[23, LiveIndiv] = Cratio[3, LiveIndiv]; drift prey 4 in g   
consumption[24, LiveIndiv] = Cratio[4, LiveIndiv]; drift prey 5 in g   
;PRINT, 'CONSUMPTION[0:4, YOY]'
;IF YOYcount GT 0.0 THEN PRINT, CONSUMPTION[0:4, LiveIndiv[YOY]]

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
;PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Shovelnose Sturgeon Foraging Ends Here'
RETURN, Consumption; TURN OFF WHEN TESTING
END