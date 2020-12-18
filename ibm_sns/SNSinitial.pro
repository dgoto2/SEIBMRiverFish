FUNCTION SNSinitial, nState, NpopYOY, nSIyoy, nSNS, TotDriftBio, HydroInput, WQInput, nGridcell
; this function initializes the model for shovelnose sturgeon

;*****TEST ONLY*************************************************************************************************************
;;; values need to test the function... TURN OFF when full model running
;; Total number of superindividuals in each cohort
;nSIyoy = 5000L ; number of shovelnose sturgeon egg as superindividuals(SIs)
;; INITIAL TOTAL NUMBER OF FISH POPUALTION IN THE LOWER PLATTE RIVER -> Initial population structure is the same for all years
;;Average population size and age structure of XXX to XXX from XXXX >>>> NEED TO ADJUST FOR STURGEON
;; In the 1D model, XXXX
;NpopSNS = 50000L; number of SNS individuals
;nSNS = NpopSNS + nSIyoy
;NpopYOY = 5000000L; number of SNS eggs/larvae
;nGridcell = 162L; the number of longitudianl grid cells
;iDay = 1L; day 1 - end of month
;iYear = 2009L
;TotDriftBio = RANDOMU(seed, nGridcell)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;; Read a daily environmental input
;WQEnvir1D = EcoToxRiver1DInput(iYear) 
;HydroEnvir1D = EcoToxRiver1DHydrologyInput(iYear);, iDay, TotDriftBio) 
;
;; Call only a daily input from a yearly input read from the file
;iDayPointer = iDay - 1L; - 105L
;; First DOY for the simulation - DOY105 =~April 15 (the fisrt day in the input files), DOY152 = ~June 1
;WQInput = WQEnvir1D[*, iDayPointer]; No spatial resolution for the water quality inputs
;HydroInput = HydroEnvir1D[*, 162L*iDayPointer : 162L*iDayPointer+161L]; 162 longitudianl grid cells
;**************************************************************************************************************************

PRINT, 'SNSinitial Starts Here'

; Assign array structure
SNS = FLTARR(nState, nSNS)
randomNumbers = RANDOMU(seed, nSNS); random number for YOY superindividual ID 
no_inds = FLTARR(nSNS);
Linf = FLTARR(nSNS)
K = FLTARR(nSNS)
t0 = FLTARR(nSNS)
LENGTH = FLTARR(nSNS)
opt_rho = FLTARR(nSNS)
maturity = FLTARR(nSNS)
maturityFunc = FLTARR(nSNS)
maturitystatus = FLTARR(nSNS)
maturityprob = FLTARR(nSNS)
MinMatAge = FLTARR(nSNS)

; Parameter values
MinMatAgeMale = 4.; minmimum age of mature male
MinMatAgeFemale = 6.; minmium age of mature female
MaxIntGSIFemale = 0.15; initial maximal GSI for female
MaxIntGSIMale = 0.03; inital maximal GSI for male
DOYExpSpwn = 82.; expected earliest day of spawning
IntMaxAge = 16; inital maximum age
;vonBertParamMale1
;vonBertParamMale2
;vonBertParamMale3
;vonBertParamFemale1
;vonBertParamFemale2
;vonBertParamFemale3
IntMinV = 0.2; inital minimal velocity for sturgeon
OptRhoMin = 0.3

; Set initial values for state variables
SNS[0, *] = 0.; YEAR
SNS[1, *] = 0.; MONTH
SNS[2, *] = 0.; DAY
;FishEnvirHydro[0, *] = YEAR 
;FishEnvirHydro[1, *] = MONTH
;FishEnvirHydro[2, *] = DAY
;FishEnvirHydro[3, *] = DOY

SNS[3, *] = FINDGEN(nSNS)+1L; Fish SI ID

; Set the number of individuals in EACH superindividual
; below statement is required to make an even distribution of ages between 0-20
; set the number of individuals within an age category to frequency dist from the lower Platte River
; randomly assign ages 0-7 based on a uniform distribution

SEX = ROUND(RANDOMU(seed, nSNS)); randomly assign sex -> 1:1 ratio
SNS[5, *] = SEX ; MALE = 0 AND FEMALE = 1

AGE = FLTARR(nSNS)+1L; add 1 to locate YOY individuals
;print, total(age)
          
