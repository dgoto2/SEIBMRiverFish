FUNCTION river1d_hydrology_input, iYEAR, ForecastScenario, SpatialUniformDisc, RandInputYear2, PropAddFlow, $
                                    FlowAugIntYear, FlowAugLastYear; HydroChange1, HydroChange2;, DOY, TotDriftBio
; Function to read in hydrology input files for the Lower Platte River, Nebraska obtained 
; from the USGS Natioanl Water Information System (http://waterdata.usgs.gov/nwis)
;***open the file for reading as file unit 1:

PRINT, '1D Hydrology Input Files Begins Here'
tstart = systime(/seconds)

;; Change in probability to select hydrological year for forecating
;HydroChange1 = 0.; proportional change in frequency of wet conditions
;HydroChange2 = 0.; proportional change in frequency of dry conditions

; Directory: forbeslab
;IF iYEAR LE 2011L THEN BEGIN  
;  ; 1992-1994 are burn-in simulations using the 1995 input
;  ; YEAR 1990
;  IF iYEAR EQ 1990L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1991
;  IF iYEAR EQ 1991L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1992
;  IF iYEAR EQ 1992L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1993
;  IF iYEAR EQ 1993L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1994
;  IF iYEAR EQ 1994L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  
;  
;  ; YEAR 1995
;  IF iYEAR EQ 1995L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1996 
;  IF iYEAR EQ 1996L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1997
;  IF iYEAR EQ 1997L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1998
;  IF iYEAR EQ 1998L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1999 
;  IF iYEAR EQ 1999L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2000
;  IF iYEAR EQ 2000L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2001
;  IF iYEAR EQ 2001L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2002 
;  IF iYEAR EQ 2002L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2003
;  IF iYEAR EQ 2003L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2004
;  IF iYEAR EQ 2004L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2005 
;  IF iYEAR EQ 2005L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2006
;  IF iYEAR EQ 2006L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2007
;  IF iYEAR EQ 2007L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2008 
;  IF iYEAR EQ 2008L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2009
;  IF iYEAR EQ 2009L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2010
;  IF iYEAR EQ 2010L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2011 
;  IF iYEAR EQ 2011L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;ENDIF

;IF iYEAR GE 2012L THEN BEGIN
;  PRINT, 'INPUT YEAR FOR FORECASTING: ', RandInputYear2
;  ; YEAR 1995
;  IF RandInputYear2 EQ 1995L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1996 
;  IF RandInputYear2 EQ 1996L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1997
;  IF RandInputYear2 EQ 1997L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1998
;  IF RandInputYear2 EQ 1998L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 1999 
;  IF RandInputYear2 EQ 1999L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2000
;  IF RandInputYear2 EQ 2000L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2001
;  IF RandInputYear2 EQ 2001L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2002 
;  IF RandInputYear2 EQ 2002L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2003
;  IF RandInputYear2 EQ 2003L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2004
;  IF RandInputYear2 EQ 2004L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2005 
;  IF RandInputYear2 EQ 2005L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2006
;  IF RandInputYear2 EQ 2006L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2007
;  IF RandInputYear2 EQ 2007L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2008 
;  IF RandInputYear2 EQ 2008L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2009
;  IF RandInputYear2 EQ 2009L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2010
;  IF RandInputYear2 EQ 2010L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ; YEAR 2011 
;  IF RandInputYear2 EQ 2011L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;ENDIF
; For hypothetical simulation experiments, run 20-30 years

; Forecasting (2012 + years of forecasts (YOF))
; In each simulation year, the input is randomly selected from 1995 to 2011



;; Normal hydrological year scenarios (N = 4): 2001, 2007-2009
;;IF (iYEAR GE 1990L) AND (iYEAR LE 2011L) THEN BEGIN
;IF (iYEAR GT 2011L) AND (ForecastScenario EQ 0) THEN BEGIN
;  RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(5) - MIN(1)) + MIN(1)); 
;  IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;ENDIF
;
;; Wet hydrological year scenarios (N = 8): 1995-2000, 2010-2011
;;IF (iYEAR GE 1990L) AND (iYEAR LE 2011L) THEN BEGIN
;IF (iYEAR GT 2011L) AND (ForecastScenario EQ 1) THEN BEGIN
;  RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(9) - MIN(1)) + MIN(1)); 
;  IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 5L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 6L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 7L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 8L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;ENDIF
;
;; Dry hydrological year scenarios (N = 5): 2002-2006
;;IF (iYEAR GE 1990L) AND (iYEAR LE 2011L) THEN BEGIN
;IF (iYEAR GT 2011L)  AND (ForecastScenario EQ 2) THEN BEGIN
;  RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(6) - MIN(1)) + MIN(1)); 
;  IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 5L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;ENDIF
;
;
;; Random hydrological year (N = 17); 1995-2011
;IF (iYEAR GT 2011L) AND (ForecastScenario EQ 3) THEN BEGIN
;  RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(18) - MIN(1)) + MIN(1)); 
;  IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;
;  IF RandNormYear EQ 5L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 6L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 7L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 8L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 9L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 10L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 11L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 12L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;
;  IF RandNormYear EQ 13L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 14L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 15L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 16L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  IF RandNormYear EQ 17L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;ENDIF
;
;; Hydrological conditions based on 1947-2011 data
;IF (iYEAR GT 2011L) AND (ForecastScenario EQ 4) THEN BEGIN
;  HydroWetFreq = 0.3692 * (1. + HydroChange1)
;  HydroDryFreq = 0.2615 * (1. + HydroChange2)
;  HydroNormFreq = 1. - HydroWetFreq - HydroDryFreq
;    REPEAT BEGIN
;      ProbHydroNorm = RANDOMU(seed, /double)
;      IF ProbHydroNorm LT HydroNormFreq THEN HydroNorm = 1 ELSE HydroNorm = 0
;      ProbHydroWet = RANDOMU(seed, /double)
;      IF ProbHydroWet LT HydroWetFreq THEN HydroWet = 1 ELSE HydroWet = 0
;      ProbHydroDry = RANDOMU(seed, /double)
;      IF ProbHydroDry LT HydroDryFreq THEN HydroDry = 1 ELSE HydroDry = 0
;      HydroCond = HydroNorm+HydroWet+HydroDry
;    ENDREP UNTIL HydroCond EQ 1
;    IF HydroNorm GT 0 THEN HydroCond = HydroNorm*1
;    IF HydroWet GT 0 THEN HydroCond = HydroWet*2
;    IF HydroDry GT 0 THEN HydroCond = HydroDry*3
;    IF HydroNorm GT 0 THEN PRINT, 'Hydrological condition: NORMAL'
;    IF HydroWet GT 0 THEN  PRINT, 'Hydrological condition: WET'
;    IF HydroDry GT 0 THEN  PRINT, 'Hydrological condition: DRY'
;
;  ; Normal hydrological year scenarios (N = 4): 2001, 2007-2009
;  IF (HydroCond EQ 1) THEN BEGIN
;    RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(5) - MIN(1)) + MIN(1)); 
;    IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ENDIF
;  ; Wet hydrological year scenarios (N = 8): 1995-2000, 2010-2011
;  IF (HydroCond EQ 2) THEN BEGIN
;    RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(9) - MIN(1)) + MIN(1)); 
;    IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 5L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 6L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 7L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 8L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ENDIF
;  ; Dry hydrological year scenarios (N = 5): 2002-2006
;  IF (HydroCond EQ 3) THEN BEGIN
;    RandNormYear = FLOOR(RANDOMU(seed, 1L) * (MAX(6) - MIN(1)) + MIN(1)); 
;    IF RandNormYear EQ 1L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 2L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 3L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 4L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;    IF RandNormYear EQ 5L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace\ECOTOXriver_Main\LowerPlatteRiverInput')
;  ENDIF
;ENDIF
  
  
; Directory: IDLWorkspace
; YEAR 1990
IF iYEAR EQ 1990L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1991
IF iYEAR EQ 1991L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1992
IF iYEAR EQ 1992L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1993
IF iYEAR EQ 1993L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1994
IF iYEAR EQ 1994L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')

