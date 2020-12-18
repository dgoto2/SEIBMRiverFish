FUNCTION SNSMove1DL, ts, SNS, nSNS, HydroInput, DriftPrey, LonOldLocWithinCell, LiveIndiv2, DaylightHour, SNSGridcellSize
; This function determines movement in the logitudinal direction for shovelnose sturgeon
; LiveIndiv2 includes eggs and yolk-sac larvae
; SNS in this subroutine includes only individuals with LiveIndiv2
;>In this model, sturgeon movement is based on prey density and water velocity only.

PRINT, 'Shovelnose sturgeon 1D Movement Begins Here'
tstart = SYSTIME(/seconds)

; >>>>>>>>>>>>>>>>>>>> NEED TO ADD SPAWNING MIGTRATION BETWEEN MARCH AND JULY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; >>>>>>>>>>>>>>>>>>>> NEED TO ADD POTENTIAL CONNECTIVITY ISSUE BETWEEN REACHES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;*****NEED TO INCORPORATE PREDATOR-BASED HABITAT-QIALITY***********************************
;******NO NEED TO IDENTIFY THE CURRENT CELL AND INCORPORATE 
;******Change * to 0 in row subscripting*********

;*****Identify potential cell IDs in all 6 directions*******************************************

; Lower Platte River, Nebraska
; total length = 159 km
; total # of segments = 162
; length of each segment = 1 km
; longitudianl grid cells 0 - 161 from Columbus to Plattsmouth, NE
;***longitudinal movement is restricted within 3 (3 km maximum) cells in upstream and downstream the current layer***
; average daily movement rate is <800m/d (upstream or downstream) for adult shovelnose sturgeon in the lower Platter River (Peters and Perham 2009)
; Movement rate is highest during the spawning season

; Assign array structure
nNeighborCell = 7L; number of neighboring cells+1
LocLon = FLTARR(nNeighborCell, nSNS)
ImmigProb = FLTARR(nSNS)
EnvironLon = FLTARR(70L, nSNS)
Discharge = FLTARR(nNeighborCell, nSNS); proportional habitat suitability index
Vmax = FLTARR(nSNS); fish maximal sustainable velocity
Connectivity = FLTARR(nNeighborCell, nSNS); proportional connectivity 
;EnvironVDO = FLTARR(7, nSNS)
;EnvironVT = FLTARR(7, nSNS)
;EnvironVL = FLTARR(7, nSNS)
EnvironLonDis = FLTARR(nNeighborCell, nSNS)
m = 5; the number of prey types 
PL = FLTARR(m, nSNS); prey length
PW = FLTARR(m, nSNS); weight of each prey type
dens = FLTARR(m*nNeighborCell, nSNS)  
Calpha = FLTARR(m, nSNS); SNS[7, *] = sturgeon length
TOT = FLTARR(nNeighborCell, nSNS); total number of all prey atacked and captured
t = FLTARR(m*nNeighborCell, nSNS); total number of each prey atacked and captured
preyTOT = FLTARR(nSNS)
preyTOT2 = FLTARR(nNeighborCell, nSNS)
EnvironLonPrey = FLTARR(nNeighborCell, nSNS)
EnvironLonSum = FLTARR(nNeighborCell, nSNS)
LonMove = FLTARR(nSNS)
SS = FLTARR(nSNS)
;S = FLTARR(nSNS)
GSImin = FLTARR(nSNS)
MoveS = FLTARR(nSNS)
LonNewLocWithinCell = FLTARR(nSNS)
LonSize = FLTARR(nSNS)
NewFishEnviron = FLTARR(20, nSNS)

; Parameter values
MinCellLoc = 0L
MaxCellLoc = 161L
p_immig = 0.001;4; 1 - (65.252 * EXP(-EXP(-(HydroInput[7, SNS[17, *]] - ALOG(ALOG(2.)) - 111.03)/63.3)))/100.; emigration probability
PredPreyRatio = 0.2
GSIminFemale = 0.15
GSIminMale =  0.03
MinSpwnTemp = 12.
MaxSpwnTemp = 24.
MinSpwnDaylength = 12.
PropSusV = 0.2
PropSusVSpwn = 0.2
PropYolksacV = 0.9
MaxLarvaL = 43.
Dp = 0.2; proportional vertical location>>>>>>>NEED TO ADJUST<<<<<<<<<<<<<<<<
ActiveHour = 3; h 
PropNetMoveV1 = 0.3
PropNetMoveV2 = 1.;0.8
PropNetMoveVStay = 0.;1


LocLon[0, LiveIndiv2] = SNS[17, *]; current longitudianl grid cell ID

; Probability of emigration
;p_immig = FLTARR(nSNS)
FOR iOut = 0L, nSNS-1L DO ImmigProb[iOut] = RANDOMU(seed, /double); RANDOMN(seed, BINOMIAL = [nSNS, p_pred[iPred]], /double)/nSNS


; DOWNSTREAM MOVEMNT
; current cell -3
Lower3Cells0 = WHERE((SNS[17, *] LE 158L), Lower3Cells0count, complement = NONLower3Cells0, ncomplement = NonLower3Cells0count)
IF Lower3Cells0count GT 0. THEN LocLon[1, LiveIndiv2[Lower3Cells0]] = LocLon[0, LiveIndiv2[Lower3Cells0]]+3L;
IF NonLower3Cells0count GT 0. THEN BEGIN;LocLon[1, NonLower3Cells0] = LocLon[0, NonLower3Cells0];
  ImmigrantLower3 = WHERE((ImmigProb[LiveIndiv2[NonLower3Cells0]] LT p_immig[NonLower3Cells0]), ImmigrantLower3count $
                         , complement = nonImmigrantLower3, ncomplement = nonImmigrantLower3count)
  IF ImmigrantLower3count GT 0. THEN LocLon[1, LiveIndiv2[NonLower3Cells0[ImmigrantLower3]]] = 162
ENDIF
  
; current layer -2
Lower2Cells0 = WHERE((SNS[17, *] LE 159L), Lower2Cells0count, complement = NONLower2Cells0, ncomplement = NonLower2Cells0count)
IF Lower2Cells0count GT 0. THEN LocLon[2, LiveIndiv2[Lower2Cells0]] = LocLon[0, LiveIndiv2[Lower2Cells0]]+2L; 
;IF NonLower2Cells0count GT 0. THEN LocLon[2, NonLower2Cells0] = LocLon[0, NonLower2Cells0];
IF NonLower2Cells0count GT 0. THEN BEGIN;LocLon[2, NonLower2Cells0] = LocLon[0, NonLower2Cells0];
  ImmigrantLower2 = WHERE((ImmigProb[LiveIndiv2[NonLower2Cells0]] LT p_immig[NonLower2Cells0]), ImmigrantLower2count $
                         , complement = nonImmigrantLower2, ncomplement = nonImmigrantLower2count)
  IF ImmigrantLower2count GT 0. THEN LocLon[2, LiveIndiv2[NonLower2Cells0[ImmigrantLower2]]] = 162 
ENDIF

; current layer -1
Lower1Cells0 = WHERE((SNS[17, *] LE 160L), Lower1Cells0count, complement = NONLower1Cells0, ncomplement = NonLower1Cells0count)
IF Lower1Cells0count GT 0. THEN LocLon[3, LiveIndiv2[Lower1Cells0]] = LocLon[0, LiveIndiv2[Lower1Cells0]]+1L; 
;IF NonLower1Cells0count GT 0. THEN LocLon[3, LiveIndiv2[NonLower1Cells0]] = LocLon[0, LiveIndiv2[NonLower1Cells0]];
IF NonLower1Cells0count GT 0. THEN BEGIN;LocLon[3, NonLower1Cells0] = LocLon[0, NonLower1Cells0];
  ImmigrantLower1 = WHERE((ImmigProb[LiveIndiv2[NonLower1Cells0]] LT p_immig[NonLower1Cells0]), ImmigrantLower1count $
                         , complement = nonImmigrantLower1, ncomplement = nonImmigrantLower1count)
  IF ImmigrantLower1count GT 0. THEN LocLon[3, LiveIndiv2[NonLower1Cells0[ImmigrantLower1]]] = 162 
ENDIF

; UPSTREAM MOVEMENT
; current layer +1
Upper1Cells0 = WHERE((SNS[17, *] GE 1L), Upper1Cells0count, complement = NONUpper1Cells0, ncomplement = NonUpper1Cells0count)
IF Upper1Cells0count GT 0. THEN LocLon[4, LiveIndiv2[Upper1Cells0]] = LocLon[0, LiveIndiv2[Upper1Cells0]]-1L;
;IF NonUpper1Cells0count GT 0. THEN LocLon[4, LiveIndiv2[NonUpper1Cells0]] = LocLon[0, LiveIndiv2[NonUpper1Cells0]];
IF NonUpper1Cells0count GT 0. THEN BEGIN;LocLon[4, LiveIndiv2[NonUpper1Cells0]] = LocLon[0, LiveIndiv2[NonUpper1Cells0]];
  ImmigrantUpper1 = WHERE((ImmigProb[LiveIndiv2[NonUpper1Cells0]] LT p_immig[NonUpper1Cells0]), ImmigrantUpper1count $
                         , complement = nonImmigrantUpper1, ncomplement = nonImmigrantUpper1count)
  IF ImmigrantUpper1count GT 0. THEN LocLon[4, LiveIndiv2[NonUpper1Cells0[ImmigrantUpper1]]] = 163 
ENDIF

; current layer +2
Upper2Cells0 = WHERE((SNS[17, *] GE 2L), Upper2Cells0count, complement = NONUpper2Cells0, ncomplement = NonUpper2Cells0count)
IF Upper2Cells0count GT 0. THEN LocLon[5, LiveIndiv2[Upper2Cells0]] = LocLon[0, LiveIndiv2[Upper2Cells0]]-2L;
;IF NonUpper2Cells0count GT 0. THEN LocLon[5, LiveIndiv2[NonUpper2Cells0]] = LocLon[0, LiveIndiv2[NonUpper2Cells0]];
IF NonUpper2Cells0count GT 0. THEN BEGIN;LocLon[5, LiveIndiv2[NonUpper1Cells0]] = LocLon[0, LiveIndiv2[NonUpper1Cells0]];
  ImmigrantUpper2 = WHERE((ImmigProb[LiveIndiv2[NonUpper2Cells0]] LT p_immig[NonUpper2Cells0]), ImmigrantUpper2count $
                         , complement = nonImmigrantUpper2, ncomplement = nonImmigrantUpper2count)
  IF ImmigrantUpper2count GT 0. THEN LocLon[5, LiveIndiv2[NonUpper2Cells0[ImmigrantUpper2]]] = 163 
ENDIF

; current layer +3
Upper3Cells0 = WHERE((SNS[17, *] GE 3L), Upper3Cells0count, complement = NONUpper3Cells0, ncomplement = NonUpper3Cells0count)
IF Upper3Cells0count GT 0. THEN LocLon[6, LiveIndiv2[Upper3Cells0]] = LocLon[0, LiveIndiv2[Upper3Cells0]]-3L;
;IF NonUpper3Cells0count GT 0. THEN LocLon[6, LiveIndiv2[NonUpper3Cells0]] = LocLon[0, LiveIndiv2[NonUpper3Cells0]];
IF NonUpper3Cells0count GT 0. THEN BEGIN;LocLon[6, LiveIndiv2[NonUpper1Cells0]] = LocLon[0, LiveIndiv2[NonUpper1Cells0]];
  ImmigrantUpper3 = WHERE((ImmigProb[LiveIndiv2[NonUpper3Cells0]] LT p_immig[NonUpper3Cells0]), ImmigrantUpper3count $
                         , complement = nonImmigrantUpper3, ncomplement = nonImmigrantUpper3count)
  IF ImmigrantUpper3count GT 0. THEN LocLon[6, LiveIndiv2[NonUpper3Cells0[ImmigrantUpper3]]] = 163 