sortedRandomNumbers = SORT(randomNumbers)     
YOYLoc = sortedRandomNumbers[0L:nSIyoy-1L]; randomly assign YOY to superindividuals  
;print, YOYLoc
;print,'#yoyloc',n_elements(yoyloc)
AGE[YOYLoc] = 0L
;print,'#yoyloc',n_elements(AGE[YOYLoc])
;print,total(AGE[YOYLoc])
YOY = WHERE(AGE LT 1L, YOYcount, complement = YAO, ncomplement = YAOcount); locate YOY (super)individuals 
;print,'#yoyloc',n_elements(AGE[YOYLoc])
;print,'yoycount',yoycount
;print,'yaocount',yaocount
AGE[YAO] = RANDOMN(seed, (nSNS-nSIyoy), POISSON=7)>1L; randomly assing age >1 to the rest using a Poisoon distribution
AGE17plus = WHERE(AGE GE IntMaxAge, AGE17pluscount, complement = AGE17less, ncomplement = AGE17lesscount); set maximum age = 18
IF AGE17pluscount GT 0. THEN AGE[AGE17plus] = ROUND(RANDOMU(seed, AGE17pluscount) * (MAX(IntMaxAge - 1) - MIN(1)) + MIN(1)); 
;print, (age)
;PRINT, transpose(histogram(age))
SNS[6, *] = AGE;

; YOY fractional develpment >>> Post-settlment YOY and YAO = 1
SNS[57, YOY] = 0.; = embryonic development
;SNS[57, YAO] = 1.; 
SNS[58, YOY] = 0.; = yolk-sac larval develpment
;SNS[58, YAO] = 1.; Post-settlment YOY and YAO >= 1

; determine the number of SIs at age and the total number of individuals represented by age
;AgeProp = FLTARR(21)
; The following is based on average values of the lower Platte River field data between 2009 to 2012?
;AgeProp[0] = 1.; YOY is initialized separtely as superindividuals

IF YOYcount GT 0. THEN no_inds[YOY] = NpopYOY/YOYcount; initially no YOY until spawning
IF YAOcount GT 0. THEN no_inds[YAO] = (nSNS - nSIyoy)/YAOcount
SNS[4, *] = no_inds;                                 >>>>>>> MAY NOT BE NEEDED <<<<<<<<<<<<<<<<<<<<<<<<<<<
; Age 1 and older should have #individual=1

; Lower Platte River surface area = ~XXXkm2 
; 1 ha = 0.01km2


;*****Lower Platte River AGE-SPECIFIC LENGTHS**********
; von bertalanffy params 
; from Tripp et al. 2009 TAFS for shovelnose sturgeon (from Middle Mississippi River)
; parameters are for fork lengths
Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
IF malecount GT 0. THEN BEGIN
  ; males, based on age 3-19
  Linf[male] = 770.78
  K[male] = 0.14
  t0[male] = -1.13
ENDIF
IF femalecount GT 0. THEN BEGIN
  ; females, based on age 4-22
  Linf[female] = 811.52
  K[female] =  0.11
  t0[female] = -1.99
ENDIF
Length[*] = Linf[*] * (1 - EXP(-K[*] * ((AGE[*]-1) - t0[*]))); * 1.02 + 43.14; convert FL to TL
LAG0 = WHERE((AGE EQ 0), LAG0count); YOY begin from the the egg stage
IF(LAG0count GT 0.) THEN Length[LAG0] = 0.; RANDOMU(seed, LAG0count) * (MAX(3.5) - MIN(3.)) + MIN(3.); diameter of eggs >>> MAY NEED TO BE CHANGED TO 0 TO SKIP OTHER SUBMODELS
; shovelnose sturgeon larvae initial length = mm
;length = IntLength + RANDOMN(seed, nSNS) * (0.2/6.6)*IntLength
; random numbers with mean 9.0 and SD 0.2 FOR  from 
SNS[7, *] = Length; in mm
;PRINT, 'SNS[7, *]'
;PRINT, TRANSPOSE(SNS[7, 0L:199L])

; Locate surviving individuals
LiveIndiv = WHERE(SNS[4, *] GT 0., LiveIndivcount)

; Assining weight, storage weight, structural weight
SNS[10, LiveIndiv] = 0.035*0.00001 * (SNS[7, LiveIndiv])^(2.8403 * 1.1573); YAO structural weight - length-based
opt_rho[LiveIndiv] = 1.4 * 0.0912 * ALOG10((SNS[7, LiveIndiv])); + 0.128 * 1.6; YAO optimal rho - length-based
;print, min(opt_rho)

