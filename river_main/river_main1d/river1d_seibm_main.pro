PRO river1d_seibm_main; *Spatially explicit indiviudal-based model for shovelnose sturgeon (SNS)
; *Retrospective simulations are calibrated with the Lower Platte River field data.

;*****Population structure*********
; In the lower Platte River, NE (~162 km)
; 16 age classes for shovelnose sturgeon (SNS)

; System-level parameter values
; Time steps for subdaily simulations
ts = 24*60L ; minutes in a time step
;td = (60L/ts)*24L ; number of time steps in a day
nStateVar = 80L; number of IBM state variables
nLonTran = 162L; the number of longitudianl grid cells
nDOY = 365L; the number of days in a year
nSumStatVar = 570L; the number of state variables in the summary output files

; Total number of superindividuals in each YOY cohort
nSNSyoySI = 10000L ; number of shovelnose sturgeon egg as superindividuals(SIs)

;Average population size and age structure of YOY to max age 16
NpopSNS = 60000L; number of SNS individuals in the Lower Platte River

; total shovelnose sturgeon population in the Lower Platte River: 23000-69000 > 46000 average based on the 2001-2004 sampling (Peters and Perham 2008)
nSNS = NpopSNS + nSNSyoySI
VirTelYear = 1995; year of tagging for virtual telemetry study

; Set a direcotry for exporting daily output of state variables as .csv file
;CD, F:\SNS_SEIBM
Time='_Daily_'

; Assign array structure
;SNSsumout = FLTARR(nSumStatVar, 1L)
TotDriftBio2 = FLTARR(5L, nLonTran)
DriftConsRatio = FLTARR(nLonTran)
;HydroEnvir1D = FLTARR(12L, nLonTran*365L)
;WQEnvir1D = FLTARR(8L, 365L)
HydroEnvir1D2 = FLTARR(12L, nLonTran)
WQEnvir1D2 = FLTARR(8L, 1L)
SNSpbio = FLTARR(45, nSNS); prey & conspecific individuals 

; Daily fractional development toward hatching
DVsns = FLTARR(nSNS) ; determines when individual shovelnose sturgeon hatch

; Daily fractional development toward 1st feeding
FEEDsns = FLTARR(nSNS) ; determines when individual shovelnose sturgeon feed

; Number of prey consumed as determined in foraging
SNSeaten = FLTARR(5, nSNS) ; number of prey consumed as determined by the foraging subroutine

; Number of prey consumed as determined in foraging
;SNSgro = FLTARR(8, nSNS) ; number of prey consumed as determined by the foraging subroutine
nSpwnFemale = INTARR(1); total number of spawning females
LiveIndiv2count2 = FLTARR(1); total numebr of indidividuals (SIs for YOY)

tstart1 = SYSTIME(/seconds); used to calcualte computation time

; Set initial and final simulation years and days
IntDay = 1L; initial day of simulations
FinDay = 365L; final day of simulations
IntYear = 1991L; initial year of simulations; 1992-1994 simulations are dicarded
IntYear2 = 1995L; initial year of simulations used for model assessment
FinYear = 2011L; final year of simulations

; Submodel parameter values
KS2 = 0.8; minimum condition index value for initiating an annual spwawning cycle

; Environmental condition thresholds spawning
MinDaylength = 12.; daylight hour threshold for spawning migration, Spawning occurs when daylight hours are >12hrs        

; Tempearture (degree C) USGS reports
; >Shovelnose sturgeon spawn from late April to mid June at 16-25C in the Missouri River ad its tributaries (REF???).
TspwnL = 12.6
TspwnH = 24.9   

; Discharge (m3/s)
; there is no suitablt habitat below 2000 cfs and rapidly increase up to 6000 cfs and reach asymptote at 9000 cfs
; river connectivity incrases rapidly from 3200 to 5600 cfs and 100% connectivity at 8000 cfs
Dspwn = 141.6; 5000; connectivity is >50% in the LPR

; Post-settlement larvae initial body length (mean +/- SE mm)
SwimupIntL = 15.6
SwimupIntLSE = 0.84

; Simulation experiment scenario parameter
nForecastYear = 50L; number of years for forecating simulations
ForecastScenario = 4L; A.River hydrology: 0=normal, 1=wet, 2=dry, 3=random, 4=1947-2011 field data
HydroChange1 = 0.
HydroChange2 = 0.
FlowAugIntYear = 2011L
FlowAugLastYear = 2011L + nForecastYear
FlowAugIntDay = 100;
FlowAugLastDay = 365; 

; Proportiolnal flow change
PropAddFlow = 0.3;

; Temp increase
WarmTemp = 0L; 0 = no change, 1 = 1C, 2 = 2C

; No spatial heterogeniety scenario
SpatialUniformDisc = Dspwn; discharge rate is constant; need to adjust discharge input

; Start simulations here
FOR iYEAR = IntYear, (FinYear + nForecastYear) DO BEGIN;*************INTER-ANNUAL LOOP********************************************************
  PRINT, 'YEAR', iYEAR; the year of simulations
  tstart2 = SYSTIME(/seconds); timer for each daily time step
  
  ;***************************
  ; Assign a file name
  ; Endocrine disrupting chemical (EndDisChem) effect
  EndDisChem = 'OFF'
  
  ; Density dependence effect
  DensityDependence = 'ON'
  
  ; Year & Replicate #
  RepNum = 'Rep1' 
  ; Burn-in simulations 
;  IF iYear LT 1995 THEN HydroCond = '(Burn-in-WET)'
;  IF iYear EQ 1995 THEN HydroCond = '(WET)' 
;  IF iYear EQ 1996 THEN HydroCond = '(WET)'
;  IF iYear EQ 1997 THEN HydroCond = '(WET)'
;  IF iYear EQ 1998 THEN HydroCond = '(WET)'
;  IF iYear EQ 1999 THEN HydroCond = '(WET)'
;  IF iYear EQ 2000 THEN HydroCond = '(WET)'
;  IF iYear EQ 2001 THEN HydroCond = '(NORMAL)'
;  IF iYear EQ 2002 THEN HydroCond = '(DRY)'
;  IF iYear EQ 2003 THEN HydroCond = '(DRY)' 
;  IF iYear EQ 2004 THEN HydroCond = '(DRY)'
;  IF iYear EQ 2005 THEN HydroCond = '(DRY)'
;  IF iYear EQ 2006 THEN HydroCond = '(DRY)'
;  IF iYear EQ 2007 THEN HydroCond = '(NORMAL)'
;  IF iYear EQ 2008 THEN HydroCond = '(NORMAL)'
;  IF iYear EQ 2009 THEN HydroCond = '(NORMAL)'
;  IF iYear EQ 2010 THEN HydroCond = '(WET)'
;  IF iYear EQ 2011 THEN HydroCond = '(WET)
   ;Rep = 'YEAR_'+STRING(iYEAR, FORMAT = '(I4)')+'(Burn-in-WET)'+RepNum
   Rep = 'YEAR_'+STRING(iYEAR, FORMAT = '(I4)')+RepNum
   ;*********************************************************************
  
  ; Forecasting (2012 + years of forecasts (YOF))
  ; In each simulation year, the input is randomly selected from 1995 to 2011
  ; Normal hydrological year scenarios (N = 4): 2001, 2007-2009
  ;IF (iYEAR GE 1990L) AND (iYEAR LE 2011L) THEN BEGIN
  IF (iYEAR GT 2011L) AND (ForecastScenario EQ 0) THEN BEGIN
    RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(5) - MIN(1)) + MIN(1)); 
    IF RandInputYear EQ 1L THEN RandInputYear2 = 2001L; 
    IF RandInputYear EQ 2L THEN RandInputYear2 = 2007L; 
    IF RandInputYear EQ 3L THEN RandInputYear2 = 2008L; 
    IF RandInputYear EQ 4L THEN RandInputYear2 = 2009L; 
  ENDIF
  
  ; Wet hydrological year scenarios (N = 8): 1995-2000, 2010-2011
  ;IF (iYEAR GE 1990L) AND (iYEAR LE 2011L) THEN BEGIN
  IF (iYEAR GT 2011L) AND (ForecastScenario EQ 1) THEN BEGIN
    RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(9) - MIN(1)) + MIN(1)); 
    IF RandInputYear EQ 1L THEN RandInputYear2 = 1995L; 
    IF RandInputYear EQ 2L THEN RandInputYear2 = 1996L; 
    IF RandInputYear EQ 3L THEN RandInputYear2 = 1997L; 
    IF RandInputYear EQ 4L THEN RandInputYear2 = 1998L;
    IF RandInputYear EQ 5L THEN RandInputYear2 = 1999L; 
    IF RandInputYear EQ 6L THEN RandInputYear2 = 2000L; 
    IF RandInputYear EQ 7L THEN RandInputYear2 = 2010L; 
    IF RandInputYear EQ 8L THEN RandInputYear2 = 2011L; 
  ENDIF
  
  ; Dry hydrological year scenarios (N = 5): 2002-2006
  ;IF (iYEAR GE 1990L) AND (iYEAR LE 2011L) THEN BEGIN
  IF (iYEAR GT 2011L) AND (ForecastScenario EQ 2) THEN BEGIN
    RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(6) - MIN(1)) + MIN(1)); 
    IF RandInputYear EQ 1L THEN RandInputYear2 = 2002L; 
    IF RandInputYear EQ 2L THEN RandInputYear2 = 2003L; 
    IF RandInputYear EQ 3L THEN RandInputYear2 = 2004L; 
    IF RandInputYear EQ 4L THEN RandInputYear2 = 2005L; 
    IF RandInputYear EQ 5L THEN RandInputYear2 = 2006L; 
  ENDIF
  
  ; Random hydrological year (N = 17); 1995-2011
  IF (iYEAR GT 2011L) AND (ForecastScenario EQ 3) THEN BEGIN
    RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(18) - MIN(1)) + MIN(1)); 
    IF RandInputYear EQ 1L THEN RandInputYear2 = 2001L;
    IF RandInputYear EQ 2L THEN RandInputYear2 = 2007L;
    IF RandInputYear EQ 3L THEN RandInputYear2 = 2008L;
    IF RandInputYear EQ 4L THEN RandInputYear2 = 2009L;
    IF RandInputYear EQ 5L THEN RandInputYear2 = 1995L;
    IF RandInputYear EQ 6L THEN RandInputYear2 = 1996L;
    IF RandInputYear EQ 7L THEN RandInputYear2 = 1997L;
    IF RandInputYear EQ 8L THEN RandInputYear2 = 1998L;
    IF RandInputYear EQ 9L THEN RandInputYear2 = 1999L;
    IF RandInputYear EQ 10L THEN RandInputYear2 = 2000L;
    IF RandInputYear EQ 11L THEN RandInputYear2 = 2010L;
    IF RandInputYear EQ 12L THEN RandInputYear2 = 2011L;
  
    IF RandInputYear EQ 13L THEN RandInputYear2 = 2002L;
    IF RandInputYear EQ 14L THEN RandInputYear2 = 2003L;
    IF RandInputYear EQ 15L THEN RandInputYear2 = 2004L;
    IF RandInputYear EQ 16L THEN RandInputYear2 = 2005L;
    IF RandInputYear EQ 17L THEN RandInputYear2 = 2006L;
  ENDIF
  
  ; Hydrological conditions based on 1947-2011 data
  IF (iYEAR GT 2011L) AND (ForecastScenario EQ 4) THEN BEGIN
    HydroWetFreq = 0.3692 * (1. + HydroChange1)
    HydroDryFreq = 0.2615 * (1. + HydroChange2)
    HydroNormFreq = 1. - HydroWetFreq - HydroDryFreq
      REPEAT BEGIN
        ProbHydroNorm = RANDOMU(seed, /double)
        IF ProbHydroNorm LT HydroNormFreq THEN HydroNorm = 1 ELSE HydroNorm = 0
        ProbHydroWet = RANDOMU(seed, /double)
        IF ProbHydroWet LT HydroWetFreq THEN HydroWet = 1 ELSE HydroWet = 0
        ProbHydroDry = RANDOMU(seed, /double)
        IF ProbHydroDry LT HydroDryFreq THEN HydroDry = 1 ELSE HydroDry = 0
        HydroCond = HydroNorm+HydroWet+HydroDry
      ENDREP UNTIL HydroCond EQ 1
      IF HydroNorm GT 0 THEN HydroCond = HydroNorm*1
      IF HydroWet GT 0 THEN HydroCond = HydroWet*2
      IF HydroDry GT 0 THEN HydroCond = HydroDry*3
      IF HydroNorm GT 0 THEN PRINT, 'Hydrological condition: NORMAL'
      IF HydroWet GT 0 THEN  PRINT, 'Hydrological condition: WET'
      IF HydroDry GT 0 THEN  PRINT, 'Hydrological condition: DRY'
  
    ; Normal hydrological year scenarios (N = 4): 2001, 2007-2009
    IF (HydroCond EQ 1) THEN BEGIN
      RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(5) - MIN(1)) + MIN(1)); 
      IF RandInputYear EQ 1L THEN RandInputYear2 = 2001L; 
      IF RandInputYear EQ 2L THEN RandInputYear2 = 2007L; 
      IF RandInputYear EQ 3L THEN RandInputYear2 = 2008L; 
      IF RandInputYear EQ 4L THEN RandInputYear2 = 2009L; 
    ENDIF
    
    ; Wet hydrological year scenarios (N = 8): 1995-2000, 2010-2011
    IF (HydroCond EQ 2) THEN BEGIN
      RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(9) - MIN(1)) + MIN(1)); 
      IF RandInputYear EQ 1L THEN RandInputYear2 = 1995L; 
      IF RandInputYear EQ 2L THEN RandInputYear2 = 1996L; 
      IF RandInputYear EQ 3L THEN RandInputYear2 = 1997L; 
      IF RandInputYear EQ 4L THEN RandInputYear2 = 1998L; 
      IF RandInputYear EQ 5L THEN RandInputYear2 = 1999L; 
      IF RandInputYear EQ 6L THEN RandInputYear2 = 2000L; 
      IF RandInputYear EQ 7L THEN RandInputYear2 = 2010L; 
      IF RandInputYear EQ 8L THEN RandInputYear2 = 2011L; 
    ENDIF
    
    ; Dry hydrological year scenarios (N = 5): 2002-2006
    IF (HydroCond EQ 3) THEN BEGIN
      RandInputYear = FLOOR(RANDOMU(seed, 1L) * (MAX(6) - MIN(1)) + MIN(1)); 
      IF RandInputYear EQ 1L THEN RandInputYear2 = 2002L; 
      IF RandInputYear EQ 2L THEN RandInputYear2 = 2003L; 
      IF RandInputYear EQ 3L THEN RandInputYear2 = 2004L; 
      IF RandInputYear EQ 4L THEN RandInputYear2 = 2005L; 
      IF RandInputYear EQ 5L THEN RandInputYear2 = 2006L; 
    ENDIF
  ENDIF 
  IF (iYEAR GT 2011L) THEN PRINT, 'INPUT YEAR FOR FORECASTING: ', RandInputYear2
  
  ; Initialize drift prey biomass
  TotDriftBio = 18.8 + RANDOMN(seed, nLonTran) * 2.5; ~4*.4 /0.085 = 18.8g wet mass/m2 in January
  ; dry:wet = 5 to 12 for diptera
  ; 22 to 24 for ephmeroptera
  ; 25g dry mass/m2 = g wet mass /m2
  ; assuming insects are 40% of benthic macroinvertebrates => 10g dry mass max = 83 to 200g wet mass/m2 or 117.7g average
 
  ; Read a daily environmental input
  WQEnvir1D = river1d_input(iYear, ForecastScenario, RandInputYear2) 
  HydroEnvir1D = river1d_hydrology_input(iYear, ForecastScenario, SpatialUniformDisc, RandInputYear2, PropAddFlow, $
                                    FlowAugIntYear, FlowAugLastYear);, iDay, TotDriftBio) 
  
  
  FOR iDay = IntDay, FinDay DO BEGIN;*******************INTRA-ANNUAL (DAILY) LOOP******************************************
    counter =  iDay - IntDay;*****FOR OUTPUT FILES (DOY)
    nYearCounter = iYEAR - IntYear
    nDayCounter = nYearCounter * 365L + iDay; countinuous day counter
    PRINT, 'Number of days since the initialization', nDayCounter
    ;******DO THE SAME FOR the initialization (DOY-1) AND TotBenBio (DOY-1)************
    ;PRINT, 'Counter', counter
    ;PRINT, 'iDay', iDay
 
    tstart3 = SYSTIME(/seconds)
     
    ; Call only a daily input from a yearly input read from the file
    iDayPointer = iDay - 1L; 
    WQEnvir1D2 = WQEnvir1D[*, iDayPointer]; No spatial resolution for the water quality inputs    
    HydroEnvir1D2[0L:11L, *] = HydroEnvir1D[*, 162L*iDayPointer : 162L*iDayPointer+161L]; 162 longitudianl grid cells fo hydrology inputs