; YEAR 1995
IF iYEAR EQ 1995L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1996 
IF iYEAR EQ 1996L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1997
IF iYEAR EQ 1997L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1998
IF iYEAR EQ 1998L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 1999 
IF iYEAR EQ 1999L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2000
IF iYEAR EQ 2000L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2001
IF iYEAR EQ 2001L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2002 
IF iYEAR EQ 2002L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2003
IF iYEAR EQ 2003L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2004
IF iYEAR EQ 2004L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2005 
IF iYEAR EQ 2005L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2006
IF iYEAR EQ 2006L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2007
IF iYEAR EQ 2007L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2008 
IF iYEAR EQ 2008L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2009
IF iYEAR EQ 2009L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2010
IF iYEAR EQ 2010L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
; YEAR 2011 
IF iYEAR EQ 2011L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')

IF iYEAR GE 2012L THEN BEGIN
  PRINT, 'INPUT YEAR FOR FORECASTING: ', RandInputYear2
  ; YEAR 1995
  IF RandInputYear2 EQ 1995L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 1996 
  IF RandInputYear2 EQ 1996L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput96.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 1997
  IF RandInputYear2 EQ 1997L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput97.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 1998
  IF RandInputYear2 EQ 1998L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput98.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 1999 
  IF RandInputYear2 EQ 1999L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput99.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2000
  IF RandInputYear2 EQ 2000L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput00.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2001
  IF RandInputYear2 EQ 2001L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2002 
  IF RandInputYear2 EQ 2002L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2003
  IF RandInputYear2 EQ 2003L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2004
  IF RandInputYear2 EQ 2004L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2005 
  IF RandInputYear2 EQ 2005L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2006
  IF RandInputYear2 EQ 2006L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2007
  IF RandInputYear2 EQ 2007L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput07.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2008 
  IF RandInputYear2 EQ 2008L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput08.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2009
  IF RandInputYear2 EQ 2009L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2010
  IF RandInputYear2 EQ 2010L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput10.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
  ; YEAR 2011 
  IF RandInputYear2 EQ 2011L THEN file = FILEPATH('LowerPlatteRiverHydrologyInput11.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_Input')