; Don't allow opt_rho to drop below 0.2
CheckRho = WHERE(opt_rho LT OptRhoMin, CheckRhocount)
IF CheckRhocount GT 0 THEN opt_rho[CheckRho] = OptRhoMin
SNS[8, LiveIndiv] = SNS[10, LiveIndiv] / (1 - opt_rho[LiveIndiv]); total weight -> struc weight-based


; Maturation status
LiveIndivMale = WHERE(SNS[4, Male] GT 0., LiveIndivMalecount)
LiveIndivFemale = WHERE(SNS[4, Female] GT 0., LiveIndivFemalecount)
IF LiveIndivMalecount GT 0. THEN maturityFunc[Male[LiveIndivMale]] = 0.9236/(1+ABS(length[Male[LiveIndivMale]]/520.5735)^(-21.3815)); males
IF LiveIndivFemalecount GT 0. THEN maturityFunc[female[LiveIndivFemale]] = 1.0711/(1+ABS(length[female[LiveIndivFemale]]/624.6820)^(-15.8870))<1.; females

FOR iMature = 0L, nSNS-1L DO MaturityProb[iMature] = RANDOMN(seed, binomial=[nSNS, maturityfunc[iMature]])/nSNS
;print, 'maturityprob', maturityprob
maturitystatus = WHERE((MaturityProb LT maturityFunc), maturitycount, complement = immature, ncomplement = immaturecount)
IF maturitycount GT 0. THEN maturity[maturitystatus] = 1.

;>Assume shovelnose sturgeon cannot mature before age 5(male) or 7(female)
MinMatAge[male] = MinMatAgeMale
MinMatAge[female] = MinMatAgeFemale
MaturityCheck = WHERE((age LT MinMatAge), maturitycheckcount, complement = immaturecheck, ncomplement = immaturecheckcount)
IF maturitycheckcount GT 0. THEN maturity[MaturityCheck] = 0.

SNS[12, *] = maturity; maturity, 0 or 1, initially randomly assinged to individuals
;PRINT, 'SNS[12, *]'
;PRINT, TRANSPOSE(SNS[12, 0L:199L])

MatureMale = WHERE(SNS[12, male] GT 0., Maturemalecount, complement = Immaturemale, ncomplement = Immaturemalecount); 
MatureFemale = WHERE(SNS[12, female] GT 0., Maturefemalecount, complement = Immaturefemale, ncomplement = Immaturefemalecount);
Immature = WHERE(SNS[12, *] LE 0., Immaturecount);

; GSI
IF Maturemalecount GT 0. THEN SNS[59, Male[Maturemale]] = RANDOMU(seed, Maturemalecount) * (MAX(MaxIntGSIMale) - MIN(0.02)) + MIN(0.02);SNS[13, LiveIndiv]/SNS[8, LiveIndiv]; GSI in proportion of total weight
IF Maturemalecount GT 0. THEN SNS[59, Female[Maturefemale]] = RANDOMU(seed, Maturefemalecount) * (MAX(MaxIntGSIFemale) - MIN(0.02)) + MIN(0.02);SNS[13, LiveIndiv]/SNS[8, LiveIndiv]; GSI in proportion of total weight
;PRINT, 'GSI of spawning females'
;PRINT, MEAN(SNS[59, Female[Maturefemale]]), MAX(SNS[59, Female[Maturefemale]]), MIN(SNS[59, Female[Maturefemale]])
    
; gonad weight (g) >>>>>>> FOR INITIALIZATION, SOME SPAWNING ADULTS MAY NEED TO HAVE RIPE GONAD <<<<<<<<<<<<<<<<<<<<<<
IF Maturemalecount GT 0. THEN SNS[13, Male[Maturemale]] = SNS[8, Male[Maturemale]] * SNS[59, Male[Maturemale]]; RANDOMU(seed, Maturemalecount) * (MAX(0.03) - MIN(0.015)) + MIN(0.015); 
IF Maturefemalecount GT 0. THEN SNS[13, Female[Maturefemale]] = SNS[8, Female[Maturefemale]] * SNS[59, Female[Maturefemale]]; RANDOMU(seed, Maturefemalecount) * (MAX(0.22) - MIN(0.04)) + MIN(0.04)
;IF Immaturemalecount GT 0. THEN SNS[13, Male[Immaturemale]] = SNS[8, Male[Immaturemale]] * 0.001
;IF Immaturefemalecount GT 0. THEN SNS[13, Female[Immaturefemale]] = SNS[8, Female[Immaturefemale]] * 0.001
IF Immaturecount GT 0. THEN SNS[13, Immature] = SNS[8, Immature] * 0.02

