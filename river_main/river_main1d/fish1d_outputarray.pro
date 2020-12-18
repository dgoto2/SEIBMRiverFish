PRO fish1d_outputarray; TURN OFF WHEN RUNNING A FULL MODEL

PRINT, 'FISH OUTPUT Files Begins Here'
tstart = SYSTIME(/seconds)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FISH OUTPUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;DOY = 5L; day 1 of simulations
NpopSNS = 38000L; number of individuals
nLonTran = 162L
nStateVar = 80L
FishComArray = FLTARR(20L, nLonTran)
FISHCellIDcount = FLTARR(2L, nLonTran)
FishComArray2 = FLTARR(nLonTran, 20L)
OutputArray= FLTARR(365L, nLonTran)

; Directory information of output files
Direct = 'F:'
SubDirect = 'SNS_SEIBM_Rep1'

  ;***************************
  ; Simulation year
  iYear = 2006L
  
  ; Endocrine disrupting chemical (EndDisChem) effect
  EndDisChem = 'OFF'
  
  ; Density dependence effect
  DensityDependence = 'ON'
  
  ; Year & Replicate #
  RepNum = 'Rep1' 
  IF iYear EQ 1995 THEN Rep = 'YEAR_1995(WET)'+RepNum
  IF iYear EQ 1996 THEN Rep = 'YEAR_1996(WET)'+RepNum
  IF iYear EQ 1997 THEN Rep = 'YEAR_1997(WET)'+RepNum
  IF iYear EQ 1998 THEN Rep = 'YEAR_1998(WET)'+RepNum
  IF iYear EQ 1999 THEN Rep = 'YEAR_1999(WET)'+RepNum
  IF iYear EQ 2000 THEN Rep = 'YEAR_2000(WET)'+RepNum
  IF iYear EQ 2001 THEN Rep = 'YEAR_2001(NORMAL)'+RepNum
  IF iYear EQ 2002 THEN Rep = 'YEAR_2002(DRY)'+RepNum
  IF iYear EQ 2003 THEN Rep = 'YEAR_2003(DRY)' +RepNum
  IF iYear EQ 2004 THEN Rep = 'YEAR_2004(DRY)'+RepNum
  IF iYear EQ 2005 THEN Rep = 'YEAR_2005(DRY)'+RepNum
  IF iYear EQ 2006 THEN Rep = 'YEAR_2006(DRY)'+RepNum
  IF iYear EQ 2007 THEN Rep = 'YEAR_2007(NORMAL)'+RepNum
  IF iYear EQ 2008 THEN Rep = 'YEAR_2008(NORMAL)'+RepNum
  IF iYear EQ 2009 THEN Rep = 'YEAR_2009(NORMAL)'+RepNum
  IF iYear EQ 2010 THEN Rep = 'YEAR_2010(WET)'+RepNum
  IF iYear EQ 2011 THEN Rep = 'YEAR_2011(WET)'+RepNum 
  Time='_Daily_'
 
 ; Choosing individuals randomly
  nRAND = 100L
  NsiSNSyoy = 2000L
  nSNS = NpopSNS+NsiSNSyoy
  randomNumbers = RANDOMU(seed, nSNS)            
  sortedRandomNumbers = SORT(randomNumbers)  
  RANDIND= sortedRandomNumbers[0L:nRAND-1L]
  ;***************************
  
  
  ; ADD SUMMARY OUTPUT FIELS TO THE FOLLOWNG FILE LOCATIONS********
  
  
  ; Number of rows from daily output >>>> NEED TO OBTAIN FROM THE OUTPUT FIELES <<<<<<
  nSNS = 99356L; NpopSNS+NsiSNSyoy
  
  