ENDIF
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Input file order
; (1) year (2) month (3) day (4) Julian date (5) Reach ID# (6) segment # (7) segment ID# 
; (8) discharge (m3/s) (9) width (m) (10) depth (m) (11) depth SE
n = 59130L; 162 * 365
InputArray = FLTARR(11L, N)
OPENR, lun, file, /GET_LUN
READF, lun, InputArray; 
YEAR = InputArray[0, *]
MONTH = InputArray[1, *]
DAY = InputArray[2, *]
DOY = InputArray[3, *]
ReachID = InputArray[4, *]
SegmentID = InputArray[5, *]
SegmentID2 = InputArray[6, *]
DISCHARGE = InputArray[7, *]; m3/s
Width = InputArray[8, *]; 
Depth = InputArray[9, *]
DepthSE = InputArray[10, *]
FREE_LUN, lun
;PRINT, INPUTARRAY


;; For spawtially uniform discharge scenarios; all discharge rates are the same
;DISCHARGE[*] = DISCHARGE[161]
;DISCHARGE[*] = SpatialUniformDisc; spatially and temporally uniform

;>Flow-based simulation scenarios during dry years
 ;1) Sustained flow augmentation (last for 10 to 30 days) ->500 to 1000 cfs -> NEED TO INCORPORATE FLOW ATTENUATION
;PRINT, 'DISCHARGE', TRANSPOSE(DISCHARGE)
IF ((iYEAR GE FlowAugIntYear) AND (iYEAR LE FlowAugLastYear)) THEN BEGIN
  ;IF ((iDay GE FlowAugIntDay) AND (iDay LE FlowAugLastDay)) THEN HydroEnvir1D2[7, *] = HydroEnvir1D2[7, *] + HydroEnvir1D2[7, *]*PropAddFlow; > MinFlowThread
  DISCHARGE = DISCHARGE + DISCHARGE * PropAddFlow/50. * (iyear - 2011L)
  ;PRINT, 'DISCHARGE', TRANSPOSE(DISCHARGE)
ENDIF


; Width and depth are calculated separtely for each reach
; Duncan to North Bend: 0:49
; North Bend to Leshara: 50:75
; Leshara to Ashland: 76:127
; Ashland to Louiville: 128:161

;; Channel width (m)
ReachOne = WHERE((SegmentID2 GE 0L) AND (SegmentID2 LE 49L), ReachOnecount)
ReachTwo = WHERE((SegmentID2 GE 50L) AND (SegmentID2 LE 75L), ReachTwocount)
ReachThree = WHERE((SegmentID2 GE 76L) AND (SegmentID2 LE 127L), ReachThreecount)
ReachFour = WHERE((SegmentID2 GE 128L) AND (SegmentID2 LE 161L), ReachFourcount)

y0Width1 = FLTARR(N)
aWidth1 = FLTARR(N)
bWidth1 = FLTARR(N)
y0Width2 = FLTARR(N)
aWidth2 = FLTARR(N)
bWidth2 = FLTARR(N)
aWidthDuncun = 252.31
bWidthDuncun = 0.9041
y0WidthNorthBend = 183.44
aWidthNorthBend =  244.49
bWidthNorthBend = 0.9923
y0WidthLeshara = 155.29
aWidthLeshara = 328.60
bWidthLeshara = 0.9943
y0WidthAshland = 168.75
aWidthAshland = 229.24
bWidthAshland = 0.9933
y0WidthLouiville = 167.56
aWidthLouiville = 194.70
bWidthLouiville = 0.9992
IF ReachOnecount GT 0. THEN BEGIN
  aWidth1[ReachOne] = aWidthDuncun
  bWidth1[ReachOne] = bWidthDuncun  
  y0Width2[ReachOne] = y0WidthNorthBend
  aWidth2[ReachOne] = aWidthNorthBend
  bWidth2[ReachOne] = bWidthNorthBend   
  InputArray[8, ReachOne] = (aWidth1[ReachOne] * (1. - bWidth1[ReachOne]^DISCHARGE[ReachOne]) $
                          + y0Width2[ReachOne] + aWidth2[ReachOne] * (1. - bWidth2[ReachOne]^DISCHARGE[ReachOne])) / 2.