IF YOYcount GT 0. THEN  SNS[13, YOY] = 0.

;PRINT, 'SNS[13, *]'
;PRINT, TRANSPOSE(SNS[13, 0L:199L])

SNS[14, *] = 0.; 0 (no) or 1 (yes), annual reproductive cycle status 
SNS[54, *] = DOYExpSpwn; = ~March 23rd (DLH = 12h), tExpSpwn 
SNS[55, *] = 0.;
SNS[56, *] = 0.; J, GonadtEndGrwth, gonad energy content when females become mature (stage I)
;SNS[59, LiveIndiv] = SNS[13, LiveIndiv]/SNS[8, LiveIndiv]; GSI in proportion of total weight
SNS[9, *] = SNS[8, *] - SNS[10, *] - SNS[13, *]; storage weight = total wieght - struc weight - gonad weight (for adults)

; Physiological condition
SNS[11, LiveIndiv] = (SNS[9, LiveIndiv]+SNS[13, LiveIndiv])/(opt_rho[LiveIndiv]*SNS[8, LiveIndiv]); KS = STOR/OPT_WT
;PRINT, 'KS of spawning females'
;PRINT, MEAN(SNS[11, Female[Maturefemale]]), MAX(SNS[11, Female[Maturefemale]]), MIN(SNS[11, Female[Maturefemale]])

;***Assigning hatch cell or initial location of fish***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
; Haching occurs in ???
Vwater = hydroinput[7, *] / (hydroinput[8, *] * (hydroinput[9, *] + ABS(hydroinput[10, *]*RANDOMN(SEED, nSNS))))
;Vwater = 0.1176+0.4031*Vwater
;SNShat = WHERE((Vwater[0L : nGridcell-1L] GE 0.3 AND hydroinput[9L : nGridcell-1L] GE 0.6), count)
SNShat = WHERE((Vwater[0L : nGridcell-1L] GE IntMinV), count)

; >>>>>>>>>>>>>>FIND MINIMUM WATER VELOCITY FOR SHOVELNOSE STURGEON<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; ********adjust it for discharge&depth-based habitat quality from Peters and Perham (2008)

; cells that can be used as hatching cells for SHOVELNOSE STURGEON
;PRINT, 'Shat', Shat
;PRINT, 'count', count

;HatLoc = FLTARR(nSNS)
HatLoc = ROUND(RANDOMU(seed, nSNS) * (count - 1L))
; random number for all SNS SIs ranging from 0-# cells with depths less than XX m
;PRINT, 'HatLoc', HatLoc

SNSenvirhydro = HydroInput[*, SNShat[HatLoc]]; x, y location based on depths less than XX m
SNSenvirWQ = WQInput[*, *] # REPLICATE(1., nSNS)
;PRINT, 'Senvir', Senvir



; Environment
SNS[15:21, *] = SNSenvirhydro[4:10, *]; from Hydrology inputs
; 15-FishEnvirHydro[4, *] = ReachID
; 16-FishEnvirHydro[5, *] = SegmentID
; 17-FishEnvirHydro[6, *] = SegmentID2     => ***LONGITUDIANL GRID ID#***
; 18-FishEnvirHydro[7, *] = DISCHARGE
; 19-FishEnvirHydro[8, *] = width
; 20-FishEnvirHydro[9, *] = Depth
; 21-FishEnvirHydro[10, *] = DepthSE

SNS[24, *] = SNSenvirhydro[11, *]; from Hydrology inputs
; 24-FishEnvirHydro[11, *] = TURB; 

SNS[22:23, *] = SNSenvirWQ[4:5, *]
; 22-FishEnvir[4, *] = TEMP;
; 23-FishEnvir[5, *] = OXYGEN; 
SNS[25, *] = SNSenvirWQ[7, *]
; 25-FishEnvir[7, *] = DAYLIGHT; 


;***Assining hatch temp***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
HatchTemp = ROUND(RANDOMU(seed, YOYcount) * (MAX(24.9) - MIN(12)) + MIN(12)); ADJUST FOR SHOVEL NOSE STURGEON
CheckHatchTemp = WHERE(HatchTemp LT 12.0, CheckHatchTempcount)
IF (CheckHatchTempcount GT 0) THEN HatchTemp[CheckHatchTemp] = 12.0
SNS[26, YOY] = HatchTemp