FOR DOY = 1L, 365L DO BEGIN
  ;PRINT, 'Counter', counter
  
  ; Output file locations

  ; 1995 
  IF iYear EQ 1995 THEN BEGIN 
  NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1995(WET)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 1996  
  IF iYear EQ 1996 THEN BEGIN 
    NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1996(WET)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 1997  
  IF iYear EQ 1997 THEN BEGIN 
    NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1997(WET)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 1998  
  IF iYear EQ 1998 THEN BEGIN 
    NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1998(WET)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 1999  
  IF iYear EQ 1999 THEN BEGIN 
  NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_1999(WET)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2000  
  IF iYear EQ 2000 THEN BEGIN 
    NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2000(WET)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2001
   IF iYear EQ 2001 THEN BEGIN 
    NsiSNSyoy = 2001L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2001(NORMAL)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2002  
  IF iYear EQ 2002 THEN BEGIN 
    NsiSNSyoy = 2002L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2002(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2003  
  IF iYear EQ 2003 THEN BEGIN 
    NsiSNSyoy = 2003L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2003(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2004  
  IF iYear EQ 2004 THEN BEGIN 
    NsiSNSyoy = 2004L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2004(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2005
  IF iYear EQ 2005 THEN BEGIN 
    NsiSNSyoy = 2005L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2005(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2006  
  IF iYear EQ 2006 THEN BEGIN 
    NsiSNSyoy = 2006L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2006(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2007  
  IF iYear EQ 2007 THEN BEGIN 
    NsiSNSyoy = 2007L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2007(NORMAL)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2008  
  IF iYear EQ 2008 THEN BEGIN 
    NsiSNSyoy = 2008L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2008(NORMAL)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2009  
  IF iYear EQ 2009 THEN BEGIN 
  NsiSNSyoy = 2000L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2009(NORMAL)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2010
  IF iYear EQ 2010 THEN BEGIN 
    NsiSNSyoy = 2010L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2010(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF
  
  ; 2011
  IF iYear EQ 2011 THEN BEGIN 
    NsiSNSyoy = 2011L; <--------------------->>>>>>>>>>>>>>>>>THIS NEEDS TO BE CHANGED FOR # NEW RECRUITS<<<<<<<<<<<<<<<<<<<<
  
    IF DOY GE 1L AND DOY LE 20L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_1.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 1L)
    ENDIF
    IF DOY GE 21L AND DOY LE 40L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_2.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 21L)
    ENDIF
    IF DOY GE 41L AND DOY LE 60L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_3.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 41L)
    ENDIF  
    IF DOY GE 61L AND DOY LE 80L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_4.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 61L)
    ENDIF  
    IF DOY GE 81L AND DOY LE 100L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_5.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 81L)
    ENDIF  
    IF DOY GE 101L AND DOY LE 120L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_6.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 101L)
    ENDIF  
    IF DOY GE 121L AND DOY LE 140L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_7.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 121L)
    ENDIF  
    IF DOY GE 141L AND DOY LE 160L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_8.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 141L)
    ENDIF  
    IF DOY GE 161L AND DOY LE 180L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_9.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 161L)
    ENDIF  
    IF DOY GE 181L AND DOY LE 200L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_10.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 181L)
    ENDIF  
    IF DOY GE 201L AND DOY LE 220L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_11.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 201L)
    ENDIF  
    IF DOY GE 221L AND DOY LE 240L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_12.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 221L)
    ENDIF  
    IF DOY GE 241L AND DOY LE 260L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_13.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 241L)
    ENDIF  
    IF DOY GE 261L AND DOY LE 280L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_14.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 261L)
    ENDIF  
    IF DOY GE 281L AND DOY LE 300L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_15.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 281L)
    ENDIF  
    IF DOY GE 301L AND DOY LE 320L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_16.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 301L)
    ENDIF  
    IF DOY GE 321L AND DOY LE 340L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_17.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 321L)
    ENDIF 
    IF DOY GE 341L AND DOY LE 360L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(WET)Rep1_IDLoutputSNS_18.csv', Root_dir = Direct, SUBDIR = SubDirect)
      counter = (DOY - 341L)
    ENDIF  
    IF DOY GE 361L AND DOY LE 365L THEN BEGIN
      file1 = FILEPATH('EDC_OFF_DD_ON_Daily__Rep_YEAR_2011(DRY)Rep1_IDLoutputSNS_19.csv', Root_dir = 'F:', SUBDIR = SubDirect)
      counter = (DOY - 361L)
    ENDIF  
  ENDIF

  pointer = nSNS * counter; 1st line to read in 

  ; Number of state variables = 70
  ;InputArray1 = FLTARR(75L, nSNS)
  InputArraY1 = FLTARR(nStateVar, nSNS)
  
  ; Shovelnose sturgeon
  OPENR, lun, file1, /GET_LUN
  ;POINT_LUN, lun, pointer; return to the previous stored location
  SKIP_LUN, lun, pointer,/LINES
  READF, lun, InputArray1
  AGE = InputArray1[6, *]
  FishLength = InputArray1[7, *]
  FishWeight = InputArray1[8, *]
  fecundity = InputArray1[50, *]
  ReproCycle = InputArray1[14, *]
  GSI = InputArray1[59, *]
  
  MATURITY = InputArray1[12, *]
  SEX = InputArray1[5, *]
  LonLoc = InputArray1[17, *]
  nFish = InputArray1[4, *]
  ;FishWeight = InputArray1[2, *]
  ;GrowthWeight = InputArray1[62, *]
  FREE_LUN, lun
  SNS=InputArray1
  ;PRINT, 'Sturgeon age'
  ;PRINT, TRANSPOSE(AGE[0:199])
  ;PRINT, TRANSPOSE(HISTOGRAM(AGE))
  PRINT, 'DATE', SNS[0:2, 0]
  ;PRINT, 'Sturgeon length (mm)'
  ;PRINT, TRANSPOSE(HISTOGRAM(FishLength,  BINSIZE=15))
  
 
  ;; Fecundity
  SpwnFemale = WHERE(FECUNDITY GT 0., SpwnFemalecount)
  MatureFemale = WHERE((MATURITY GT 0.) and (sex gt 0.), MatureFemalecount)
  PRINT, 'SPAWNING FEMALES'
  PRINT, SpwnFemale
  PRINT, '#MATURE FEMALES', N_ELEMENTS(MatureFemale)
  PRINT, '#SPAWNING FEMALES', N_ELEMENTS(SpwnFemale>0)
  ;PRINT, 'SPAWNING DAY', SNS[1:2, 0]
  ;IF SpwnFemalecount GT 0. THEN PRINT, TRANSPOSE(FECUNDITY[SpwnFemale])
  
 
  ;; YOY growth
  ;YOY = WHERE(AGE LT 1, YOYcount, COMPLEMENT = YAO, NCOMPLEMENT = YAOcount)
  ;PRINT, 'DOY', SNS[1:2, 0]
  ;PRINT, 'YOY LENGTH (mm)'
  ;PRINT, TRANSPOSE(FISHLENGTH[YOY])
 
 
  ; Longitudinal location
  PRINT, 'Longitudinal location'
  ;PRINT, TRANSPOSE(HISTOGRAM(LonLoc,  BINSIZE=1))
  
  FOR ID = 0L, nLonTran-1L DO BEGIN
    SNSMultiInd = WHERE((LonLoc EQ ID), SNSMultiIndcount);    
    IF SNSMultiIndcount GT 0. THEN BEGIN
    
