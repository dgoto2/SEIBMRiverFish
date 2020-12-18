FUNCTION SNSinitialYOY, nState, NpopYOY, nSIyoy, nSNS, SNSyao, YOY, TotDriftBio, HydroInput, WQInput, nGridcell
;this function initializes the model for YOY shovelnose sturgeon


PRINT, 'SNSinitialYOY Starts Here'

SNS = FLTARR(nState, nSNS)
SNS[0, YOY] = 0.0; YEAR
SNS[1, YOY] = 0.0; MONTH
SNS[2, YOY] = 0.0; DAY
;FishEnvirHydro[0, *] = YEAR 
;FishEnvirHydro[1, *] = MONTH
;FishEnvirHydro[2, *] = DAY
;FishEnvirHydro[3, *] = DOY

SNS[3, YOY] = SNSyao[3, YOY]; FINDGEN(nSIyoy)+1L; Fish SI ID

; Set the number of individuals in EACH superindividual
; below statement is required to make an even distribution of ages between 0-20
; set the number of individuals within an age category to frequency dist from the lower Platte River
; randomly assign ages 0-7 based on a uniform distribution

SEX = ROUND(RANDOMU(seed, nSIyoy)); randomly assign sex -> 1:1 ratio
SNS[5, YOY] = SEX ; MALE = 0 AND FEMALE = 1


AGE = 0; FLTARR(nSNS)+1L; add 1 to locate YOY individuals
;print, total(age)

;randomNumbers = RANDOMU(seed, nSNS)            
;sortedRandomNumbers = SORT(randomNumbers)     
;YOYLoc = sortedRandomNumbers[0L:nSNS-1L]; randomly assign YOY to superindividuals  
;print, YOYLoc
;print,'#yoyloc',n_elements(yoyloc)

;AGE[YOYLoc] = 0L
;print,'#yoyloc',n_elements(AGE[YOYLoc])
;print,total(AGE[YOYLoc])

;YOY = WHERE(AGE LT 1L, YOYcount, complement = YAO, ncomplement = YAOcount); locate YOY (super)individuals 
;print,'#yoyloc',n_elements(AGE[YOYLoc])
;print,'yoycount',yoycount
;print,'yaocount',yaocount

;AGE[YAO] = RANDOMN(seed, (nSNS-nSIyoy), POISSON=8)>1L; randomly assing age >1 to the rest using a Poisoon distribution
;AGE20plus = WHERE(AGE GT 20., AGE20pluscount, complement = AGE20less, ncomplement = AGE20lesscount); set maximum age = 20
;IF AGE20pluscount GT 0. THEN AGE[AGE20plus] = 20L
;print, (age)
;PRINT, transpose(histogram(age))
SNS[6, YOY] = AGE;

; YOY fractional develpment >>> Post-settlment YOY and YAO = 1
SNS[57, YOY] = 0.; = embryonic development
;SNS[57, YAO] = 1.; 
SNS[58, YOY] = 0.; = yolk-sac larval develpment
;SNS[58, YAO] = 1.; Post-settlment YOY and YAO >= 1

; determine the number of SIs at age and the total number of individuals represented by age
;AgeProp = FLTARR(21)
; The following is based on average values of the lower Platte River field data between 2009 to 2012?
;AgeProp[0] = 1.; YOY is initialized separtely as superindividuals

no_inds = FLTARR(nSNS);                            

;IF YOYcount GT 0. THEN 
no_inds[YOY] = NpopYOY/nSIyoy; initially no YOY until spawning
SNS[4, YOY] = no_inds[YOY];                                
; Age 1 and older should have #individual=1

; Lower Platte River surface area = ~XXXkm2 
; 1 ha = 0.01km2

;LENGTH = FLTARR(nSNS)
;LAG0 = WHERE((AGE EQ 0), LAG0count); YOY begin from the the egg stage
;IF(LAG0count GT 0.) THEN Length[LAG0] = 0.; RANDOMU(seed, LAG0count) * (MAX(3.5) - MIN(3.)) + MIN(3.); diameter of eggs >>> MAY NEED TO BE CHANGED TO 0 TO SKIP OTHER SUBMODELS
; shovelnose sturgeon larvae initial length = XX mm
;length = IntLength + RANDOMN(seed, nSNS) * (0.2/6.6)*IntLength
; random numbers with mean 9.0 and SD 0.2 FOR  from 
SNS[7, YOY] = 0.;Length; in mm
;PRINT, 'SNS[7, *]'
;PRINT, TRANSPOSE(SNS[7, 0L:199L])


LiveIndivYOY = WHERE(SNS[7, YOY] GT 0., LiveIndivYOYcount)