;    ;>Flow-based simulation scenarios during dry years
;    ;1) Sustained flow augmentation (last for 10 to 30 days) ->500 to 1000 cfs -> NEED TO INCORPORATE FLOW ATTENUATION
;    IF ((HydroEnvir1D2[0, 0] GE FlowAugIntYear) AND (HydroEnvir1D2[0, 0] LE FlowAugLastYear)) THEN BEGIN
;      ;IF ((iDay GE FlowAugIntDay) AND (iDay LE FlowAugLastDay)) THEN HydroEnvir1D2[7, *] = HydroEnvir1D2[7, *] + HydroEnvir1D2[7, *]*PropAddFlow; > MinFlowThread
;      HydroEnvir1D2[7, *] = HydroEnvir1D2[7, *] + HydroEnvir1D2[7, *]*PropAddFlow;
;    ENDIF

    ;2) Pulse flow augmentation 
    ;PulseFlowDay1 = 100
    ;PulseFlowDay2 = 120
    ;PulseFlowDay3 = 140
    
    ;IF ((iDay EQ PulseFlowDay1) AND (iDay EQ PulseFlowDay2) AND (iDay EQ PulseFlowDay3)) THEN BEGIN; iday = DOY-1;
;     FlowAug = 0.   
;;    FlowAug = 100.
;;    FlowAug = 200.
;;    FlowAug = 300. 
;;    FlowAug = 500. 
;;    FlowAug = 1000.
;    HydroEnvir1D2[7, *] = HydroEnvir1D2[7, *] + FlowAug    
    ;PRINT, 'Daily Input'
    ;PRINT,  (Envir1d2)
    
    ; Calculate water velocity
    Vwater = HydroEnvir1D2[7, *] / (HydroEnvir1D2[8, *] * (HydroEnvir1D2[9, *] + HydroEnvir1D2[10, *]*ABS(RANDOMN(SEED, nLonTran))))     
    Vwater = 0.1176+0.4031*Vwater 
      
    ; Calculate production in g/d
    TotDriftBio2 = DriftPrey(iday, nLonTran, TotDriftBio, HydroEnvir1D2)
    
    PRINT, 'YEAR', iYEAR, '     MONTH', WQEnvir1D2[1, 0], '     DAY', WQEnvir1D2[2, 0]
    
    ; Water tempearture
    AmbTemp = WQEnvir1D2[4]
    PRINT, 'Water temperature', AmbTemp; water tempeorature inpiut is spatially uniform
    
    ; Add stocasticity to water temperature 
    PropTempVar = 0.1
    WQEnvir1D2[4] = WQEnvir1D2[4] + RANDOMN(seed) * PropTempVar
    PRINT, 'temp', WQEnvir1D2[4]    
    
    ; Water temperature change
    IF ((iYEAR GE FlowAugIntYear) AND (iYEAR LE FlowAugLastYear)) THEN BEGIN
      ;IF ((iDay GE FlowAugIntDay) AND (iDay LE FlowAugLastDay)) THEN HydroEnvir1D2[7, *] = HydroEnvir1D2[7, *] + HydroEnvir1D2[7, *]*PropAddFlow; > MinFlowThread
      
      IF WarmTemp EQ 0L THEN WQEnvir1D2[4] = WQEnvir1D2[4]      
      IF WarmTemp EQ 1L THEN WQEnvir1D2[4] = WQEnvir1D2[4] + 0.02 * (iyear - 2011L);+ 0.000069 * (iyear - 2011L) * iday
      IF WarmTemp EQ 2L THEN WQEnvir1D2[4] = WQEnvir1D2[4] + 0.04 * (iyear - 2011L);+ 0.000137 * (iyear - 2011L) * iday
    PRINT, 'temp', WQEnvir1D2[4]         
    ENDIF
    
    ; Caluclate daily average total volume of water of the river
    TotalRiverVol = TOTAL(HydroEnvir1D2[8, *] * HydroEnvir1D2[9, *] * 1000.)
    TotalRiverArea = TOTAL(HydroEnvir1D2[8, *] * 1000.)
    GridcellArea = HydroEnvir1D2[8, *] * 1000.;
    PRINT, 'Total water volume (m3)', TotalRiverVol     
            
    ;***INITIALIZATION***
    ;***this is done ONLY ONCE at the beginning of the intial year simulation
    IF ((iDay EQ IntDay) AND (iyear EQ IntYear)) THEN BEGIN; iday = DOY-1;
      NpopSNSyoy = 0L; number of SNS eggs/larvae -> initially no YOY until spawning 
      SNS = SNSinitial(nStateVar, NpopSNSyoy, nSNSyoySI, nSNS, TotDriftBio2, HydroEnvir1D2, WQEnvir1D2, nLonTran)   
    ENDIF 
    
    YOY = WHERE(SNS[6, *] LT 1L, YOYcount, complement = YAO, ncomplement = YAOcount)
    YOYalive = WHERE((SNS[4, YOY] GT 0L), YOYalivecount, complement = YOYdead, ncomplement = YOYdeadcount)

    ;*Update AGE and ARRAYS for multi-year simulations
    ;*This is activated in the >2nd year simulations
    IF ((iyear GT IntYear) AND(iDay EQ IntDay)) THEN BEGIN; iday = DOY-1
      SNS[*, YAO] = SNS[*, YAO]    
      LiveYAO = WHERE((SNS[4, YAO] GT 0.), LiveYAOcount, complement = DeadYAO, ncomplement = DeadYAOcount)

      IF LiveYAOcount GT 0. THEN BEGIN
        SNS[6, YAO[LiveYAO]] = SNS[6, YAO[LiveYAO]] + 1L; 
        ;***Check for MATURITY (length-based maturation) and REPRODUCTIVE STATUS***
        SNSmature = SNSmaturity(nSNS, YAO[LiveYAO], SNS[6, YAO[LiveYAO]], SNS[7, YAO[LiveYAO]], SNS[12, YAO[LiveYAO]], SNS[5, YAO[LiveYAO]] $
                                , SNS[8, YAO[LiveYAO]], SNS[59, YAO[LiveYAO]], SNS[77, YAO[LiveYAO]])
        SNS[12, YAO[LiveYAO]] = SNSmature[3, YAO[LiveYAO]]; maturity status is changed only for immature individuals
        SNS[77, YAO[LiveYAO]] = SNSmature[0, YAO[LiveYAO]]; age at maturity
      ENDIF
      
      ; Create a new array for new recruit (new Age 1) SIs as an individual
      IF YOYalivecount GT 0. THEN BEGIN 
        SNSnewrec = SNSNewRecArray(nStateVar, nSNS, YOYalivecount, SNS[4, YOY[YOYalive]], SNS[*, YOY[YOYalive]])
        
        ; Total number of new recruits
        nSNSnewrec = TOTAL(SNSnewrec[4, *])
        
        ; Add a new AGE 1 array to the original array
        SNS = TRANSPOSE([TRANSPOSE(SNS), TRANSPOSE(SNSnewrec)])
         
        ; Update the number of individuals (superindividuals) in the new state variable & submodel arrays
        nSNS = nSNS + nSNSnewrec; + nSNSyoySI
      ENDIF
      
      ; Add a new YOY array to the original array -> reinitialize the original YOY array
      NpopSNSyoy = 0L; number of SNS eggs/larvae -> initially no YOY until spawning 

      IF YOYcount GT 0. THEN BEGIN 
        SNSnewYOY = SNSinitialYOY(nStateVar, NpopSNSyoy, nSNSyoySI, nSNS, SNS, YOY, TotDriftBio2, HydroEnvir1D2, WQEnvir1D2, nLonTran) 
        SNS[*, YOY] = SNSnewYOY[*, YOY]
      ENDIF
      
      ; Update arrays with new recruits
      SNSpbio = FLTARR(45, nSNS)

      ; Daily fractional development toward hatching
      DVsns = FLTARR(nSNS) ; determines when individual shovelnose sturgeon hatch

      ; Daily fractional development toward 1st feeding
      FEEDsns = FLTARR(nSNS) ; determines when individual shovelnose sturgeon feed

      ; Number of prey consumed as determined in foraging
      SNSeaten = FLTARR(5, nSNS) ; number of prey consumed as determined by the foraging subroutine