;        SNSMultiIndYOY = WHERE((AGE[SNSMultiInd] LT 1), SNSMultiIndYOYcount);   YOY 
;        IF SNSMultiIndYOYcount GT 0. THEN BEGIN
        
;        SNSMultiIndMature = WHERE((MATURITY[SNSMultiInd] GT 0), SNSMultiIndMaturecount);   Mature 
;        IF SNSMultiIndMaturecount GT 0. THEN BEGIN
        
;        SNSMultiIndSpwnF = WHERE((FECUNDITY[SNSMultiInd] GT 0), SNSMultiIndSpwnFcount);   Spwn females 

        SNSMultiIndSpwnF = WHERE((ReproCycle[SNSMultiInd] GT 0) AND (SEX[SNSMultiInd] GT 0) AND (GSI[SNSMultiInd] GE 0.13), SNSMultiIndSpwnFcount); Spwn females 
        ;SNSMultiIndSpwnF = WHERE((ReproCycle[SNSMultiInd] GT 0) AND (SEX[SNSMultiInd] GT 0), SNSMultiIndSpwnFcount); Repro females 

        IF SNSMultiIndSpwnFcount GT 0. THEN BEGIN
  
    
  ;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
  ;      m = 1
  ;      n = SNSMultiIndcount
  ;      ;im = findgen(n)+1 ; input array
  ;      im = SNSMultiInd
  ;      IF n GT 0 THEN arr = RANDOMU(seed, n)
  ;      ind = SORT(arr)
  ;      PreyFishID = im[ind[0:m-1]]
  ;      ;print, ind[0:m-1]
  ;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
  ;      FISHCOMARRAY[0, ID] = YP[0, PreyFishID]; ABUNDANCE
  ;      FISHCOMARRAY[1, ID] = YP[1, PreyFishID]; LENGTH
  ;      FISHCOMARRAY[2, ID] = YP[2, PreyFishID]; WEIGHT
  ;      FISHCOMARRAY[3, ID] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