; Assining weight, storage weight, structural weight
opt_rho = FLTARR(nSNS)
IF LiveIndivYOYcount GT 0. THEN SNS[10, YOY[LiveIndivYOY]] = 0.035*0.00001 * (SNS[7, YOY[LiveIndivYOY]])^(2.8403 * 1.1573); structural weight - length-based
IF LiveIndivYOYcount GT 0. THEN opt_rho[YOY[LiveIndivYOY]] = 1.4 * 0.0912 * ALOG10((SNS[7, YOY[LiveIndivYOY]])); + 0.128 * 1.6; optimal rho - length-based
;print, min(opt_rho)


; Don't allow opt_rho to drop below 0.2
CheckRho = WHERE(opt_rho LT 0.2, CheckRhocount)
IF CheckRhocount GT 0 THEN opt_rho[CheckRho] = 0.2
IF LiveIndivYOYcount GT 0. THEN SNS[8, YOY[LiveIndivYOY]] = SNS[10, YOY[LiveIndivYOY]] / (1 - opt_rho[YOY[LiveIndivYOY]]); total weight -> struc weight-based

SNS[12, YOY] = 0.; maturity, 0 or 1, initially randomly assinged to individuals of age >8  
;PRINT, 'SNS[12, *]'
;PRINT, TRANSPOSE(SNS[12, 0L:199L])

SNS[13, YOY] = 0.; gonadal weight

;PRINT, 'SNS[13, *]'
;PRINT, TRANSPOSE(SNS[13, 0L:199L])

SNS[14, YOY] = 0.; 0 or 1, annual reproductive cycle status 
SNS[54, YOY] = 82; = ~March 15th, tExpSpwn 
SNS[55, YOY] = 0.; = ~October 15th, tEndGrwth
SNS[56, YOY] = 0.; J, GonadtEndGrwth, gonad energy content at the end of the growing season

IF LiveIndivYOYcount GT 0. THEN SNS[59, YOY[LiveIndivYOY]] = SNS[13, YOY[LiveIndivYOY]]/SNS[8, YOY[LiveIndivYOY]]; GSI in proportion of total weight

SNS[9, YOY] = SNS[8, YOY] - SNS[10, YOY] - SNS[13, YOY]; storage weight = total wieght - struc weight - gonad weight (for adults)

; Physiological condition
IF LiveIndivYOYcount GT 0. THEN SNS[11, YOY[LiveIndivYOY]] = SNS[9, YOY[LiveIndivYOY]]/(opt_rho[YOY[LiveIndivYOY]]*SNS[8, YOY[LiveIndivYOY]]); KS = STOR/OPT_WT


;***Assigning hatch cell or initial location of fish***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
; Haching occurs in nearshore areas with depth <XX m
Vwater = hydroinput[7, *] / (hydroinput[8, *] * (hydroinput[9, *] + ABS(hydroinput[10, *]*RANDOMN(SEED, nSNS))))
SNShat = WHERE(Vwater[0L : nGridcell-1L] LE 0.2 OR hydroinput[9, 0L : nGridcell-1L] GE 0.5, count); adjust it for discharge&depth-based habitat quality from Peters and Perham (2008)
; cells that can be used as hatching cells for SHOVELNOSE STURGEON
;PRINT, 'Shat', Shat
;PRINT, 'count', count

;HatLoc = FLTARR(nSNS)
HatLoc = ROUND(RANDOMU(seed, nSIyoy) * (count - 1L))
; random number for all SNS SIs ranging from 0-# cells with depths less than XX m
;PRINT, 'HatLoc', HatLoc

SNSenvirhydro = HydroInput[*, SNShat[HatLoc]];
SNSenvirWQ = WQInput[*, *] # REPLICATE(1., nSNS)
;PRINT, 'Senvir', Senvir


; Environment
SNS[15:21, YOY] = SNSenvirhydro[4:10, *]; from Hydrology inputs
; 15-FishEnvirHydro[4, *] = ReachID
; 16-FishEnvirHydro[5, *] = SegmentID
; 17-FishEnvirHydro[6, *] = SegmentID2 => LONGITUDIANL GRID ID#
; 18-FishEnvirHydro[7, *] = DISCHARGE
; 19-FishEnvirHydro[8, *] = width
; 20-FishEnvirHydro[9, *] = Depth
; 21-FishEnvirHydro[10, *] = DepthSE

SNS[24, YOY] = SNSenvirhydro[11, *]; from Hydrology inputs
; 24-FishEnvirHydro[11, *] = TURB; 

SNS[22:23, YOY] = SNSenvirWQ[4:5, YOY]
; 22-FishEnvir[4, *] = TEMP;
; 23-FishEnvir[5, *] = OXYGEN; 
SNS[25, YOY] = SNSenvirWQ[7, YOY]
; 25-FishEnvir[7, *] = DAYLIGHT; 