;      SpwnFemale = WHERE((SNS[14, *] GE 1.) AND (SNS[5, *] EQ 1.), SpwnFemalecount)
;      SpwnMale = WHERE((SNS[14, *] GE 1.) AND (SNS[5, *] EQ 0.), SpwnMalecount)
;      Spwnall = WHERE((SNS[14, *] EQ 1), SpwnAllcount)
;      PRINT, 'Number of females in the reproductive cycle', SpwnFemalecount
;      PRINT, 'Number of males in the reproductive cycle', Spwnmalecount
;      PRINT, 'Number of all individuals in the reproductive cycle', SpwnAllcount
;      
;      PRINT, 'GSI of females in the reproductive cycle', MEAN(SNS[59, SpwnFemale]), MAX(SNS[59, SpwnFemale]), MIN(SNS[59, SpwnFemale])
;      PRINT, 'GSI of males in the reproductive cycle', MEAN(SNS[59, Spwnmale]), MAX(SNS[59, Spwnmale]), MIN(SNS[59, Spwnmale]) 
;      PRINT, 'KS of females in the reproductive cycle', MEAN(SNS[11, SpwnFemale]), MAX(SNS[11, SpwnFemale]), MIN(SNS[11, SpwnFemale])
;      PRINT, 'KS of males in the reproductive cycle', MEAN(SNS[11, Spwnmale]), MAX(SNS[11, Spwnmale]), MIN(SNS[11, Spwnmale])
    ENDIF 
     
    ; Update YOY array
    YOY = WHERE(SNS[6, *] LT 1L, YOYcount, complement = YAO, ncomplement = YAOcount)
    IF YOYcount GT 0. THEN PRINT, 'Number of YOY SIs (YOYcount)', YOYcount
         
    IF YOYalivecount GT 0. THEN BEGIN
      PRINT, 'YOY length (mm)'
      PRINT, mean(TRANSPOSE(SNS[7, YOY[YOYalive]]))
      PRINT, 'YOY # cohort' 
      PRINT, mean(TRANSPOSE(SNS[4, YOY[YOYalive]]))
      PRINT, 'Total Number of YOY individuals', TOTAL(SNS[4, YOY])  
      PRINT, 'Density of YOY individuals', TOTAL(SNS[4, YOY])/ TotalRiverVol          
    ENDIF  
         
    ; Update WATER/HABITAT QUALITY information, SNS[4, *] = #individuals
    LiveIndiv2 = WHERE(SNS[4, *] GT 0., LiveIndiv2count, complement = DeadIndiv2, ncomplement = DeadIndiv2count)

    ; ALL YOY (after spawning) & YAO
    SNS[22:25, LiveIndiv2] = WQEnvir1D2[4:7, SNS[17, LiveIndiv2]]; 

     ; Update time information for output files
     SNS[0, LiveIndiv2] = iYEAR
     SNS[1, LiveIndiv2] = WQEnvir1D2[1, LiveIndiv2]
     SNS[2, LiveIndiv2] = WQEnvir1D2[2, LiveIndiv2]
     
    PRINT, 'KS', MEAN(SNS[11, LiveIndiv2]), MAX(SNS[11, LiveIndiv2]), MIN(SNS[11, LiveIndiv2])
    ;***Check for MATURITY (length-based maturation) and REPRODUCTIVE STATUS***
    IF (iDay EQ IntDay) THEN BEGIN; RUNS ONLY ONCE A YEAR, MAY NEED TO ADJUST WHEN TO CHECK
      IF LiveIndiv2count GT 0. THEN BEGIN

        ; Find mature individuals
        Mature = WHERE(SNS[12, LiveIndiv2] GT 0., Maturecount, complement = Immature, ncomplement = Immaturecount); 
        
        ;***Check for reproductive status***
        IF (Maturecount GT 0.) THEN BEGIN
          ;PRINT, MEAN(SNS[59, LiveIndiv2[Mature]]), MAX(SNS[59, LiveIndiv2[Mature]]), MIN(SNS[59, LiveIndiv2[Mature]]) 
          SNS[56, LiveIndiv2[Mature]] = 0.02 * SNS[8, LiveIndiv2[Mature]]; assign initial gonadal weight at maturity = 2% of total weight 
          ;>>>>>>>>>>>>NEED TO ADUST THE INTIAL CONDITION OF SPAWNING FEMALE<<<<<
          ; >>INITIALIZATION (THE FIRST YEAR CONDITION) ONLY???
          ;KS2 = 0.82; minimum index for initiating an annual spwawning cycle
          
          ; Find mature indiviudals with good physiological condition
          SpwnAdult = WHERE((SNS[11, LiveIndiv2[Mature]] GE KS2), SpwnAdultcount, complement = NonSpwnAdult, ncomplement = NonSpwnAdultcount) 
          ;KS = physiological condition = SNS[11, *]