;   
;      ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL >>>>>>> ALL
;        FISHCellIDcount[0, ID] = N_ELEMENTS(SNSMultiInd); NUMBER OF individuals
;        FishComArray[4, ID] = TOTAL(nFish[SNSMultiInd]); ABUNDANCE
;        FishComArray[5, ID] = TOTAL(FishWeight[SNSMultiInd] * nFish[SNSMultiInd]); BIOMASS
        
;          ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL >>>>>>>> YOY
;          FISHCellIDcount[0, ID] = N_ELEMENTS(SNSMultiInd[SNSMultiIndYOY]); NUMBER OF individuals
;          FishComArray[4, ID] = TOTAL(nFish[SNSMultiInd[SNSMultiIndYOY]]); ABUNDANCE
;          FishComArray[5, ID] = TOTAL(FishWeight[SNSMultiInd[SNSMultiIndYOY]] * nFish[SNSMultiInd[SNSMultiIndYOY]]); BIOMASS
          
;          ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL >>>>>>>> Mature
;          FISHCellIDcount[0, ID] = N_ELEMENTS(SNSMultiInd[SNSMultiIndMature]); NUMBER OF individuals
;          FishComArray[4, ID] = TOTAL(nFish[SNSMultiInd[SNSMultiIndMature]]); ABUNDANCE
;          FishComArray[5, ID] = TOTAL(FishWeight[SNSMultiInd[SNSMultiIndMature]] * nFish[SNSMultiInd[SNSMultiIndMature]]); BIOMASS          
          
          
          ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL >>>>>>>> Spwn females
          FISHCellIDcount[0, ID] = N_ELEMENTS(SNSMultiInd[SNSMultiIndSpwnF]); NUMBER OF individuals
          FishComArray[4, ID] = TOTAL(nFish[SNSMultiInd[SNSMultiIndSpwnF]]); ABUNDANCE
          FishComArray[5, ID] = TOTAL(FishWeight[SNSMultiInd[SNSMultiIndSpwnF]] * nFish[SNSMultiInd[SNSMultiIndSpwnF]]); BIOMASS   
      
        ENDIF
        
        IF SNSMultiIndSpwnFcount EQ 0. THEN BEGIN; Spwn females
         FishComArray[4, ID] = 0.; ABUNDANCE
         FishComArray[5, ID] = 0.; BIOMASS         
        ENDIF 
       
;        IF SNSMultiIndYOYcount EQ 0. THEN BEGIN; YOY
;          FishComArray[4, ID] = 0.; ABUNDANCE
;          FishComArray[5, ID] = 0.; BIOMASS
;        ENDIF
        
;        IF SNSMultiIndMaturecount EQ 0. THEN BEGIN; mature
;         FishComArray[4, ID] = 0.; ABUNDANCE
;         FishComArray[5, ID] = 0.; BIOMASS         
;        ENDIF         
    ENDIF 
  ENDFOR
  ;  FishComArray2[*, DOY] = FishComArray[5, ID] 
  
  ;PRINT, 'Sturgeon Biomas (g)'
  ;PRINT, FishComArray[5, *] 
  
  ;OutputArray[DOY, *] = FishComArray[5, *] 
  
  counter2 = (DOY - 1L)
  pointer2 = counter2; 1st line to read in 
  
  ; biomass
  data = TRANSPOSE(FishComArray[5, *])
  ; abundance
  ;data = TRANSPOSE(FishComArray[4, *])
  ; individual location
  ;randomLonLoc = LonLoc[RANDIND]; randomly select individuals, RANDIND = #individuals
  ;data = randomLonLoc
   
  
  ; Type of the data exporting for the file name
  ;datatype = 'Location LonDist_RANDOM'
  datatype = 'All_Total biomass_Movement'  
    
  ; Set up variables.
  OutputSNS1='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1_'+datatype+'.csv'
  filename1 = OutputSNS1
  
  ;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 160000
  comma = ","
  
  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
  ;; Write the data to the file.
  ;sData = StrTrim(data,2)
  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  ;PrintF, lun, sData
  ;Free_Lun, lun
  
  
  ; Open the data file for writing.
  IF counter2 EQ 0L THEN BEGIN; 
     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ENDIF
  IF counter2 GT 0L THEN BEGIN; 
    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
    SKIP_LUN, lun, pointer2, /lines
    READF, lun
  ENDIF
  
  ; Write the data to the file.
  sData = StrTrim(data,2)
  sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  PrintF, lun, sData
  
  ; Close the file.
  Free_Lun, lun
  ;****************************************************************************************
