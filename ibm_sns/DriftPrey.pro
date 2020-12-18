FUNCTION DriftPrey, iday, nLonTran, TotDriftBio, HydroInput;
; This function computes daily drift prey biomass.

; Activate only when testing
;nLonTran = 161L
;  ;BottomCell = WHERE(DEPTHlayer[0:47] EQ 47L, BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;  ;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;   TotDriftBio = RANDOMU(seed, nLonTran)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)


; Parameter values
VwaterCrit = 0.2; m/s, critical water velocity
GrowR1 = 0.0175; the growth rate (/d)
GrowR2 = 0.035
p = 0.25; p a term that accounts for the variation that occurs in benthic macros-> should be temp-dependent (determined by DOY?)
MinGrowRateHabitat = 0.;2; minimal habitat quality for drift prey growth
MeanMigrRate = 0.007; mean net migration rate
SDMigrRate = 0.001; SD net migration rate
Bmax = 117.6; /2.; maximum biomass 


; Assign array structure
Vwater = FLTARR(nLonTran)
r = FLTARR(nLonTran)
GrowRateHabitat = FLTARR(nLonTran)
Prod = FLTARR(nLonTran)
MigrDriftprey = FLTARR(nLonTran)
TotDriftBio2 = FLTARR(5L, nLonTran)

; Compute water velocity
Vwater[*] = HydroInput[7, *] / (HydroInput[8, *] * (HydroInput[9, *] + HydroInput[10, *]*ABS(RANDOMN(SEED, nLonTran))))
    
; Calculate production in g/d >>>>>> NEED TO BE ADJUSTED FOR DRIFT PREY IN LOWER PLATTE RIVER <<<<<<<<<<<<<<< 
VwaterHigh = WHERE(Vwater[*] GE VwaterCrit, VwaterHighcount, complement = VwaterLow, ncomplement = VwaterLowcount)
IF VwaterHighcount GT 0. THEN r[VwaterHigh] = GrowR1
IF VwaterLowcount GT 0. THEN r[VwaterLow] = GrowR2; growth rate (/d)  
    
;GrowRateHabitat = FLTARR(n);q is a habitat quality value ranges from 0.1-1
;GrowRateHabitat = RANDOMU(seed, n) + 0.1
;qtb = WHERE(GrowRateHabitat GT 1.0, qtbcount, complement = qtbc, ncomplement = qtbccount)
;IF qtbcount GT 0.0 THEN q[qtb] = 1.0 
    
; habitat quality is determined daily FOR EACH GRID CELL
GrowRateHabitat[*] = 1.01*EXP(-0.5*((Vwater[*]-0.603)/0.249)^2) > MinGrowRateHabitat;>>> NEED TO BE ADJUSTEDED FOR DISCHARGE OR PREY BIOMASS BASED
GrowRateHabitatNZ = WHERE(GrowRateHabitat GT 0., GrowRateHabitatNZcount)
IF GrowRateHabitatNZcount GT 0. THEN $
Prod[GrowRateHabitatNZ] = r[GrowRateHabitatNZ] * (1.0 + p * SIN((2.0 * !Pi * iDAY) / 365.)) * (1. - (TotDriftBio[GrowRateHabitatNZ]/(GrowRateHabitat[GrowRateHabitatNZ] * Bmax))) * TotDriftBio[GrowRateHabitatNZ]
;PRINT, 'Drift prey production'
;PRINT, Prod[*]

; Net immigration 
;MigrRate = 0.003 + RANDOMN(seed, nLonTran-1L)*0.0005;0.003; /d, ebnthic macroinvertebrate movement parameter 
FOR iLonTran = 1L, 162L-1L DO BEGIN 
  ;MigrRate = 0.0042 + RANDOMN(seed)*0.001;>>>>>>> Water velocity dependent??????
  MigrRate = MeanMigrRate + RANDOMN(seed)*SDMigrRate;>>>>>>> Water velocity dependent??????
  MigrDriftprey[iLonTran] = MigrRate * (TotDriftBio[iLonTran] - TotDriftBio[iLonTran -1L])
ENDFOR
;PRINT, 'MigrDriftprey'
;PRINT, MigrDriftprey

TotDriftBio[*] = TotDriftBio[*] + Prod[*] + MigrDriftprey[*]; DONE ONLY ONCE AT THE BEGINNING OF THE DAY

TotDriftBioNEG = WHERE(TotDriftBio LE 0., TotDriftBioNEGcount)
IF TotDriftBioNEGcount GT 0. THEN TotDriftBio[TotDriftBioNEG] = 0.
;PRINT, 'TotDriftBio'
;PRINT, transpose(TotDriftBio)

TotDriftBio2[0, *] = TotDriftBio * 0.050
TotDriftBio2[1, *] = TotDriftBio * 0.086 
TotDriftBio2[2, *] = TotDriftBio * 0.123 
TotDriftBio2[3, *] = TotDriftBio * 0.224 
TotDriftBio2[4, *] = TotDriftBio * 0.516 
;PRINT, 'TotDriftBio2'
;PRINT, TotDriftBio2


;counter = iday-1L
;pointer1 = nLonTran * counter; 1st line to read in 
;;pointer2 = nYP * (counter - 30L)
;;pointer3 = nYP * (counter - 60L)
;;pointer4 = nYP * (counter - 90L)
;;pointer5 = nYP * (counter - 120L)
;;pointer6 = nYP * (counter - 150L)
;;pointer7 = nYP * (counter - 180L)
;;pointer8 = nYP * (counter - 210L)
;;iDay = STRING(iDay)
;;iHour = STRING(iHour)
;
;data = transpose(Prod); TotDriftBio2
;
;; Set up variables.
;;OutputYEP1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputYEP.csv'
;OutputDriftPrey1='LPRDriftPrey_1.csv'
;filename1 = OutputDriftPrey1
;
;;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
;s = Size(data, /Dimensions)
;xsize = s[0]
;lineWidth = 1600
;comma = ","
;
;; Open the data file for writing.
;IF counter EQ 0L THEN BEGIN; 
;   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;ENDIF
;IF counter GT 0L AND counter LT nLonTran*366L THEN BEGIN; 
;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer1, /lines
;  READF, lun
;ENDIF
;
;; Write the data to the file.
;sData = StrTrim(data, 1)
;;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;sData[0, *] = sData[0, *] + comma
;PrintF, lun, sData
;
;; Close the file.
;Free_Lun, lun
;;PRINT, '"Your drift prey Output File is Ready"'


    
PRINT, 'Drift prey production'
;PRINT, Prod
RETURN, TotDriftBio2
END