;***Assining hatch temp***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
HatchTemp = 17.0 * RANDOMU(seed, nSIyoy); ADJUST FOR SHOVEL NOSE STURGEON
CheckHatchTemp = WHERE(HatchTemp LT 11.0, CheckHatchTempcount)
IF (CheckHatchTempcount GT 0) THEN HatchTemp[CheckHatchTemp] = 11.0
SNS[26, YOY] = HatchTemp

; Prey availability
SNS[27, YOY] = TotDriftBio[0, SNShat[HatLoc]]; drift prey1
SNS[28, YOY] = TotDriftBio[1, SNShat[HatLoc]]; drift prey2
SNS[29, YOY] = TotDriftBio[2, SNShat[HatLoc]]; drift prey3
SNS[30, YOY] = TotDriftBio[3, SNShat[HatLoc]]; drift prey4
SNS[31, YOY] = TotDriftBio[4, SNShat[HatLoc]]; drift prey5

; Within-cell proportional coordinates from movements
SNS[32, YOY] = 0.0; total distance (km) moved within each cell in ts ->may be used to estimate movement-based activity cost
SNS[33, YOY] = 0.0; Within-cell coordinate for x or longitudinal direction
;SNS[31, *] = 0.0; Within-cell coordinate for y
;SNS[32, *] = 0.0; Within-cell coordinate for z

;SNS[7, *] = 0.0; holds stomach content weight in g
;SNS[60, *] = 0.0; GUT FULLNESS(%)

; Prey consumption
SNS[34, YOY] = 0.0; Cmax in g
SNS[35, YOY] = 0.0; total amount of prey consumed in g
SNS[36, YOY] = 0.0; total amount of drift prey1 consumed in g
SNS[37, YOY] = 0.0; total amount of drift prey2 consumed in g
SNS[38, YOY] = 0.0; total amount of drift prey3 consumed  in g
SNS[39, YOY] = 0.0; total amount of drift prey4 consumed in g
SNS[40, YOY] = 0.0; total amount of drift prey5 consumed in g

SNS[65, YOY] = 0.0; total # of drift prey1 consumed 
SNS[66, YOY] = 0.0; total # of drift prey2 consumed
SNS[67, YOY] = 0.0; total # of drift prey3 consumed  
SNS[68, YOY] = 0.0; total # of drift prey4 consumed 
SNS[69, YOY] = 0.0; total # of drift prey5 consumed 

; prey ratio
SNS[60, YOY] = 0.0; total amount of drift prey1 consumed in g
SNS[61, YOY] = 0.0; total amount of drift prey2 consumed in g
SNS[62, YOY] = 0.0; total amount of drift prey3 consumed  in g
SNS[63, YOY] = 0.0; total amount of drift prey4 consumed in g
SNS[64, YOY] = 0.0; total amount of drift prey5 consumed in g

; Foraging cost
SNS[41, YOY] = 0.0; SwimCost, J/d

SNS[42, YOY] = 0.0; capture cost for drift prey1, J/d
SNS[43, YOY] = 0.0; capture cost for drift prey2, J/d
SNS[44, YOY] = 0.0; capture cost for drift prey3, J/d
SNS[45, YOY] = 0.0; capture cost for drift prey4, J/d
SNS[46, YOY] = 0.0; capture cost for drift prey5, J/d

; Growth
SNS[47, YOY] = 0.0; daily cumulative growth in length
SNS[48, YOY] = 0.0; daily cumulative growth in weight

; Respiration
SNS[49, YOY] = 0.0; daily respiration rate. J/d

; Fecundity
SNS[50, YOY] = 0.0; the number of eggs

; Acclimation ; >>>>>MAY NOT BE NEEDED FOR A DAILY TIME STEP
;SNS[26, *] = SNS[19, *]; temperature the fish is acclimatized for consumption
;SNS[27, *] = SNS[19, *]; temperature the fish is acclimatized for respiration

;SNS[28, *] = SNS[20, *]; DOa ;DO the fish is acclimatized for consumption
;SNS[29, *] = SNS[20, *]; DOa ;DO the fish is acclimatized for respiration 

; Mortality
SNS[51, YOY] = 0.0; background predation mortality 
SNS[52, YOY] = 0.0; starvation mortality
SNS[53, YOY] = 0.0; fishing mortality


;PRINT, 'SNS'
;PRINT, TRANSPOSE(SNS[*, 0L:99L])
PRINT, 'SNSinitialYOY Ends Here'
RETURN, SNS; TURN OFF WHEN TESTING
END