ENDFOR

PRINT, '"Your SNS Output File is Ready"'
PRINT, 'OutputFiles ENDS HERE'
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FISH OUTPUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIVER OUTPUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;
;DOY = 351L; day 1 of simulations
;counter = (DOY - 1L)
;;PRINT, 'Counter', counter
;
;pointer = 162L * counter; 1st line to read in 
;
;; Output file locations
;file1 = FILEPATH('LowerPlatteRiverHydrologyInput09.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81\ECOTOXriver_Main\LowerPlatteRiverInput')
;n = 59130L; 162 * 365
;nLonTran = 162L
;InputArray2 = FLTARR(11L, nLonTran)
;
;; Shovelnose sturgeon
;OPENR, lun, file1, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray2
;YEAR = InputArray2[0, *]
;MONTH = InputArray2[1, *]
;DAY = InputArray2[2, *]
;DOY = InputArray2[3, *]
;ReachID = InputArray2[4, *]
;SegmentID = InputArray2[5, *]
;SegmentID2 = InputArray2[6, *]
;DISCHARGE = InputArray2[7, *]; m3/s
;Width = InputArray2[8, *]; 
;Depth = InputArray2[9, *]
;DepthSE = InputArray2[10, *]
;FREE_LUN, lun
;;SNS=InputArray1
;;PRINT, 'Sturgeon age'
;;PRINT, TRANSPOSE(AGE[0:199])
;;PRINT, TRANSPOSE(HISTOGRAM(AGE))
;PRINT, 'DATE', InputArray2[1:2, 0]
;PRINT, 'Discharge (cms)'
;PRINT, DISCHARGE
;
;; Discharge rate
;PRINT, 'Discharge (cms)'
;;;PRINT, TRANSPOSE(HISTOGRAM(LonLoc,  BINSIZE=1))
;;
;;;FishComArray = FLTARR(20L, nLonTran)
;;;FISHCellIDcount = FLTARR(2L, nLonTran)
;;;FishComArray2 = FLTARR(nLonTran, 20L)
;;EnvArray = FLTARR(nLonTran, 20L)
;;;FOR DOY = 0L, 20L - 1L DO BEGIN
;;FOR ID = 0L, nLonTran-1L DO BEGIN
;;  ;SNSMultiInd = WHERE((LonLoc EQ ID), SNSMultiIndcount); 
;;    
;;  ;IF SNSMultiIndcount GT 0. THEN BEGIN
;;;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;;;      m = 1
;;;      n = SNSMultiIndcount
;;;      ;im = findgen(n)+1 ; input array
;;;      im = SNSMultiInd
;;;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;;;      ind = SORT(arr)
;;;      PreyFishID = im[ind[0:m-1]]
;;;      ;print, ind[0:m-1]
;;;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;;;      FISHCOMARRAY[0, ID] = YP[0, PreyFishID]; ABUNDANCE
;;;      FISHCOMARRAY[1, ID] = YP[1, PreyFishID]; LENGTH
;;;      FISHCOMARRAY[2, ID] = YP[2, PreyFishID]; WEIGHT
;;;      FISHCOMARRAY[3, ID] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
;;;      
;;    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
;;      ;FISHCellIDcount[0, ID] = N_ELEMENTS(SNSMultiInd); NUMBER OF individuals
;;      ;FishComArray[4, ID] = TOTAL(nFish[SNSMultiInd]); ABUNDANCE
;;      ;FishComArray[5, ID] = TOTAL(FishWeight[SNSMultiInd] * nFish[SNSMultiInd]); BIOMASS
;;      EnvArray
;;  ENDIF 
;;ENDFOR
;;;  FishComArray2[*, DOY] = FishComArray[5, ID] 
;;;ENDFOR
;;PRINT, FishComArray[5, *] 
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIVER OUTPUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;
