ENDIF


;****Determine habitat quality of neibouring cells***************************************************************
; Hydrology inputs
;FishEnvirHydro[0, *] = YEAR 
;FishEnvirHydro[1, *] = MONTH
;FishEnvirHydro[2, *] = DAY
;FishEnvirHydro[3, *] = DOY
;FishEnvirHydro[4, *] = ReachID
;FishEnvirHydro[5, *] = SegmentID
;FishEnvirHydro[6, *] = SegmentID2

;FishEnvirHydro[7, *] = DISCHARGE
;FishEnvirHydro[8, *] = width
;FishEnvirHydro[9, *] = Depth
;FishEnvirHydro[10, *] = DepthSE

; Water quality inputs (no spatial resolution)
;FishEnvir[0, *] = YEAR;
;FishEnvir[1, *] = MONTH;
;FishEnvir[2, *] = DAY;
;FishEnvir[3, *] = DOY;

;FishEnvir[4, *] = TEMP;
;FishEnvir[5, *] = OXYGEN; 
;FishEnvir[6, *] = TURB; 
;FishEnvir[7, *] = DAYLIGHT; 
;GridCellHorSize =  1. * RiverWidth; 15500. * 1000000. * .5 / 10.; 1550km2 FOR FISH ARRAY = 1/10 OF LE CENTRAL BASIN

; Environmental conditions in (0) = the current cell
EnvironLon[0:3, LiveIndiv2] = HydroInput[7:10, LocLon[0, LiveIndiv2]];
EnvironLon[5:9, LiveIndiv2] = DriftPrey[0:4, LocLon[0, LiveIndiv2]]; drift biomass
;EnvironLon[, LiveIndiv2] = FISHPREY[5, LocLon[0, LiveIndiv2]] / GridCellHorSize; BIOMASS

; Environmental conditions for potential longitudinal movement
;LocLon# for longitudinal movement = 1, 2, 3, 4, 5, 6
; -3
EnvironLon[11:14, LiveIndiv2] = HydroInput[7:10, LocLon[1, LiveIndiv2]]; 9 parameters
EnvironLon[15:19, LiveIndiv2] = DriftPrey[0:4, LocLon[1, LiveIndiv2]] ; drift biomass
; -2
EnvironLon[21:24, LiveIndiv2] = HydroInput[7:10, LocLon[2, LiveIndiv2]];
EnvironLon[25:29, LiveIndiv2] = DriftPrey[0:4, LocLon[2, LiveIndiv2]]; drift biomass
; -1
EnvironLon[31:34, LiveIndiv2] = HydroInput[7:10, LocLon[3, LiveIndiv2]];
EnvironLon[35:39, LiveIndiv2] = DriftPrey[0:4, LocLon[3, LiveIndiv2]]; drift biomass

; +1
EnvironLon[41:44, LiveIndiv2] = HydroInput[7:10, LocLon[4, LiveIndiv2]];
EnvironLon[45:49, LiveIndiv2] = DriftPrey[0:4, LocLon[4, LiveIndiv2]]; drift biomass
; +2
EnvironLon[51:54, LiveIndiv2] = HydroInput[7:10, LocLon[5, LiveIndiv2]];
EnvironLon[55:59, LiveIndiv2] = DriftPrey[0:4, LocLon[5, LiveIndiv2]]; drift biomass
; +3
EnvironLon[61:64, LiveIndiv2] = HydroInput[7:10, LocLon[6, LiveIndiv2]];
EnvironLon[65:69, LiveIndiv2] = DriftPrey[0:4, LocLon[6, LiveIndiv2]]; drift biomass

;LiveIndiv = WHERE((SNS[7, *] GT 0.), LiveIndivcount) 

;;***Assess habitat quality of neibouring cells**********************************************************************
;DOf1 = FLTARR(7, nSNS)
;DOf2 = FLTARR(7, nSNS)
;DOf3 = FLTARR(7, nSNS)
;DOf = FLTARR(7, nSNS)
;Tf = FLTARR(7, nSNS)
;; DO***************************************************************************************************************
;DOacclim = SNSacclDO(SNS[29, *], SNS[28, *], SNS[20, *], SNS[27, *], SNS[26, *], SNS[19, *], ts, SNS[1, *], SNS[2, *], nSNS, SNS[63, *])
;;PRINT, 'DOacclim[7, *]'
;;PRINT, TRANSPOSE(DOacclim[7, 0:100])
;;PRINT, 'DOacclim[5, *]'
;;PRINT, TRANSPOSE(DOacclim[5, 0:100])
;
;; for movement, the critical DO level is 2x (2.5x for the minimum level) the critical level for physiological processes
;DOf0a = EnvironV[7, *] - 4.5*DOacclim[7, *]
;DOf1a = EnvironV[22, *] - 4.5*DOacclim[7, *]
;DOf2a = EnvironV[37, *] - 4.5*DOacclim[7, *]
;DOf3a = EnvironV[52, *] - 4.5*DOacclim[7, *]
;DOf4a = EnvironV[67, *] - 4.5*DOacclim[7, *]
;DOf5a = EnvironV[82, *] - 4.5*DOacclim[7, *]
;DOf6a = EnvironV[97, *] - 4.5*DOacclim[7, *]
;
;DOf0b = EnvironV[7, *] - 4.*DOacclim[5, *]
;DOf1b = EnvironV[22, *] - 4.*DOacclim[5, *]
;DOf2b = EnvironV[37, *] - 4.*DOacclim[5, *]
;DOf3b = EnvironV[52, *] - 4.*DOacclim[5, *]
;DOf4b = EnvironV[67, *] - 4.*DOacclim[5, *]
;DOf5b = EnvironV[82, *] - 4.*DOacclim[5, *]
;DOf6b = EnvironV[97, *] - 4.*DOacclim[5, *]
;
;; When ambient DO is below the mimimum critical DO...
;DOf10 = WHERE(DOf0a LT 0., DOf1count0)
;DOf11 = WHERE(DOf1a LT 0., DOf1count1)
;DOf12 = WHERE(DOf2a LT 0., DOf1count2)
;DOf13 = WHERE(DOf3a LT 0., DOf1count3)
;DOf14 = WHERE(DOf4a LT 0., DOf1count4)
;DOf15 = WHERE(DOf5a LT 0., DOf1count5)
;DOf16 = WHERE(DOf6a LT 0., DOf1count6)
;IF DOf1count0 GT 0.0 THEN DOf[0, DOf10] = 0.0; 
;IF DOf1count1 GT 0.0 THEN DOf[1, DOf11] = 0.0; 
;IF DOf1count2 GT 0.0 THEN DOf[2, DOf12] = 0.0; 
;IF DOf1count3 GT 0.0 THEN DOf[3, DOf13] = 0.0; 
;IF DOf1count4 GT 0.0 THEN DOf[4, DOf14] = 0.0; 
;IF DOf1count5 GT 0.0 THEN DOf[5, DOf15] = 0.0; 
;IF DOf1count6 GT 0.0 THEN DOf[6, DOf16] = 0.0; 
;
;; When ambient DO is between the minimum critical DO and the critical DO...
;DOf20 = WHERE(((DOf0a GE 0.) AND (DOf0b LE 0.)), DOf2count0)
;DOf21 = WHERE(((DOf1a GE 0.) AND (DOf1b LE 0.)), DOf2count1)  
;DOf22 = WHERE(((DOf2a GE 0.) AND (DOf2b LE 0.)), DOf2count2)
;DOf23 = WHERE(((DOf3a GE 0.) AND (DOf3b LE 0.)), DOf2count3)
;DOf24 = WHERE(((DOf4a GE 0.) AND (DOf4b LE 0.)), DOf2count4)
;DOf25 = WHERE(((DOf5a GE 0.) AND (DOf5b LE 0.)), DOf2count5)
;DOf26 = WHERE(((DOf6a GE 0.) AND (DOf6b LE 0.)), DOf2count6)
;IF DOf2count0 GT 0.0 THEN DOf[0, DOf20] = ((EnvironV[7, DOf20] - 4.5*DOacclim[7, DOf20])/(4.*DOacclim[5, DOf20] - 4.5*DOacclim[7, DOf20]))
;IF DOf2count1 GT 0.0 THEN DOf[1, DOf21] = ((EnvironV[22, DOf21] - 4.5*DOacclim[7, DOf21])/(4.*DOacclim[5, DOf21] - 4.5*DOacclim[7, DOf21]))
;IF DOf2count2 GT 0.0 THEN DOf[2, DOf22] = ((EnvironV[37, DOf22] - 4.5*DOacclim[7, DOf22])/(4.*DOacclim[5, DOf22] - 4.5*DOacclim[7, DOf22]))
;IF DOf2count3 GT 0.0 THEN DOf[3, DOf23] = ((EnvironV[52, DOf23] - 4.5*DOacclim[7, DOf23])/(4.*DOacclim[5, DOf23] - 4.5*DOacclim[7, DOf23]))
;IF DOf2count4 GT 0.0 THEN DOf[4, DOf24] = ((EnvironV[67, DOf24] - 4.5*DOacclim[7, DOf24])/(4.*DOacclim[5, DOf24] - 4.5*DOacclim[7, DOf24]))
;IF DOf2count5 GT 0.0 THEN DOf[5, DOf25] = ((EnvironV[82, DOf25] - 4.5*DOacclim[7, DOf25])/(4.*DOacclim[5, DOf25] - 4.5*DOacclim[7, DOf25]))
;IF DOf2count6 GT 0.0 THEN DOf[6, DOf26] = ((EnvironV[97, DOf26] - 4.5*DOacclim[7, DOf26])/(4.*DOacclim[5, DOf26] - 4.5*DOacclim[7, DOf26]))
;
;; When ambient DO is ABOVE the critical DO...
;DOf30 = WHERE((DOf0b GT 0.), DOf3count0)
;DOf31 = WHERE((DOf1b GT 0.), DOf3count1)
;DOf32 = WHERE((DOf2b GT 0.), DOf3count2)
;DOf33 = WHERE((DOf3b GT 0.), DOf3count3)
;DOf34 = WHERE((DOf4b GT 0.), DOf3count4)
;DOf35 = WHERE((DOf5b GT 0.), DOf3count5)
;DOf36 = WHERE((DOf6b GT 0.), DOf3count6)
;IF DOf3count0 GT 0.0 THEN DOf[0, DOf30] = 1.0
;IF DOf3count1 GT 0.0 THEN DOf[1, DOf31] = 1.0
;IF DOf3count2 GT 0.0 THEN DOf[2, DOf32] = 1.0
;IF DOf3count3 GT 0.0 THEN DOf[3, DOf33] = 1.0
;IF DOf3count4 GT 0.0 THEN DOf[4, DOf34] = 1.0
;IF DOf3count5 GT 0.0 THEN DOf[5, DOf35] = 1.0
;IF DOf3count6 GT 0.0 THEN DOf[6, DOf36] = 1.0
;;PRINT, 'DOf'
;;PRINT, DOf[*, *]
;;*************************************************************************************************************************