;          PRINT, 'Number of spawning adults', SpwnAdultcount
;          PRINT, 'SNS[11, LiveIndiv2[Mature[SpwnAdult]]]'
;          PRINT, MEAN(SNS[11, LiveIndiv2[Mature[SpwnAdult]]]), MAX(SNS[11, LiveIndiv2[Mature[SpwnAdult]]]), MIN(SNS[11, LiveIndiv2[Mature[SpwnAdult]]])
;          PRINT, MEAN(SNS[59, LiveIndiv2[Mature[SpwnAdult]]]), MAX(SNS[59, LiveIndiv2[Mature[SpwnAdult]]]), MIN(SNS[59, LiveIndiv2[Mature[SpwnAdult]]])
      
          ; Inidividuals that have spawned can begin/resume a reproductive cycle ONLY WHEN KS > KS2
          IF (SpwnAdultcount GT 0.) THEN BEGIN
            SNS[14, LiveIndiv2[Mature[SpwnAdult]]] = 1.; annual spawning cycle status
            ;PRINT, 'Initial gonad weight'
            ;PRINT, TRANSPOSE(SNS[56, LiveIndiv2[Mature[SpwnAdult]]]) 
          ENDIF
          ;IF (NonSpwnAdultcount GT 0.) THEN SNS[14, LiveIndiv2[Mature[NonSpwnAdult]]] = 0.; annual spawning cycle status
        ENDIF; End of annual reproductive cycle check
      ENDIF; End of 
    ENDIF; End of annual maturity check    
       
    MatFemale = WHERE((SNS[12, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 1.), MatFemalecount)
    MatMale = WHERE((SNS[12, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 0.), MatMalecount)
    Matall = WHERE((SNS[12, LiveIndiv2] GE 1.), MatAllcount)   
    PRINT, 'Number of mature females', MatFemalecount
    PRINT, 'Number of mature males', Matmalecount
    PRINT, 'Number of all mature individuals', MatAllcount
    IF MatFemalecount GT 0. THEN BEGIN
      PRINT, 'GSI of mature females', MEAN(SNS[59, LiveIndiv2[MatFemale]]), MAX(SNS[59, LiveIndiv2[MatFemale]]), MIN(SNS[59, LiveIndiv2[MatFemale]])
      PRINT, 'KS of mature females', MEAN(SNS[11, LiveIndiv2[MatFemale]]), MAX(SNS[11, LiveIndiv2[MatFemale]]), MIN(SNS[11, LiveIndiv2[MatFemale]])
      PRINT, 'Age of mature females', MEAN(SNS[6, LiveIndiv2[MatFemale]]), MAX(SNS[6, LiveIndiv2[MatFemale]]), MIN(SNS[6, LiveIndiv2[MatFemale]])
    ENDIF
    IF Matmalecount GT 0. THEN BEGIN
      PRINT, 'GSI of mature males', MEAN(SNS[59, LiveIndiv2[Matmale]]), MAX(SNS[59, LiveIndiv2[Matmale]]), MIN(SNS[59, LiveIndiv2[Matmale]])     
      PRINT, 'KS of mature males', MEAN(SNS[11, LiveIndiv2[Matmale]]), MAX(SNS[11, LiveIndiv2[Matmale]]), MIN(SNS[11, LiveIndiv2[Matmale]])
      PRINT, 'Age of mature males', MEAN(SNS[6, LiveIndiv2[Matmale]]), MAX(SNS[6, LiveIndiv2[Matmale]]), MIN(SNS[6, LiveIndiv2[Matmale]])        
    ENDIF
    
    SpwnFemale = WHERE((SNS[14, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 1.), SpwnFemalecount)
    SpwnMale = WHERE((SNS[14, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 0.), SpwnMalecount)
    Spwnall = WHERE((SNS[14, LiveIndiv2] GE 1.), SpwnAllcount) 
    PRINT, 'Number of females in the reproductive cycle', SpwnFemalecount
    PRINT, 'Number of males in the reproductive cycle', Spwnmalecount
    PRINT, 'Number of all individuals in the reproductive cycle', SpwnAllcount   
    IF SpwnFemalecount GT 0. THEN BEGIN
      PRINT, 'GSI of females in the reproductive cycle', MEAN(SNS[59, LiveIndiv2[SpwnFemale]]), MAX(SNS[59, LiveIndiv2[SpwnFemale]]), MIN(SNS[59, LiveIndiv2[SpwnFemale]])
      PRINT, 'KS of females in the reproductive cycle', MEAN(SNS[11, LiveIndiv2[SpwnFemale]]), MAX(SNS[11, LiveIndiv2[SpwnFemale]]), MIN(SNS[11, LiveIndiv2[SpwnFemale]])
      PRINT, 'Age of females in the reproductive cycle', MEAN(SNS[6, LiveIndiv2[SpwnFemale]]), MAX(SNS[6, LiveIndiv2[SpwnFemale]]), MIN(SNS[6, LiveIndiv2[SpwnFemale]])
    ENDIF
    IF Spwnmalecount GT 0. THEN BEGIN
      PRINT, 'GSI of males in the reproductive cycle', MEAN(SNS[59, LiveIndiv2[Spwnmale]]), MAX(SNS[59, LiveIndiv2[Spwnmale]]), MIN(SNS[59, LiveIndiv2[Spwnmale]]) 
      PRINT, 'KS of males in the reproductive cycle', MEAN(SNS[11, LiveIndiv2[Spwnmale]]), MAX(SNS[11, LiveIndiv2[Spwnmale]]), MIN(SNS[11, LiveIndiv2[Spwnmale]])
      PRINT, 'Age of males in the reproductive cycle', MEAN(SNS[6, LiveIndiv2[Spwnmale]]), MAX(SNS[6, LiveIndiv2[Spwnmale]]), MIN(SNS[6, LiveIndiv2[Spwnmale]])
    ENDIF
    

    ;***SPAWNING***
    ;*Spawning conditions-(it occurs only once a year)
    ;>daylength (WQEnvir1D2[7, *]) -> long-term cue
    ;>temperature (WQEnvir1D2[4, *]) -> short-term cue
    ;>discharge -> short-term cue
    ;>time of the year -> this might be an implicit condition based on temperature.
    ;>GSI -> this is an internal condition.
    ;>>>>> ALSO CHECH IF FISH ARE ALREADY IN THE SPAWNING CYCLE
    ;>>>>> IF SO, CHECK FOR PHYSIOLOGICAL CONDITION FOR INITIATING A NEW SPAWNING CYCLE
    ; >>>>>Non-reproductive sturgeon generally do not migrate significant distances during the spawning season.
   
    SpwnDL = WHERE((SNS[25, *] GT MinDaylength), SpwnDLcount, complement = NSpwnDL, ncomplement = NSpwnDLcount)
    ; daylight hour threshold for spawning migration  
    ;SpwnTemp = WHERE((SNS[22, *] GE 12.) AND (SNS[22, *] LE 24.), SpwnTempcount, complement = NSpwnTemp, ncomplement = NSpwnTempcount)
    ;; temperature (C) threshold for spawning
    ;SpwnDisc = WHERE((SNS[18, *] GE 100.), SpwnDisccount, complement = NSpwnDisc, ncomplement = NSpwnDisccount)
    ;; discharge (m3/s) (= 10000cfs) threshold for spawning   
    ;PRINT, 'Photoperiod'
    ;PRINT, TRANSPOSE(SNS[25, 0L:199L])
    ;PRINT, 'SpwnDLcount', SpwnDLcount

    IF SpwnDLcount GT 0. THEN BEGIN; when photoperiod is >12 hrs
      SpwnCond = WHERE((SNS[22, SpwnDL] GE TspwnL) AND (SNS[22, SpwnDL] LE TspwnH) AND (SNS[18, SpwnDL] GE Dspwn), SpwnCondcount $
                       , complement = NSpwnCond, ncomplement = NSpwnCondcount)
    ;SpwnCond = WHERE((SpwnDLcount GT 0.) AND (SpwnTempcount GT 0.) AND (SpwnDisccount GT 0.), SpwnCondcount, complement = NSpwnCond, ncomplement = NSpwnCondcount)
    ;SpwnCond = WHERE((SNS[25, *] GT 12.) AND ((SNS[22, *] GE 12.) AND (SNS[22, *] LE 24.)), SpwnCondcount, complement = NSpwnCond, ncomplement = NSpwnCondcount)
;    PRINT, 'Discharge'
;    PRINT, TRANSPOSE(SNS[18, 0L:199L])

      IF SpwnCondcount GT 0. THEN BEGIN; when all the habitat conditions meet the criteria for spawning
        SpwnAdult2 = WHERE((SNS[14, SpwnDL[SpwnCond]] GT 0.) AND (SNS[4, SpwnDL[SpwnCond]] GT 0.), SpwnAdult2count $
                          , complement = NonSpwnAdult2, ncomplement = NonSpwnAdult2count)
        ; SNS[14, *] = an annual reproductive cycle
        PRINT, 'Number of potentially spawning adults in suitable spawning habitat= ', SpwnAdult2count;, TOTAL(SNS[14, SpwnDL[SpwnCond]])
        
        IF (SpwnAdult2count GT 0.) THEN BEGIN
          PRINT, 'Spawning day: ', iday
        ; when all the habitat conditions meet the spawning criteria AND fish are in the reproductive cycle...
          SNSspwn = SNSspawn(iDay, nDayCounter, SNS[71, *], SNS[75, *], SNS[76, *], SNS[72, *], SNS[8, *], SNS[9, *], SNS[10, *], SNS[13, *], SNS[5, *], SNS[59, *], SNS[18, *] $ 
                             , SpwnDL[SpwnCond[SpwnAdult2]], nSNS, AmbTemp)
        
          ; Update state variables of spawning adults
          SNS[50, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[0, SpwnDL[SpwnCond[SpwnAdult2]]]; updates SNS fecundity (#eggs)
          SNS[8, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[1, SpwnDL[SpwnCond[SpwnAdult2]]]; updates SNS weight after spawning (g)
          SNS[13, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[2, SpwnDL[SpwnCond[SpwnAdult2]]]; updates SNS gonad after spawning (g)
          
          ; Update the spawning interval
          SNS[72, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[3, SpwnDL[SpwnCond[SpwnAdult2]]]; spawning interval
          PRINT, 'Spawning interval', MEAN(SNS[72, SpwnDL[SpwnCond[SpwnAdult2]]]), MAX(SNS[72, SpwnDL[SpwnCond[SpwnAdult2]]]) $
                                    , MIN(SNS[72, SpwnDL[SpwnCond[SpwnAdult2]]])                                            
          SNS[71, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[4, SpwnDL[SpwnCond[SpwnAdult2]]]; spawning day (continous)
          SNS[75, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[5, SpwnDL[SpwnCond[SpwnAdult2]]]; spawning day (annual)          
          SNS[76, SpwnDL[SpwnCond[SpwnAdult2]]] = SNSspwn[6, SpwnDL[SpwnCond[SpwnAdult2]]]; spawning frequency         
          PRINT, 'Spawning frequency', MEAN(SNS[76, SpwnDL[SpwnCond[SpwnAdult2]]]), MAX(SNS[76, SpwnDL[SpwnCond[SpwnAdult2]]]) $
                                    , MIN(SNS[76, SpwnDL[SpwnCond[SpwnAdult2]]])          
          
;          ; KS 
;          OptRho1 = 1.4 * 0.0912 * ALOG10(SNS[7, SpwnDL[SpwnCond[SpwnAdult2]]]); + 0.128*1.6; Optimal weight allocated as storage
;          Opt_wt1 = Optrho1 * SNS[8, SpwnDL[SpwnCond[SpwnAdult2]]]; optimal fractional storage weight 
;          OptWt1NZ = WHERE(Opt_wt1 GT 0., OptWt1NZcount, complement = OptWt1Z, ncomplement = OptWt1Zcount)
;          IF OptWt1NZcount GT 0. THEN SNS[11, SpwnDL[SpwnCond[SpwnAdult2[OptWt1NZ]]]] $
;                                      = (SNS[9, SpwnDL[SpwnCond[SpwnAdult2[OptWt1NZ]]]] $
;                                      + SNS[13, SpwnDL[SpwnCond[SpwnAdult2[OptWt1NZ]]]]) / Opt_wt1[OptWt1NZ]
;          
;          ; Update the reproductive cycel status after spawning
;          ;KS2 = 0.8; minimum index for initiating an annual spwawning cycle
;          SpwndAdult = WHERE((SNS[11, SpwnDL[SpwnCond[SpwnAdult2]]] GT KS2), SpwndAdultcount $
;                            , complement = NonSpwndAdult, ncomplement = NonSpwndAdultcount); 
;          ; Inidividuals that have spawned can resume a reproductive cycle when KS > KS2
;          IF (SpwndAdultcount GT 0.) THEN SNS[14, SpwnDL[SpwnCond[SpwnAdult2]]] = 1.; annual spawning cycle status
;          IF (NonSpwndAdultcount GT 0.) THEN SNS[14, SpwnDL[SpwnCond[SpwnAdult2]]] = 0.; annual spawning cycle status 
          
          ; Calculate total number of eggs spawned by all spawning adults 
          NpopSNSyoy = ROUND(TOTAL(SNSspwn[0, *]))
          PRINT, 'Total Number of eggs spawned', NpopSNSyoy
          
          ; Number of spawning females
          SNSspwnF = WHERE((SNS[4, *] EQ 1.) AND (SNSspwn[0, *] GT 0.), nSNSspwnFcount)
          PRINT, 'Number of spawning females (NSNSspwnFcount)', nSNSspwnFcount; number of spawning females
          
          ; Array locations of YOY  
          SNSyoy = WHERE((SNS[6, *] EQ 0.), SNSyoycount, complement = nSNSyoy, ncomplement = nSNSyoycount)
          
          ; Empty YOY array rows 
          SNSyoyZ = WHERE((SNS[6, *] EQ 0.) AND (SNS[4, *] LE 0.), SNSyoyZcount, complement = SNSyoyNZ, ncomplement = SNSyoyNZcount)
          ;SNS[6, *] = AGE
          ;SNSyoy = WHERE((SNS[6, *] EQ 0.) AND (SNS[4, *] LE 0.), SNSyoycount, complement = nSNSyoy, ncomplement = nSNSyoycount)
          ;SNS[6, *] = AGE -> only SIs w/o inds
          
          ; Distribute eggs to YOY array
          ;IF (SNSyoycount GT 0.) THEN SNS[4, SNSyoy] = SNS[4, SNSyoy] + ROUND(NpopSNSyoy/SNSyoycount)
          ; equally distribute spawned eggs to YOY SIs 
        
          ; Find spawning locations 
          SNSSpwnloc = WHERE(SNS[50, *] GT 0., SNSSpwnloccount)
          PRINT, 'Number of egg SIs (SNSSpwnloccount)', SNSSpwnloccount
         
          IF SNSSpwnloccount GT 0. THEN BEGIN; when females spawn...
            
            ; Randomly choose empty YOY array rows for egg deposition
            nRand = SNSSpwnloccount; number of spawning females
            nSNSyoyarr = SNSyoyZcount; number of empty YOY rows
            im = SNSyoyZ; array of empty YOY
            
            IF nSNSyoyarr GE SNSSpwnloccount THEN BEGIN
              arr = RANDOMU(seed, nSNSyoyarr)
              ind = SORT(arr)
              RandomYOYID = im[ind[0:nRand-1]]
              ;PRINT, 'Randomly selected YOY array locations(RandomYOYID)'; nRand random elements from im
              ;PRINT, RandomYOYID
                      
           ; Random number for all SNS ranging from 0-# cells with spawned eggs
              SNS[17, RandomYOYID] = SNS[17, SNSSpwnloc];
              SNS[4, RandomYOYID] = SNS[4, RandomYOYID] + ROUND(SNS[50, SNSSpwnloc])
              
              ; Egg and larval state variables are reset to 0
              DVsns[RandomYOYID] = 0.
              FEEDsns[RandomYOYID] = 0.
              SNS[7, RandomYOYID] = 0.
              SNS[8, RandomYOYID] = 0. 
              SNS[9, RandomYOYID] = 0.
              SNS[10, RandomYOYID] = 0.
              SNS[11, RandomYOYID] = 0.
              SNS[57, RandomYOYID] = 0.
              SNS[58, RandomYOYID] = 0. 
            ENDIF
            
            ; If there is not enough empty array rows, redistribute eggs equally to all YOY rows 
            IF nSNSyoyarr LT SNSSpwnloccount THEN SNS[4, SNSyoy] = SNS[4, SNSyoy] + ROUND(NpopSNSyoy/SNSyoycount)
          ENDIF; End of SNSSpwnloccount

          ; Whenever sturgeon spawn and eggs are distributed to SIs, embrionic and larval developments are reset (for now)
          ;IF ROUND(NpopSNSyoy/SNSyoycount) GT 0. THEN DVsns[SNSyoy] = 0.
          ;IF ROUND(NpopSNSyoy/SNSyoycount) GT 0. THEN FEEDsns[SNSyoy] = 0.
          
          ;SNSyoyZ = WHERE((SNS[6, *] EQ 0.) AND (SNS[4, *] LE 0.), SNSyoyZcount, complement = SNSyoyNZ, ncomplement = SNSyoyNZcount)
;          IF SNSyoyZcount GT 0. THEN BEGIN 
;            DVsns[SNSyoyZ] = 0.
;            FEEDsns[SNSyoyZ] = 0.
;          ENDIF    
         
         ; Total number of spawning females
         nSpwnFemale = nSpwnFemale + nSNSspwnFcount
        ENDIF; End of SpwnAdult2count
      ENDIF; End of SpwnAdultcount  
    ENDIF; End of SpwnDLcount
    PRINT, 'Total number of spawning females', nSpwnFemale
    IF NSpwnDLcount GT 0. THEN PRINT, 'Number of adults in suitable spawning habitat = ', 0
    

;    SpwnFemale = WHERE((SNS[14, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 1.), SpwnFemalecount)
;    SpwnMale = WHERE((SNS[14, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 0.), SpwnMalecount)
;    Spwnall = WHERE((SNS[14, LiveIndiv2] EQ 1), SpwnAllcount)
;    MatFemale = WHERE((SNS[12, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 1.), MatFemalecount)
;    MatMale = WHERE((SNS[12, LiveIndiv2] GE 1.) AND (SNS[5, LiveIndiv2] EQ 0.), MatMalecount)
;    Matall = WHERE((SNS[12, LiveIndiv2] EQ 1), MatAllcount)    
;    PRINT, 'Number of females in the reproductive cycle', SpwnFemalecount
;    PRINT, 'Number of males in the reproductive cycle', Spwnmalecount
;    PRINT, 'Number of all individuals in the reproductive cycle', SpwnAllcount
;        
;    IF SpwnFemalecount GT 0. THEN BEGIN
;      PRINT, 'GSI of females in the reproductive cycle', MEAN(SNS[59, LiveIndiv2[SpwnFemale]]), MAX(SNS[59, LiveIndiv2[SpwnFemale]]), MIN(SNS[59, LiveIndiv2[SpwnFemale]])
;      PRINT, 'KS of females in the reproductive cycle', MEAN(SNS[11, LiveIndiv2[SpwnFemale]]), MAX(SNS[11, LiveIndiv2[SpwnFemale]]), MIN(SNS[11, LiveIndiv2[SpwnFemale]])
;      PRINT, 'Age of females in the reproductive cycle', MEAN(SNS[6, LiveIndiv2[SpwnFemale]]), MAX(SNS[6, LiveIndiv2[SpwnFemale]]), MIN(SNS[6, LiveIndiv2[SpwnFemale]])
;    ENDIF
;    IF Spwnmalecount GT 0. THEN BEGIN
;      PRINT, 'GSI of males in the reproductive cycle', MEAN(SNS[59, LiveIndiv2[Spwnmale]]), MAX(SNS[59, LiveIndiv2[Spwnmale]]), MIN(SNS[59, LiveIndiv2[Spwnmale]]) 
;      PRINT, 'KS of males in the reproductive cycle', MEAN(SNS[11, LiveIndiv2[Spwnmale]]), MAX(SNS[11, LiveIndiv2[Spwnmale]]), MIN(SNS[11, LiveIndiv2[Spwnmale]])
;      PRINT, 'Age of males in the reproductive cycle', MEAN(SNS[6, LiveIndiv2[Spwnmale]]), MAX(SNS[6, LiveIndiv2[Spwnmale]]), MIN(SNS[6, LiveIndiv2[Spwnmale]])
;    ENDIF
;    IF SpwnAllcount GT 0. THEN BEGIN 
;      PRINT, 'Number of mature females', MatFemalecount
;      PRINT, 'Number of mature males', Matmalecount
;      PRINT, 'Number of all mature individuals', MatAllcount
;    ENDIF
;    
;    IF MatFemalecount GT 0. THEN BEGIN
;      PRINT, 'GSI of mature females', MEAN(SNS[59, LiveIndiv2[MatFemale]]), MAX(SNS[59, LiveIndiv2[MatFemale]]), MIN(SNS[59, LiveIndiv2[MatFemale]])
;      PRINT, 'KS of mature females', MEAN(SNS[11, LiveIndiv2[MatFemale]]), MAX(SNS[11, LiveIndiv2[MatFemale]]), MIN(SNS[11, LiveIndiv2[MatFemale]])
;      PRINT, 'Age of mature females', MEAN(SNS[6, LiveIndiv2[MatFemale]]), MAX(SNS[6, LiveIndiv2[MatFemale]]), MIN(SNS[6, LiveIndiv2[MatFemale]])
;    ENDIF
;    IF Matmalecount GT 0. THEN BEGIN
;      PRINT, 'GSI of mature males', MEAN(SNS[59, LiveIndiv2[Matmale]]), MAX(SNS[59, LiveIndiv2[Matmale]]), MIN(SNS[59, LiveIndiv2[Matmale]])     
;      PRINT, 'KS of mature males', MEAN(SNS[11, LiveIndiv2[Matmale]]), MAX(SNS[11, LiveIndiv2[Matmale]]), MIN(SNS[11, LiveIndiv2[Matmale]])
;      PRINT, 'Age of mature males', MEAN(SNS[6, LiveIndiv2[Matmale]]), MAX(SNS[6, LiveIndiv2[Matmale]]), MIN(SNS[6, LiveIndiv2[Matmale]])        
;    ENDIF
    
    
;    ; Update YOY array
;    YOY = WHERE((SNS[6, *] LT 1L) AND (SNS[4, *] GT 0L) , YOYcount, complement = YAO, ncomplement = YAOcount)
;    PRINT, 'Number of YOY SIs (YOYcount)', YOYcount    
      
      
    ;***Egg and yolk-sac larva development***
    ;***THE FOLLOWING SUBROUTEINES ARE ACTIVATED ONLY FOR YOY AFTER SPAWNING****************************
    SNSyoySpwn = WHERE((SNS[6, *] EQ 0.) AND (SNS[4, *] GT 0.), SNSyoySpwncount, complement = NSNSyoySpwn $
                      , ncomplement = NSNSyoySpwncount)

   
    IF (SNSyoySpwncount GT 0.) THEN BEGIN
      ; Egg develpment -> hatching occurs when DV > 1.0
      SNShat = SNShatch(iday, nSNS, DVsns, SNS[22, *], SNS, SNSyoySpwn); track development of shovelnose sturgeon eggs
      SNS[57, SNSyoySpwn] = DVsns[SNSyoySpwn]
      SNS[73, SNSyoySpwn] = SNShat[1, SNSyoySpwn]
        
      ; Check if hatching occurs
      SNScheck = WHERE(DVsns[SNSyoySpwn] GT 1.0, SNShatchcount, complement = nSNScheck, ncomplement = nSNShatchcount)

      IF SNShatchcount GT 0.0 THEN BEGIN
        ;SNS[73, SNSyoySpwn[SNScheck]] = iDAY
        
        ; Larval develpment to 1st exogenous feeding -> 1st feeding occurs when DVy > 1.0
        SNS1stfd = SNS1stfeed(iday, nSNS, FEEDsns, SNS[22, *], SNS, SNSyoySpwn[SNScheck])
        SNS[74, SNSyoySpwn[SNScheck]] = SNS1stfd[1, SNSyoySpwn[SNScheck]]
        
        ; track development of shovelnose sturgoen yolk-sac larvae

        ; Check if exogenous feeding has began
        SNScheck2 = WHERE((FEEDsns[SNSyoySpwn[SNScheck]] GT 1.0), SNSfeedcount, complement = nSNScheck2, ncomplement = nSNSfeedcount)
   
        ; An additional condition to assign initial state variables to new YOY only once 
        SNScheck3 = WHERE((FEEDsns[SNSyoySpwn[SNScheck]] GT 1.0) AND (SNS[58, SNSyoySpwn[SNScheck]] LT 1.) $
                         , SNSfeedcount2, complement = nSNScheck3, ncomplement = nSNSfeedcount2)
               
        ; New initial state variable values are assigned to YOY after they start exogenous feeding.
        IF SNSfeedcount2 GT 0.0 THEN BEGIN 
          SNS[74, SNSyoySpwn[SNScheck[SNScheck3]]] = iDAY
        
          SNS[7, SNSyoySpwn[SNScheck[SNScheck3]]] = SwimupIntL + RANDOMU(seed, SNSfeedcount2) * SwimupIntLSE
          ; randomly assigned using a normal distribution.
          ; after 6 dph, drifting larvae transition to benthic life stage (Braaten et al. 2008) 
            
          ; Assining weight, storage weight, structural weight 0.035*0.00001 * (length)^(2.8403*1.1573)
          SNS[10, SNSyoySpwn[SNScheck[SNScheck3]]] = 0.0366 * 0.00001 * (SNS[7, SNSyoySpwn[SNScheck[SNScheck3]]])^(2.8403 * 0.96)
          ; structural weight - length-based
          OptRho2 = 1.4*0.0912 * ALOG10((SNS[7, SNSyoySpwn[SNScheck[SNScheck3]]])); + 0.128 * 1.6; optimal rho - length-based

          ; Don't allow opt_rho to drop below 0.2(?) -> CHECK FOR STURGEON
          CheckRho2 = WHERE(optrho2[SNSyoySpwn[SNScheck[SNScheck3]]] LT 0.2, CheckRho2count)
          IF CheckRho2count GT 0 THEN optrho2[SNSyoySpwn[SNScheck[SNScheck3[CheckRho2]]]] = 0.2
          SNS[8, SNSyoySpwn[SNScheck[SNScheck3]]] = SNS[10, SNSyoySpwn[SNScheck[SNScheck3]]] / (1 - optrho2)
          ; total weight -> struc weight-based
          SNS[9, SNSyoySpwn[SNScheck[SNScheck3]]] = SNS[8, SNSyoySpwn[SNScheck[SNScheck3]]] - SNS[10, SNSyoySpwn[SNScheck[SNScheck3]]]
          ; storage weight = total wieght - struc weight

          ; Physiological condition
          SNS[11, SNSyoySpwn[SNScheck[SNScheck3]]] = SNS[9, SNSyoySpwn[SNScheck[SNScheck3]]]/(optrho2*SNS[8, SNSyoySpwn[SNScheck[SNScheck3]]])
        ENDIF; free embryos transition to larvae at about 15-16mm
        
        ; Update YOY feeding status  
        SNS[58, SNSyoySpwn[SNScheck]] = FEEDsns[SNSyoySpwn[SNScheck]]
        
        ; Update cumulative YOY swimup 
        NpopSNSyoyswimup = FLTARR(1)
        NpopSNSyoyswimup = (NpopSNSyoyswimup + SNSfeedcount2)*1.
      ENDIF ELSE SNScheck2 = -1; larvae have not settled
    ENDIF ELSE SNShatchcount = 0L; embryos have not hatched
;   SNScheck = 0L
;   SNScheck2 = -1
    ;ENDELSE           
    ;> Once YOY starts exogenous feeding, they go through the followng subroutines as superindividuals.
     
     ;***Update live individuals***
     ;>Feeding YOY, juveniles, and adults***
     ; feeding YOY & YAO    
     LiveIndiv = WHERE((SNS[7, *] GT 0.) AND (SNS[4, *] GT 0.), LiveIndivcount, complement = DeadIndiv, ncomplement = DeadIndivcount)
     ;SNS[7, *] = length; SNS[4, *] = #individuals
     PRINT, 'Number of post-settlement YOY SIs and YAO (LiveIndivcount)', LiveIndivcount     
     
     ; ALL YOY (after spawning) & YAO     
     LiveIndiv2 = WHERE((SNS[4, *] GT 0.), LiveIndiv2count, complement = DeadIndiv2, ncomplement = DeadIndiv2count)
     PRINT, 'Number of pre-settlement YOY and YAO (LiveIndiv2count)', LiveIndiv2count    
     
     ;***Longitudinal (1D) movement***            
     IF LiveIndiv2count GT 0. THEN BEGIN
       tsvm = ts/1.; FOR SHORTER TIME STEP FOR MOVEMENT
       ;FOR i2Minute = 0L, 0L DO BEGIN;******************iMINUTE LOOP***************** 
         SNSGridcellSize = 1000. * SNS[19, LiveIndiv2]
         SNSMoveL = SNSMove1DL(tsvm, SNS[*, LiveIndiv2], nSNS, HydroEnvir1D2, TotDriftBio2, SNS[33, LiveIndiv2] $
                              , LiveIndiv2, SNS[25, LiveIndiv2], SNSGridcellSize)
       ;ENDFOR 
        SNS[15:21, LiveIndiv2] = SNSmoveL[0:6, LiveIndiv2]  

       ;***Update turbidity***
       SNS[24, LiveIndiv2] = HydroEnvir1D2[11, SNS[17, LiveIndiv2]]; 
       SNS[27:31, LiveIndiv2] = SNSmoveL[7:11, LiveIndiv2]        
    
       ; Update within-cell locations
       SNS[33, LiveIndiv2] = SNSmoveL[12, LiveIndiv2]       
    
      ; Update total distance (km) traveled
       SNS[32, LiveIndiv2] = SNSmoveL[13, LiveIndiv2] 
       
      ; Number of individuals emigrate
       SNS[70, LiveIndiv2] = SNSmoveL[14, LiveIndiv2]  
       nEmmigUp = MEAN(SNSmoveL[16, LiveIndiv2])
       nEmigDown = MEAN(SNSmoveL[17, LiveIndiv2])
      
      ; update the number of individuals after emigration      
       SNS[4, LiveIndiv2] = SNSmoveL[15, LiveIndiv2] 
     ENDIF;
     
     
    ;***Update live individuals***
    ;>Feeding YOY, juveniles, and adults***
    ; feeding YOY & YAO    
    LiveIndiv = WHERE((SNS[7, *] GT 0.) AND (SNS[4, *] GT 0.), LiveIndivcount, complement = DeadIndiv, ncomplement = DeadIndivcount)

    ;SNS[7, *] = length
    ; ALL YOY (after spawning) & YAO     
    LiveIndiv2 = WHERE((SNS[4, *] GT 0.), LiveIndiv2count, complement = DeadIndiv2, ncomplement = DeadIndiv2count) 
    
    ;***Foraging/consumption***
    ;***Cmax*** 
    ;>> tempearture-dependent Cmax is updated every time step
    IF LiveIndivcount GT 0. THEN BEGIN
      SNScmx = SNScmax(SNS[8, LiveIndiv], SNS[7, LiveIndiv], nSNS, SNS[22, LiveIndiv], LiveIndiv)
      
      ; sets a limit for how much a SNS can eat in a 24 hr period
      ; Determine stomach capacity >>>> MAY NOT BE NEEDED FOR SIMULATIONS WITH A DAILY TIME STEP <<<<<<<<
      ;SstomCap = SNSstcap(SNS[2, *], nSNS) ; stomach capacity for shovelnose sturgeon
      
      ; Update size-based stomach capacity
      ;SNS[8, *] = SstomCap[*]; updates SNS stomach capacity (g)       
      ;SNS[34, LiveIndiv] = SNScmx[LiveIndiv]; Cmax (g/d)   
    ENDIF

    ;***Prey availability***
    ; for determining encounter rates
    ;***Biomass needs to be incoporated in to density dependence effects***
    ; Prey & competitor biomass (g/m2 or g/m3)
    ; shovelnose sturgeon
    SNSpbio[0, *] = SNS[27, *]; drift prey 1 
    SNSpbio[1, *] = SNS[28, *]; drift prey 2 
    SNSpbio[2, *] = SNS[29, *]; drift prey 3 
    SNSpbio[3, *] = SNS[30, *]; drift prey 4
    SNSpbio[4, *] = SNS[31, *]; drift prey 5
      
    ;***Create a fish prey array for potential competitors***        
    SNSFishComp = SNSFishArray1D(SNS, nSNS, nLonTran); Fish array for intra-/inter- specific interactions

    IF LiveIndivcount GT 0. THEN BEGIN  
      SNSGridcellSize = 1000. * SNS[19, LiveIndiv]; * (SNS[20, *] + ABS(SNS[21, *]*RANDOMN(SEED, nSNS))); grid cell size (in m3) 
      SNSGridcellSizeN0 = WHERE((SNSGridcellSize[LiveIndiv] GT 0.), SNSGridcellSizeN0count); 1km=1000m
      IF SNSGridcellSizeN0count GT 0. THEN BEGIN
        ; ****** The number of elements in SNSFishComp = nLonTran (162)
        ; Total YAO fish abundance and biomass for intra-/inter- specific interactions
        SNSpbio[11, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[1, SNS[17, LiveIndiv[SNSGridcellSizeN0]]]; length        
        SNSpbio[12, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[2, SNS[17, LiveIndiv[SNSGridcellSizeN0]]]; weight        
        SNSpbio[13, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[4, SNS[17, LiveIndiv[SNSGridcellSizeN0]]] / SNSGridcellSize[LiveIndiv[SNSGridcellSizeN0]]; abundance
        SNSpbio[14, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[5, SNS[17, LiveIndiv[SNSGridcellSizeN0]]] / SNSGridcellSize[LiveIndiv[SNSGridcellSizeN0]]; biomass
  ;      SNSpbio[16, SNSGridcellSizeN0] = SNSFishComp[11, SNS[17, SNSGridcellSizeN0]] / SNSGridcellSize[SNSGridcellSizeN0];
        SNSpbio[15, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[6, SNS[17, LiveIndiv[SNSGridcellSizeN0]]]; length        
        SNSpbio[16, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[7, SNS[17, LiveIndiv[SNSGridcellSizeN0]]]; weight        
        SNSpbio[17, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[8, SNS[17, LiveIndiv[SNSGridcellSizeN0]]] / SNSGridcellSize[LiveIndiv[SNSGridcellSizeN0]]; abundance
        SNSpbio[18, LiveIndiv[SNSGridcellSizeN0]] = SNSFishComp[9, SNS[17, LiveIndiv[SNSGridcellSizeN0]]] / SNSGridcellSize[LiveIndiv[SNSGridcellSizeN0]]; biomass
  ;      SNSpbio[16, SNSGridcellSizeN0] = SNSFishComp[11, SNS[17, SNSGridcellSizeN0]] / SNSGridcellSize[SNSGridcellSizeN0]; 
      ENDIF
    ENDIF
     
    ;***Foraging*** 
    IF LiveIndivcount GT 0. THEN BEGIN  
      SNSenc = SNSforage(SNS[6, LiveIndiv], SNS[7, LiveIndiv], SNS[8, LiveIndiv], SNS[22, LiveIndiv], SNS[24, LiveIndiv] $
                        , SNS[18, LiveIndiv], SNS[19, LiveIndiv], SNS[20, LiveIndiv], SNS[21, LiveIndiv], SNS[25, LiveIndiv] $
                        , SNSpbio[*, *], SNScmx[LiveIndiv], nSNS, SNS[*, LiveIndiv], LiveIndiv) 
     
      ; Update SNS cumulative total consumption per day (g)
      SNSeaten[0:4, LiveIndiv] = SNSenc[0:4, LiveIndiv]; the amount of prey items used for growth

      ;SNS[7, *] = SNSenc[9, *]; updates SNS stomach weight (g)
      SNS[34, LiveIndiv] = SNSenc[25, LiveIndiv]; relative to Cmax    
      SNS[35, LiveIndiv] = SNSenc[11, LiveIndiv]; updates SNS cumulative total consumption per day (g)
      SNS[36, LiveIndiv] = SNSenc[0, LiveIndiv]; total amount of drift prey 1 consumed in g
      SNS[37, LiveIndiv] = SNSenc[1, LiveIndiv]; total amount of drift prey 2 consumed in g
      SNS[38, LiveIndiv] = SNSenc[2, LiveIndiv]; total amount of drift prey 3 consumed in g
      SNS[39, LiveIndiv] = SNSenc[3, LiveIndiv]; total amount of drift prey 4 consumed in g
      SNS[40, LiveIndiv] = SNSenc[4, LiveIndiv]; total amount of drift prey 5 consumed in g
        
      ; number of prey consumed
      SNS[65, LiveIndiv] = SNSenc[6, LiveIndiv]; total # of drift prey 1 consumed 
      SNS[66, LiveIndiv] = SNSenc[7, LiveIndiv]; total # of drift prey 2 consumed 
      SNS[67, LiveIndiv] = SNSenc[8, LiveIndiv]; total # of drift prey 3 consumed 
      SNS[68, LiveIndiv] = SNSenc[9, LiveIndiv]; total # of drift prey 4 consumed
      SNS[69, LiveIndiv] = SNSenc[10, LiveIndiv]; total # of drift prey 5 consumed
        
      ; Prey specific ratio
      SNS[60, LiveIndiv] = SNSenc[20, LiveIndiv]; total amount of drift prey 1 consumed in g
      SNS[61, LiveIndiv] = SNSenc[21, LiveIndiv]; total amount of drift prey 2 consumed in g
      SNS[62, LiveIndiv] = SNSenc[22, LiveIndiv]; total amount of drift prey 3 consumed in g
      SNS[63, LiveIndiv] = SNSenc[23, LiveIndiv]; total amount of drift prey 4 consumed in g
      SNS[64, LiveIndiv] = SNSenc[24, LiveIndiv]; total amount of drift prey 5 consumed in g
        
      ; Foraging cost
      SNS[41, LiveIndiv] = SNSenc[12, LiveIndiv]; SwimCost, J/d
      SNS[42, LiveIndiv] = SNSenc[13, LiveIndiv]; cpature cost for drift prey 1, J/d
      SNS[43, LiveIndiv] = SNSenc[14, LiveIndiv]; cpature cost for drift prey 2, J/d
      SNS[44, LiveIndiv] = SNSenc[15, LiveIndiv]; cpature cost for drift prey 3, J/d
      SNS[45, LiveIndiv] = SNSenc[16, LiveIndiv]; cpature cost for drift prey 4, J/d
      SNS[46, LiveIndiv] = SNSenc[17, LiveIndiv]; cpature cost for drift prey 5, J/d 
    ENDIF;

    ;***Drift prey consumption by sturgeon***
    SNSDeadPrey = SNSDeadPreyArray1D(SNSenc, SNS, nSNS, nLonTran)
    TotDriftCons = SNSDeadPrey[5, *]
    TotDriftBioNZ = WHERE(TotDriftBio GT 0., TotDriftBioNZcount)

    IF TotDriftBioNZcount GT 0. THEN DriftConsRatio[TotDriftBioNZ] = (TotDriftCons[TotDriftBioNZ] / GridcellArea[TotDriftBioNZ]) / TotDriftBio[TotDriftBioNZ]
    TotDriftBio = (TotDriftBio[*]*HydroEnvir1D2[8, *]*1000. - TotDriftCons[*])/(HydroEnvir1D2[8, *]*1000.)

    ;***Respiration/Routine metabolism*** 
    IF LiveIndivcount GT 0. THEN BEGIN
      SNSres = SNSresp(SNS[6, LiveIndiv], SNS[22, LiveIndiv], SNS[8, LiveIndiv], SNS[7, LiveIndiv], ts, nSNS $
                      , SNS[*, LiveIndiv], LiveIndiv);  determine respiration for shovelnose sturgeon

     ; Update daily respiration rates
      SNS[49, LiveIndiv] = SNSres[0, LiveIndiv]; total RESPIRATION RATE
    ENDIF;******************************************************************
  
  
    ;***GROWTH***
    ; If fish reach minimum length at maturity (different for males and females)-> from the literature
    ; then age at maturity is determined

    ;>>>>Estimate energy/weight allocation rates for soma, storage, and gonad...>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; use monthly schedule for energy allocation to soma, storage, and gonad (?)    
     ; The reproductive cycle is between the end of growing season and the spawning day....
    ; Spawning mature adults...
    ; AND Check for the physiological codition
    
    ;Mature = WHERE(SNS[12, *] EQ 1., Maturecount, complement = Immature, ncomplement = Immaturecount); Maturity = SNS[12, *]
    ; Check for maturity status...>>> body length-dependent
    
    ;>>> Check if fish reached maturity at the end of the growing season (?)
    ; once fish have reached maturity, no need to check these individuals.
    ; Maturity = ; immature = 0; mature = 1
    IF LiveIndivcount GT 0. THEN BEGIN; LiveIndiv = feeding individuals
      LiveMature = WHERE(SNS[12, LiveIndiv] GT 0., LiveMaturecount); 
      LiveImmature = WHERE(SNS[12, LiveIndiv] LE 0., LiveImmaturecount); 
      
      IF (LiveMaturecount GT 0.) THEN BEGIN; Mature feeding individuals >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;       IF (iDay EQ IntDay) THEN BEGIN
;         KS2 = 0.8; minimum index for initiating an annual spwawning cycle
;         LiveSpwnAdult = WHERE((SNS[11, LiveIndiv[LiveMature]] GT KS2), LiveSpwnAdultcount);
;         LiveNonSpwnAdult = WHERE((SNS[11, LiveIndiv[LiveMature]] LE KS2), LiveNonSpwnAdultcount);
;             
;         KS = physiological condition = SNS[11, *]
;         CREATE STATE VARIABLE FOR ANNUAL SPAWNING STATUS
;         AnnuSpawn = 1.; spawning, AnnuSpawn = 0.; non-spawning
;         IF (LiveSpwnAdultcount GT 0.) THEN SNS[14, LiveIndiv[LiveMature[LiveSpwnAdult]]] = 1.; annual spawning cycle status
;         IF (LiveNonSpwnAdultcount GT 0.) THEN SNS[14, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = 0.
;       ENDIF

        LiveSpwnAdult = WHERE((SNS[14, LiveIndiv[LiveMature]] GT 0.), LiveSpwnAdultcount); 
        LiveNonSpwnAdult = WHERE((SNS[14, LiveIndiv[LiveMature]] LE 0.), LiveNonSpwnAdultcount); 
                                              
      ; Estimate physiological condition using KS to determine energy allocaiton to gonad
      ; At the beginning of each annual spwaning cycle, check (only once) for maturity 
      ; and physiological condition to initiate the spawning cycle...
      ; Check if fish are in the spawning cycle (KS > KS2), if so, check for the physiological condition...
      ; -> this state variable lasts for the whole annual spawning cycle 
      ; >>>> MAY NEED TO CREATE THEIR REPRODUCTIVE STATUS AS A STATE VARIABLE<<<<
        
        ;>Spawning mature fish         
        IF (LiveSpwnAdultcount GT 0.) THEN BEGIN; spawning adults >>>>check for the thresholds<<<<<<    
          PRINT, 'Number of mature fish in the reproductive cycle', N_ELEMENTS(LiveIndiv[LiveMature[LiveSpwnAdult]])      
        
          ; Need to code for maturity status-based conditional statement      
          ; continue the spawning cycle        
          ; >>>> CHANGE THE FILE NAME "MATURE" <<<<<<<<<<<<<<<<<<<<<<<<<     
          SNSgro = SNSgrowthSpwn(SNS[7, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[8, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[9, LiveIndiv[LiveMature[LiveSpwnAdult]]],$
                                 SNS[10, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[13, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[5, LiveIndiv[LiveMature[LiveSpwnAdult]]],$
                                 SNS[54, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[55, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[56, LiveIndiv[LiveMature[LiveSpwnAdult]]],$ 
                                 SNS[14, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNScmx[LiveIndiv[LiveMature[LiveSpwnAdult]]], SNSeaten[*, LiveIndiv[LiveMature[LiveSpwnAdult]]],$ 
                                 SNSres[*, LiveIndiv[LiveMature[LiveSpwnAdult]]], SNS[22, LiveIndiv[LiveMature[LiveSpwnAdult]]], nSNS, iday, LiveSpwnAdultcount,$
                                 LiveIndiv[LiveMature[LiveSpwnAdult]], iyear, SNS[17, LiveIndiv[LiveMature[LiveSpwnAdult]]])                                       
        
          ; Update body size
          SNS[7, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[1, LiveIndiv[LiveMature[LiveSpwnAdult]]]; length (mm)
          SNS[8, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[0, LiveIndiv[LiveMature[LiveSpwnAdult]]]; weight (g)
          SNS[9, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[3, LiveIndiv[LiveMature[LiveSpwnAdult]]]; storage weight (g)   
          SNS[10, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[2, LiveIndiv[LiveMature[LiveSpwnAdult]]]; structure weight (g)
          SNS[11, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[9, LiveIndiv[LiveMature[LiveSpwnAdult]]]; KS
          SNS[13, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[6, LiveIndiv[LiveMature[LiveSpwnAdult]]]; gonad weight (g)
          SNS[47, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[4, LiveIndiv[LiveMature[LiveSpwnAdult]]]; daily growth in length (mm)   
          SNS[48, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[5, LiveIndiv[LiveMature[LiveSpwnAdult]]]; daily growth in weight (g)
          ;SNS[62, *] = SNS[62, *] + SNSgro[5, *]; growth in gonad weight (g)
          SNS[14, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[8, LiveIndiv[LiveMature[LiveSpwnAdult]]]; intermittent spawning cycle status
          SNS[59, LiveIndiv[LiveMature[LiveSpwnAdult]]] = SNSgro[10, LiveIndiv[LiveMature[LiveSpwnAdult]]]; GSI
          ;PRINT,'SNS[11, LiveIndiv[LiveMature[LiveSpwnAdult]]]'
          ;PRINT, transpose(GrowthAttribute[10, SNSSpwnArray])
          ;PRINT, MEAN(SNS[11, LiveIndiv[LiveMature[LiveSpwnAdult]]]), MAX(SNS[11, LiveIndiv[LiveMature[LiveSpwnAdult]]]), MIN(SNS[11, LiveIndiv[LiveMature[LiveSpwnAdult]]])  
          ;PRINT,'SNS[59, LiveIndiv[LiveMature[LiveSpwnAdult]]]'
          ;PRINT, transpose(GrowthAttribute[10, SNSSpwnArray])
          ;PRINT, MEAN(SNS[59, LiveIndiv[LiveMature[LiveSpwnAdult]]]), MAX(SNS[59, LiveIndiv[LiveMature[LiveSpwnAdult]]]), MIN(SNS[59, LiveIndiv[LiveMature[LiveSpwnAdult]]])  
          nSpwnAbort = TOTAL(SNSgro[12, LiveIndiv[LiveMature[LiveSpwnAdult]]])
          PRINT, 'NUMBER OF ABORTIONS', nSpwnAbort
        ENDIF
        
        ;>Non-spawning mature fish 
        IF (LiveNonSpwnAdultcount GT 0.) THEN BEGIN;l non-spawning adults >>> Once they abort spawning, no spawning for that year.
          PRINT, 'Number of mature fish NOT in the reproductive cycle', N_ELEMENTS(LiveIndiv[LiveMature[LiveNonSpwnAdult]])
          SNSgro = SNSgrowthNSpwn(SNS[6, LiveIndiv[LiveMature[LiveNonSpwnAdult]]], SNS[7, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] $
                                 , SNS[8, LiveIndiv[LiveMature[LiveNonSpwnAdult]]], SNS[9, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] $
                                 , SNS[10, LiveIndiv[LiveMature[LiveNonSpwnAdult]]], SNS[13, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] $
                                 , SNS[5, LiveIndiv[LiveMature[LiveNonSpwnAdult]]], SNScmx[LiveIndiv[LiveMature[LiveNonSpwnAdult]]] $
                                 , SNSeaten[*, LiveIndiv[LiveMature[LiveNonSpwnAdult]]], SNSres[*, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] $
                                 , SNS[22, LiveIndiv[LiveMature[LiveNonSpwnAdult]]], nSNS, iday, LiveNonSpwnAdultcount $
                                 , LiveIndiv[LiveMature[LiveNonSpwnAdult]])
         
          ; Update body size
          SNS[7, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[1, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; length (mm)
          SNS[8, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[0, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; weight (g)
          SNS[9, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[3, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; storage weight (g)   
          SNS[10, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[2, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; structure weight (g)
          SNS[11, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[9, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; KS         
          SNS[13, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[6, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; gonad weight (g)
          SNS[47, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[4, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; daily growth in length (mm)   
          SNS[48, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[5, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; daily growth in weight (g)
          SNS[59, LiveIndiv[LiveMature[LiveNonSpwnAdult]]] = SNSgro[10, LiveIndiv[LiveMature[LiveNonSpwnAdult]]]; GSI
          ;SNS[62, *] = SNS[62, *] + SNSgro[5, *]; updates SNS growth in gonad weight (g)                                        
        ENDIF; End of LiveNonSpwnAdultcount
        
      ENDIF; End of LiveMaturecount
       
      ;>Immature fish
      IF (LiveImmaturecount GT 0.) THEN BEGIN
       PRINT, 'Number of immature fish', N_ELEMENTS(LiveIndiv[LiveImmature]) 
        ; >terminate the spwaning cycle -> enter the non-spawning cycle and reallocate energy from gonad  
        SNSgro = SNSgrowthNSpwn(SNS[6, LiveIndiv[LiveImmature]], SNS[7, LiveIndiv[LiveImmature]], SNS[8, LiveIndiv[LiveImmature]] $
                               , SNS[9, LiveIndiv[LiveImmature]], SNS[10, LiveIndiv[LiveImmature]], SNS[13, LiveIndiv[LiveImmature]] $
                               , SNS[5, LiveIndiv[LiveImmature]], SNScmx[LiveIndiv[LiveImmature]], SNSeaten[*, LiveIndiv[LiveImmature]] $
                               , SNSres[*, LiveIndiv[LiveImmature]], SNS[22, LiveIndiv[LiveImmature]], nSNS, iday $
                               , LiveImmaturecount, LiveIndiv[LiveImmature])
      
        ; Update body size
        SNS[7, LiveIndiv[LiveImmature]] = SNSgro[1, LiveIndiv[LiveImmature]]; updates SNS length (mm)
        SNS[8, LiveIndiv[LiveImmature]] = SNSgro[0, LiveIndiv[LiveImmature]]; updates SNS weight (g)
        SNS[9, LiveIndiv[LiveImmature]] = SNSgro[3, LiveIndiv[LiveImmature]]; updates SNS storage weight (g)   
        SNS[10, LiveIndiv[LiveImmature]] = SNSgro[2, LiveIndiv[LiveImmature]]; updates SNS structure weight (g)
        SNS[11, LiveIndiv[LiveImmature]] = SNSgro[9, LiveIndiv[LiveImmature]]; updates SNS KS      
        ;SNS[13, Immature] = SNSgro[6, Immature]; updates SNS gonad weight (g)
        SNS[47, LiveIndiv[LiveImmature]] = SNSgro[4, LiveIndiv[LiveImmature]]; updates SNS daily growth in length (mm)   
        SNS[48, LiveIndiv[LiveImmature]] = SNSgro[5, LiveIndiv[LiveImmature]]; updates SNS daily growth in weight (g)
        ;SNS[62, *] = SNS[62, *] + SNSgro[5, *]; updates SNS growth in gonad weight (g)
      ENDIF; End of LiveImmaturecount
    ENDIF; End of LiveIndivcount
   
   ;***Mortality***
   IF ((SNSyoySpwncount GT 0.)) THEN BEGIN; Total mortality = predation + starvation
    IF (SNShatchcount GT 0.) THEN BEGIN
      IF (SNSfeedcount GT 0.) THEN BEGIN; WHEN EXOGENOUS FEEDING OCCURS
        SNSlost = SNSmortYOYswimup(SNS[1, *], SNS[3, *], SNS[4, *], SNS[0, *], nSNS, SNSyoySpwn[SNScheck[SNScheck2]], SNS[24, *])
        ; mortality of shovelnose sturgeon
        PRINT,'Swimp-upmortality (SNSlost1)'
      
        ; Update numbers of individuals
        SNS[51, SNSyoySpwn[SNScheck[SNScheck2]]] = SNSlost[0, SNSyoySpwn[SNScheck[SNScheck2]]]; predation; 
        SNS[52, SNSyoySpwn[SNScheck[SNScheck2]]] = SNSlost[1, SNSyoySpwn[SNScheck[SNScheck2]]]; starvation; 
        
        ; Remove individuals from predation (0), starvation (1) FOR feeding YOY
        SNS[4, SNSyoySpwn[SNScheck[SNScheck2]]] = SNS[4, SNSyoySpwn[SNScheck[SNScheck2]]] $
                                      - SNSlost[0, SNSyoySpwn[SNScheck[SNScheck2]]] - SNSlost[1, SNSyoySpwn[SNScheck[SNScheck2]]]
                                      ; no fishing mortality       
        SNSyoyOverkill1 = WHERE((SNS[4, SNSyoySpwn[SNScheck[SNScheck2]]] LT 0.), SNSyoyOverkill1count $
                               , complement = SNSyoyNOverkill1, ncomplement = SNSyoyNOverkill1count)
        IF SNSyoyOverkill1count GT 0. THEN SNS[4, SNSyoySpwn[SNScheck[SNScheck2[SNSyoyOverkill1]]]] = 0
      ENDIF; End of SNSfeedcount
    ENDIF; End of SNShatchcount
    IF (SNShatchcount GT 0.) THEN BEGIN; WHEN ONLY HATCHING OCCURS
      IF (NSNSfeedcount GT 0.) THEN BEGIN; WHEN EXOGENOUS FEEDING OCCURS
        SNSlost = SNSmortYOYyolksac(SNS[7, *], SNS[9, *], SNS[10, *], SNS[4, *], nSNS, SNSyoySpwn[SNScheck[NSNScheck2]] $
                                   , SNS[24, *], SNS[22, *])
        ; mortality of shovelnose sturgeon
        PRINT,'Yolksac mortality (SNSlost2)'
;
        ; Update numbers of individuals
        SNS[51, SNSyoySpwn[SNScheck[NSNScheck2]]] = SNSlost[0, SNSyoySpwn[SNScheck[NSNScheck2]]]; predation;    
        SNS[53, SNSyoySpwn[SNScheck[NSNScheck2]]] = SNSlost[2, SNSyoySpwn[SNScheck[NSNScheck2]]]; thermal mortality    
        ; Remove individuals by predation (0) and thermal morality (2)
        SNS[4, SNSyoySpwn[SNScheck[NSNScheck2]]] = SNS[4, SNSyoySpwn[SNScheck[NSNScheck2]]] $
                         - SNSlost[0, SNSyoySpwn[SNScheck[NSNScheck2]]] - SNSlost[2, SNSyoySpwn[SNScheck[NSNScheck2]]]
                         ; no fishing mortality           
        SNSyoyOverkill2 = WHERE((SNS[4, SNSyoySpwn[SNScheck[NSNScheck2]]] LT 0.), SNSyoyOverkill2count)
        IF SNSyoyOverkill2count GT 0. THEN SNS[4, SNSyoySpwn[SNScheck[NSNScheck2[SNSyoyOverkill2]]]] = 0
      ENDIF; End of NSNSfeedcount
    ENDIF ELSE BEGIN; WHEN ONLY SPAWNING OCCURS
      SNSlost = SNSmortYOYegg(SNS[7, *], SNS[9, *], SNS[10, *], SNS[4, *], nSNS, SNSyoySpwn[NSNScheck], SNS[24, *], SNS[22, *]) 
      PRINT,'Egg mortality (SNSlost3)'
;     
      ; Update numbers of individuals
      SNS[51, SNSyoySpwn[NSNScheck]] = SNSlost[0, SNSyoySpwn[NSNScheck]]; predation
      SNS[53, SNSyoySpwn[NSNScheck]] = SNSlost[2, SNSyoySpwn[NSNScheck]]; thermal mortality
      
      ; Remove individuals by predation (0) and thermal morality (2)
      SNS[4, SNSyoySpwn[NSNScheck]] = SNS[4, SNSyoySpwn[NSNScheck]] - SNSlost[0, SNSyoySpwn[NSNScheck]] $
                                    - SNSlost[2, SNSyoySpwn[NSNScheck]]; no fishing mortality    
      SNSyoyOverkill3 = WHERE((SNS[4, SNSyoySpwn[NSNScheck]] LT 0.), SNSyoyOverkill3count)
      IF SNSyoyOverkill3count GT 0. THEN SNS[4, SNSyoySpwn[NSNScheck[SNSyoyOverkill3]]] = 0
    ENDELSE
   ENDIF; ELSE BEGIN; WHEN NO SPAWNING OCCURS >>> YAO only
   IF YAOcount GT 0. THEN BEGIN
    SNSlost = SNSmortYAO(SNS[6, *], SNS[7, *], SNS[9, *], SNS[10, *], SNS[13, *], SNS[4, *], nSNS, YAO, SNS[24, *])
    
    ; mortality of YAO shovelnose sturgeon  
    PRINT,'YAO Stravation Mortality (SNSlost4)'
    PRINT, TOTAL(SNSlost[1, *]) 
    SNS[51, YAO] = SNSlost[0, YAO] ; background predation mortality 
    SNS[52, YAO] = SNSlost[1, YAO]; starvation mortality
    SNS[53, YAO] = SNSlost[2, YAO]; fishing mortality
    SNS[4, YAO] = SNS[4, YAO] - SNSlost[0, YAO] - SNSlost[1, YAO] - SNSlost[2, YAO] 

   ; Individuals dies (YAO)
    DeadYAO = WHERE((SNS[4, YAO] LE 0.), DeadYAOcount, complement = AliveYAO, ncomplement = AliveYAOcount) 
    IF DeadYAOcount GT 0. THEN SNS[4, YAO[DeadYAO]] = 0; SNS[4, YAO] - SNSlost[0, YAO] - SNSlost[1, YAO]; - SNSlost[1, YAO]
   ENDIF; End of YAOcount
         
  ; Create daily summary statistics
  HydroYear = HydroEnvir1D2[0L, 0L]
  LiveIndiv2 = WHERE((SNS[4, *] GT 0.), LiveIndiv2count, complement = DeadIndiv2, ncomplement = DeadIndiv2count)
  SNSsum = SNSsumStat(SNS[*, LiveIndiv2], nSumStatVar, iday, HydroYear, nSpwnAbort, nEmmigUp, nEmigDown, TotalRiverVol, TotalRiverArea, TotDriftCons, DriftConsRatio)
  PopSpace = PopSpaceOutput(SNS[*, LiveIndiv2], nLonTran, GridcellArea)
  ReproFPopSpace = ReproFPopSpaceOutput(SNS[*, LiveIndiv2], nLonTran, GridcellArea)
  SwimupPopSpace = SwimupPopSpaceOutput(SNS[*, LiveIndiv2], nLonTran, GridcellArea)
  
  ; Identify the location of reprodutive females
  ReproF = WHERE((SNS[14, *] GT 0.) AND (SNS[5, *] GT 0.), ReproFcount)
  IF ReproFcount GT 0. THEN ReproFloc = SNS[17, ReproF]
  PRINT, 'Number of reproductive females', N_ELEMENTS(ReproFloc)
  
  nSubsamReproF = 500
  randomNumbers = RANDOMU(seed, N_ELEMENTS(ReproFloc)); random number for YOY superindividual ID 
  sortedRandomNumbers = SORT(randomNumbers)     
  ReproFloc2 = SNS[17, ReproF[sortedRandomNumbers[0L:nSubsamReproF-1L]]]; randomly assign YOY to superindividuals  
  PRINT, N_ELEMENTS(ReproFloc2)
  
  ; To export only summary statistices
  IF iYear GE 1990 THEN OutputFiles = river1d_seibm_sumout(counter, nSNS, SNSsum, TotDriftBio2, PopSpace, ReproFPopSpace, SwimupPopSpace, ReproFloc2, EndDisChem, DensityDependence, Time, Rep)

   ;***Reset cumulative daily consumption, respiration, growth, fecundity, and mortality at the end of the daily loop***
  ; Fecundity
  SNS[50, *] = 0.; the number of eggs
  nSpwnAbort = 0.; NUMBER OF ABORTED SPAWNING
  SNS[34, *] = 0.; daily consumption relative to Cmax (g) 
  SNS[35, *] = 0.; daily total consumption (g)
  SNS[36, *] = 0.; total amount of drift prey 1 in g
  SNS[37, *] = 0.; total amount of drift prey 2 in g
  SNS[38, *] = 0.; total amount of drift prey 3 in g
  SNS[39, *] = 0.; total amount of drift prey 4 in g
  SNS[40, *] = 0.; total amount of drift prey 5 in g
  SNS[47, *] = 0.; growth in length (mm)   
  SNS[48, *] = 0.; growth in weight (g)
  SNS[49, *] = 0.; respiration   
  SNS[51, *] = 0.; daily predation
  SNS[52, *] = 0.; daily starvation
  SNS[53, *] = 0.; daily fishing or thermal morality (eggs & yorksac)

  ;***NEED TO CHANGE INITIAL TOTAL NUMBER OF POPULATIONS***
  ; Shovelnose sturgeon
  PRINT, 'Total number of surviving YAO SNS individuals at the end of DAY', iday, '     =', TOTAL(SNS[4, YAO])
  PRINT, 'Total biomass of surviving YAO SNS individuals at the end of DAY', iday, '     =', TOTAL(SNS[4, YAO]*SNS[8, YAO]) 
  PRINT, '% surviving YAO SNS individuals at the end of DAY', iday, '     =', TOTAL(SNS[4, YAO])/(NpopSNS);
  PRINT, 'Total number of surviving YOY SNS individuals at the end of DAY', iday, '     =', TOTAL(SNS[4, YOY])
  PRINT, 'Total biomass of surviving YOY SNS individuals at the end of DAY', iday, '     =', TOTAL(SNS[4, YOY]*SNS[8, YOY]) 

    t_elapsed = systime(/seconds) - tstart3
    PRINT, 'Elapesed time (minutes) in a DAILY loop:', t_elapsed/60.
  ENDFOR;********************************************END OF A DAILY LOOP**********************************************************
    
     ; Reset some state variables at the end of each simmulation year
     ; Total number of YOY swim-up
     NpopSNSyoyswimup = 0.; 
     nSpwnFemale = 0.; total number of spawning females
    SNS[70, *] = 0.; emigration
    ;SNS[72, *] = 0.; spawning interval
    SNS[73, *] = 0.; hatching day
    SNS[74, *] = 0.; settlement day
    SNS[75, *] = 0.; spawning day (ANNUAL)
      
  t_elapsed = systime(/seconds) - tstart2
  ;PRINT, 'Elapesed time (seconds) in a YEARLY loop:', t_elapsed  
  PRINT, 'Elapesed time (minutes) in a YEARLY loop:', t_elapsed/60.
  PRINT, 'Elapesed time (hours) in a YEARLY loop:', t_elapsed/60./60.
ENDFOR;***********************************END OF A YEARLY LOOP*******************************************************************

  
t_elapsed = systime(/seconds) - tstart1
;PRINT, 'Elapesed time (seconds) for all simulations:', t_elapsed 
PRINT, 'Elapesed time (minutes) for all simulations:', t_elapsed/60. 
PRINT, 'Elapesed time (hours) for all simulations:', t_elapsed/60./60. 
PRINT, 'END OF ALL SIMULATIONS'
END