ENDIF
IF ReachTwocount GT 0. THEN BEGIN
  y0Width1[ReachTwo] = y0WidthNorthBend
  aWidth1[ReachTwo] = aWidthNorthBend
  bWidth1[ReachTwo] = bWidthNorthBend
  y0Width2[ReachTwo] = y0WidthLeshara
  aWidth2[ReachTwo] = aWidthLeshara
  bWidth2[ReachTwo] = bWidthLeshara  
  InputArray[8, ReachTwo] = (y0Width1[ReachTwo] + aWidth1[ReachTwo] * (1. - bWidth1[ReachTwo]^DISCHARGE[ReachTwo]) $
                          + y0Width2[ReachTwo] + aWidth2[ReachTwo] * (1. - bWidth2[ReachTwo]^DISCHARGE[ReachTwo])) / 2.
ENDIF
IF ReachThreecount GT 0. THEN BEGIN
  y0Width1[ReachThree] = y0WidthLeshara
  aWidth1[ReachThree] = aWidthLeshara
  bWidth1[ReachThree] = bWidthLeshara  
  y0Width2[ReachThree] = y0WidthAshland
  aWidth2[ReachThree] = aWidthAshland
  bWidth2[ReachThree] = bWidthAshland   
  InputArray[8, ReachThree] = (y0Width1[ReachThree] + aWidth1[ReachThree] * (1. - bWidth1[ReachThree]^DISCHARGE[ReachThree]) $
                          + y0Width2[ReachThree] + aWidth2[ReachThree] * (1. - bWidth2[ReachThree]^DISCHARGE[ReachThree])) / 2.
ENDIF
IF ReachFourcount GT 0. THEN BEGIN
  y0Width1[ReachFour] = y0WidthAshland
  aWidth1[ReachFour] = aWidthAshland
  bWidth1[ReachFour] = bWidthAshland  
  y0Width2[ReachFour] = y0WidthLouiville
  aWidth2[ReachFour] = aWidthLouiville
  bWidth2[ReachFour] = bWidthLouiville   
  InputArray[8, ReachFour] = (y0Width1[ReachFour] + aWidth1[ReachFour] * (1. - bWidth1[ReachFour]^DISCHARGE[ReachFour]) $
                          + y0Width2[ReachFour] + aWidth2[ReachFour] * (1. - bWidth2[ReachFour]^DISCHARGE[ReachFour])) / 2.
ENDIF
WIDTH = InputArray[8, *];
;
;; Gage height (m)
y0Height1 = FLTARR(N)
aHeight1 = FLTARR(N)
bheight1 = FLTARR(N)
y0Height2 = FLTARR(N)
aHeight2 = FLTARR(N)
bheight2 = FLTARR(N)
y0GHeightDuncun = 0.9663
aGHeightDuncun = 1.2562
bGHeightDuncun = 0.0089
y0GHeightNorthBend = 0.7820
aGHeightNorthBend = 1.6957
bGHeightNorthBend = 0.0022
y0GHeightLeshara = 0.9909
aGHeightLeshara = 1.3614
bGHeightLeshara = 0.0024
y0GHeightAshland = 4.4333
aGHeightAshland = 1.7589
bGHeightAshland = 0.0015
y0GHeightLouiville = 0.7484
aGHeightLouiville = 2.10063
bGHeightLouiville = 0.0012
IF ReachOnecount GT 0. THEN BEGIN
  y0Height1[ReachOne] = y0GHeightDuncun
  aHeight1[ReachOne] = aGHeightDuncun
  bHeight1[ReachOne] = bGHeightDuncun  
  y0Height2[ReachOne] = y0GHeightNorthBend
  aHeight2[ReachOne] = aGHeightNorthBend
  bHeight2[ReachOne] = bGHeightNorthBend   
  InputArray[9, ReachOne] = (y0Height1[ReachOne] + aHeight1[ReachOne] * (1. - EXP(-bHeight1[ReachOne]*DISCHARGE[ReachOne])) $
                          + y0Height2[ReachOne] + aHeight2[ReachOne] * (1. - EXP(-bHeight2[ReachOne]*DISCHARGE[ReachOne]))) / 2.
