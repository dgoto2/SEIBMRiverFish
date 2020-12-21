FUNCTION river1d_input, iYear, ForecastScenario, RandInputYear2; HydroChange1, HydroChange2;, DOY
; Function to read in input files for the Lower Platte River, Nebraska obtained from the USGS Natioanl Water Information System (http://waterdata.usgs.gov/nwis)
;***open the file for reading as file unit 1:

PRINT, 'Reading 1D Input Files Begins Here'
tstart = systime(/seconds)

;; Change in probability to select hydrological year for forecating
;HydroChange1 = 0.; proportional change in frequency of wet conditions
;HydroChange2 = 0.; proportional change in frequency of dry conditions

; Directory: IDLWorkspace
; YEAR 1990
IF iYEAR EQ 1990L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1991
IF iYEAR EQ 1991L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1992
IF iYEAR EQ 1992L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1993
IF iYEAR EQ 1993L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1994
IF iYEAR EQ 1994L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')

; YEAR 1995
IF iYEAR EQ 1995L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1996
IF iYEAR EQ 1996L THEN file = FILEPATH('lowerPlatteRiverInput96.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1997
IF iYEAR EQ 1997L THEN file = FILEPATH('lowerPlatteRiverInput97.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1998
IF iYEAR EQ 1998L THEN file = FILEPATH('lowerPlatteRiverInput98.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 1999
IF iYEAR EQ 1999L THEN file = FILEPATH('lowerPlatteRiverInput99.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2000
IF iYEAR EQ 2000L THEN file = FILEPATH('lowerPlatteRiverInput00.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2001
IF iYEAR EQ 2001L THEN file = FILEPATH('lowerPlatteRiverInput01.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2002
IF iYEAR EQ 2002L THEN file = FILEPATH('lowerPlatteRiverInput02.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2003
IF iYEAR EQ 2003L THEN file = FILEPATH('lowerPlatteRiverInput03.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2004
IF iYEAR EQ 2004L THEN file = FILEPATH('lowerPlatteRiverInput04.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2005
IF iYEAR EQ 2005L THEN file = FILEPATH('lowerPlatteRiverInput05.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2006
IF iYEAR EQ 2006L THEN file = FILEPATH('lowerPlatteRiverInput06.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2007
IF iYEAR EQ 2007L THEN file = FILEPATH('lowerPlatteRiverInput07.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2008
IF iYEAR EQ 2008L THEN file = FILEPATH('lowerPlatteRiverInput08.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2009
IF iYEAR EQ 2009L THEN file = FILEPATH('lowerPlatteRiverInput09.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2010
IF iYEAR EQ 2010L THEN file = FILEPATH('lowerPlatteRiverInput10.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
; YEAR 2011
IF iYEAR EQ 2011L THEN file = FILEPATH('lowerPlatteRiverInput11.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')

IF iYEAR GE 2012L THEN BEGIN
  PRINT, 'INPUT YEAR FOR FORECASTING: ', RandInputYear2
  ; YEAR 1995
  IF RandInputYear2 EQ 1995L THEN file = FILEPATH('lowerPlatteRiverInput95.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 1996
  IF RandInputYear2 EQ 1996L THEN file = FILEPATH('lowerPlatteRiverInput96.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 1997
  IF RandInputYear2 EQ 1997L THEN file = FILEPATH('lowerPlatteRiverInput97.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 1998
  IF RandInputYear2 EQ 1998L THEN file = FILEPATH('lowerPlatteRiverInput98.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 1999
  IF RandInputYear2 EQ 1999L THEN file = FILEPATH('lowerPlatteRiverInput99.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2000
  IF RandInputYear2 EQ 2000L THEN file = FILEPATH('lowerPlatteRiverInput00.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2001
  IF RandInputYear2 EQ 2001L THEN file = FILEPATH('lowerPlatteRiverInput01.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2002
  IF RandInputYear2 EQ 2002L THEN file = FILEPATH('lowerPlatteRiverInput02.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2003
  IF RandInputYear2 EQ 2003L THEN file = FILEPATH('lowerPlatteRiverInput03.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2004
  IF RandInputYear2 EQ 2004L THEN file = FILEPATH('lowerPlatteRiverInput04.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2005
  IF RandInputYear2 EQ 2005L THEN file = FILEPATH('lowerPlatteRiverInput05.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2006
  IF RandInputYear2 EQ 2006L THEN file = FILEPATH('lowerPlatteRiverInput06.csv', Root_dir = 'C:', SUBDIR = 'Users\daisu\IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2007
  IF RandInputYear2 EQ 2007L THEN file = FILEPATH('lowerPlatteRiverInput07.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2008
  IF RandInputYear2 EQ 2008L THEN file = FILEPATH('lowerPlatteRiverInput08.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2009
  IF RandInputYear2 EQ 2009L THEN file = FILEPATH('lowerPlatteRiverInput09.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2010
  IF RandInputYear2 EQ 2010L THEN file = FILEPATH('lowerPlatteRiverInput10.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
  ; YEAR 2011
  IF RandInputYear2 EQ 2011L THEN file = FILEPATH('lowerPlatteRiverInput11.csv', Root_dir = 'C:', SUBDIR = 'IDLWorkspace\river_main\lowerPlatteRiver_input')
ENDIF
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Input file order
; (1) year, (2) month, (3) day, (4) julian day (DOY), (5)  Temperature (C), (6) Dissolved Oxygen (mg/L)
; (7) Turbidity (NTU), (8) daylight (hours), (9) (mgC/L), (10)  (mgC/L)

N = 365L
InputArray = FLTARR(8L, N)
OPENR, lun, file, /GET_LUN
READF, lun, InputArray;
YEAR = InputArray[0, *]
MONTH = InputArray[1, *]
DAY = InputArray[2, *]
DOY = InputArray[3, *]
TEMP = InputArray[4, *]
OXYGEN = InputArray[5, *]
TURB = InputArray[6, *]
DAYLIGHT = InputArray[7, *]
;ZOOP = InputArray[8, *]
;CARBON = InputArray[9, *]
FREE_LUN, lun
;PRINT, InputArray

; Carbon-based benthic habitat quality is determined daily 
;GrowRateHabitat = FLTARR(N)
;NZGrowthRate = WHERE(GrowthRate GT 0., NZGrowthRatecount, complement = ZGrowthRate, ncomplement = ZGrowthRatecount)
;IF DONZcount GT 0. THEN GrowRateHabitat[DCNZ] = GrowthRate[DCNZ]/MAX(GrowthRate[DCNZ]) 
;IF DCZcount GT 0. THEN  GrowRateHabitat[DCZ] = 0.00000001 
;GrowRateHabitat = 1.;GrowthRate/MAX(GrowthRate) 
;PRINT, 'Habitat quality based on carbon (GrowRateHabitat)'
;PRINT, (GrowRateHabitat)

; Calculate production in g/d 
;r = 0.0175; r is the growth rate (/d)
;p = 0.25; p a term that accounts for the variation that occurs in benthic macros-> should be temp-dependent (determined by DOY?)
;q = FLTARR(n);q is a habitat quality value ranges from 0.1-1
;q = RANDOMU(seed, n) + 0.1
;PRINT, 'Habitat quality (q)'
;PRINT, q[0:499L]
;qtb = WHERE(q GT 1.0, qtbcount, complement = qtbc, ncomplement = qtbccount)
;IF qtbcount GT 0.0 THEN q[qtb] = 1.0 

;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:499L]; TotBenBio is the biomass in each cell
;Prod = FLTARR(N)
;Bmax = 6.679; MAX(TotBenBio); 1500000.; Bmax = the maximum production; 6 g/m^2 or 1500000 g/km^2
;IF BottomCellcount GT 0. THEN Prod[BottomCell] = r * (1.0 + p * SIN((2.0 * !Pi * DOY) / 365.0)) $
;                                       * (1 - (TotBenBio[BottomCell]/(GrowRateHabitat[BottomCell] * Bmax))) * TotBenBio[BottomCell] 
;IF NonBottomCellcount GT 0. THEN Prod[NonBottomCell] = 0.

;PRINT, 'Chironomid production'
;PRINT, Prod[BottomCell];[0:47]
;PRINT, 'BMAX =', BMAX
;print, min(totbenbio)
;print, transpose(growratehabitat)
;PRINT, 'GrowthRate'
;print, (growthrate)
;print, (carbon[bottomcell])
;print, max(prod)
;print, min(r*(1.0 + p * SIN((2.0 * !Pi * DOY) / 365.0))) 
;print, min(GrowRateHabitat[BottomCell] * Bmax)

;TotBenBio = TotBenBio+Prod 
;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:77499L] 
;ENDFOR;***FOR TESTING CHIRODOMID PRODUCTION***********************
;PRINT, n_elements(prod)
;PRINT, n_elements(totbenbio)
;PRINT, n_elements(bottomcell)
;PRINT, n_elements(bottomcell24)
;PRINT, n_elements(zl)

; (1) year, (2) month, (3) day, (4) julian day (DOY), (5)  Temperature (C), (6) Dissolved Oxygen (mg/L)
; (7) Turbidity (NTU), (8) daylight (hours), (9) (mgC/L), (10)  (mgC/L)

; Inputs for SEIBMs
FishEnvir = FLTARR(8, n)
FishEnvir[0, *] = YEAR;
FishEnvir[1, *] = MONTH;
FishEnvir[2, *] = DAY;
FishEnvir[3, *] = DOY;
FishEnvir[4, *] = TEMP;
FishEnvir[5, *] = OXYGEN; 
FishEnvir[6, *] = TURB; 
FishEnvir[7, *] = DAYLIGHT; 
;PRINT, fishenvir[*, *];



PRINT, 'End of Input: YEAR', iYEAR;, '     DAY', DOY
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
;PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Reading 1D Input Files Ends Here'
RETURN, FishEnvir; TUEN OFF WHEN TESTING; TURN ON WHEN RUNNING A FULL MODEL
END