;; Temperature**************************************************************************************************************
;CA = FLTARR(nSNS)
;CB = FLTARR(nSNS)
;CQ = FLTARR(nSNS)
;CTM = FLTARR(nSNS)
;CTO = FLTARR(nSNS)
;
;; values are for larvae
;TL = WHERE(SNS[1, *] LE 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
;IF (TLcount GT 0.0) THEN BEGIN
;  CA[TL] = 0.45
;  CB[TL] = -0.27
;  CQ[TL] = 2.3
;  CTM[TL] = 28.0
;  CTO[TL] = 25.0
;ENDIF
;; values are for juveniles and adults 
;IF (TLLcount GT 0.0) THEN BEGIN 
;  CA[TLL] = 0.25
;  CB[TLL] = -0.27
;  CQ[TLL] = 2.3
;  CTM[TLL] = 28.0
;  CTO[TLL] = 22.0
;ENDIF
;
;V_C0 = (CTM - EnvironV[6, *]) / (CTM - CTO)
;V_C1 = (CTM - EnvironV[21, *]) / (CTM - CTO)
;V_C2 = (CTM - EnvironV[36, *]) / (CTM - CTO)
;V_C3 = (CTM - EnvironV[51, *]) / (CTM - CTO)
;V_C4 = (CTM - EnvironV[66, *]) / (CTM - CTO)
;V_C5 = (CTM - EnvironV[81, *]) / (CTM - CTO)
;V_C6 = (CTM - EnvironV[96, *]) / (CTM - CTO)
;
;Z_C = ALOG(CQ) * (CTM - CTO)
;Y_C = ALOG(CQ) * (CTM - CTO + 2.0)
;X_C = (Z_C^2.0 * ((1.0 + (1.0 + 40.0 / Y_C)^0.5)^2.0)) / 400.0
;
;Tf[0, *] = V_C0^X_C * EXP(X_C * (1.0 - V_C0))
;Tf[1, *] = V_C1^X_C * EXP(X_C * (1.0 - V_C1))
;Tf[2, *] = V_C2^X_C * EXP(X_C * (1.0 - V_C2))
;Tf[3, *] = V_C3^X_C * EXP(X_C * (1.0 - V_C3))
;Tf[4, *] = V_C4^X_C * EXP(X_C * (1.0 - V_C4))
;Tf[5, *] = V_C5^X_C * EXP(X_C * (1.0 - V_C5))
;Tf[6, *] = V_C6^X_C * EXP(X_C * (1.0 - V_C6))
;;PRINT, 'Tf'
;;PRINT, Tf
;;***********************************************************************************************************************

; Discharge based habitat suitability 
; >>>> HSI = (65.252*EXP(-EXP(-(DISCHARGE-LN(LN(2))-111.03)/63.3)))
; proportional habitat suitability index
Discharge[0, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[0, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252; 100.
Discharge[1, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[11, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252;100.
Discharge[2, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[21, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252;100.
Discharge[3, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[31, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252;100.
Discharge[4, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[41, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252;100.
Discharge[5, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[51, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252;100.
Discharge[6, LiveIndiv2] = (65.252 * EXP(-EXP(-(EnvironLon[61, LiveIndiv2] - ALOG(ALOG(2.)) - 111.03)/63.3)))/65.252;100.
;PRINT, 'DISCHARGE RATE'
;;EnvironLon[0, 0:100] 
;;EnvironLon[11, 0:100]
;;EnvironLon[21, 0:100]
;PRINT, TRANSPOSE(EnvironLon[31, 0:100])
;PRINT, TRANSPOSE(EnvironLon[41, 0:100])
;;EnvironLon[51, 0:100] 
;;EnvironLon[61, 0:100] 


LengthGT225 = WHERE(SNS[7, *] GT 225., LengthGT225count, complement = LengthLE225, ncomplement = LengthLE225count)
; Individuals <225mm
IF LengthLE225count GT 0. THEN Vmax[LiveIndiv2[LengthLE225]] =  4.8 * 0.0031 * 13.86 * (((30.5 - SNS[22, LengthLE225])/3.92)^0.23) $
                               * EXP(0.24 *(1 - ((30.5 - SNS[22, LengthLE225])/3.52))) * (SNS[7, LengthLE225]/10.)^0.26;
; Individuals >=225mm, derived from white sturgeon study by 
IF LengthGT225count GT 0. THEN Vmax[LiveIndiv2[LengthGT225]] = 2 * (25.512 + (0.214 * SNS[7, LengthGT225]/10.) $
                               - (0.762 * SNS[22, LengthGT225]) + (0.0342 * SNS[22, LengthGT225] * SNS[7, LengthGT225]/10.))/100.
;Vwater = Discharge / (Width * (Depth + ABS(DepthSE*RANDOMN(SEED, nSNS))))
;Vwater *0.919 * (Dp1/depth)^0.23
;Dp = 0.2; bottom velocity
;DepthVel = 0.4031 + 0.1176; dpeth-specific water velocity

;ExtDis0 = WHERE((EnvironLon[0, LiveIndiv2] / (EnvironLon[1, LiveIndiv2] * (EnvironLon[2, LiveIndiv2] + ABS(EnvironLon[3, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[2, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis0count)
;ExtDis1 = WHERE((EnvironLon[11, LiveIndiv2] / (EnvironLon[12, LiveIndiv2] * (EnvironLon[13, LiveIndiv2] + ABS(EnvironLon[14, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[13, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis1count)
;ExtDis2 = WHERE((EnvironLon[21, LiveIndiv2] / (EnvironLon[22, LiveIndiv2] * (EnvironLon[23, LiveIndiv2] + ABS(EnvironLon[24, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[23, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis2count)
;ExtDis3 = WHERE((EnvironLon[31, LiveIndiv2] / (EnvironLon[32, LiveIndiv2] * (EnvironLon[33, LiveIndiv2] + ABS(EnvironLon[34, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[33, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis3count)
;ExtDis4 = WHERE((EnvironLon[41, LiveIndiv2] / (EnvironLon[42, LiveIndiv2] * (EnvironLon[43, LiveIndiv2] + ABS(EnvironLon[44, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[43, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis4count)
;ExtDis5 = WHERE((EnvironLon[51, LiveIndiv2] / (EnvironLon[52, LiveIndiv2] * (EnvironLon[53, LiveIndiv2] + ABS(EnvironLon[54, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[53, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis5count)
;ExtDis6 = WHERE((EnvironLon[61, LiveIndiv2] / (EnvironLon[62, LiveIndiv2] * (EnvironLon[63, LiveIndiv2] + ABS(EnvironLon[64, LiveIndiv2] $
;               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.919 * (Dp/EnvironLon[63, LiveIndiv2])^0.23 GT Vmax[LiveIndiv2], ExtDis6count)

ExtDis0 = WHERE((EnvironLon[0, LiveIndiv2] / (EnvironLon[1, LiveIndiv2] * (EnvironLon[2, LiveIndiv2] + ABS(EnvironLon[3, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis0count)
ExtDis1 = WHERE((EnvironLon[11, LiveIndiv2] / (EnvironLon[12, LiveIndiv2] * (EnvironLon[13, LiveIndiv2] + ABS(EnvironLon[14, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis1count)
ExtDis2 = WHERE((EnvironLon[21, LiveIndiv2] / (EnvironLon[22, LiveIndiv2] * (EnvironLon[23, LiveIndiv2] + ABS(EnvironLon[24, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis2count)
ExtDis3 = WHERE((EnvironLon[31, LiveIndiv2] / (EnvironLon[32, LiveIndiv2] * (EnvironLon[33, LiveIndiv2] + ABS(EnvironLon[34, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis3count)
ExtDis4 = WHERE((EnvironLon[41, LiveIndiv2] / (EnvironLon[42, LiveIndiv2] * (EnvironLon[43, LiveIndiv2] + ABS(EnvironLon[44, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis4count)
ExtDis5 = WHERE((EnvironLon[51, LiveIndiv2] / (EnvironLon[52, LiveIndiv2] * (EnvironLon[53, LiveIndiv2] + ABS(EnvironLon[54, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis5count)
ExtDis6 = WHERE((EnvironLon[61, LiveIndiv2] / (EnvironLon[62, LiveIndiv2] * (EnvironLon[63, LiveIndiv2] + ABS(EnvironLon[64, LiveIndiv2] $
               * RANDOMN(SEED, N_ELEMENTS(LiveIndiv2)))))) * 0.4031 + 0.1176 GT Vmax[LiveIndiv2], ExtDis6count)

;PRINT, 'Current (ExtDis0#)', N_ELEMENTS(ExtDis0)
;PRINT, 'Down-3 (ExtDis1#)', N_ELEMENTS(ExtDis1), '   Down-2 (ExtDis2#)', N_ELEMENTS(ExtDis2), '   Down-1 (ExtDis3#)', N_ELEMENTS(ExtDis3)
;PRINT, 'Up+1 (ExtDis4#)', N_ELEMENTS(ExtDis4), '   Up+2 (ExtDis5#)', N_ELEMENTS(ExtDis5), '   Up+3 (ExtDis6#)', N_ELEMENTS(ExtDis6)
IF ExtDis0count GT 0. THEN Discharge[0, LiveIndiv2[ExtDis0]] = 0.
IF ExtDis1count GT 0. THEN Discharge[1, LiveIndiv2[ExtDis1]] = 0.
IF ExtDis2count GT 0. THEN Discharge[2, LiveIndiv2[ExtDis2]] = 0.
IF ExtDis3count GT 0. THEN Discharge[3, LiveIndiv2[ExtDis3]] = 0.
IF ExtDis4count GT 0. THEN Discharge[4, LiveIndiv2[ExtDis4]] = 0.
IF ExtDis5count GT 0. THEN Discharge[5, LiveIndiv2[ExtDis5]] = 0.
IF ExtDis6count GT 0. THEN Discharge[6, LiveIndiv2[ExtDis6]] = 0.


; Connectivity based on dishcarge (Peters and Perham 2008)
; proportional connectivity - 100.083/(1+EXP(-(EnvironLon[0, LiveIndiv2]-123.107)/38.099))/100.083
Connectivity[0, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[0, LiveIndiv2] - 123.107) / 38.099)) /100.083
Connectivity[1, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[11, LiveIndiv2] - 123.107) / 38.099)) /100.083
Connectivity[2, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[21, LiveIndiv2] - 123.107) / 38.099)) /100.083
Connectivity[3, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[31, LiveIndiv2] - 123.107) / 38.099)) /100.083
Connectivity[4, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[41, LiveIndiv2] - 123.107) / 38.099)) /100.083
Connectivity[5, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[51, LiveIndiv2] - 123.107) / 38.099)) /100.083
Connectivity[6, LiveIndiv2] = 100.083 / (1 + EXP(-(EnvironLon[61, LiveIndiv2] -123.107) / 38.099)) /100.083
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[0, LiveIndiv2]), '   MAX', MAX(Connectivity[0, LiveIndiv2]), '   MIN', MIN(Connectivity[0, LiveIndiv2])
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[1, LiveIndiv2]), '   MAX', MAX(Connectivity[1, LiveIndiv2]), '   MIN', MIN(Connectivity[1, LiveIndiv2])
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[2, LiveIndiv2]), '   MAX', MAX(Connectivity[2, LiveIndiv2]), '   MIN', MIN(Connectivity[2, LiveIndiv2])
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[3, LiveIndiv2]), '   MAX', MAX(Connectivity[3, LiveIndiv2]), '   MIN', MIN(Connectivity[3, LiveIndiv2])
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[4, LiveIndiv2]), '   MAX', MAX(Connectivity[4, LiveIndiv2]), '   MIN', MIN(Connectivity[4, LiveIndiv2])
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[5, LiveIndiv2]), '   MAX', MAX(Connectivity[5, LiveIndiv2]), '   MIN', MIN(Connectivity[5, LiveIndiv2])
;PRINT, 'Connectivity: MEAN', MEAN(Connectivity[6, LiveIndiv2]), '   MAX', MAX(Connectivity[6, LiveIndiv2]), '   MIN', MIN(Connectivity[6, LiveIndiv2])

 
; Incorporate a random component to habitat quality index
;EnvironVDO[0, *] = DOUBLE(DOf[0, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVDO[2, *] = DOUBLE(DOf[2, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVDO[5, *] = DOUBLE(DOf[5, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nSNS, /DOUBLE))
;;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component
;
;EnvironVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nSNS, /DOUBLE))
;;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component
;
;EnvironVL[0, *] = DOUBLE(litfac[0, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVL[1, *] = DOUBLE(litfac[1, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVL[2, *] = DOUBLE(litfac[2, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVL[3, *] = DOUBLE(litfac[3, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVL[4, *] = DOUBLE(litfac[4, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVL[5, *] = DOUBLE(litfac[5, *] * RANDOMU(seed, nSNS, /DOUBLE))
;EnvironVL[6, *] = DOUBLE(litfac[6, *] * RANDOMU(seed, nSNS, /DOUBLE))
;PRINT, 'EnvironVDO'
;PRINT, EnvironVDO[*, 0:100]
;PRINT, 'EnvironVT'
;PRINT, EnvironVT[*, 0:100]

EnvironLonDis[0, LiveIndiv2] = DOUBLE(Discharge[0, LiveIndiv2] * Connectivity[0, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
EnvironLonDis[1, LiveIndiv2] = DOUBLE(Discharge[1, LiveIndiv2] * Connectivity[1, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
EnvironLonDis[2, LiveIndiv2] = DOUBLE(Discharge[2, LiveIndiv2] * Connectivity[2, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
EnvironLonDis[3, LiveIndiv2] = DOUBLE(Discharge[3, LiveIndiv2] * Connectivity[3, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
EnvironLonDis[4, LiveIndiv2] = DOUBLE(Discharge[4, LiveIndiv2] * Connectivity[4, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
EnvironLonDis[5, LiveIndiv2] = DOUBLE(Discharge[5, LiveIndiv2] * Connectivity[5, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
EnvironLonDis[6, LiveIndiv2] = DOUBLE(Discharge[6, LiveIndiv2] * Connectivity[6, LiveIndiv2] * RANDOMU(seed, N_ELEMENTS(LiveIndiv2), /DOUBLE))
;PRINT, 'EnvironLonDis'
;PRINT, EnvironLonDis[*, 0:100]


; Determine prey fields*****************************************************************************************************
PL[0, *] = RANDOMU(seed, nSNS)*(MAX(3.) - MIN(1.)) + MIN(1.); length for benthic insects(chironmoidae) size class 1
PL[1, *] = RANDOMU(seed, nSNS)*(MAX(5.) - MIN(3.)) + MIN(3.); length for benthic insects(chironmoidae) size class 2
PL[2, *] = RANDOMU(seed, nSNS)*(MAX(7.) - MIN(5.)) + MIN(5.); length for benthic insects(chironmoidae) size class 3
PL[3, *] = RANDOMU(seed, nSNS)*(MAX(9.) - MIN(7.)) + MIN(7.); length for benthic insects(chironmoidae) size class 4
PL[4, *] = RANDOMU(seed, nSNS)*(MAX(11.) - MIN(9.)) + MIN(9.); length for benthic insects(chironmoidae) size class 5

; prey weight
; assign weights to each prey type in g
PW[0, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.12 / 1000.); chironomids in g from Nalepa for 2005 Lake Erie data
PW[1, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.12 / 1000.)
PW[2, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.12 / 1000.)
PW[3, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.12 / 1000.)
PW[4, *] = DOUBLE(0.0013*(PL[3, *]^2.69) / 0.12 / 1000.)

; Convert prey biomass (g/m^2) into numbers/ m^2
; drift prey size class 1
dens[0,*] = EnvironLon[5, *] / Pw[0, *]
dens[1,*] = EnvironLon[15, *] / Pw[0, *]
dens[2,*] = EnvironLon[25, *] / Pw[0, *]
dens[3,*] = EnvironLon[35, *] / Pw[0, *]
dens[4,*] = EnvironLon[45, *] / Pw[0, *]
dens[5,*] = EnvironLon[55, *] / Pw[0, *]
dens[6,*] = EnvironLon[65, *] / Pw[0, *]

; drift prey size class 2
dens[7,*] = EnvironLon[6, *] / Pw[1, *]
dens[8,*] = EnvironLon[16, *] / Pw[1, *]
dens[9,*] = EnvironLon[26, *] / Pw[1, *]
dens[10,*] = EnvironLon[36, *] / Pw[1, *]
dens[11,*] = EnvironLon[46, *] / Pw[1, *]
dens[12,*] = EnvironLon[56, *] / Pw[1, *]
dens[13,*] = EnvironLon[66, *] / Pw[1, *]

; drift prey size class 3
dens[14,*] = EnvironLon[7, *] / Pw[2, *]
dens[15,*] = EnvironLon[17, *] / Pw[2, *]
dens[16,*] = EnvironLon[27, *] / Pw[2, *]
dens[17,*] = EnvironLon[37, *] / Pw[2, *]
dens[18,*] = EnvironLon[47, *] / Pw[2, *]
dens[19,*] = EnvironLon[57, *] / Pw[2, *]
dens[20,*] = EnvironLon[67, *] / Pw[2, *]

; drift prey size class 4 (chironomids)
dens[21, *] = EnvironLon[8, *] / Pw[3, *] 
dens[22, *] = EnvironLon[18, *] / Pw[3, *] 
dens[23, *] = EnvironLon[28, *] / Pw[3, *] 
dens[24, *] = EnvironLon[38, *] / Pw[3, *] 
dens[25, *] = EnvironLon[48, *] / Pw[3, *] 
dens[26, *] = EnvironLon[58, *] / Pw[3, *] 
dens[27, *] = EnvironLon[68, *] / Pw[3, *] 

; drift prey size class 5 (chironmoids)
dens[28, *] = EnvironLon[9, *] / Pw[4, *] 
dens[29, *] = EnvironLon[19, *] / Pw[4, *] 
dens[30, *] = EnvironLon[29, *] / Pw[4, *] 
dens[31, *] = EnvironLon[39, *] / Pw[4, *] 
dens[32, *] = EnvironLon[49, *] / Pw[4, *] 
dens[33, *] = EnvironLon[59, *] / Pw[4, *] 
dens[34, *] = EnvironLon[69, *] / Pw[4, *] 


; Calculate Chesson's alpha for each prey type
LiveIndiv = WHERE((SNS[7, *] GT 0.) AND (SNS[4, *] GT 0.), LiveIndivcount, complement = DeadIndiv, ncomplement = DeadIndivcount)
IF LiveIndivcount GT 0. THEN BEGIN
PL0 = WHERE((PL[0, LiveIndiv2[LiveIndiv]] / SNS[7, LiveIndiv]) LE PredPreyRatio, pl0count, complement = pl0c, ncomplement = pl0ccount)
IF (pl0count GT 0.0) THEN Calpha[0, LiveIndiv2[LiveIndiv[PL0]]] = ABS(1. - 1.75 * (PL[0, LiveIndiv2[LiveIndiv[PL0]]] / SNS[7, LiveIndiv[PL0]]))
IF (pl0ccount GT 0.0) THEN Calpha[0, LiveIndiv2[LiveIndiv[PL0c]]] = 0. ;for benthic prey for flounder by Rose et al. 1996 

PL1 = WHERE((PL[1, LiveIndiv2[LiveIndiv]] / SNS[7, LiveIndiv]) LE PredPreyRatio, pl1count, complement = pl1c, ncomplement = pl1ccount)
IF (pl1count GT 0.0) THEN Calpha[1, LiveIndiv2[LiveIndiv[PL1]]] = ABS(1. - 1.75 * (PL[1, LiveIndiv2[LiveIndiv[PL1]]] / SNS[7, LiveIndiv[PL1]]))
IF (pl1ccount GT 0.0) THEN Calpha[1, LiveIndiv2[LiveIndiv[PL1c]]] = 0. ;for benthic prey for flounder by Rose et al. 1996 

PL2 = WHERE((PL[2, LiveIndiv2[LiveIndiv]] / SNS[7, LiveIndiv]) LE PredPreyRatio, pl2count, complement = pl2c, ncomplement = pl2ccount)
IF (pl2count GT 0.0) THEN Calpha[2, LiveIndiv2[LiveIndiv[PL2]]] = ABS(1. - 1.75 * (PL[2, LiveIndiv2[LiveIndiv[PL2]]] / SNS[7, LiveIndiv[PL2]]))
IF (pl2ccount GT 0.0) THEN Calpha[2, LiveIndiv2[LiveIndiv[PL2c]]] = 0. ;for benthic prey for flounder by Rose et al. 1996 

PL3 = WHERE((PL[3, LiveIndiv2[LiveIndiv]] / SNS[7, LiveIndiv]) LE PredPreyRatio, pl3count, complement = pl3c, ncomplement = pl3ccount)
IF (pl3count GT 0.0) THEN Calpha[3, LiveIndiv2[LiveIndiv[PL3]]] = ABS(1. - 1.75 * (PL[3, LiveIndiv2[LiveIndiv[PL3]]] / SNS[7, LiveIndiv[PL3]]))
IF (pl3ccount GT 0.0) THEN Calpha[3, LiveIndiv2[LiveIndiv[PL3c]]] = 0. ;for benthic prey for flounder by Rose et al. 1996 

PL4 = WHERE((PL[4, LiveIndiv2[LiveIndiv]] / SNS[7, LiveIndiv]) LE PredPreyRatio, pl4count, complement = pl4c, ncomplement = pl4ccount)
IF (pl4count GT 0.0) THEN Calpha[4, LiveIndiv2[LiveIndiv[PL4]]] = ABS(1. - 1.75 * (PL[4, LiveIndiv2[LiveIndiv[PL4]]] / SNS[7, LiveIndiv[PL4]]))
IF (pl4ccount GT 0.0) THEN Calpha[4, LiveIndiv2[LiveIndiv[PL4c]]] = 0. ;for benthic prey for flounder by Rose et al. 1996 
;PRINT, 'Calpha'
;PRINT, Calpha
ENDIF

; Calculate attack probability using chesson's alpha = capture efficiency
; drift prey size class 1
t[0,*] = (Calpha[0,*] * dens[0,*]) * Pw[0, *]   
t[1,*] = (Calpha[0,*] * dens[1,*]) * Pw[0, *] 
t[2,*] = (Calpha[0,*] * dens[2,*]) * Pw[0, *]   
t[3,*] = (Calpha[0,*] * dens[3,*]) * Pw[0, *]     
t[4,*] = (Calpha[0,*] * dens[4,*]) * Pw[0, *]    
t[5,*] = (Calpha[0,*] * dens[5,*]) * Pw[0, *] 
t[6,*] = (Calpha[0,*] * dens[6,*]) * Pw[0, *]  

; drift prey size class 2
t[7,*] = (Calpha[1,*] * dens[7,*]) * Pw[1, *] 
t[8,*] = (Calpha[1,*] * dens[8,*]) * Pw[1, *] 
t[9,*] = (Calpha[1,*] * dens[9,*]) * Pw[1, *]  
t[10,*] = (Calpha[1,*] * dens[10,*]) * Pw[1, *]  
t[11,*] = (Calpha[1,*] * dens[11,*]) * Pw[1, *] 
t[12,*] = (Calpha[1,*] * dens[12,*]) * Pw[1, *] 
t[13,*] = (Calpha[1,*] * dens[13,*]) * Pw[1, *] 

; drift prey size class 3
t[14,*] = (Calpha[2,*] * dens[14,*]) * Pw[2, *] 
t[15,*] = (Calpha[2,*] * dens[15,*]) * Pw[2, *] 
t[16,*] = (Calpha[2,*] * dens[16,*]) * Pw[2, *] 
t[17,*] = (Calpha[2,*] * dens[17,*]) * Pw[2, *] 
t[18,*] = (Calpha[2,*] * dens[18,*]) * Pw[2, *] 
t[19,*] = (Calpha[2,*] * dens[19,*]) * Pw[2, *] 
t[20,*] = (Calpha[2,*] * dens[20,*]) * Pw[2, *] 

; drift prey size class 4
t[21,*] = (Calpha[3,*] * dens[21,*]) * Pw[3, *]   
t[22,*] = (Calpha[3,*] * dens[22,*]) * Pw[3, *]  
t[23,*] = (Calpha[3,*] * dens[23,*]) * Pw[3, *]  
t[24,*] = (Calpha[3,*] * dens[24,*]) * Pw[3, *]  
t[25,*] = (Calpha[3,*] * dens[25,*]) * Pw[3, *]  
t[26,*] = (Calpha[3,*] * dens[26,*]) * Pw[3, *]  
t[27,*] = (Calpha[3,*] * dens[27,*]) * Pw[3, *]  

; drift prey size class 5
t[28,*] = (Calpha[4,*] * dens[28,*]) * Pw[4, *] 
t[29,*] = (Calpha[4,*] * dens[29,*]) * Pw[4, *] 
t[30,*] = (Calpha[4,*] * dens[30,*]) * Pw[4, *] 
t[31,*] = (Calpha[4,*] * dens[31,*]) * Pw[4, *] 
t[32,*] = (Calpha[4,*] * dens[32,*]) * Pw[4, *] 
t[33,*] = (Calpha[4,*] * dens[33,*]) * Pw[4, *] 
t[34,*] = (Calpha[4,*] * dens[34,*]) * Pw[4, *] 

TOT[0, *] = t[0,*] + t[7,*] + t[14,*] + t[21,*] + t[28,*]; 
TOT[1, *] = t[1,*] + t[8,*] + t[15,*] + t[22,*] + t[29,*]; 
TOT[2, *] = t[2,*] + t[9,*] + t[16,*] + t[23,*] + t[30,*]; 
TOT[3, *] = t[3,*] + t[10,*] + t[17,*] + t[24,*] + t[31,*]; 
TOT[4, *] = t[4,*] + t[11,*] + t[18,*] + t[25,*] + t[32,*]; 
TOT[5, *] = t[5,*] + t[12,*] + t[19,*] + t[26,*] + t[33,*]; 
TOT[6, *] = t[6,*] + t[13,*] + t[20,*] + t[27,*] + t[34,*]; 
;PRINT, 'TOT'
;PRINT, TOT[*, 0:100]

; Calculate WEIGHTED cumulative prey biomass for each NEIGHBORING layer 
; And copy cumulative prey biomass to all NEIGHBORING cells
preyTOT = TOTAL(TOT[0:6, *], 1)  
preyTOT2[0, *] = preyTOT
preyTOT2[1, *] = preyTOT
preyTOT2[2, *] = preyTOT
preyTOT2[3, *] = preyTOT
preyTOT2[4, *] = preyTOT
preyTOT2[5, *] = preyTOT
preyTOT2[6, *] = preyTOT
;PRINT, 'PREYTOT'
;PRINT, PREYTOT2[*, 0:100]

preyTOT2nz0 = WHERE(preyTOT2[0, *] GT 0., preyTOT2nz0count)
preyTOT2nz1 = WHERE(preyTOT2[1, *] GT 0., preyTOT2nz1count)
preyTOT2nz2 = WHERE(preyTOT2[2, *] GT 0., preyTOT2nz2count)
preyTOT2nz3 = WHERE(preyTOT2[3, *] GT 0., preyTOT2nz3count)
preyTOT2nz4 = WHERE(preyTOT2[4, *] GT 0., preyTOT2nz4count)
preyTOT2nz5 = WHERE(preyTOT2[5, *] GT 0., preyTOT2nz5count)
preyTOT2nz6 = WHERE(preyTOT2[6, *] GT 0., preyTOT2nz6count)
IF preyTOT2nz0count GT 0. THEN EnvironLonPrey[0, preyTOT2nz0] = (TOT[0, preyTOT2nz0] / preyTOT2[0, preyTOT2nz0]) $
                                                              * RANDOMU(seed, preyTOT2nz0count, /DOUBLE)
IF preyTOT2nz1count GT 0. THEN EnvironLonPrey[1, preyTOT2nz1] = (TOT[1, preyTOT2nz1] / preyTOT2[1, preyTOT2nz1]) $
                                                              * RANDOMU(seed, preyTOT2nz1count, /DOUBLE)
IF preyTOT2nz2count GT 0. THEN EnvironLonPrey[2, preyTOT2nz2] = (TOT[2, preyTOT2nz2] / preyTOT2[2, preyTOT2nz2]) $
                                                              * RANDOMU(seed, preyTOT2nz2count, /DOUBLE)
IF preyTOT2nz3count GT 0. THEN EnvironLonPrey[3, preyTOT2nz3] = (TOT[3, preyTOT2nz3] / preyTOT2[3, preyTOT2nz3]) $
                                                              * RANDOMU(seed, preyTOT2nz3count, /DOUBLE)
IF preyTOT2nz4count GT 0. THEN EnvironLonPrey[4, preyTOT2nz4] = (TOT[4, preyTOT2nz4] / preyTOT2[4, preyTOT2nz4]) $
                                                              * RANDOMU(seed, preyTOT2nz4count, /DOUBLE)
IF preyTOT2nz5count GT 0. THEN EnvironLonPrey[5, preyTOT2nz5] = (TOT[5, preyTOT2nz5] / preyTOT2[5, preyTOT2nz5]) $
                                                              * RANDOMU(seed, preyTOT2nz5count, /DOUBLE)
IF preyTOT2nz6count GT 0. THEN EnvironLonPrey[6, preyTOT2nz6] = (TOT[6, preyTOT2nz6] / preyTOT2[6, preyTOT2nz6]) $
                                                              * RANDOMU(seed, preyTOT2nz6count, /DOUBLE)
;PRINT, 'EnvironLonPrey'
;PRINT, EnvironLonPrey[*, 0:100]
;;**********************************************************************************************************************


; Determine overall habitat quality with a random component
;EnvironHVSum[9, *] = DOUBLE((EnvironHVDO[9, *] * EnvironHVT[9, *] * EnvironHVprey[9, *])^(1.0/3.0))
;EnvironHVSum[10, *] = DOUBLE((EnvironHVDO[10, *] * EnvironHVT[10, *] * EnvironHVprey[10, *])^(1.0/3.0))
;EnvironHVSum[11, *] = DOUBLE((EnvironHVDO[11, *] * EnvironHVT[11, *] * EnvironHVprey[11, *])^(1.0/3.0))
;EnvironHVSum[12, *] = DOUBLE((EnvironHVDO[12, *] * EnvironHVT[12, *] * EnvironHVprey[12, *])^(1.0/3.0))
;EnvironHVSum[13, *] = DOUBLE((EnvironHVDO[13, *] * EnvironHVT[13, *] * EnvironHVprey[13, *])^(1.0/3.0))
;EnvironHVSum[14, *] = DOUBLE((EnvironHVDO[14, *] * EnvironHVT[14, *] * EnvironHVprey[14, *])^(1.0/3.0))
;EnvironHVSum[15, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[15, *])^(1.0/3.0))
;PRINT, 'EnvironHVSum'
;PRINT, EnvironHVSum

; WITH GUT FULLNESS EFFECT
;Gutfull2 = (100.- (SNS[60, *] < 100.0))/100.; < (1./3.); * RANDOMU(seed, nYP, /DOUBLE)
;Gutfull = (1. - Gutfull2)/2.
;print, 'gutfull', transpose(gutfull)
;PRINT, 'gutfull2'
;PRINT, (gutfull2[0:100])
;EnvironVSum[0, *] = DOUBLE(EnvironVDO[0, *]^gutfull * EnvironVT[0, *]^gutfull * EnvironVprey[0, *]^gutfull2)
;EnvironVSum[1, *] = DOUBLE(EnvironVDO[1, *]^gutfull * EnvironVT[1, *]^gutfull * EnvironVprey[1, *]^gutfull2)
;EnvironVSum[2, *] = DOUBLE(EnvironVDO[2, *]^gutfull * EnvironVT[2, *]^gutfull * EnvironVprey[2, *]^gutfull2)
;EnvironVSum[3, *] = DOUBLE(EnvironVDO[3, *]^gutfull * EnvironVT[3, *]^gutfull * EnvironVprey[3, *]^gutfull2)
;EnvironVSum[4, *] = DOUBLE(EnvironVDO[4, *]^gutfull * EnvironVT[4, *]^gutfull * EnvironVprey[4, *]^gutfull2)
;EnvironVSum[5, *] = DOUBLE(EnvironVDO[5, *]^gutfull * EnvironVT[5, *]^gutfull * EnvironVprey[5, *]^gutfull2)
;EnvironVSum[6, *] = DOUBLE(EnvironVDO[6, *]^gutfull * EnvironVT[6, *]^gutfull * EnvironVprey[6, *]^gutfull2)


; hierherchical habitat quality assessment
; first, determine weight of each environmental factor
; 1. Discharge
; 2. Drift prey biomass
Weight0 = (1. - EnvironLonDis[0, *]); higher the discharge-based habitat quality index, lower the weight
Weight1 = (1. - EnvironLonDis[1, *])
Weight2 = (1. - EnvironLonDis[2, *])
Weight3 = (1. - EnvironLonDis[3, *])
Weight4 = (1. - EnvironLonDis[4, *])
Weight5 = (1. - EnvironLonDis[5, *])
Weight6 = (1. - EnvironLonDis[6, *])

EnvironLonSum[0, *] = DOUBLE(EnvironLonDis[0, *]^Weight0 * EnvironLonPrey[0, *]^(1.- Weight0)); 
EnvironLonSum[1, *] = DOUBLE(EnvironLonDis[1, *]^Weight1 * EnvironLonPrey[1, *]^(1.- Weight1));
EnvironLonSum[2, *] = DOUBLE(EnvironLonDis[2, *]^Weight2 * EnvironLonPrey[2, *]^(1.- Weight2)); 
EnvironLonSum[3, *] = DOUBLE(EnvironLonDis[3, *]^Weight3 * EnvironLonPrey[3, *]^(1.- Weight3)); 
EnvironLonSum[4, *] = DOUBLE(EnvironLonDis[4, *]^Weight4 * EnvironLonPrey[4, *]^(1.- Weight4)); 
EnvironLonSum[5, *] = DOUBLE(EnvironLonDis[5, *]^Weight5 * EnvironLonPrey[5, *]^(1.- Weight5)); 
EnvironLonSum[6, *] = DOUBLE(EnvironLonDis[6, *]^Weight6 * EnvironLonPrey[6, *]^(1.- Weight6)); 
;PRINT, 'EnvironLonSum'
;PRINT, EnvironLonSum[*, 0:100]


;>Determine fish movement orientation<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1. determine which neighbouring cell to move
; Movement in longoitudinal direction

;; Move to the direction with highest habitat quality
;EnvironLonSumMax1 = MAX(EnvironLonSum[1:3, LiveIndiv2], DIMENSION = 1) - MAX(EnvironLonSum[4:6, LiveIndiv2], DIMENSION = 1)
;EnvironLonSumMax2 = MAX(EnvironLonSum[1:3, LiveIndiv2], DIMENSION = 1) - EnvironLonSum[0, LiveIndiv2]
;EnvironLonSumMax3 = MAX(EnvironLonSum[4:6, LiveIndiv2], DIMENSION = 1) - EnvironLonSum[0, LiveIndiv2]

;; Move to the direction with higher average habitat quality of 3 neighboring cells
;EnvironLonSumMax1 = TOTAL(EnvironLonSum[1:3, LiveIndiv2], 1)/3. - TOTAL(EnvironLonSum[4:6, LiveIndiv2], 1)/3
;EnvironLonSumMax2 = TOTAL(EnvironLonSum[1:3, LiveIndiv2], 1)/3. - EnvironLonSum[0, LiveIndiv2]
;EnvironLonSumMax3 = TOTAL(EnvironLonSum[4:6, LiveIndiv2], 1)/3. - EnvironLonSum[0, LiveIndiv2]

; Move to the direction with higher habitat quality - downtream or upstream
EnvironLonSumMax1 = EnvironLonSum[3, LiveIndiv2] - EnvironLonSum[4, LiveIndiv2]
EnvironLonSumMax2 = EnvironLonSum[3, LiveIndiv2] - EnvironLonSum[0, LiveIndiv2]
EnvironLonSumMax3 = EnvironLonSum[4, LiveIndiv2] - EnvironLonSum[0, LiveIndiv2]

; move downstream (3)
LonMoveNeg = WHERE((EnvironLonSumMax1 GT 0.) AND (EnvironLonSumMax2 GT 0.), LonMoveNegcount, complement = LonMoveNegN $
                  , ncomplement = LonMoveNegNcount)
IF LonMoveNegcount GT 0.0 THEN LonMove[LiveIndiv2[LonMoveNeg]] = 3
; move upstream (4)
LonMovePos = WHERE((EnvironLonSumMax1 LT 0.) AND (EnvironLonSumMax3 GT 0.), LonMovePoscount, complement = LonMovePosN $
                  , ncomplement = lonMovePosNcount)
IF LonMovePoscount GT 0.0 THEN LonMove[LiveIndiv2[LonMovePos]] = 4
; stay (0)
LonMoveNon = WHERE((EnvironLonSumMax2 LE 0.) AND (EnvironLonSumMax3 LE 0.), LonMoveNoncount, complement = LonMoveNonN $
                  , ncomplement = LonMoveNonNcount)
IF LonMoveNoncount GT 0.0 THEN LonMove[LiveIndiv2[LonMoveNon]] = 0

;>>>> Eggs don't move <<<<<<<<<<
Egg = WHERE((SNS[57, *] LT 1.) AND (SNS[4, *] GT 0.) AND (SNS[6, *] LT 1.), Eggcount)
IF Eggcount GT 0.0 THEN LonMove[LiveIndiv2[Egg]] = 0
IF Eggcount GT 0.0 THEN PRINT, 'Egg movement check', MAX(SNS[6, Egg])


;> Yolk-sac larvae can move only in the downstream direction (they just go with flow)
PreSetYOY = WHERE((SNS[57, *] GT 1.) AND (SNS[58, *] LT 1.) AND (SNS[4, *] GT 0.) AND (SNS[6, *] LT 1.), PreSetYOYcount, complement = PostSetYOYplus $
                 , ncomplement = PostSetYOYpluscount)
IF PreSetYOYcount GT 0.0 THEN LonMove[LiveIndiv2[PreSetYOY]] = 3
IF PreSetYOYcount GT 0.0 THEN PRINT, 'Larval movement check', MAX(SNS[6, PreSetYOY])

; Mature fish in a reproductive cycle move upstream until they spawn --> in April and May in the lower Platte River
Male = WHERE(SNS[5, *] EQ 0., malecount, complement = female, ncomplement = femalecount)
MatureSpwnYAOfemale = WHERE((SNS[59, female] GE GSIminFemale) AND (SNS[25, female] GT MinSpwnDaylength) AND (SNS[22, female] GE MinSpwnTemp) AND $
      (SNS[22, female] LE MaxSpwnTemp), MatureSpwnYAOfemalcount, complement = MatureNSpwnYAOfemale, ncomplement = MatureNSpwnYAOfemalecount)
MatureSpwnYAOmale = WHERE((SNS[59, Male] GE GSIminMale) AND (SNS[25, Male] GT MinSpwnDaylength) AND (SNS[22, Male] GE MinSpwnTemp) AND $
      (SNS[22, Male] LE MaxSpwnTemp), MatureSpwnYAOmalecount, complement = MatureNSpwnYAOmale, ncomplement = MatureNSpwnYAOmalecount)

;IF MatureSpwnYAOfemalcount GT 0.0 THEN LonMove[LiveIndiv2[female[MatureSpwnYAOfemale]]] = 3
;IF MatureSpwnYAOmalecount GT 0.0 THEN LonMove[LiveIndiv2[male[MatureSpwnYAOmale]]] = 4;
IF MatureSpwnYAOfemalcount GT 0.0 THEN PRINT, 'Spwaning adult movement check', MIN(SNS[6, female[MatureSpwnYAOfemale]])
PRINT, 'LonMove (DOWN)', LonMoveNegcount, '   (UP)', LonMovePoscount, '   (STAY)', LonMoveNoncount


;EnvironVSumMinNZ1 = WHERE((EnvironVSum[1:3, *] GT 0.) AND (EnvironVSum[4:6, *] GT 0.), EnvironVSumMinNZ1count)
;IF EnvironVSumMinNZ1count GT 0. THEN BEGIN
;  EnvironVSumMax1 = TOTAL(EnvironVSum[1:3, EnvironVSumMinNZ1], 1)/3 - TOTAL(EnvironVSum[4:6, EnvironVSumMinNZ1], 1)/3
;  EnvironVSumMax2 = TOTAL(EnvironVSum[1:3, EnvironVSumMinNZ1], 1)/3 - EnvironVSum[0, EnvironVSumMinNZ1]
;  EnvironVSumMax3 = TOTAL(EnvironVSum[4:6, EnvironVSumMinNZ1], 1)/3 - EnvironVSum[0, EnvironVSumMinNZ1]
;  ; move downward (3)
;  zMoveNeg = WHERE((EnvironVSumMax1 GT 0.) AND (EnvironVSumMax2 GT 0.), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
;  IF zMoveNegcount GT 0.0 THEN zMove[EnvironVSumMinNZ1[zMoveNeg]] = 3
;  ; move upward (4)
;  zMovePos = WHERE((EnvironVSumMax1 LT 0.) AND (EnvironVSumMax3 GT 0.), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
;  IF zMovePoscount GT 0.0 THEN zMove[EnvironVSumMinNZ1[zMovePos]] = 4
;  ; stay (0)
;  zMoveNon = WHERE((EnvironVSumMax2 LE 0.) AND (EnvironVSumMax3 LE 0.), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
;  IF zMoveNoncount GT 0.0 THEN zMove[EnvironVSumMinNZ1[zMoveNon]] = 0
;ENDIF
;
;EnvironVSumMinNZ2 = WHERE((EnvironVSum[1:3, *] LE 0.) AND (EnvironVSum[4:6, *] GT 0.), EnvironVSumMinNZ2count)
;IF EnvironVSumMinNZ2count GT 0. THEN BEGIN
;  EnvironVSumMax3 = TOTAL(EnvironVSum[4:6, EnvironVSumMinNZ2], 1)/3 - EnvironVSum[0, EnvironVSumMinNZ2]
;  ; move upward (4)
;  zMovePos = WHERE((EnvironVSumMax3 GT 0.), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
;  IF zMovePoscount GT 0.0 THEN zMove[EnvironVSumMinNZ2[zMovePos]] = 4
;  ; stay (0)
;  zMoveNon = WHERE((EnvironVSumMax3 LE 0.), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
;  IF zMoveNoncount GT 0.0 THEN zMove[EnvironVSumMinNZ2[zMoveNon]] = 0
;ENDIF
;
;EnvironVSumMinNZ3 = WHERE((EnvironVSum[1:3, *] GT 0.) AND (EnvironVSum[4:6, *] LE 0.), EnvironVSumMinNZ3count)
;IF EnvironVSumMinNZ3count GT 0. THEN BEGIN
;  EnvironVSumMax2 = TOTAL(EnvironVSum[1:3, EnvironVSumMinNZ3], 1)/3 - EnvironVSum[0, EnvironVSumMinNZ3]
;  ; move downward (3)
;  zMoveNeg = WHERE((EnvironVSumMax2 GT 0.), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
;  IF zMoveNegcount GT 0.0 THEN zMove[EnvironVSumMinNZ3[zMoveNeg]] = 3
;  ; stay (0)
;  zMoveNon = WHERE((EnvironVSumMax2 LE 0.), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
;  IF zMoveNoncount GT 0.0 THEN zMove[EnvironVSumMinNZ3[zMoveNon]] = 0
;ENDIF
;
;EnvironVSumMinNZ4 = WHERE((EnvironVSum[1:3, *] LE 0.) AND (EnvironVSum[4:6, *] LE 0.), EnvironVSumMinNZ4count)
;IF EnvironVSumMinNZ4count GT 0. THEN zMove[EnvironVSumMinNZ4] = 0
;PRINT, 'zMove'
;PRINT, zMove[0:100]


;;2. Determine specific fish movement orientation angle******************** 
;>>>>> NOT NEEDED FOR LONGITUDINAL MOVEMENT OF STURGEON <<<<<<<<<<<<<<
;; For now, each cell is assumed to have gradients between the current and neiboring cells
;; fish are able to detect gradients within a cetain range... 
;; Longitudianl movement
;LonOriAng = FLTARR(nSNS)
;; Dowanstream
;LonMoveOri1 = WHERE((LonMove EQ 3), LonMoveOri1count, complement = LonMoveOri1N, ncomplement = LonMoveOri1Ncount)
;IF (LonMoveOri1count GT 0.0) THEN LonOriAng[LonMoveOri1] = RANDOMU(seed, LonMoveOri1count)*(MAX(180.)-MIN(90.))+MIN(90.)
;; Upstream
;LonMoveOri2 = WHERE((LonMove EQ 4), LonMoveOri2count, complement = LonMoveOri2N, ncomplement = LonMoveOri2Ncount)
;IF (LonMoveOri2count GT 0.0) THEN LonOriAng[LonMoveOri2] = RANDOMU(seed, LonMoveOri2count)*(MAX(90.)-MIN(0.))+MIN(0.)
;; stay
;LonMoveOri3 = WHERE((LonMove EQ 0), LonMoveOri3count, complement = LonMoveOri3N, ncomplement = LonMoveOri3Ncount)
;IF (LonMoveOri3count GT 0.0)  THEN LonOriAng[LonMoveOri3] = RANDOMU(seed, LonMoveOri3count)*(MAX(135)-MIN(45))+MIN(45)
;                                                            randomu(seed, zMoveOri5count)*(max(180)-min(0))+min(0)
;;PRINT, 'COS(VerOriAng)', COS(VerOriAng)
;;PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)
;
;; Convert degrees to radians
;LonOriAng = LonOriAng*(!pi/180.)
;;PRINT, 'COS(VerOriAng)', COS(VerOriAng)
;;PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)


;3. Determine the distance and direction fish move uisng the habitat quality values estimated above***************************
; Calculate fish swimming speed, SS, in m /sec                               >>>>>>  NEED OT ADJJUST FOR STURGEON <<<<<<<<<<<
Larva = WHERE(SNS[7, *] LT MaxLarvaL, Larvacount, complement = JuvAdu, ncomplement = JuvAducount); SNS[7, *] = length
;IF (Lcount GT 0.0) THEN $
;S[L] = 3.0227 * ALOG(SNS[7, L]) - 4.6273; for walleye <20mm, Houde, 1969 
 ;SS equation based on data from Houde 1969 in body lengths/sec
;IF (LLcount GT 0.0) THEN $
;S[LL] = 1000 * (0.263 + 0.72 * SNS[7, LL] + 0.012 * SNS[22, LL]); for walleye >20mm; Peake et al., 2000, SNS[22, *] = temperature

; Converts SS into mm/s >>>>> NEED TO INCORPORATE SEASONAL MOVEMENT PATTERN >>>>>>> NO OR LITTLE MOVEMENT DURING WINTERS <<<<<<<<
;IF (Larvacount GT 0.0) THEN SS[LiveIndiv2[Larva]] = .5 * SNS[7, LiveIndiv2[Larva]]; S[L] * SNS[7, L]
;IF (JuvAducount GT 0.0) THEN SS[LiveIndiv2[JuvAdu]] = .5 * SNS[7, LiveIndiv2[JuvAdu]]; S[LL]

; Sustained swimming speed is XX% of Vmax >>>>>>>>>>>> NEED TO MAKE IT LENGTH SPECIFIC <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Male = WHERE(SNS[5, *] EQ 0., malecount, complement = female, ncomplement = femalecount)
IF femalecount GT 0. THEN GSImin[LiveIndiv2[female]] = GSIminFemale; GSI of stage IV female
IF malecount GT 0. THEN GSImin[LiveIndiv2[male]] = GSIminMale; GSI of stage II male

LengthGT225 = WHERE(SNS[7, *] GT 225., LengthGT225count, complement = LengthLE225, ncomplement = LengthLE225count)
; Individuals <225mm
IF LengthLE225count GT 0. THEN SS[LiveIndiv2[LengthLE225]] = PropSusV * 5.4 * 0.0031 * 13.86 * (((30.5 - SNS[22, LengthLE225])/3.92)^0.23) $
                               * EXP(0.24 *(1 - ((30.5 - SNS[22, LengthLE225])/3.52))) * (SNS[7, LengthLE225]/10.)^0.18
; Individuals >=225mm, derived from white sturgeon study by ???
IF LengthGT225count GT 0. THEN BEGIN 
  SS[LiveIndiv2[LengthGT225]] = PropSusV * 2. * (25.512 + (0.214 * SNS[7, LengthGT225]/10.) - ( 0.762 * SNS[22, LengthGT225]) $
                              + (0.0342 * SNS[22, LengthGT225] * SNS[7, LengthGT225]/10.))/100.
                                       
  ; During the spawning season, mature females in the reproductive cycle migrate upstream at higher swmming speed
  MatureSpwnYAO2 = WHERE((SNS[59, LengthGT225] GT GSImin[LiveIndiv2[LengthGT225]]) AND (SNS[25, LengthGT225] GT 12.) AND $
        (SNS[22, LengthGT225] GT 12.) AND (SNS[22, LengthGT225] LT 24.) AND (SNS[5, LengthGT225] GE 1.), MatureSpwnYAOcount, complement = MatureNSpwnYAO $
        , ncomplement = MatureNSpwnYAOcount)
  IF MatureSpwnYAOcount GT 0.0 THEN SS[LiveIndiv2[LengthGT225[MatureSpwnYAO2]]] = PropSusVSpwn * 2.* (25.512 + (0.214 $
                                    * SNS[7, LengthGT225[MatureSpwnYAO2]]/10.) - (0.762 * SNS[22, LengthGT225[MatureSpwnYAO2]]) $
                                    + (0.0342 * SNS[22, LengthGT225[MatureSpwnYAO2]] * SNS[7, LengthGT225[MatureSpwnYAO2]]/10.))/100.

ENDIF
; >>> Pre-settlement larvae swim at 90% of the water velocity
IF PreSetYOYcount GT 0.0 THEN SS[LiveIndiv2[PreSetYOY]] = PropYolksacV * SNS[18, PreSetYOY] / (SNS[19, PreSetYOY] * (SNS[20, PreSetYOY] $ 
                                                        + ABS(SNS[21, PreSetYOY] *RANDOMN(SEED, PreSetYOYcount))))
;PRINT, 'Mean fish velocity (SS, m/s)', MEAN(SS)
;PRINT, 'Max fish velocity (SS, m/s)', MAX(SS)
;PRINT, 'Min fish velocity (SS, m/s)', MIN(SS)



;; Calculate realized swimming speed (mm/s) in the longitudinal direction
;MoveSpeed = FLTARR(5, nSNS)
;IF (Lcount GT 0.0) THEN MoveSpeed[2, L] = SS[L] * COS(LonOriAng[L]) * RANDOMU(seed, Lcount, /DOUBLE); VERTICAL DIRECTION
;IF (LLcount GT 0.0) THEN MoveSpeed[2, LL] = SS[LL]/(ts*1000.) * COS(LonOriAng[LL]) * RANDOMU(seed, LLcount, /DOUBLE)
; VERTICAL DIRECTION

; Estimate realized movement speed
LonMoveDown = WHERE((LonMove[LiveIndiv2] EQ 3.), LonMoveDowncount)
LonMoveUP = WHERE((LonMove[LiveIndiv2] EQ 4.), LonMoveUPcount)
LonMoveStay = WHERE((LonMove[LiveIndiv2] EQ 0.), LonMoveStaycount)

Vwater = SNS[18, *] / (SNS[19, *]  * (SNS[20, *]  + SNS[21, *] * ABS(RANDOMN(SEED, N_ELEMENTS(LiveIndiv2))))); m/s
; 15-FishEnvirHydro[4, *] = ReachID
; 16-FishEnvirHydro[5, *] = SegmentID
; 17-FishEnvirHydro[6, *] = SegmentID2 => LONGITUDIANL GRID ID#
; 18-FishEnvirHydro[7, *] = DISCHARGE
; 19-FishEnvirHydro[8, *] = width
; 20-FishEnvirHydro[9, *] = Depth
; 21-FishEnvirHydro[10, *] = DepthSE

; Convert m/s to mm/s
SS[LiveIndiv2] = SS[LiveIndiv2] * 1000.
;PRINT, 'Swimming speed (mm/s)'
;PRINT, SS


;Vwater2 = 0.1176+0.4031*Vwater
;PRINT, 'bottom water velocity (Vwater2, m/s)'
;PRINT, Vwater2[0:199]
Vwater =  Vwater * 0.919 * (Dp/SNS[20, *])^0.23;
Vwater = 0.1176+0.4031*Vwater
;PRINT, 'bottom water velocity (Vwater, m/s)'
;PRINT, Vwater[0:199]
Vwater = Vwater  * 1000.
IF (LonMoveDowncount GT 0.0) THEN MoveS[LiveIndiv2[LonMoveDown]] = PropNetMoveV1 * (SS[LiveIndiv2[LonMoveDown]] + Vwater[LonMoveDown])
IF (LonMoveUPcount GT 0.0) THEN MoveS[LiveIndiv2[LonMoveUP]] = -1. * PropNetMoveV2 * ABS(SS[LiveIndiv2[LonMoveUP]] - Vwater[LonMoveUP])
IF (LonMoveStaycount GT 0.0) THEN MoveS[LiveIndiv2[LonMoveStay]] = PropNetMoveVStay * (SS[LiveIndiv2[LonMoveStay]] - Vwater[LonMoveStay])

; NEED TO CHECK IF RESULTANT SWIMMING SPEED DOES NOT EXCEED MAXIMUM ACCETABLE SPEED*****
;MoveSpeed[4, *] = (0.102*(YP[1, *]/39.10/EXP(0.330)) + 30.3) * 10.0;n critical swimming speed for adult yellow perch from Nelson, 1989, J. Exp. Biol.
;***Maximum speed is also used for 'URGENCY' move? (from Goodwin et al., 2001)***
;PRINT, 'Realized movement speed (mm/s)'
;PRINT, MoveSpeed


; Distance fish move in each time step OR shorter subtime step???
;ts2 = 120L; frequency of turning = >1
;******Determine the distance tarveled**********************************************************  
; sturgeon movement occurs while ther are not foraging (i.e., night)
;LonNewLoc = MoveS[LiveIndiv2] * (ts - DaylightHour*60.) * 60.; *.1; distance (mm/ts) in longitudinal dimension 
; during the night only >>>>>>>>> NEED TO INCORPORATE TIME sturgeon are actively moving

; sturgeon movement (habitat selection) duration - shovelnose sturgeon are generally sedentary
LonNewLoc = MoveS[LiveIndiv2] * activehour*60. * 60.; *.1; distance (mm/ts) in longitudinal dimension all day  
;>>>>>>>>> NEED TO INCORPORATE TIME sturgeon are actively moving
;PRINT, 'Swiming distance (km/d)'
;PRINT, LonNewLoc[0:199]/1000000.

LonSize[*] = 1000. * 1000.; in mm, ALL LONGITUDIANL CELL = 1000 m
;PRINT, 'Longitudinal cell length (mm)'
;PRINT, LonSize

; Relative location (unit = #grid cell) of fish after movement in the longitudinal direction
LonMovePosLoc = WHERE((LonNewLoc GE 0.), LonMovePosLoccount, complement = LonMoveNegLoc, ncomplement = LonMoveNegLoccount)
IF LonMovePosLoccount GT 0.0 THEN LonNewLocWithinCell[LiveIndiv2[LonMovePosLoc]] = LonNewLoc[LonMovePosLoc] $
                                                         /(LonSize[LiveIndiv2[LonMovePosLoc]]) + LonOldLocWithinCell[LonMovePosLoc]
                                                         ; proportional distance in y-dimension
IF LonMoveNegLoccount GT 0.0 THEN LonNewLocWithinCell[LiveIndiv2[LonMoveNegLoc]] = LonNewLoc[LonMoveNegLoc] $
                                                         /(LonSize[LiveIndiv2[LonMoveNegLoc]]) + LonOldLocWithinCell[LonMoveNegLoc]
                                                         ; proportional distance in y-dimension  


; *****Determine new cell locations****************************************************************************************
; Identify new longitudinal cell
LonMoveOut0 = WHERE((LonNewLocWithinCell[LiveIndiv2] GT 4.), LonMoveOut0count, complement = LonMoveOut0N $
                   , ncomplement = LonMoveOut0Ncount)
LonMoveOut1 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT 3.) AND (LonNewLocWithinCell[LiveIndiv2] LE 4.)), LonMoveOut1count $
                   , complement = LonMoveOut1N, ncomplement = LonMoveOut1Ncount)
LonMoveOut2 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT 2.) AND (LonNewLocWithinCell[LiveIndiv2] LE 3.)), LonMoveOut2count $
                   , complement = LonMoveOut2N, ncomplement = LonMoveOut2Ncount)
LonMoveOut3 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT 1.) AND (LonNewLocWithinCell[LiveIndiv2] LE 2.)), LonMoveOut3count $
                   , complement = LonMoveOut3N, ncomplement = LonMoveOut3Ncount)
LonMoveOut4 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT 0.) AND (LonNewLocWithinCell[LiveIndiv2] LE 1.)), LonMoveOut4count $
                   , complement = LonMoveOut4N, ncomplement = LonMoveOut4Ncount)
LonMoveOut5 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT -1.) AND (LonNewLocWithinCell[LiveIndiv2] LE 0.)), LonMoveOut5count $
                   , complement = LonMoveOut5N, ncomplement = LonMoveOut5Ncount)
LonMoveOut6 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT -2.) AND (LonNewLocWithinCell[LiveIndiv2] LE -1.)), LonMoveOut6count $
                   , complement = LonMoveOut6N, ncomplement = LonMoveOut6Ncount)
LonMoveOut7 = WHERE(((LonNewLocWithinCell[LiveIndiv2] GT -3.) AND (LonNewLocWithinCell[LiveIndiv2] LE -2.)), LonMoveOut7count $
                   , complement = LonMoveOut7N, ncomplement = LonMoveOut7Ncount)
LonMoveOut8 = WHERE((LonNewLocWithinCell[LiveIndiv2] LE -3.), LonMoveOut8count, complement = LonMoveOut8N $
                   , ncomplement = LonMoveOut8Ncount)
IF LonMoveOut0count GT 0.0 THEN SNS[17, LonMoveOut0] = LocLon[1, LiveIndiv2[LonMoveOut0]]
IF LonMoveOut1count GT 0.0 THEN SNS[17, LonMoveOut1] = LocLon[1, LiveIndiv2[LonMoveOut1]]
IF LonMoveOut2count GT 0.0 THEN SNS[17, LonMoveOut2] = LocLon[2, LiveIndiv2[LonMoveOut2]]
IF LonMoveOut3count GT 0.0 THEN SNS[17, LonMoveOut3] = LocLon[3, LiveIndiv2[LonMoveOut3]]
IF LonMoveOut4count GT 0.0 THEN SNS[17, LonMoveOut4] = LocLon[0, LiveIndiv2[LonMoveOut4]]
IF LonMoveOut5count GT 0.0 THEN SNS[17, LonMoveOut5] = LocLon[4, LiveIndiv2[LonMoveOut5]]
IF LonMoveOut6count GT 0.0 THEN SNS[17, lonMoveOut6] = LocLon[5, LiveIndiv2[LonMoveOut6]]
IF LonMoveOut7count GT 0.0 THEN SNS[17, LonMoveOut7] = LocLon[6, LiveIndiv2[LonMoveOut7]]
IF LonMoveOut8count GT 0.0 THEN SNS[17, LonMoveOut8] = LocLon[6, LiveIndiv2[LonMoveOut8]]


;SNS[17, *] = SNS[17, *] + ROUND(LonNewLocWithinCell); 0 - 161 = upstream - downstream
;; '-' = upstream; '+' = downstream
;
;;FOR iOut = 0L, nSNS-1L DO ImmigProb[iOut] = RANDOMU(seed, /double);
;p_immig = 0.01
;
;ImmigUp = WHERE(SNS[17, *] LT 0., ImmigUpcount, complement = nonImmigUp, ncomplement = nonImmigUpcount)
;IF ImmigUpcount GT 0. THEN BEGIN; 
;  SNS[17, ImmigUp] = 0
;  ImmigUpInd = WHERE((ImmigProb[LiveIndiv2[ImmigUp]] LT p_immig[ImmigUp]), ImmigUpIndcount, complement = nonImmigUpInd, ncomplement = nonImmigUpIndcount)
;  IF ImmigUpIndcount GT 0. THEN SNS[17, ImmigUp[ImmigUpInd]] = 161
;PRINT, 'Number of fish that potentially move out of the system (Up)'
;PRINT, ImmigUpIndcount
;ENDIF  
;
;ImmigDown = WHERE(SNS[17, *] GT 161., ImmigDowncount, complement = nonImmigDown, ncomplement = nonImmigDowncount)
;IF ImmigDowncount GT 0. THEN BEGIN; 
;  SNS[17, ImmigDown] = 161
;  ImmigDownInd = WHERE((ImmigProb[LiveIndiv2[ImmigDown]] LT p_immig[ImmigDown]), ImmigDownIndcount, complement = nonImmigDownInd, ncomplement = nonImmigDownIndcount)
;  IF ImmigDownIndcount GT 0. THEN SNS[17, ImmigDown[ImmigDownInd]] = 0
;PRINT, 'Number of fish that potentially move out of the system (Down)'
;PRINT, ImmigDownIndcount
;ENDIF


; When fish moves out the current cell, a within-cell location needs to be updated (LonNewLocWithinCell is standardized; 0 to 1)
; Movement in positive longitudinal direction 
LonMoveOutPos = WHERE((LonNewLocWithinCell[LiveIndiv2] GT 1.0), LonMoveOutPoscount, complement = lonMoveOutPosN $
                     , ncomplement = LonMoveOutPosNcount)
IF LonMoveOutPoscount GT 0.0 THEN LonNewLocWithinCell[LiveIndiv2[LonMoveOutPos]] = LonNewLocWithinCell[LiveIndiv2[LonMoveOutPos]] $
                                                                            - FLOOR(LonNewLocWithinCell[LiveIndiv2[LonMoveOutPos]])

; Movement in negative longitudinal direction 
LonMoveOutNeg = WHERE((LonNewLocWithinCell[LiveIndiv2] LT 0.0), LonMoveOutNegcount, complement = LonMoveOutNegN, ncomplement = LonMoveOutNegNcount)
IF LonMoveOutNegcount GT 0.0 THEN LonNewLocWithinCell[LiveIndiv2[LonMoveOutNeg]] = LonNewLocWithinCell[LiveIndiv2[LonMoveOutNeg]] $
                                                                        + CEIL(ABS(LonNewLocWithinCell[LiveIndiv2[LonMoveOutNeg]]))  
;PRINT,'LonMoveOutPos', LonMoveOutPos
;PRINT,'LonMoveOutNeg', LonMoveOutNeg
;PRINT, 'New within-cell location in z-dimension in new cell '
;PRINT, LonNewLocWithinCell[0:200]


; When fish move out from the lower boundary of the LPR system
ImmigDownInd = WHERE(SNS[17, *] EQ 162., ImmigDownIndcount, complement = nonImmigDownInd, ncomplement = nonImmigDownIndcount)
IF ImmigDownIndcount GT 0. THEN BEGIN
  SNS[17, ImmigDownInd] = 0; 161; emigrated indiviudals are re-introduced from the upstream
  SNS[70, ImmigDownInd] = SNS[4, ImmigDownInd]; number of individuals emigrate
;  ImmigIndYOY = WHERE(SNS[17, YOY] EQ 162., ImmigIndYOYcount, complement = nonImmigIndYOY, ncomplement = nonImmigIndYOYcount)
;  SNS[4, ImmigIndYOY] = 0
;  SNS[4, ImmigInd] = 0; update the number of individuals after emigration
ENDIF
PRINT, 'Number of fish that move out of the system (downstream)', ImmigDownIndcount

; When fish move out from the upper boundary of the LPR system
ImmigUpInd = WHERE(SNS[17, *] EQ 163., ImmigUpIndcount, complement = nonImmigUpInd, ncomplement = nonImmigUpIndcount)
IF ImmigUpIndcount GT 0. THEN BEGIN
  SNS[17, ImmigUpInd] = 161; emigrated indiviudals are re-introduced from the downstream
  SNS[70, ImmigUpInd] = SNS[4, ImmigUpInd]; number of individuals emigrate
;  ImmigIndYOY = WHERE(SNS[17, YOY] EQ 162., ImmigIndYOYcount, complement = nonImmigIndYOY, ncomplement = nonImmigIndYOYcount)
;  SNS[4, ImmigIndYOY] = 0
;  SNS[4, ImmigInd] = 0; update the number of individuals after emigration
ENDIF
PRINT, 'Number of fish that move out of the system (upstream)', ImmigUpIndcount


; New environmental conditions
NewFishEnviron[0:6, LiveIndiv2] = HydroInput[4:10, SNS[17, *]];
;PRINT, '#HydroInput array', N_ELEMENTS(NewFishEnviron[0, LiveIndiv2])
PRINT, 'LOCATION ID: MEAN', MEAN(SNS[17, *]), '   MAX', MAX(SNS[17, *]), '   MIN', MIN(SNS[17, *])
;PRINT, 'ERROR CHECK',WHERE( ~FINITE(SNS[17, *]))

NewFishEnviron[7:11, LiveIndiv2] = DriftPrey[0:4, SNS[17, *]]; drift prey biomass
NewFishEnviron[12, LiveIndiv2] = LonNewLocWithinCell[LiveIndiv2]; New within-cell location in a new cell
NewFishEnviron[13, LiveIndiv2] = LonNewLoc/1000000.; total distance traveled (km) per day
NewFishEnviron[14, LiveIndiv2] = SNS[70, *]; number of individuals emigrate 
NewFishEnviron[15, LiveIndiv2] = SNS[4, *]; update the number of individuals after emigration
NewFishEnviron[16, LiveIndiv2] = ImmigUpIndcount
NewFishEnviron[17, LiveIndiv2] = ImmigDownIndcount
;PRINT, 'NewFishEnviron[15, *]'
;PRINT, NewFishEnviron[15, 0:199]
PRINT, 'Fish movement rate (m/d): MEAN', MEAN(LonNewLoc/1000.), '   MAX', MAX(LonNewLoc/1000.), '   MIN', MIN(ABS(LonNewLoc/1000.))

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
;PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Shovelnose sturgeon 1D Movement Ends Here'
RETURN, NewFishEnviron; TURN OFF WHEN TESTING
END