;OPENR, lun, file1, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray1
;Cchiro = InputArray1[51, *]
;FishWeight = InputArray1[2, *]
;GrowthWeight = InputArray1[62, *]
;
;;yl = InputArray[1, *]
;;Temp = InputArray[2, *]
;;DOam = InputArray[3, *]
;;DC = InputArray[4, *]
;;Zoop = InputArray[5, *]
;;uw = InputArray[6, *]
;;vw = InputArray[7, *]
;;ww = InputArray[8, *]
;;Light = InputArray[9, *]
;FREE_LUN, lun
;YP=InputArray1
;
;;benthic consumption rate
;FishWeightNZ = where(FishWeight GT 0., FishWeightNZcount)
;Cchiro[FishWeightNZ] = Cchiro[FishWeightNZ]/FishWeight[FishWeightNZ]
;CchiroNZ = where(Cchiro GT 0., CchiroNZcount)
;AveCchiro = mean(Cchiro[CchiroNZ], /DOUBLE, /NAN)
;;print, AveCchiro
;
;; DAILY GROWTH
;GrowthWeight[FishWeightNZ] = GrowthWeight[FishWeightNZ]/FishWeight[FishWeightNZ]
;GrowthWeightNZ = where(GrowthWeight[FishWeightNZ] GT 0., GrowthWeightNZcount)
;AveGrowthWeightYEP = mean(GrowthWeight[GrowthWeightNZ], /DOUBLE, /NAN)
;print, AveGrowthWeightYEP
;
;
;; walleye's rainow smelt consumption rate
;FishWeightNZ = where(FishWeight GT 0., FishWeightNZcount)
;Cras[FishWeightNZ] = Cras[FishWeightNZ]/FishWeight[FishWeightNZ]
;CrasNZ = where(Cras GT 0., CemsNZcount)
;AveCras = mean(Cras[CrasNZ], /DOUBLE, /NAN)
;;print, AveCras
;
;; Daily growth
;;GrowthWeight[FishWeightNZ] = GrowthWeight[FishWeightNZ]/FishWeight[FishWeightNZ]
;GrowthWeightNZ = where(GrowthWeight[FishWeightNZ]/FishWeight[FishWeightNZ] GT 0., GrowthWeightNZcount)
;AveGrowthWeightWAE = mean(GrowthWeight[GrowthWeightNZ], /DOUBLE, /NAN)
;PRINT, AveGrowthWeightWAE




;nGridcell = 77500L
;PreyFish = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)
;Zplkn = FLTARR(20); 1 = top layer; 20 = bottom layer

;PreyFish = FLTARR(5L, nGridcell)
;FISHCellIDcount = FLTARR(5L, nGridcell)

; ARRAYS FOR ABUNDANCE
;PreyFish[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;PreyFish[1, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;PreyFish[2, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;PreyFish[3, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;PreyFish[4, WAE[14, *]] = WAE[0, *]; ABUNDANCE

;ARRAYS FOR BIOMASS
;PreyFish[0, YP[14, *]] = YP[0, *]*YP[2, *]; BIOMASS
;PreyFish[1, EMS[14, *]] = EMS[0, *]*EMS[2, *]; BIOMASS
;PreyFish[2, RAS[14, *]] = RAS[0, *]*RAS[2, *]; BIOMASS
;PreyFish[3, ROG[14, *]] = ROG[0, *]*ROG[2, *]; BIOMASS
;PreyFish[4, WAE[14, *]] = WAE[0, *]*WAE[2, *]; BIOMASS
;PRINT, TOTAL(PreyFish[4, WAE[14, *]])


;PRINT, 'ORIGINAL', TRANSPOSE(PREYFISH[0, 0:5000L])
;PRINT, 'BIG', TRANSPOSE(FISH2Dpre[0, 0:100L])
;PRINT, 'SMALL', TRANSPOSE(FISH2D[0, 0:500L])
t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
;PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading shovelnose sturgeon 1D OUTPUT Files Ends Here'

;RETURN, PREYFISH; TURN OFF WHEN TESTING
END