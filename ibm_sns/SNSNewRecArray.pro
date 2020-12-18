FUNCTION SNSNewRecArray, nState, nSNS, YOYcount, YOYindnum, YOYarray
; This funciton converts YOY superindiviuals to new age1 individuals

PRINT, 'SNSNewRecArray Begins Here'


;;>>>> THE FOLLOWNG CODE IS FOR TESTING ONLY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;iYear = 2009
;iday = 1L
;nLonTran = 162L; the number of longitudianl grid cells
;TotDriftBio2 = FLTARR(5L, nLonTran)
;HydroEnvir1D2 = FLTARR(12L, nLonTran)
;WQEnvir1D2 = FLTARR(8L, 1L)
;
;; Read a daily environmental input
;WQEnvir1D = EcoToxRiver1DInput(iYear) 
;HydroEnvir1D = EcoToxRiver1DHydrologyInput(iYear);
;TotDriftBio = 18.8 + RANDOMN(seed, nLonTran) * 2.5; ~4*.4 /0.085 = 18.8g wet mass/m2 in January
;
;iDayPointer = iDay - 1L; - 105L
;; First DOY for the simulation - DOY105 =~April 15 (the fisrt day in the input files), DOY152 = ~June 1
;WQEnvir1D2 = WQEnvir1D[*, iDayPointer]; No spatial resolution for the water quality inputs    
;HydroEnvir1D2[0L:11L, *] = HydroEnvir1D[*, 162L*iDayPointer : 162L*iDayPointer+161L]; 162 longitudianl grid cells
;
; ; Calculate production in g/d >>>>>> NEED TO BE ADJUSTED FOR DRIFT PREY IN LOWER PLATTE RIVER <<<<<<<<<<<<<<< 
; TotDriftBio2 = DriftPrey(iday, nLonTran, TotDriftBio, HydroEnvir1D2)
;
;nSNSyoy = 500L ; number of shovelnose sturgeon egg as superindividuals(SIs)
;NpopSNSyoy = 5000L; number of SNS eggs/larvae -> initially no YOY until spawning 
;NpopSNS = 25000L; number of SNS individuals >>>>>> NEED TO BE ADJUSTED <<<<<<<<<<<<<<<<<<<<<<<<<<<
;nSNS = NpopSNS + nSNSyoy
;
;SNS = SNSinitial(NpopSNSyoy, nSNSyoy, nSNS, TotDriftBio2, HydroEnvir1D2, WQEnvir1D2, nLonTran)  
;YOY = WHERE(SNS[6, *] LT 1L, YOYcount, complement = YAO, ncomplement = YAOcount)
;YOYarray = SNS[*, YOY]; 
;YOYindnum = (SNS[4, YOY]);  number of individuals in each SI
;print, yoycount

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



; >>>>>>> USE THE FOLLOWING FORMAT TO CREATE A METAFILE FOR ALL SEIBMs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;+
; NAME:
;    SHUFFLE
;
; PURPOSE:
;    This function shuffles the values in an array.
;
; CATEGORY:
;    Array
;
; CALLING SEQUENCE:
;    Result = SHUFFLE( X )
;
; INPUTS:
;    X:  An array of any type.
;
; KEYWORD PARAMETERS:
;    INDEX:  Returns the index values of the shuffled array.
;    REPLACE:  If set, the function shuffles with replacement.  The default is 
;        without replacement.
;    SEED:  A seed for the random number generator to use.
;
; OUTPUTS:
;    Result:  Returns the shuffled version of array X.
;    INDEX:  See above.
;    SEED:  See above.  Also returns a seed for the next implementation of the 
;        random number generator.
;
; PROCEDURE:
;    This function used the RANDOMU IDL function to produce an array of random 
;    index values.
;
; EXAMPLE:
;    Define a vector.
;      x = [0,1,2,3,4]
;    Shuffle the vector with replacement.
;      result = shuffle( x, replace=1, seed=1 )
;    This should give result = [2,0,3,2,4].
;
; MODIFICATION HISTORY:
;    Written by:  Daithi A. Stone (stoned@atm.ox.ac.uk), 2001-07-18.
;    Modified:  DAS, 2002-11-21 (added seed initialisation).
;    Modified:  DAS, 2003-02-17 (allowed input of very long vectors)
;    Modified:  DAS, 2005-01-03 (added SEED keyword)
;    Modified:  DAS, 2011-03-16 (corrected bug when long vectors are input;  
;        modified formating)
;-

;***********************************************************************

;IF YOYcount GT 0. THEN BEGIN
  ;n = 70; number of state vairables
  ;m = YOYcount; number of superindividuals
  rep = ROUND(MEAN(YOYindnum)); MAX(SNS[4, YOY]);  number of individuals in each SI
  ;print, REP
  IF rep GT 0. THEN BEGIN
    NewAge1array = FLTARR(nState, YOYcount*REP)
    FOR i = 0L, YOYcount-1L DO BEGIN
      subarray = (YOYarray[*, i]) # REPLICATE(1., rep)
      ;print, subarray
      NewAge1array[*, (i*rep):(i*rep+(rep-1L))] = subarray
      NewAge1array[3, (i*rep):(i*rep+(rep-1L))] = INDGEN(rep)+YOYarray[3, i]
      ;print, subarray1[*, i*5L:i*5L+4L]
    ENDFOR  
    NewAge1array[3, *] = FINDGEN(YOYcount*REP)+nSNS+1L; Fish ID#
    NewAge1array[4, *] = 1.; a superindividual (>1 individuals) become an individual
    NewAge1array[5, *] = ROUND(RANDOMU(seed, YOYcount*REP)) ; MALE = 0 AND FEMALE = 1        
    NewAge1array[6, *] = 1; YOYs become yearlings 
    ;LengthGT150 = WHERE(NewAge1array[7, *] GT 150., LengthGT150count)
    ;IF LengthGT150count GT 0. THEN NewAge1array[7, LengthGT150] = (NewAge1array[7, LengthGT150] - 43.14) /1.02; convert TL to FL
  ENDIF
  ;PRINT, NewAge1array[*, 0:199]
;ENDIF

;PRINT, N_ELEMENTS(SNS[0, *])
;PRINT, N_ELEMENTS(NewAge1array[0, *])
;SNS = TRANSPOSE([TRANSPOSE(SNS), TRANSPOSE(NewAge1array)])
;PRINT, 'New SNS array'
;PRINT, N_ELEMENTS(SNS[0, *])

PRINT, 'SNSNewRecArray Ends Here'      
RETURN, NewAge1array
END