ENDIF
IF ReachTwocount GT 0. THEN BEGIN
  y0Height1[ReachTwo] = y0GHeightNorthBend
  aHeight1[ReachTwo] = aGHeightNorthBend
  bHeight1[ReachTwo] = bGHeightNorthBend
  y0Height2[ReachTwo] = y0GHeightLeshara
  aHeight2[ReachTwo] = aGHeightLeshara
  bHeight2[ReachTwo] = bGHeightLeshara  
  InputArray[9, ReachTwo] = (y0Height1[ReachTwo] + aHeight1[ReachTwo] * (1. - EXP(-bHeight1[ReachTwo]*DISCHARGE[ReachTwo])) $
                          + y0Height2[ReachTwo] + aHeight2[ReachTwo] * (1. - EXP(-bHeight2[ReachTwo]*DISCHARGE[ReachTwo]))) / 2.
ENDIF
IF ReachThreecount GT 0. THEN BEGIN
  y0Height1[ReachThree] = y0GHeightLeshara
  aHeight1[ReachThree] = aGHeightLeshara
  bHeight1[ReachThree] = bGHeightLeshara  
  y0Height2[ReachThree] = y0GHeightAshland
  aHeight2[ReachThree] = aGHeightAshland
  bHeight2[ReachThree] = bGHeightAshland   
  InputArray[9, ReachThree] = (y0Height1[ReachThree] + aHeight1[ReachThree] * (1. - EXP(-bHeight1[ReachThree]*DISCHARGE[ReachThree])) $
                          + y0Height2[ReachThree] + aHeight2[ReachThree] * (1. - EXP(-bHeight2[ReachThree]*DISCHARGE[ReachThree]))) / 2.
ENDIF
IF ReachFourcount GT 0. THEN BEGIN
  y0Height1[ReachFour] = y0GHeightAshland
  aHeight1[ReachFour] = aGHeightAshland
  bHeight1[ReachFour] = bGHeightAshland  
  y0Height2[ReachFour] = y0GHeightLouiville
  aHeight2[ReachFour] = aGHeightLouiville
  bHeight2[ReachFour] = bGHeightLouiville   
  InputArray[9, ReachFour] = (y0Height1[ReachFour] + aHeight1[ReachFour] * (1. - EXP(-bHeight1[ReachFour]*DISCHARGE[ReachFour])) $
                          + y0Height2[ReachFour] + aHeight2[ReachFour] * (1. - EXP(-bHeight2[ReachFour]*DISCHARGE[ReachFour]))) / 2.
ENDIF
DEPTH = InputArray[9, *]

;Turbidity

TURBy0 = -68.8031 + RANDOMN(seed, N) * 12.3288 
TURBa = 990.8303 + RANDOMN(seed, N) * 59.4367
TURBb= 0.001 + RANDOMN(seed, N) * 0.0001
Turbidity = TURBy0 + TURBa * (1. - EXP(-TURBb*DISCHARGE))
TURBnz = WHERE(Turbidity GE 0., TURBnzcount, COMPLEMENT = TURBz, NCOMPLEMENT = TURBzcount)
IF TURBnzcount GT 0. THEN Turbidity[TURBnz] = Turbidity[TURBnz]
IF TURBzcount GT 0. THEN Turbidity[TURBz] = 0.


; Hydrology Inputs for SE-IBMs
FishEnvirHydro = FLTARR(12L, N)
FishEnvirHydro[0, *] = YEAR 
FishEnvirHydro[1, *] = MONTH
FishEnvirHydro[2, *] = DAY
FishEnvirHydro[3, *] = DOY
FishEnvirHydro[4, *] = ReachID
FishEnvirHydro[5, *] = SegmentID
FishEnvirHydro[6, *] = SegmentID2
FishEnvirHydro[7, *] = DISCHARGE
FishEnvirHydro[8, *] = width
FishEnvirHydro[9, *] = Depth
FishEnvirHydro[10, *] = DepthSE
FishEnvirHydro[11, *] = Turbidity
;PRINT, (FishEnvirHydro[*, *])

PRINT, 'Hydrological year:', YEAR[0]


PRINT, 'End of Input: Year', iYEAR
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
;PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading 1D Hydrology Input Files Ends Here'
RETURN, FishEnvirHydro; TUEN OFF WHEN TESTING; TURN ON WHEN RUNNING A FULL MODEL
END