; Prey availability
SNS[27, *] = TotDriftBio[0, SNShat[HatLoc]]; drift prey1
SNS[28, *] = TotDriftBio[1, SNShat[HatLoc]]; drift prey2
SNS[29, *] = TotDriftBio[2, SNShat[HatLoc]]; drift prey3
SNS[30, *] = TotDriftBio[3, SNShat[HatLoc]]; drift prey4
SNS[31, *] = TotDriftBio[4, SNShat[HatLoc]]; drift prey5

; Within-cell proportional coordinates from movements
SNS[32, *] = 0.0; total distance (km) moved within each cell in ts ->may be used to estimate movement-based activity cost
SNS[33, *] = 0.0; Within-cell coordinate for x or longitudinal direction
;SNS[31, *] = 0.0; Within-cell coordinate for y
;SNS[32, *] = 0.0; Within-cell coordinate for z

;SNS[7, *] = 0.0; holds stomach content weight in g
;SNS[60, *] = 0.0; GUT FULLNESS(%)

; Prey consumption
SNS[34, *] = 0.0; total consumption/Cmax 
SNS[35, *] = 0.0; total amount of prey consumed in g
SNS[36, *] = 0.0; total amount of drift prey1 consumed in g
SNS[37, *] = 0.0; total amount of drift prey2 consumed in g
SNS[38, *] = 0.0; total amount of drift prey3 consumed  in g
SNS[39, *] = 0.0; total amount of drift prey4 consumed in g
SNS[40, *] = 0.0; total amount of drift prey5 consumed in g

SNS[65, *] = 0.0; total # of drift prey1 consumed 
SNS[66, *] = 0.0; total # of drift prey2 consumed
SNS[67, *] = 0.0; total # of drift prey3 consumed  
SNS[68, *] = 0.0; total # of drift prey4 consumed 
SNS[69, *] = 0.0; total # of drift prey5 consumed 

; prey ratio
SNS[60, *] = 0.0; total amount of drift prey1 consumed in g
SNS[61, *] = 0.0; total amount of drift prey2 consumed in g
SNS[62, *] = 0.0; total amount of drift prey3 consumed  in g
SNS[63, *] = 0.0; total amount of drift prey4 consumed in g
SNS[64, *] = 0.0; total amount of drift prey5 consumed in g

; Foraging cost
SNS[41, *] = 0.0; SwimCost, J/d

SNS[42, *] = 0.0; capture cost for drift prey1, J/d
SNS[43, *] = 0.0; capture cost for drift prey2, J/d
SNS[44, *] = 0.0; capture cost for drift prey3, J/d
SNS[45, *] = 0.0; capture cost for drift prey4, J/d
SNS[46, *] = 0.0; capture cost for drift prey5, J/d

; Growth
SNS[47, *] = 0.0; daily cumulative growth in length
SNS[48, *] = 0.0; daily cumulative growth in weight

; Respiration
SNS[49, *] = 0.0; daily respiration rate. J/d

; Fecundity
SNS[50, *] = 0.; the number of eggs

; Acclimation ; >>>>>MAY NOT BE NEEDED FOR A DAILY TIME STEP
;SNS[26, *] = SNS[19, *]; temperature the fish is acclimatized for consumption
;SNS[27, *] = SNS[19, *]; temperature the fish is acclimatized for respiration

;SNS[28, *] = SNS[20, *]; DOa ;DO the fish is acclimatized for consumption
;SNS[29, *] = SNS[20, *]; DOa ;DO the fish is acclimatized for respiration 

; Mortality
SNS[51, *] = 0.; background predation mortality 
SNS[52, *] = 0.; starvation mortality
SNS[53, *] = 0.; thermal (eggs and yolksac larvae) or fishing mortality

SNS[70, *] = 0.; emigration
SNS[71, *] = 0.; spawning day (CONTINUOUS)
SNS[72, *] = 0.; spawning interval

SNS[73, *] = 0.; hatching day
SNS[74, *] = 0.; settlement day
SNS[75, *] = 0.; spawning day (ANNUAL)
SNS[76, *] = 0.; spawning frequency

; Locate mature individuals
Mature = WHERE(SNS[12, *] GT 0., Maturecount, complement = Immature, ncomplement = Immaturecount); 
SNS[77, Mature] = SNS[6, Mature]; age at maturity

;PRINT, 'SNS'
;PRINT, TRANSPOSE(SNS[*, 0L:99L])
PRINT, 'SNSinitial Ends Here'
RETURN, SNS; TURN OFF WHEN TESTING
END