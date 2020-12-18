FUNCTION SNSsumStat, SNS, nSumStatVar, DOY, HydroYear, nSpwnAbort, nEmmigUp, nEmmigDown, TotalRiverVol, TotalRiverArea, TotDriftCons, DriftConsRatio ;, SpwnFemale, SpwnMale
;this function creates an array output summary statistics for shovelnose sturgeon
; 'SNS' array is already subscripted (LiveIndiv2). 

PRINT, 'SNSsumstat Starts Here'

; Assign an array structure
SNSsumout = FLTARR(nSumStatVar, 1L)

;; Find live sturgeon
;LiveInd = WHERE((SNS[4, *] GT 0.), LiveIndcount, complement = DeadInd, ncomplement = DeadIndcount)

SNSsumout[0, *] = DOY; DOY
SNSsumout[1, *] = TOTAL(SNS[4, *]); total # of sturgeon individuals
SNSsumout[2, *] = TOTAL(SNS[4, *] * SNS[8, *]); total biomass of sturgeon population

SNSsumout[553, *] = HydroYear

SNSsumout[564, *] = nSpwnAbort; number of abotred spawning females

; Find males and females
Male = WHERE(SNS[5, *] EQ 0L, Malecount, complement = Female, ncomplement = Femalecount)

; Locate age-specific information
; Male
Age0Male = WHERE((SNS[6, Male] EQ 0L), Age0Malecount)
Age0aMale = WHERE((SNS[6, Male] EQ 0L) AND (SNS[7, Male] GT 0L), Age0aMalecount)
Age1Male = WHERE((SNS[6, Male] EQ 1L), Age1Malecount)
Age2Male = WHERE((SNS[6, Male] EQ 2L), Age2Malecount)
Age3Male = WHERE((SNS[6, Male] EQ 3L), Age3Malecount)
Age4Male = WHERE((SNS[6, Male] EQ 4L), Age4Malecount)
Age5Male = WHERE((SNS[6, Male] EQ 5L), Age5Malecount)
Age6Male = WHERE((SNS[6, Male] EQ 6L), Age6Malecount)
Age7Male = WHERE((SNS[6, Male] EQ 7L), Age7Malecount)
Age8Male = WHERE((SNS[6, Male] EQ 8L), Age8Malecount)
Age9Male = WHERE((SNS[6, Male] EQ 9L), Age9Malecount)
Age10Male = WHERE((SNS[6, Male] EQ 10L), Age10Malecount)
Age11Male = WHERE((SNS[6, Male] EQ 11L), Age11Malecount)
Age12Male = WHERE((SNS[6, Male] EQ 12L), Age12Malecount)
Age13Male = WHERE((SNS[6, Male] EQ 13L), Age13Malecount)
Age14Male = WHERE((SNS[6, Male] EQ 14L), Age14Malecount)
Age15Male = WHERE((SNS[6, Male] EQ 15L), Age15Malecount)
Age16plusMale = WHERE((SNS[6, Male] GE 16L), Age16plusMalecount)

; Female
Age0Female = WHERE((SNS[6, Female] EQ 0L), Age0Femalecount)
Age0aFemale = WHERE((SNS[6, Female] EQ 0L) AND (SNS[7, Female] GT 0L), Age0aFemalecount)
Age1Female = WHERE((SNS[6, Female] EQ 1L), Age1Femalecount)
Age2Female = WHERE((SNS[6, Female] EQ 2L), Age2Femalecount)
Age3Female = WHERE((SNS[6, Female] EQ 3L), Age3Femalecount)
Age4Female = WHERE((SNS[6, Female] EQ 4L), Age4Femalecount)
Age5Female = WHERE((SNS[6, Female] EQ 5L), Age5Femalecount)
Age6Female = WHERE((SNS[6, Female] EQ 6L), Age6Femalecount)
Age7Female = WHERE((SNS[6, Female] EQ 7L), Age7Femalecount)
Age8Female = WHERE((SNS[6, Female] EQ 8L), Age8Femalecount)
Age9Female = WHERE((SNS[6, Female] EQ 9L), Age9Femalecount)
Age10Female = WHERE((SNS[6, Female] EQ 10L), Age10Femalecount)
Age11Female = WHERE((SNS[6, Female] EQ 11L), Age11Femalecount)
Age12Female = WHERE((SNS[6, Female] EQ 12L), Age12Femalecount)
Age13Female = WHERE((SNS[6, Female] EQ 13L), Age13Femalecount)
Age14Female = WHERE((SNS[6, Female] EQ 14L), Age14Femalecount)
Age15Female = WHERE((SNS[6, Female] EQ 15L), Age15Femalecount)
Age16plusFemale = WHERE((SNS[6, Female] GE 16L), Age16plusFemalecount)


; Age-specific total # of individuals
; Male
IF Age0Malecount GT 0. THEN SNSsumout[3, *] = TOTAL(SNS[4, Male[Age0Male]])
IF Age1Malecount GT 0. THEN SNSsumout[4, *] = TOTAL(SNS[4, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[5, *] = TOTAL(SNS[4, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[6, *] = TOTAL(SNS[4, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[7, *] = TOTAL(SNS[4, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[8, *] = TOTAL(SNS[4, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[9, *] = TOTAL(SNS[4, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[10, *] = TOTAL(SNS[4, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[11, *] = TOTAL(SNS[4, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[12, *] = TOTAL(SNS[4, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[13, *] = TOTAL(SNS[4, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[14, *] = TOTAL(SNS[4, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[15, *] = TOTAL(SNS[4, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[16, *] = TOTAL(SNS[4, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[17, *] = TOTAL(SNS[4, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[18, *] = TOTAL(SNS[4, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[19, *] = TOTAL(SNS[4, Male[Age16plusMale]])

; Female
IF Age0Femalecount GT 0. THEN SNSsumout[20, *] = TOTAL(SNS[4, Female[Age0Female]])
IF Age1Femalecount GT 0. THEN SNSsumout[21, *] = TOTAL(SNS[4, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[22, *] = TOTAL(SNS[4, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[23, *] = TOTAL(SNS[4, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[24, *] = TOTAL(SNS[4, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[25, *] = TOTAL(SNS[4, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[26, *] = TOTAL(SNS[4, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[27, *] = TOTAL(SNS[4, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[28, *] = TOTAL(SNS[4, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[29, *] = TOTAL(SNS[4, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[30, *] = TOTAL(SNS[4, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[31, *] = TOTAL(SNS[4, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[32, *] = TOTAL(SNS[4, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[33, *] = TOTAL(SNS[4, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[34, *] = TOTAL(SNS[4, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[35, *] = TOTAL(SNS[4, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[36, *] = TOTAL(SNS[4, Female[Age16plusFemale]])


; Age-specific total biomass
; Male
IF Age0Malecount GT 0. THEN SNSsumout[37, *] = TOTAL(SNS[4, Male[Age0Male]] * SNS[8, Male[Age0Male]])
IF Age1Malecount GT 0. THEN SNSsumout[38, *] = TOTAL(SNS[4, Male[Age1Male]] * SNS[8, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[39, *] = TOTAL(SNS[4, Male[Age2Male]] * SNS[8, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[40, *] = TOTAL(SNS[4, Male[Age3Male]] * SNS[8, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[41, *] = TOTAL(SNS[4, Male[Age4Male]] * SNS[8, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[42, *] = TOTAL(SNS[4, Male[Age5Male]] * SNS[8, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[43, *] = TOTAL(SNS[4, Male[Age6Male]] * SNS[8, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[44, *] = TOTAL(SNS[4, Male[Age7Male]] * SNS[8, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[45, *] = TOTAL(SNS[4, Male[Age8Male]] * SNS[8, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[46, *] = TOTAL(SNS[4, Male[Age9Male]] * SNS[8, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[47, *] = TOTAL(SNS[4, Male[Age10Male]] * SNS[8, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[48, *] = TOTAL(SNS[4, Male[Age11Male]] * SNS[8, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[49, *] = TOTAL(SNS[4, Male[Age12Male]] * SNS[8, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[50, *] = TOTAL(SNS[4, Male[Age13Male]] * SNS[8, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[51, *] = TOTAL(SNS[4, Male[Age14Male]] * SNS[8, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[52, *] = TOTAL(SNS[4, Male[Age15Male]] * SNS[8, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[53, *] = TOTAL(SNS[4, Male[Age16plusMale]] * SNS[8, Male[Age16plusMale]])

; Female
IF Age0Femalecount GT 0. THEN SNSsumout[54, *] = TOTAL(SNS[4, Female[Age0Female]] * SNS[8, Female[Age0Female]])
IF Age1Femalecount GT 0. THEN SNSsumout[55, *] = TOTAL(SNS[4, Female[Age1Female]] * SNS[8, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[56, *] = TOTAL(SNS[4, Female[Age2Female]] * SNS[8, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[57, *] = TOTAL(SNS[4, Female[Age3Female]] * SNS[8, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[58, *] = TOTAL(SNS[4, Female[Age4Female]] * SNS[8, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[59, *] = TOTAL(SNS[4, Female[Age5Female]] * SNS[8, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[60, *] = TOTAL(SNS[4, Female[Age6Female]] * SNS[8, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[61, *] = TOTAL(SNS[4, Female[Age7Female]] * SNS[8, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[62, *] = TOTAL(SNS[4, Female[Age8Female]] * SNS[8, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[63, *] = TOTAL(SNS[4, Female[Age9Female]] * SNS[8, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[64, *] = TOTAL(SNS[4, Female[Age10Female]] * SNS[8, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[65, *] = TOTAL(SNS[4, Female[Age11Female]] * SNS[8, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[66, *] = TOTAL(SNS[4, Female[Age12Female]] * SNS[8, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[67, *] = TOTAL(SNS[4, Female[Age13Female]] * SNS[8, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[68, *] = TOTAL(SNS[4, Female[Age14Female]] * SNS[8, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[69, *] = TOTAL(SNS[4, Female[Age15Female]] * SNS[8, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[70, *] = TOTAL(SNS[4, Female[Age16plusFemale]] * SNS[8, Female[Age16plusFemale]])


; Age-specific mean length
; Male
IF Age0aMalecount GT 0. THEN SNSsumout[71, *] = MEAN(SNS[7, Male[Age0aMale]])
IF Age1Malecount GT 0. THEN SNSsumout[72, *] = MEAN(SNS[7, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[73, *] = MEAN(SNS[7, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[74, *] = MEAN(SNS[7, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[75, *] = MEAN(SNS[7, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[76, *] = MEAN(SNS[7, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[77, *] = MEAN(SNS[7, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[78, *] = MEAN(SNS[7, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[79, *] = MEAN(SNS[7, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[80, *] = MEAN(SNS[7, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[81, *] = MEAN(SNS[7, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[82, *] = MEAN(SNS[7, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[83, *] = MEAN(SNS[7, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[84, *] = MEAN(SNS[7, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[85, *] = MEAN(SNS[7, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[86, *] = MEAN(SNS[7, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[87, *] = MEAN(SNS[7, Male[Age16plusMale]])

;; Age-specific SD length
IF Age0aMalecount GT 1. THEN SNSsumout[88, *] = STDDEV(SNS[7, Male[Age0aMale]], /DOUBLE)
IF Age1Malecount GT 1. THEN SNSsumout[89, *] = STDDEV(SNS[7, Male[Age1Male]], /DOUBLE)
IF Age2Malecount GT 1. THEN SNSsumout[90, *] = STDDEV(SNS[7, Male[Age2Male]], /DOUBLE)
IF Age3Malecount GT 1. THEN SNSsumout[91, *] = STDDEV(SNS[7, Male[Age3Male]], /DOUBLE)
IF Age4Malecount GT 1. THEN SNSsumout[92, *] = STDDEV(SNS[7, Male[Age4Male]], /DOUBLE)
IF Age5Malecount GT 1. THEN SNSsumout[93, *] = STDDEV(SNS[7, Male[Age5Male]], /DOUBLE)
IF Age6Malecount GT 1. THEN SNSsumout[94, *] = STDDEV(SNS[7, Male[Age6Male]], /DOUBLE)
IF Age7Malecount GT 1. THEN SNSsumout[95, *] = STDDEV(SNS[7, Male[Age7Male]], /DOUBLE)
IF Age8Malecount GT 1. THEN SNSsumout[96, *] = STDDEV(SNS[7, Male[Age8Male]], /DOUBLE)
IF Age9Malecount GT 1. THEN SNSsumout[97, *] = STDDEV(SNS[7, Male[Age9Male]], /DOUBLE)
IF Age10Malecount GT 1. THEN SNSsumout[98, *] = STDDEV(SNS[7, Male[Age10Male]], /DOUBLE)
IF Age11Malecount GT 1. THEN SNSsumout[99, *] = STDDEV(SNS[7, Male[Age11Male]], /DOUBLE)
IF Age12Malecount GT 1. THEN SNSsumout[100, *] = STDDEV(SNS[7, Male[Age12Male]], /DOUBLE)
IF Age13Malecount GT 1. THEN SNSsumout[101, *] = STDDEV(SNS[7, Male[Age13Male]], /DOUBLE)
IF Age14Malecount GT 1. THEN SNSsumout[102, *] = STDDEV(SNS[7, Male[Age14Male]], /DOUBLE)
IF Age15Malecount GT 1. THEN SNSsumout[103, *] = STDDEV(SNS[7, Male[Age15Male]], /DOUBLE)
IF Age16plusMalecount GT 1. THEN SNSsumout[104, *] = STDDEV(SNS[7, Male[Age16plusMale]], /DOUBLE)

;PRINT, Age0aMalecount, Age1Malecount, Age2Malecount, Age3Malecount, Age4Malecount, Age5Malecount, Age6Malecount $
;  , Age7Malecount, Age8Malecount, Age9Malecount, Age10Malecount, Age11Malecount, Age12Malecount, Age13Malecount, Age14Malecount, Age15Malecount, Age16plusMalecount 
;PRINT, SNSsumout[71:87, *]
;PRINT, TRANSPOSE(SNS[7, Male[Age4Male]])
;PRINT, STDDEV(SNS[7, Male[Age4Male]], /DOUBLE)
;PRINT, SNSsumout[88:104, *]

; Female
IF Age0aFemalecount GT 0. THEN SNSsumout[105, *] = MEAN(SNS[7, Female[Age0aFemale]])
IF Age1Femalecount GT 0. THEN SNSsumout[106, *] = MEAN(SNS[7, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[107, *] = MEAN(SNS[7, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[108, *] = MEAN(SNS[7, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[109, *] = MEAN(SNS[7, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[110, *] = MEAN(SNS[7, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[111, *] = MEAN(SNS[7, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[112, *] = MEAN(SNS[7, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[113, *] = MEAN(SNS[7, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[114, *] = MEAN(SNS[7, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[115, *] = MEAN(SNS[7, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[116, *] = MEAN(SNS[7, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[117, *] = MEAN(SNS[7, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[118, *] = MEAN(SNS[7, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[119, *] = MEAN(SNS[7, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[120, *] = MEAN(SNS[7, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[121, *] = MEAN(SNS[7, Female[Age16plusFemale]])

; age-specific SD length
IF Age0aFemalecount GT 1. THEN SNSsumout[122, *] = STDDEV(SNS[7, Female[Age0aFemale]], /DOUBLE)
IF Age1Femalecount GT 1. THEN SNSsumout[123, *] = STDDEV(SNS[7, Female[Age1Female]], /DOUBLE)
IF Age2Femalecount GT 1. THEN SNSsumout[124, *] = STDDEV(SNS[7, Female[Age2Female]], /DOUBLE)
IF Age3Femalecount GT 1. THEN SNSsumout[125, *] = STDDEV(SNS[7, Female[Age3Female]], /DOUBLE)
IF Age4Femalecount GT 1. THEN SNSsumout[126, *] = STDDEV(SNS[7, Female[Age4Female]], /DOUBLE)
IF Age5Femalecount GT 1. THEN SNSsumout[127, *] = STDDEV(SNS[7, Female[Age5Female]], /DOUBLE)
IF Age6Femalecount GT 1. THEN SNSsumout[128, *] = STDDEV(SNS[7, Female[Age6Female]], /DOUBLE)
IF Age7Femalecount GT 1. THEN SNSsumout[129, *] = STDDEV(SNS[7, Female[Age7Female]], /DOUBLE)
IF Age8Femalecount GT 1. THEN SNSsumout[130, *] = STDDEV(SNS[7, Female[Age8Female]], /DOUBLE)
IF Age9Femalecount GT 1. THEN SNSsumout[131, *] = STDDEV(SNS[7, Female[Age9Female]], /DOUBLE)
IF Age10Femalecount GT 1. THEN SNSsumout[132, *] = STDDEV(SNS[7, Female[Age10Female]], /DOUBLE)
IF Age11Femalecount GT 1. THEN SNSsumout[133, *] = STDDEV(SNS[7, Female[Age11Female]], /DOUBLE)
IF Age12Femalecount GT 1. THEN SNSsumout[134, *] = STDDEV(SNS[7, Female[Age12Female]], /DOUBLE)
IF Age13Femalecount GT 1. THEN SNSsumout[135, *] = STDDEV(SNS[7, Female[Age13Female]], /DOUBLE)
IF Age14Femalecount GT 1. THEN SNSsumout[136, *] = STDDEV(SNS[7, Female[Age14Female]], /DOUBLE)
IF Age15Femalecount GT 1. THEN SNSsumout[137, *] = STDDEV(SNS[7, Female[Age15Female]], /DOUBLE)
IF Age16plusFemalecount GT 1. THEN SNSsumout[138, *] = STDDEV(SNS[7, Female[Age16plusFemale]], /DOUBLE)

; Male
; Age-specific mean weight
IF Age0aMalecount GT 0. THEN SNSsumout[139, *] = MEAN(SNS[8, Male[Age0aMale]])
IF Age1Malecount GT 0. THEN SNSsumout[140, *] = MEAN(SNS[8, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[141, *] = MEAN(SNS[8, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[142, *] = MEAN(SNS[8, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[143, *] = MEAN(SNS[8, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[144, *] = MEAN(SNS[8, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[145, *] = MEAN(SNS[8, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[146, *] = MEAN(SNS[8, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[147, *] = MEAN(SNS[8, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[148, *] = MEAN(SNS[8, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[149, *] = MEAN(SNS[8, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[150, *] = MEAN(SNS[8, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[151, *] = MEAN(SNS[8, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[152, *] = MEAN(SNS[8, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[153, *] = MEAN(SNS[8, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[154, *] = MEAN(SNS[8, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[155, *] = MEAN(SNS[8, Male[Age16plusMale]])

; Age-specific SD weight
IF Age0aMalecount GT 1. THEN SNSsumout[156, *] = STDDEV(SNS[8, Male[Age0aMale]], /DOUBLE)
IF Age1Malecount GT 1. THEN SNSsumout[157, *] = STDDEV(SNS[8, Male[Age1Male]], /DOUBLE)
IF Age2Malecount GT 1. THEN SNSsumout[158, *] = STDDEV(SNS[8, Male[Age2Male]], /DOUBLE)
IF Age3Malecount GT 1. THEN SNSsumout[159, *] = STDDEV(SNS[8, Male[Age3Male]], /DOUBLE)
IF Age4Malecount GT 1. THEN SNSsumout[160, *] = STDDEV(SNS[8, Male[Age4Male]], /DOUBLE)
IF Age5Malecount GT 1. THEN SNSsumout[161, *] = STDDEV(SNS[8, Male[Age5Male]], /DOUBLE)
IF Age6Malecount GT 1. THEN SNSsumout[162, *] = STDDEV(SNS[8, Male[Age6Male]], /DOUBLE)
IF Age7Malecount GT 1. THEN SNSsumout[163, *] = STDDEV(SNS[8, Male[Age7Male]], /DOUBLE)
IF Age8Malecount GT 1. THEN SNSsumout[164, *] = STDDEV(SNS[8, Male[Age8Male]], /DOUBLE)
IF Age9Malecount GT 1. THEN SNSsumout[165, *] = STDDEV(SNS[8, Male[Age9Male]], /DOUBLE)
IF Age10Malecount GT 1. THEN SNSsumout[166, *] = STDDEV(SNS[8, Male[Age10Male]], /DOUBLE)
IF Age11Malecount GT 1. THEN SNSsumout[167, *] = STDDEV(SNS[8, Male[Age11Male]], /DOUBLE)
IF Age12Malecount GT 1. THEN SNSsumout[168, *] = STDDEV(SNS[8, Male[Age12Male]], /DOUBLE)
IF Age13Malecount GT 1. THEN SNSsumout[169, *] = STDDEV(SNS[8, Male[Age13Male]], /DOUBLE)
IF Age14Malecount GT 1. THEN SNSsumout[170, *] = STDDEV(SNS[8, Male[Age14Male]], /DOUBLE)
IF Age15Malecount GT 1. THEN SNSsumout[171, *] = STDDEV(SNS[8, Male[Age15Male]], /DOUBLE)
IF Age16plusMalecount GT 1. THEN SNSsumout[172, *] = STDDEV(SNS[8, Male[Age16plusMale]], /DOUBLE)

; Female
; Age-specific mean weight
IF Age0aFemalecount GT 0. THEN SNSsumout[173, *] = MEAN(SNS[8, Female[Age0aFemale]])
IF Age1Femalecount GT 0. THEN SNSsumout[174, *] = MEAN(SNS[8, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[175, *] = MEAN(SNS[8, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[176, *] = MEAN(SNS[8, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[177, *] = MEAN(SNS[8, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[178, *] = MEAN(SNS[8, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[179, *] = MEAN(SNS[8, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[180, *] = MEAN(SNS[8, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[181, *] = MEAN(SNS[8, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[182, *] = MEAN(SNS[8, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[183, *] = MEAN(SNS[8, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[184, *] = MEAN(SNS[8, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[185, *] = MEAN(SNS[8, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[186, *] = MEAN(SNS[8, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[187, *] = MEAN(SNS[8, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[188, *] = MEAN(SNS[8, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[189, *] = MEAN(SNS[8, Female[Age16plusFemale]])

; Age-specific SD weight
IF Age0aFemalecount GT 1. THEN SNSsumout[190, *] = STDDEV(SNS[8, Female[Age0aFemale]], /DOUBLE)
IF Age1Femalecount GT 1. THEN SNSsumout[191, *] = STDDEV(SNS[8, Female[Age1Female]], /DOUBLE)
IF Age2Femalecount GT 1. THEN SNSsumout[192, *] = STDDEV(SNS[8, Female[Age2Female]], /DOUBLE)
IF Age3Femalecount GT 1. THEN SNSsumout[193, *] = STDDEV(SNS[8, Female[Age3Female]], /DOUBLE)
IF Age4Femalecount GT 1. THEN SNSsumout[194, *] = STDDEV(SNS[8, Female[Age4Female]], /DOUBLE)
IF Age5Femalecount GT 1. THEN SNSsumout[195, *] = STDDEV(SNS[8, Female[Age5Female]], /DOUBLE)
IF Age6Femalecount GT 1. THEN SNSsumout[196, *] = STDDEV(SNS[8, Female[Age6Female]], /DOUBLE)
IF Age7Femalecount GT 1. THEN SNSsumout[197, *] = STDDEV(SNS[8, Female[Age7Female]], /DOUBLE)
IF Age8Femalecount GT 1. THEN SNSsumout[198, *] = STDDEV(SNS[8, Female[Age8Female]], /DOUBLE)
IF Age9Femalecount GT 1. THEN SNSsumout[199, *] = STDDEV(SNS[8, Female[Age9Female]], /DOUBLE)
IF Age10Femalecount GT 1. THEN SNSsumout[200, *] = STDDEV(SNS[8, Female[Age10Female]], /DOUBLE)
IF Age11Femalecount GT 1. THEN SNSsumout[201, *] = STDDEV(SNS[8, Female[Age11Female]], /DOUBLE)
IF Age12Femalecount GT 1. THEN SNSsumout[202, *] = STDDEV(SNS[8, Female[Age12Female]], /DOUBLE)
IF Age13Femalecount GT 1. THEN SNSsumout[203, *] = STDDEV(SNS[8, Female[Age13Female]], /DOUBLE)
IF Age14Femalecount GT 1. THEN SNSsumout[204, *] = STDDEV(SNS[8, Female[Age14Female]], /DOUBLE)
IF Age15Femalecount GT 1. THEN SNSsumout[205, *] = STDDEV(SNS[8, Female[Age15Female]], /DOUBLE)
IF Age16plusFemalecount GT 1. THEN SNSsumout[206, *] = STDDEV(SNS[8, Female[Age16plusFemale]], /DOUBLE)


; Locate mature individuals
MatFemale = WHERE((SNS[12, *] GE 1L) AND (SNS[5, *] EQ 1L), MatFemalecount)
MatMale = WHERE((SNS[12, *] GE 1L) AND (SNS[5, *] EQ 0L), MatMalecount)

; Number of mature females
IF MatFemalecount GT 0. THEN SNSsumout[207, *] = TOTAL(SNS[4, MatFemale])
; Number of mature males
IF MatMalecount GT 0. THEN SNSsumout[208, *] = TOTAL(SNS[4, MatMale])


; Age at maturity
; Mean age of mature females
IF MatFemalecount GT 0. THEN SNSsumout[209, *] = MEAN(SNS[77, MatFemale])
  ; SD age of mature females
IF MatFemalecount GT 1. THEN SNSsumout[210, *] = STDDEV(SNS[77, MatFemale])

; Mean age of mature males
IF MatMalecount GT 0. THEN SNSsumout[211, *] = MEAN(SNS[77, MatMale])
  ; SD age of mature males
IF MatMalecount GT 1. THEN   SNSsumout[212, *] = STDDEV(SNS[77, MatMale]) 


;GSI
; Mean GSI of mature females
IF MatFemalecount GT 0. THEN SNSsumout[213, *] = MEAN(SNS[59, MatFemale])
  ; SD GSI of mature females
IF MatFemalecount GT 1. THEN SNSsumout[214, *] = STDDEV(SNS[59, MatFemale])
; Mean GSI of mature males
IF MatMalecount GT 0. THEN SNSsumout[215, *] = MEAN(SNS[59, MatMale])
; SD GSI of mature males
IF MatMalecount GT 1. THEN SNSsumout[216, *] = STDDEV(SNS[59, MatMale]) 

;KS
; Mean KS of mature females
IF MatFemalecount GT 0. THEN SNSsumout[217, *] = MEAN(SNS[11, MatFemale])
  ; SD KS of mature females
IF MatFemalecount GT 1. THEN SNSsumout[218, *] = STDDEV(SNS[11, MatFemale])
; Mean KS of mature males
IF MatMalecount GT 0. THEN SNSsumout[219, *] = MEAN(SNS[11, MatMale])
; SD KS of mature males
IF MatMalecount GT 1. THEN SNSsumout[220, *] = STDDEV(SNS[11, MatMale]) 


;length
; Mean length of mature females
IF MatFemalecount GT 0. THEN SNSsumout[528, *] = MEAN(SNS[7, MatFemale])
; SD length of mature females
IF MatFemalecount GT 1. THEN SNSsumout[529, *] = STDDEV(SNS[7, MatFemale])
; Mean length of mature males
IF MatMalecount GT 0. THEN SNSsumout[530, *] = MEAN(SNS[7, MatMale])
; SD length of mature males
IF MatMalecount GT 1. THEN SNSsumout[531, *] = STDDEV(SNS[7, MatMale]) 


; Number of females in the reproductive cycle
RepFemale = WHERE((SNS[14, *] GE 1.) AND (SNS[5, *] EQ 1L), RepFemalecount)
RepMale = WHERE((SNS[14, *] GE 1.) AND (SNS[5, *] EQ 0L), RepMalecount)

IF RepFemalecount GT 0. THEN SNSsumout[221, *] = TOTAL(SNS[4, RepFemale])
; Number of males in the reproductive cycle
IF RepMalecount GT 0. THEN SNSsumout[222, *] = TOTAL(SNS[4, RepMale])

;KS
; Mean KS of reproductive females
IF RepFemalecount GT 0. THEN SNSsumout[565, *] = MEAN(SNS[11, RepFemale])
  ; SD KS of reproductive females
IF RepFemalecount GT 1. THEN SNSsumout[566, *] = STDDEV(SNS[11, RepFemale])
; Mean KS of reproductive males
IF RepMalecount GT 0. THEN SNSsumout[567, *] = MEAN(SNS[11, RepMale])
; SD KS of reproductive males
IF RepMalecount GT 1. THEN SNSsumout[568, *] = STDDEV(SNS[11, RepMale]) 


; Number of spawning females ---> need array information for spawning sturgeon
SpwnFemale2 = WHERE((SNS[50, *] GT 0) AND (SNS[5, *] EQ 1L), SpwnFemale2count)
SpwnMale2 = WHERE((SNS[75, *] EQ DOY) AND (SNS[5, *] EQ 0L), SpwnMale2count)
IF SpwnFemale2count GT 0. THEN SNSsumout[223, *] = TOTAL(SNS[4, SpwnFemale2])
; Number of spawning males
IF SpwnMale2count GT 0. THEN SNSsumout[224, *] = TOTAL(SNS[4, SpwnMale2])

;length
; Mean length of spawning females
IF SpwnFemale2count GT 0. THEN SNSsumout[532, *] = MEAN(SNS[7, SpwnFemale2])
; SD length of spawning females
IF SpwnFemale2count GT 1. THEN SNSsumout[533, *] = STDDEV(SNS[7, SpwnFemale2])
; Mean length of spawning males
IF SpwnMale2count GT 0. THEN SNSsumout[534, *] = MEAN(SNS[7, SpwnMale2])
; SD length of spawning males
IF SpwnMale2count GT 1. THEN SNSsumout[535, *] = STDDEV(SNS[7, SpwnMale2]) 


; Mean number of eggs spawned
IF SpwnFemale2count GT 0. THEN SNSsumout[225, *] = MEAN(SNS[50, SpwnFemale2])
; SD number of eggs spawned
IF SpwnFemale2count GT 1. THEN SNSsumout[226, *] = STDDEV(SNS[50, SpwnFemale2])

; total number of eggs spawned
IF SpwnFemale2count GT 0. THEN SNSsumout[569, *] = TOTAL(SNS[50, SpwnFemale2])


SpwnFemale3 = WHERE((SNS[75, *] GT 0.) AND (SNS[5, *] EQ 1L), SpwnFemale3count)
;SpwnMale2 = WHERE((SNS[75, *] GT 0.) AND (SNS[5, *] EQ 0.), SpwnMale2count)
; Mean DOY of spawning
IF SpwnFemale3count GT 0. THEN SNSsumout[227, *] = MEAN(SNS[75, SpwnFemale3])
; SD DOY of spwaning
IF SpwnFemale3count GT 1. THEN SNSsumout[228, *] = STDDEV(SNS[75, SpwnFemale3])


; Mean DOY of hatching
YOYhatch = WHERE((SNS[6, *] LT 1L) AND (SNS[57, *] GE 1.) AND (SNS[58, *] LT 1.), YOYhatchcount)
IF YOYhatchcount GT 0. THEN SNSsumout[229, *] = MEAN(SNS[73, YOYhatch])
  ; SD DOY of hatching
IF YOYhatchcount GT 1. THEN  SNSsumout[230, *] = STDDEV(SNS[73, YOYhatch])

; Mean time to hatching
IF YOYhatchcount GT 0. THEN SNSsumout[475, *] = MEAN(SNS[73, YOYhatch] - SNS[75, YOYhatch])
  ; SD time to hatching
IF YOYhatchcount GT 1. THEN  SNSsumout[476, *] = STDDEV(SNS[73, YOYhatch] - SNS[75, YOYhatch])
  
; Total number of pre-settlement larval moraltiy by predation
IF  YOYhatchcount GT 0. THEN SNSsumout[231, *] = TOTAL(SNS[51, YOYhatch])
; Total number of pre-settlement larval moraltiy by lethal temperature
IF  YOYhatchcount GT 0. THEN SNSsumout[232, *] = TOTAL(SNS[53, YOYhatch])


; Mean DOY of settlemnt 
YOYsettle = WHERE((SNS[6, *] LT 1L) AND (SNS[58, *] GE 1.), YOYsettlecount)
IF  YOYsettlecount GT 0. THEN SNSsumout[233, *] = MEAN(SNS[74, YOYsettle])
  ; SD DOY of settlement
IF  YOYsettlecount GT 1. THEN  SNSsumout[234, *] = STDDEV(SNS[74, YOYsettle])

; Mean time to settlemnt 
IF  YOYsettlecount GT 0. THEN SNSsumout[477, *] = MEAN(SNS[74, YOYsettle] - SNS[73, YOYsettle])
  ; SD time to settlement
IF  YOYsettlecount GT 1. THEN  SNSsumout[478, *] = STDDEV(SNS[74, YOYsettle] - SNS[73, YOYsettle])

; Total number of postsettlement larval moraltiy by predation
IF  YOYsettlecount GT 0. THEN SNSsumout[235, *] = TOTAL(SNS[51, YOYsettle])
; Total number of postsettlement larval moraltiy by starvation
IF  YOYsettlecount GT 0. THEN SNSsumout[236, *] = TOTAL(SNS[52, YOYsettle])

; Total number of pre-settlement larvae
IF  YOYsettlecount GT 0. THEN SNSsumout[538, *] = TOTAL(SNS[4, YOYsettle])
; Total number of post-settlement larvae
IF  YOYsettlecount GT 0. THEN SNSsumout[539, *] = TOTAL(SNS[4, YOYsettle])


YOY = WHERE(SNS[6, *] LT 1L, YOYcount, complement = YAO, ncomplement = YAOcount)

; Movement rate
; mean movement rate YOY
IF YOYcount GT 0. THEN SNSsumout[237, *] = MEAN(ABS(SNS[32, YOY]))
  ; SD movement rate YOY
IF YOYcount GT 1. THEN SNSsumout[238, *] = STDDEV(ABS(SNS[32, YOY]))

IF YAOcount GT 0. THEN BEGIN
  ; mean movement rate YAO
  SNSsumout[239, *] = MEAN(ABS(SNS[32, YAO]))
  ; SD movement rate YAO
  SNSsumout[240, *] = STDDEV(ABS(SNS[32, YAO]))
ENDIF

; Emigration
;total # fish move out (upstream)
SNSsumout[241, *] = nEmmigUp; TOTAL(SNS[70, YAO])
;total # fish move out (downstream)
SNSsumout[242, *] = nEmmigDown; TOTAL(SNS[70, YAO])


; Foraging rate (g/g/d)
; mean foraging rate YOY
IF YOYsettlecount GT 0. THEN SNSsumout[243, *] = MEAN(SNS[35, YOYsettle]/SNS[8, YOYsettle])
  ;SD foraging rate YOY
IF YOYsettlecount GT 1. THEN SNSsumout[244, *] = STDDEV(SNS[35, YOYsettle]/SNS[8, YOYsettle])
; mean current  YOY
IF YOYsettlecount GT 0. THEN SNSsumout[554, *] = MEAN(SNS[18, YOYsettle] / (SNS[19, YOYsettle] * SNS[20, YOYsettle]))
  ;SD current YOY
IF YOYsettlecount GT 1. THEN SNSsumout[555, *] = STDDEV(SNS[18, YOYsettle] / (SNS[19, YOYsettle] * SNS[20, YOYsettle]))
; mean drift rate YOY
IF YOYsettlecount GT 0. THEN SNSsumout[556, *] = MEAN(SNS[27:31, YOYsettle])
  ;SD drift rate YOY
IF YOYsettlecount GT 1. THEN SNSsumout[557, *] = STDDEV(SNS[27:31, YOYsettle])


IF YAOcount GT 0. THEN BEGIN
  ;mean foraging rate YAO
  SNSsumout[245, *] = MEAN(SNS[35, YAO]/SNS[8, YAO])
  ;SD foraging rate YAO
  SNSsumout[246, *] = STDDEV(SNS[35, YAO]/SNS[8, YAO])
ENDIF

IF MatFemalecount GT 0. THEN BEGIN
  ;mean foraging rate MatFemale
  SNSsumout[536, *] = MEAN(SNS[35, MatFemale]/SNS[8, MatFemale])
  ;SD foraging rate MatFemale
  SNSsumout[537, *] = STDDEV(SNS[35, MatFemale]/SNS[8, MatFemale])
  ;mean current MatFemale
  SNSsumout[558, *] = MEAN(SNS[18, MatFemale] / (SNS[19, MatFemale] * SNS[20, MatFemale]))
  ;SD current MatFemale
  SNSsumout[559, *] = STDDEV(SNS[18, MatFemale] / (SNS[19, MatFemale] * SNS[20, MatFemale]))
  ;mean drift MatFemale
  SNSsumout[560, *] = MEAN(SNS[27:31, MatFemale])
  ;SD drift MatFemale
  SNSsumout[561, *] = STDDEV(SNS[27:31, MatFemale])  
END  

IF RepFemalecount GT 0. THEN SNSsumout[562, *] = MEAN(SNS[35, RepFemale]/SNS[8, RepFemale])
; Number of males in the reproductive cycle
IF RepFemalecount GT 0. THEN SNSsumout[563, *] = STDDEV(SNS[35, RepFemale]/SNS[8, RepFemale])


SNSsumout[540, *] = TOTAL(TotDriftCons)
SNSsumout[541, *] = MEAN(DriftConsRatio)


; Growth rate in length
;mean growth rate YOY
IF YOYsettlecount GT 0. THEN SNSsumout[247, *] = MEAN(SNS[47, YOYsettle])
  ;SD growth rate YOY
IF YOYsettlecount GT 1. THEN SNSsumout[248, *] = STDDEV(SNS[47, YOYsettle])

IF YAOcount GT 0. THEN BEGIN
  ;mean growth rate YAO
  SNSsumout[249, *] = MEAN(SNS[47, YAO])
  ;SD growth rate YAO
  SNSsumout[250, *] = STDDEV(SNS[47, YAO])
ENDIF


; Growth rate in weight
;mean growth rate YOY
IF YOYsettlecount GT 0. THEN SNSsumout[251, *] = MEAN(SNS[48, YOYsettle]/SNS[8, YOYsettle])
  ;SD growth rate YOY
IF YOYsettlecount GT 1. THEN SNSsumout[252, *] = STDDEV(SNS[48, YOYsettle]/SNS[8, YOYsettle])

IF YAOcount GT 0. THEN BEGIN
  ;mean growth rate YAO
  SNSsumout[253, *] = MEAN(SNS[48, YAO])
  ;SD growth rate YAO
  SNSsumout[254, *] = STDDEV(SNS[48, YAO])
ENDIF


; Mean physiological condition
;mean KS YOY
IF YOYsettlecount GT 0. THEN SNSsumout[255, *] = MEAN(SNS[11, YOYsettle])
  ;SD KS YOY
IF YOYsettlecount GT 1. THEN SNSsumout[256, *] = STDDEV(SNS[11, YOYsettle])
IF YAOcount GT 0. THEN BEGIN
  ;mean KS YAO
  SNSsumout[257, *] = MEAN(SNS[11, YAO])
  ;SD KS YAO
  SNSsumout[258, *] = STDDEV(SNS[11, YAO])
ENDIF


; Mean location of spawning females
IF SpwnFemale2count GT 0. THEN SNSsumout[259, *] = MEAN(SNS[17, SpwnFemale2])
; SD location of spawning females
IF SpwnFemale2count GT 1. THEN SNSsumout[260, *] = STDDEV(SNS[17, SpwnFemale2])

; Mean location of swimup
IF YOYsettlecount GT 0. THEN SNSsumout[261, *] = MEAN(SNS[17, YOYsettle])
; SD location of swimup
IF YOYsettlecount GT 1. THEN SNSsumout[262, *] = STDDEV(SNS[17, YOYsettle])


; River total volume and area
SNSsumout[263, *] = TotalRiverVol
SNSsumout[527, *] = TotalRiverArea


IF YOYcount GT 0. THEN BEGIN
  YOYlive = WHERE(SNS[4, YOY] GT 0., YOYlivecount)
  IF YOYlivecount GT 0. THEN nYOYSI = YOYlivecount 
ENDIF ELSE nYOYSI = 0.

IF YAOcount GT 0. THEN SNSsumout[264, *] = TOTAL(SNS[4, YAO]) + nYOYSI; total # of sturgeon individuals w/ YOY as SI
PRINT, 'Total # w/ SI YOYs (SNSsumout[264, *])', SNSsumout[264, *];, SNSsumout[1, *] - TOTAL(SNS[4, YOY]) + nYOYSI

; Age-specific total mortality
; Male
IF Age0aMalecount GT 0. THEN SNSsumout[265, *] = TOTAL(SNS[51:52, Male[Age0aMale]])
IF Age1Malecount GT 0. THEN SNSsumout[266, *] = TOTAL(SNS[51:52, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[267, *] = TOTAL(SNS[51:52, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[268, *] = TOTAL(SNS[51:52, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[269, *] = TOTAL(SNS[51:52, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[270, *] = TOTAL(SNS[51:52, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[271, *] = TOTAL(SNS[51:52, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[272, *] = TOTAL(SNS[51:52, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[273, *] = TOTAL(SNS[51:52, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[274, *] = TOTAL(SNS[51:52, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[275, *] = TOTAL(SNS[51:52, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[276, *] = TOTAL(SNS[51:52, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[277, *] = TOTAL(SNS[51:52, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[278, *] = TOTAL(SNS[51:52, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[279, *] = TOTAL(SNS[51:52, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[280, *] = TOTAL(SNS[51:52, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[281, *] = TOTAL(SNS[51:52, Male[Age16plusMale]])

; Female
IF Age0aFemalecount GT 0. THEN SNSsumout[282, *] = TOTAL(SNS[51:52, Female[Age0aFemale]])
IF Age1Femalecount GT 0. THEN SNSsumout[283, *] = TOTAL(SNS[51:52, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[284, *] = TOTAL(SNS[51:52, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[285, *] = TOTAL(SNS[51:52, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[286, *] = TOTAL(SNS[51:52, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[287, *] = TOTAL(SNS[51:52, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[288, *] = TOTAL(SNS[51:52, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[289, *] = TOTAL(SNS[51:52, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[290, *] = TOTAL(SNS[51:52, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[291, *] = TOTAL(SNS[51:52, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[292, *] = TOTAL(SNS[51:52, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[293, *] = TOTAL(SNS[51:52, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[294, *] = TOTAL(SNS[51:52, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[295, *] = TOTAL(SNS[51:52, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[296, *] = TOTAL(SNS[51:52, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[297, *] = TOTAL(SNS[51:52, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[298, *] = TOTAL(SNS[51:52, Female[Age16plusFemale]])
;PRINT, 'SNSsumout'
;PRINT, TRANSPOSE(SNSsumout[282:298, *])


; Male
; Age-specific mean storage weight
IF Age0aMalecount GT 0. THEN SNSsumout[299, *] = MEAN(SNS[9, Male[Age0aMale]])
IF Age1Malecount GT 0. THEN SNSsumout[300, *] = MEAN(SNS[9, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[301, *] = MEAN(SNS[9, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[302, *] = MEAN(SNS[9, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[303, *] = MEAN(SNS[9, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[304, *] = MEAN(SNS[9, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[305, *] = MEAN(SNS[9, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[306, *] = MEAN(SNS[9, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[307, *] = MEAN(SNS[9, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[308, *] = MEAN(SNS[9, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[309, *] = MEAN(SNS[9, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[310, *] = MEAN(SNS[9, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[311, *] = MEAN(SNS[9, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[312, *] = MEAN(SNS[9, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[313, *] = MEAN(SNS[9, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[314, *] = MEAN(SNS[9, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[315, *] = MEAN(SNS[9, Male[Age16plusMale]])

; Age-specific SD storage weight
IF Age0aMalecount GT 1. THEN SNSsumout[316, *] = STDDEV(SNS[9, Male[Age0aMale]], /DOUBLE)
IF Age1Malecount GT 1. THEN SNSsumout[317, *] = STDDEV(SNS[9, Male[Age1Male]], /DOUBLE)
IF Age2Malecount GT 1. THEN SNSsumout[318, *] = STDDEV(SNS[9, Male[Age2Male]], /DOUBLE)
IF Age3Malecount GT 1. THEN SNSsumout[319, *] = STDDEV(SNS[9, Male[Age3Male]], /DOUBLE)
IF Age4Malecount GT 1. THEN SNSsumout[320, *] = STDDEV(SNS[9, Male[Age4Male]], /DOUBLE)
IF Age5Malecount GT 1. THEN SNSsumout[321, *] = STDDEV(SNS[9, Male[Age5Male]], /DOUBLE)
IF Age6Malecount GT 1. THEN SNSsumout[322, *] = STDDEV(SNS[9, Male[Age6Male]], /DOUBLE)
IF Age7Malecount GT 1. THEN SNSsumout[323, *] = STDDEV(SNS[9, Male[Age7Male]], /DOUBLE)
IF Age8Malecount GT 1. THEN SNSsumout[324, *] = STDDEV(SNS[9, Male[Age8Male]], /DOUBLE)
IF Age9Malecount GT 1. THEN SNSsumout[325, *] = STDDEV(SNS[9, Male[Age9Male]], /DOUBLE)
IF Age10Malecount GT 1. THEN SNSsumout[326, *] = STDDEV(SNS[9, Male[Age10Male]], /DOUBLE)
IF Age11Malecount GT 1. THEN SNSsumout[327, *] = STDDEV(SNS[9, Male[Age11Male]], /DOUBLE)
IF Age12Malecount GT 1. THEN SNSsumout[328, *] = STDDEV(SNS[9, Male[Age12Male]], /DOUBLE)
IF Age13Malecount GT 1. THEN SNSsumout[329, *] = STDDEV(SNS[9, Male[Age13Male]], /DOUBLE)
IF Age14Malecount GT 1. THEN SNSsumout[330, *] = STDDEV(SNS[9, Male[Age14Male]], /DOUBLE)
IF Age15Malecount GT 1. THEN SNSsumout[331, *] = STDDEV(SNS[9, Male[Age15Male]], /DOUBLE)
IF Age16plusMalecount GT 1. THEN SNSsumout[332, *] = STDDEV(SNS[9, Male[Age16plusMale]], /DOUBLE)

; Female
; Age-specific mean storage weight
IF Age0aFemalecount GT 0. THEN SNSsumout[333, *] = MEAN(SNS[9, Female[Age0aFemale]])
IF Age1Femalecount GT 0. THEN SNSsumout[334, *] = MEAN(SNS[9, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[335, *] = MEAN(SNS[9, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[336, *] = MEAN(SNS[9, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[337, *] = MEAN(SNS[9, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[338, *] = MEAN(SNS[9, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[339, *] = MEAN(SNS[9, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[340, *] = MEAN(SNS[9, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[341, *] = MEAN(SNS[9, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[342, *] = MEAN(SNS[9, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[343, *] = MEAN(SNS[9, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[344, *] = MEAN(SNS[9, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[345, *] = MEAN(SNS[9, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[346, *] = MEAN(SNS[9, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[347, *] = MEAN(SNS[9, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[348, *] = MEAN(SNS[9, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[349, *] = MEAN(SNS[9, Female[Age16plusFemale]])

; Age-specific SD storage weight
IF Age0aFemalecount GT 1. THEN SNSsumout[350, *] = STDDEV(SNS[9, Female[Age0aFemale]], /DOUBLE)
IF Age1Femalecount GT 1. THEN SNSsumout[351, *] = STDDEV(SNS[9, Female[Age1Female]], /DOUBLE)
IF Age2Femalecount GT 1. THEN SNSsumout[352, *] = STDDEV(SNS[9, Female[Age2Female]], /DOUBLE)
IF Age3Femalecount GT 1. THEN SNSsumout[353, *] = STDDEV(SNS[9, Female[Age3Female]], /DOUBLE)
IF Age4Femalecount GT 1. THEN SNSsumout[354, *] = STDDEV(SNS[9, Female[Age4Female]], /DOUBLE)
IF Age5Femalecount GT 1. THEN SNSsumout[355, *] = STDDEV(SNS[9, Female[Age5Female]], /DOUBLE)
IF Age6Femalecount GT 1. THEN SNSsumout[356, *] = STDDEV(SNS[9, Female[Age6Female]], /DOUBLE)
IF Age7Femalecount GT 1. THEN SNSsumout[357, *] = STDDEV(SNS[9, Female[Age7Female]], /DOUBLE)
IF Age8Femalecount GT 1. THEN SNSsumout[358, *] = STDDEV(SNS[9, Female[Age8Female]], /DOUBLE)
IF Age9Femalecount GT 1. THEN SNSsumout[359, *] = STDDEV(SNS[9, Female[Age9Female]], /DOUBLE)
IF Age10Femalecount GT 1. THEN SNSsumout[360, *] = STDDEV(SNS[9, Female[Age10Female]], /DOUBLE)
IF Age11Femalecount GT 1. THEN SNSsumout[361, *] = STDDEV(SNS[9, Female[Age11Female]], /DOUBLE)
IF Age12Femalecount GT 1. THEN SNSsumout[362, *] = STDDEV(SNS[9, Female[Age12Female]], /DOUBLE)
IF Age13Femalecount GT 1. THEN SNSsumout[363, *] = STDDEV(SNS[9, Female[Age13Female]], /DOUBLE)
IF Age14Femalecount GT 1. THEN SNSsumout[364, *] = STDDEV(SNS[9, Female[Age14Female]], /DOUBLE)
IF Age15Femalecount GT 1. THEN SNSsumout[365, *] = STDDEV(SNS[9, Female[Age15Female]], /DOUBLE)
IF Age16plusFemalecount GT 1. THEN SNSsumout[366, *] = STDDEV(SNS[9, Female[Age16plusFemale]], /DOUBLE)

; Male
; Age-specific mean structural weight
IF Age0aMalecount GT 0. THEN SNSsumout[367, *] = MEAN(SNS[10, Male[Age0aMale]])
IF Age1Malecount GT 0. THEN SNSsumout[368, *] = MEAN(SNS[10, Male[Age1Male]])
IF Age2Malecount GT 0. THEN SNSsumout[369, *] = MEAN(SNS[10, Male[Age2Male]])
IF Age3Malecount GT 0. THEN SNSsumout[370, *] = MEAN(SNS[10, Male[Age3Male]])
IF Age4Malecount GT 0. THEN SNSsumout[371, *] = MEAN(SNS[10, Male[Age4Male]])
IF Age5Malecount GT 0. THEN SNSsumout[372, *] = MEAN(SNS[10, Male[Age5Male]])
IF Age6Malecount GT 0. THEN SNSsumout[373, *] = MEAN(SNS[10, Male[Age6Male]])
IF Age7Malecount GT 0. THEN SNSsumout[374, *] = MEAN(SNS[10, Male[Age7Male]])
IF Age8Malecount GT 0. THEN SNSsumout[375, *] = MEAN(SNS[10, Male[Age8Male]])
IF Age9Malecount GT 0. THEN SNSsumout[376, *] = MEAN(SNS[10, Male[Age9Male]])
IF Age10Malecount GT 0. THEN SNSsumout[377, *] = MEAN(SNS[10, Male[Age10Male]])
IF Age11Malecount GT 0. THEN SNSsumout[378, *] = MEAN(SNS[10, Male[Age11Male]])
IF Age12Malecount GT 0. THEN SNSsumout[379, *] = MEAN(SNS[10, Male[Age12Male]])
IF Age13Malecount GT 0. THEN SNSsumout[380, *] = MEAN(SNS[10, Male[Age13Male]])
IF Age14Malecount GT 0. THEN SNSsumout[381, *] = MEAN(SNS[10, Male[Age14Male]])
IF Age15Malecount GT 0. THEN SNSsumout[382, *] = MEAN(SNS[10, Male[Age15Male]])
IF Age16plusMalecount GT 0. THEN SNSsumout[383, *] = MEAN(SNS[10, Male[Age16plusMale]])

; Age-specific SD structural weight
IF Age0aMalecount GT 1. THEN SNSsumout[384, *] = STDDEV(SNS[10, Male[Age0aMale]], /DOUBLE)
IF Age1Malecount GT 1. THEN SNSsumout[385, *] = STDDEV(SNS[10, Male[Age1Male]], /DOUBLE)
IF Age2Malecount GT 1. THEN SNSsumout[386, *] = STDDEV(SNS[10, Male[Age2Male]], /DOUBLE)
IF Age3Malecount GT 1. THEN SNSsumout[387, *] = STDDEV(SNS[10, Male[Age3Male]], /DOUBLE)
IF Age4Malecount GT 1. THEN SNSsumout[388, *] = STDDEV(SNS[10, Male[Age4Male]], /DOUBLE)
IF Age5Malecount GT 1. THEN SNSsumout[389, *] = STDDEV(SNS[10, Male[Age5Male]], /DOUBLE)
IF Age6Malecount GT 1. THEN SNSsumout[390, *] = STDDEV(SNS[10, Male[Age6Male]], /DOUBLE)
IF Age7Malecount GT 1. THEN SNSsumout[391, *] = STDDEV(SNS[10, Male[Age7Male]], /DOUBLE)
IF Age8Malecount GT 1. THEN SNSsumout[392, *] = STDDEV(SNS[10, Male[Age8Male]], /DOUBLE)
IF Age9Malecount GT 1. THEN SNSsumout[393, *] = STDDEV(SNS[10, Male[Age9Male]], /DOUBLE)
IF Age10Malecount GT 1. THEN SNSsumout[394, *] = STDDEV(SNS[10, Male[Age10Male]], /DOUBLE)
IF Age11Malecount GT 1. THEN SNSsumout[395, *] = STDDEV(SNS[10, Male[Age11Male]], /DOUBLE)
IF Age12Malecount GT 1. THEN SNSsumout[396, *] = STDDEV(SNS[10, Male[Age12Male]], /DOUBLE)
IF Age13Malecount GT 1. THEN SNSsumout[397, *] = STDDEV(SNS[10, Male[Age13Male]], /DOUBLE)
IF Age14Malecount GT 1. THEN SNSsumout[398, *] = STDDEV(SNS[10, Male[Age14Male]], /DOUBLE)
IF Age15Malecount GT 1. THEN SNSsumout[399, *] = STDDEV(SNS[10, Male[Age15Male]], /DOUBLE)
IF Age16plusMalecount GT 1. THEN SNSsumout[400, *] = STDDEV(SNS[10, Male[Age16plusMale]], /DOUBLE)

; Female
; Age-specific mean structural weight
IF Age0aFemalecount GT 0. THEN SNSsumout[401, *] = MEAN(SNS[10, Female[Age0aFemale]])
IF Age1Femalecount GT 0. THEN SNSsumout[402, *] = MEAN(SNS[10, Female[Age1Female]])
IF Age2Femalecount GT 0. THEN SNSsumout[403, *] = MEAN(SNS[10, Female[Age2Female]])
IF Age3Femalecount GT 0. THEN SNSsumout[404, *] = MEAN(SNS[10, Female[Age3Female]])
IF Age4Femalecount GT 0. THEN SNSsumout[405, *] = MEAN(SNS[10, Female[Age4Female]])
IF Age5Femalecount GT 0. THEN SNSsumout[406, *] = MEAN(SNS[10, Female[Age5Female]])
IF Age6Femalecount GT 0. THEN SNSsumout[407, *] = MEAN(SNS[10, Female[Age6Female]])
IF Age7Femalecount GT 0. THEN SNSsumout[408, *] = MEAN(SNS[10, Female[Age7Female]])
IF Age8Femalecount GT 0. THEN SNSsumout[409, *] = MEAN(SNS[10, Female[Age8Female]])
IF Age9Femalecount GT 0. THEN SNSsumout[410, *] = MEAN(SNS[10, Female[Age9Female]])
IF Age10Femalecount GT 0. THEN SNSsumout[411, *] = MEAN(SNS[10, Female[Age10Female]])
IF Age11Femalecount GT 0. THEN SNSsumout[412, *] = MEAN(SNS[10, Female[Age11Female]])
IF Age12Femalecount GT 0. THEN SNSsumout[413, *] = MEAN(SNS[10, Female[Age12Female]])
IF Age13Femalecount GT 0. THEN SNSsumout[414, *] = MEAN(SNS[10, Female[Age13Female]])
IF Age14Femalecount GT 0. THEN SNSsumout[415, *] = MEAN(SNS[10, Female[Age14Female]])
IF Age15Femalecount GT 0. THEN SNSsumout[416, *] = MEAN(SNS[10, Female[Age15Female]])
IF Age16plusFemalecount GT 0. THEN SNSsumout[417, *] = MEAN(SNS[10, Female[Age16plusFemale]])

; Age-specific SD structural weight
IF Age0aFemalecount GT 1. THEN SNSsumout[418, *] = STDDEV(SNS[10, Female[Age0aFemale]], /DOUBLE)
IF Age1Femalecount GT 1. THEN SNSsumout[419, *] = STDDEV(SNS[10, Female[Age1Female]], /DOUBLE)
IF Age2Femalecount GT 1. THEN SNSsumout[420, *] = STDDEV(SNS[10, Female[Age2Female]], /DOUBLE)
IF Age3Femalecount GT 1. THEN SNSsumout[421, *] = STDDEV(SNS[10, Female[Age3Female]], /DOUBLE)
IF Age4Femalecount GT 1. THEN SNSsumout[422, *] = STDDEV(SNS[10, Female[Age4Female]], /DOUBLE)
IF Age5Femalecount GT 1. THEN SNSsumout[423, *] = STDDEV(SNS[10, Female[Age5Female]], /DOUBLE)
IF Age6Femalecount GT 1. THEN SNSsumout[424, *] = STDDEV(SNS[10, Female[Age6Female]], /DOUBLE)
IF Age7Femalecount GT 1. THEN SNSsumout[425, *] = STDDEV(SNS[10, Female[Age7Female]], /DOUBLE)
IF Age8Femalecount GT 1. THEN SNSsumout[426, *] = STDDEV(SNS[10, Female[Age8Female]], /DOUBLE)
IF Age9Femalecount GT 1. THEN SNSsumout[427, *] = STDDEV(SNS[10, Female[Age9Female]], /DOUBLE)
IF Age10Femalecount GT 1. THEN SNSsumout[428, *] = STDDEV(SNS[10, Female[Age10Female]], /DOUBLE)
IF Age11Femalecount GT 1. THEN SNSsumout[429, *] = STDDEV(SNS[10, Female[Age11Female]], /DOUBLE)
IF Age12Femalecount GT 1. THEN SNSsumout[430, *] = STDDEV(SNS[10, Female[Age12Female]], /DOUBLE)
IF Age13Femalecount GT 1. THEN SNSsumout[431, *] = STDDEV(SNS[10, Female[Age13Female]], /DOUBLE)
IF Age14Femalecount GT 1. THEN SNSsumout[432, *] = STDDEV(SNS[10, Female[Age14Female]], /DOUBLE)
IF Age15Femalecount GT 1. THEN SNSsumout[433, *] = STDDEV(SNS[10, Female[Age15Female]], /DOUBLE)
IF Age16plusFemalecount GT 1. THEN SNSsumout[434, *] = STDDEV(SNS[10, Female[Age16plusFemale]], /DOUBLE)


; Locate repeat spawners
ReSpwnFemale = WHERE((SNS[76, *] GT 1L) AND (SNS[5, *] EQ 1L), ReSpwnFemalecount)
ReSpwnMale = WHERE((SNS[76, *] GT 1L) AND (SNS[5, *] EQ 0L), ReSpwnMalecount)

;Spawning interval
; Mean spawning interval for females
IF ReSpwnFemalecount GT 0. THEN SNSsumout[435, *] = MEAN(SNS[72, ReSpwnFemale])
  ; SD spawning interval for  females
IF ReSpwnFemalecount GT 1. THEN SNSsumout[436, *] = STDDEV(SNS[72, ReSpwnFemale])
; Mean spawning interval for  males
IF ReSpwnMalecount GT 0. THEN SNSsumout[437, *] = MEAN(SNS[72, ReSpwnMale])
; SD spawning interval for males
IF ReSpwnMalecount GT 1. THEN SNSsumout[438, *] = STDDEV(SNS[72, ReSpwnMale]) 

SpwnFemale4 = WHERE((SNS[76, *] GE 1L) AND (SNS[5, *] EQ 1L), SpwnFemale4count)
SpwnMale3 = WHERE((SNS[76, *] GE 1L) AND (SNS[5, *] EQ 0L), SpwnMale3count)

;Spawning frequency
; Mean spawning frequency for females
IF SpwnFemale4count GT 0. THEN SNSsumout[439, *] = MEAN(SNS[76, SpwnFemale4])
; SD spawning frequency for  females
IF SpwnFemale4count GT 1. THEN SNSsumout[440, *] = STDDEV(SNS[76, SpwnFemale4])
; Mean spawning frequency for  males
IF SpwnMale3count GT 0. THEN SNSsumout[441, *] = MEAN(SNS[76, SpwnMale3])
; SD spawning frequency for  males
IF SpwnMale3count GT 1. THEN SNSsumout[442, *] = STDDEV(SNS[76, SpwnMale3]) 


;Life stage-specific energy allocation (proportion)
JuvFemale = WHERE((SNS[6, *] GE 1L) AND (SNS[12, *] LT 1L) AND (SNS[5, *] EQ 1L), JuvFemalecount)
JuvMale = WHERE((SNS[6, *] GE 1L) AND (SNS[12, *] LT 1L) AND (SNS[5, *] EQ 0L), JuvMalecount)

;Storage
; Mean of JUVENILE(AGE 1+) females
IF JuvFemalecount GT 0. THEN SNSsumout[447, *] = MEAN(SNS[9, JuvFemale]/SNS[8, JuvFemale])
  ; SD of JUVENILE(AGE 1+) females
IF JuvFemalecount GT 1. THEN SNSsumout[448, *] = STDDEV(SNS[9, JuvFemale]/SNS[8, JuvFemale], /DOUBLE)
; Mean of JUVENILE(AGE 1+) males
IF JuvMalecount GT 0. THEN SNSsumout[449, *] = MEAN(SNS[9, JuvMale]/SNS[8, JuvMale])
; SD of JUVENILE(AGE 1+) males
IF JuvMalecount GT 1. THEN SNSsumout[450, *] = STDDEV(SNS[9, JuvMale]/SNS[8, JuvMale], /DOUBLE) 

;Structural weight
; Mean of JUVENILE(AGE 1+) females
IF JuvFemalecount GT 0. THEN SNSsumout[443, *] = MEAN(SNS[10, JuvFemale]/SNS[8, JuvFemale])
  ; SD of JUVENILE(AGE 1+) females
IF JuvFemalecount GT 1. THEN SNSsumout[444, *] = STDDEV(SNS[10, JuvFemale]/SNS[8, JuvFemale], /DOUBLE)
; Mean of JUVENILE(AGE 1+) males
IF JuvMalecount GT 0. THEN SNSsumout[445, *] = MEAN(SNS[10, JuvMale]/SNS[8, JuvMale])
; SD of JUVENILE(AGE 1+) males
IF JuvMalecount GT 1. THEN SNSsumout[446, *] = STDDEV(SNS[10, JuvMale]/SNS[8, JuvMale], /DOUBLE) 


;Storage
; Mean of reproductive females
IF RepFemalecount GT 0. THEN SNSsumout[455, *] = MEAN(SNS[9, RepFemale]/SNS[8, RepFemale])
  ; SD of reproductive females
IF RepFemalecount GT 1. THEN SNSsumout[456, *] = STDDEV(SNS[9, RepFemale]/SNS[8, RepFemale], /DOUBLE)
; Mean of reproductive males
IF RepMalecount GT 0. THEN SNSsumout[457, *] = MEAN(SNS[9, RepMale]/SNS[8, RepMale])
; SD of reproductive males
IF RepMalecount GT 1. THEN SNSsumout[458, *] = STDDEV(SNS[9, MatMale]/SNS[8, RepMale], /DOUBLE) 

;Structural weight
; Mean of reproductive females
IF RepFemalecount GT 0. THEN SNSsumout[451, *] = MEAN(SNS[10, RepFemale]/SNS[8, RepFemale])
  ; SD of reproductive females
IF RepFemalecount GT 1. THEN SNSsumout[452, *] = STDDEV(SNS[10, RepFemale]/SNS[8, RepFemale], /DOUBLE)
; Mean of reproductive males
IF RepMalecount GT 0. THEN SNSsumout[453, *] = MEAN(SNS[10, RepMale]/SNS[8, RepMale])
; SD of reproductive males
IF RepMalecount GT 1. THEN SNSsumout[454, *] = STDDEV(SNS[10, RepMale]/SNS[8, RepMale], /DOUBLE) 

;Gonad
; Mean of reproductive females
IF RepFemalecount GT 0. THEN SNSsumout[459, *] = MEAN(SNS[13, RepFemale]/SNS[8, RepFemale])
  ; SD of reproductive females
IF RepFemalecount GT 1. THEN SNSsumout[460, *] = STDDEV(SNS[13, RepFemale]/SNS[8, RepFemale], /DOUBLE)
; Mean of reproductive males
IF RepMalecount GT 0. THEN SNSsumout[461, *] = MEAN(SNS[13, RepMale]/SNS[8, RepMale])
; SD of reproductive males
IF RepMalecount GT 1. THEN SNSsumout[462, *] = STDDEV(SNS[13, RepMale]/SNS[8, RepMale], /DOUBLE) 

; Find non-reproductive adults
NonRepFemale = WHERE((SNS[12, *] GE 1.) AND (SNS[14, *] LT 1.) AND (SNS[5, *] EQ 1L), NonRepFemalecount)
NonRepMale = WHERE((SNS[12, *] GE 1.) AND (SNS[14, *] LT 1.) AND (SNS[5, *] EQ 0L), NonRepMalecount)

;Storage
; Mean of non-reproductive females
IF NonRepFemalecount GT 0. THEN SNSsumout[463, *] = MEAN(SNS[9, NonRepFemale]/SNS[8, NonRepFemale])
  ; SD of non-reproductive females
IF NonRepFemalecount GT 1. THEN SNSsumout[464, *] = STDDEV(SNS[9, NonRepFemale]/SNS[8, NonRepFemale], /DOUBLE)
; Mean of non-reproductive males
IF NonRepMalecount GT 0. THEN SNSsumout[465, *] = MEAN(SNS[9, NonRepMale]/SNS[8, NonRepMale])
; SD of non-reproductive males
IF NonRepMalecount GT 1. THEN SNSsumout[466, *] = STDDEV(SNS[9, NonRepMale]/SNS[8, NonRepMale], /DOUBLE) 

;Structural weight
; Mean of non-reproductive females
IF NonRepFemalecount GT 0. THEN SNSsumout[467, *] = MEAN(SNS[10, NonRepFemale]/SNS[8, NonRepFemale])
  ; SD of non-reproductive females
IF NonRepFemalecount GT 1. THEN SNSsumout[468, *] = STDDEV(SNS[10, NonRepFemale]/SNS[8, NonRepFemale], /DOUBLE)
; Mean of non-reproductive males
IF NonRepMalecount GT 0. THEN SNSsumout[469, *] = MEAN(SNS[10, NonRepMale]/SNS[8, NonRepMale])
; SD of non-reproductive males
IF NonRepMalecount GT 1. THEN SNSsumout[470, *] = STDDEV(SNS[10, NonRepMale]/SNS[8, NonRepMale], /DOUBLE) 

;Gonad
; Mean of non-reproductive females
IF NonRepFemalecount GT 0. THEN SNSsumout[471, *] = MEAN(SNS[13, NonRepFemale]/SNS[8, NonRepFemale])
  ; SD of non-reproductive females
IF NonRepFemalecount GT 1. THEN SNSsumout[472, *] = STDDEV(SNS[13, NonRepFemale]/SNS[8, NonRepFemale], /DOUBLE)
; Mean of non-reproductive males
IF NonRepMalecount GT 0. THEN SNSsumout[473, *] = MEAN(SNS[13, NonRepMale]/SNS[8, NonRepMale])
; SD of non-reproductive males
IF NonRepMalecount GT 1. THEN SNSsumout[474, *] = STDDEV(SNS[13, NonRepMale]/SNS[8, NonRepMale], /DOUBLE) 


; Age-specific spawning stock information
;SpwnFemale2 = WHERE((SNS[50, *] GT 0) AND (SNS[5, *] EQ 1L), SpwnFemale2count)
;SpwnMale2 = WHERE((SNS[75, *] EQ DOY) AND (SNS[5, *] EQ 0L), SpwnMale2count)
; Male
SpwnAge4Male = WHERE((SNS[6, Male] EQ 4L) AND (SNS[75, Male] GT DOY), SpwnAge4Malecount)
SpwnAge5Male = WHERE((SNS[6, Male] EQ 5L) AND (SNS[75, Male] GT DOY), SpwnAge5Malecount)
SpwnAge6Male = WHERE((SNS[6, Male] EQ 6L) AND (SNS[75, Male] GT DOY), SpwnAge6Malecount)
SpwnAge7Male = WHERE((SNS[6, Male] EQ 7L) AND (SNS[75, Male] GT DOY), SpwnAge7Malecount)
SpwnAge8Male = WHERE((SNS[6, Male] EQ 8L) AND (SNS[75, Male] GT DOY), SpwnAge8Malecount)
SpwnAge9Male = WHERE((SNS[6, Male] EQ 9L) AND (SNS[75, Male] GT DOY), SpwnAge9Malecount)
SpwnAge10Male = WHERE((SNS[6, Male] EQ 10L) AND (SNS[75, Male] GT DOY), SpwnAge10Malecount)
SpwnAge11Male = WHERE((SNS[6, Male] EQ 11L) AND (SNS[75, Male] GT DOY), SpwnAge11Malecount)
SpwnAge12Male = WHERE((SNS[6, Male] EQ 12L) AND (SNS[75, Male] GT DOY), SpwnAge12Malecount)
SpwnAge13Male = WHERE((SNS[6, Male] EQ 13L) AND (SNS[75, Male] GT DOY), SpwnAge13Malecount)
SpwnAge14Male = WHERE((SNS[6, Male] EQ 14L) AND (SNS[75, Male] GT DOY), SpwnAge14Malecount)
SpwnAge15Male = WHERE((SNS[6, Male] EQ 15L) AND (SNS[75, Male] GT DOY), SpwnAge15Malecount)
SpwnAge16plusMale = WHERE((SNS[6, Male] GE 16L) AND (SNS[75, Male] GT DOY), SpwnAge16plusMalecount)

; Female
SpwnAge6Female = WHERE((SNS[6, Female] EQ 6L) AND (SNS[50, Female] GT 0), SpwnAge6Femalecount)
SpwnAge7Female = WHERE((SNS[6, Female] EQ 7L) AND (SNS[50, Female] GT 0), SpwnAge7Femalecount)
SpwnAge8Female = WHERE((SNS[6, Female] EQ 8L) AND (SNS[50, Female] GT 0), SpwnAge8Femalecount)
SpwnAge9Female = WHERE((SNS[6, Female] EQ 9L) AND (SNS[50, Female] GT 0), SpwnAge9Femalecount)
SpwnAge10Female = WHERE((SNS[6, Female] EQ 10L AND (SNS[50, Female] GT 0)), SpwnAge10Femalecount)
SpwnAge11Female = WHERE((SNS[6, Female] EQ 11L) AND (SNS[50, Female] GT 0), SpwnAge11Femalecount)
SpwnAge12Female = WHERE((SNS[6, Female] EQ 12L) AND (SNS[50, Female] GT 0), SpwnAge12Femalecount)
SpwnAge13Female = WHERE((SNS[6, Female] EQ 13L) AND (SNS[50, Female] GT 0), SpwnAge13Femalecount)
SpwnAge14Female = WHERE((SNS[6, Female] EQ 14L) AND (SNS[50, Female] GT 0), SpwnAge14Femalecount)
SpwnAge15Female = WHERE((SNS[6, Female] EQ 15L) AND (SNS[50, Female] GT 0), SpwnAge15Femalecount)
SpwnAge16plusFemale = WHERE((SNS[6, Female] GE 16L) AND (SNS[50, Female] GT 0), SpwnAge16plusFemalecount)

; Spawning female biomass
IF SpwnAge6Femalecount GT 0. THEN SNSsumout[542, *] = TOTAL(SNS[4, Female[SpwnAge6Female]] * SNS[8, Female[SpwnAge6Female]])
IF SpwnAge7Femalecount GT 0. THEN SNSsumout[543, *] = TOTAL(SNS[4, Female[SpwnAge7Female]] * SNS[8, Female[SpwnAge7Female]])
IF SpwnAge8Femalecount GT 0. THEN SNSsumout[544, *] = TOTAL(SNS[4, Female[SpwnAge8Female]] * SNS[8, Female[SpwnAge8Female]])
IF SpwnAge9Femalecount GT 0. THEN SNSsumout[545, *] = TOTAL(SNS[4, Female[SpwnAge9Female]] * SNS[8, Female[SpwnAge9Female]])
IF SpwnAge10Femalecount GT 0. THEN SNSsumout[546, *] = TOTAL(SNS[4, Female[SpwnAge10Female]] * SNS[8, Female[SpwnAge10Female]])
IF SpwnAge11Femalecount GT 0. THEN SNSsumout[547, *] = TOTAL(SNS[4, Female[SpwnAge11Female]] * SNS[8, Female[SpwnAge11Female]])
IF SpwnAge12Femalecount GT 0. THEN SNSsumout[548, *] = TOTAL(SNS[4, Female[SpwnAge12Female]] * SNS[8, Female[SpwnAge12Female]])
IF SpwnAge13Femalecount GT 0. THEN SNSsumout[549, *] = TOTAL(SNS[4, Female[SpwnAge13Female]] * SNS[8, Female[SpwnAge13Female]])
IF SpwnAge14Femalecount GT 0. THEN SNSsumout[550, *] = TOTAL(SNS[4, Female[SpwnAge14Female]] * SNS[8, Female[SpwnAge14Female]])
IF SpwnAge15Femalecount GT 0. THEN SNSsumout[551, *] = TOTAL(SNS[4, Female[SpwnAge15Female]] * SNS[8, Female[SpwnAge15Female]])
IF SpwnAge16plusFemalecount GT 0. THEN SNSsumout[552, *] = TOTAL(SNS[4, Female[SpwnAge16plusFemale]] * SNS[8, Female[SpwnAge16plusFemale]])


; Age-specific total # of spawning individuals
; Male
IF SpwnAge4Malecount GT 0. THEN SNSsumout[479, *] = TOTAL(SNS[4, Male[SpwnAge4Male]])
IF SpwnAge5Malecount GT 0. THEN SNSsumout[480, *] = TOTAL(SNS[4, Male[SpwnAge5Male]])
IF SpwnAge6Malecount GT 0. THEN SNSsumout[481, *] = TOTAL(SNS[4, Male[SpwnAge6Male]])
IF SpwnAge7Malecount GT 0. THEN SNSsumout[482, *] = TOTAL(SNS[4, Male[SpwnAge7Male]])
IF SpwnAge8Malecount GT 0. THEN SNSsumout[483, *] = TOTAL(SNS[4, Male[SpwnAge8Male]])
IF SpwnAge9Malecount GT 0. THEN SNSsumout[484, *] = TOTAL(SNS[4, Male[SpwnAge9Male]])
IF SpwnAge10Malecount GT 0. THEN SNSsumout[485, *] = TOTAL(SNS[4, Male[SpwnAge10Male]])
IF SpwnAge11Malecount GT 0. THEN SNSsumout[486, *] = TOTAL(SNS[4, Male[SpwnAge11Male]])
IF SpwnAge12Malecount GT 0. THEN SNSsumout[487, *] = TOTAL(SNS[4, Male[SpwnAge12Male]])
IF SpwnAge13Malecount GT 0. THEN SNSsumout[488, *] = TOTAL(SNS[4, Male[SpwnAge13Male]])
IF SpwnAge14Malecount GT 0. THEN SNSsumout[489, *] = TOTAL(SNS[4, Male[SpwnAge14Male]])
IF SpwnAge15Malecount GT 0. THEN SNSsumout[490, *] = TOTAL(SNS[4, Male[SpwnAge15Male]])
IF SpwnAge16plusMalecount GT 0. THEN SNSsumout[491, *] = TOTAL(SNS[4, Male[SpwnAge16plusMale]])

; Female
IF SpwnAge6Femalecount GT 0. THEN SNSsumout[492, *] = TOTAL(SNS[4, Female[SpwnAge6Female]])
IF SpwnAge7Femalecount GT 0. THEN SNSsumout[493, *] = TOTAL(SNS[4, Female[SpwnAge7Female]])
IF SpwnAge8Femalecount GT 0. THEN SNSsumout[494, *] = TOTAL(SNS[4, Female[SpwnAge8Female]])
IF SpwnAge9Femalecount GT 0. THEN SNSsumout[495, *] = TOTAL(SNS[4, Female[SpwnAge9Female]])
IF SpwnAge10Femalecount GT 0. THEN SNSsumout[496, *] = TOTAL(SNS[4, Female[SpwnAge10Female]])
IF SpwnAge11Femalecount GT 0. THEN SNSsumout[497, *] = TOTAL(SNS[4, Female[SpwnAge11Female]])
IF SpwnAge12Femalecount GT 0. THEN SNSsumout[498, *] = TOTAL(SNS[4, Female[SpwnAge12Female]])
IF SpwnAge13Femalecount GT 0. THEN SNSsumout[499, *] = TOTAL(SNS[4, Female[SpwnAge13Female]])
IF SpwnAge14Femalecount GT 0. THEN SNSsumout[500, *] = TOTAL(SNS[4, Female[SpwnAge14Female]])
IF SpwnAge15Femalecount GT 0. THEN SNSsumout[501, *] = TOTAL(SNS[4, Female[SpwnAge15Female]])
IF SpwnAge16plusFemalecount GT 0. THEN SNSsumout[502, *] = TOTAL(SNS[4, Female[SpwnAge16plusFemale]])



; Age-specific REPRODUCTIVE status information
; Male
MatureAge4Male = WHERE((SNS[6, Male] EQ 4L) AND (SNS[14, Male] GT 0), MatureAge4Malecount)
MatureAge5Male = WHERE((SNS[6, Male] EQ 5L) AND (SNS[14, Male] GT 0), MatureAge5Malecount)
MatureAge6Male = WHERE((SNS[6, Male] EQ 6L) AND (SNS[14, Male] GT 0), MatureAge6Malecount)
MatureAge7Male = WHERE((SNS[6, Male] EQ 7L) AND (SNS[14, Male] GT 0), MatureAge7Malecount)
MatureAge8Male = WHERE((SNS[6, Male] EQ 8L) AND (SNS[14, Male] GT 0), MatureAge8Malecount)
MatureAge9Male = WHERE((SNS[6, Male] EQ 9L) AND (SNS[14, Male] GT 0), MatureAge9Malecount)
MatureAge10Male = WHERE((SNS[6, Male] EQ 10L) AND (SNS[14, Male] GT 0), MatureAge10Malecount)
MatureAge11Male = WHERE((SNS[6, Male] EQ 11L) AND (SNS[14, Male] GT 0), MatureAge11Malecount)
MatureAge12Male = WHERE((SNS[6, Male] EQ 12L) AND (SNS[14, Male] GT 0), MatureAge12Malecount)
MatureAge13Male = WHERE((SNS[6, Male] EQ 13L) AND (SNS[14, Male] GT 0), MatureAge13Malecount)
MatureAge14Male = WHERE((SNS[6, Male] EQ 14L) AND (SNS[14, Male] GT 0), MatureAge14Malecount)
MatureAge15Male = WHERE((SNS[6, Male] EQ 15L) AND (SNS[14, Male] GT 0), MatureAge15Malecount)
MatureAge16plusMale = WHERE((SNS[6, Male] GE 16L) AND (SNS[14, Male] GT 0), MatureAge16plusMalecount)

; Female
MatureAge6Female = WHERE((SNS[6, Female] EQ 6L) AND (SNS[14, Female] GT 0), MatureAge6Femalecount)
MatureAge7Female = WHERE((SNS[6, Female] EQ 7L) AND (SNS[14, Female] GT 0), MatureAge7Femalecount)
MatureAge8Female = WHERE((SNS[6, Female] EQ 8L) AND (SNS[14, Female] GT 0), MatureAge8Femalecount)
MatureAge9Female = WHERE((SNS[6, Female] EQ 9L) AND (SNS[14, Female] GT 0), MatureAge9Femalecount)
MatureAge10Female = WHERE((SNS[6, Female] EQ 10L AND (SNS[14, Female] GT 0)), MatureAge10Femalecount)
MatureAge11Female = WHERE((SNS[6, Female] EQ 11L) AND (SNS[14, Female] GT 0), MatureAge11Femalecount)
MatureAge12Female = WHERE((SNS[6, Female] EQ 12L) AND (SNS[14, Female] GT 0), MatureAge12Femalecount)
MatureAge13Female = WHERE((SNS[6, Female] EQ 13L) AND (SNS[14, Female] GT 0), MatureAge13Femalecount)
MatureAge14Female = WHERE((SNS[6, Female] EQ 14L) AND (SNS[14, Female] GT 0), MatureAge14Femalecount)
MatureAge15Female = WHERE((SNS[6, Female] EQ 15L) AND (SNS[14, Female] GT 0), MatureAge15Femalecount)
MatureAge16plusFemale = WHERE((SNS[6, Female] GE 16L) AND (SNS[14, Female] GT 0), MatureAge16plusFemalecount)

; Age-specific total # of REPRODUCTIVE individuals
; Male
IF MatureAge4Malecount GT 0. THEN SNSsumout[503, *] = TOTAL(SNS[4, Male[MatureAge4Male]])
IF MatureAge5Malecount GT 0. THEN SNSsumout[504, *] = TOTAL(SNS[4, Male[MatureAge5Male]])
IF MatureAge6Malecount GT 0. THEN SNSsumout[505, *] = TOTAL(SNS[4, Male[MatureAge6Male]])
IF MatureAge7Malecount GT 0. THEN SNSsumout[506, *] = TOTAL(SNS[4, Male[MatureAge7Male]])
IF MatureAge8Malecount GT 0. THEN SNSsumout[507, *] = TOTAL(SNS[4, Male[MatureAge8Male]])
IF MatureAge9Malecount GT 0. THEN SNSsumout[508, *] = TOTAL(SNS[4, Male[MatureAge9Male]])
IF MatureAge10Malecount GT 0. THEN SNSsumout[509, *] = TOTAL(SNS[4, Male[MatureAge10Male]])
IF MatureAge11Malecount GT 0. THEN SNSsumout[510, *] = TOTAL(SNS[4, Male[MatureAge11Male]])
IF MatureAge12Malecount GT 0. THEN SNSsumout[511, *] = TOTAL(SNS[4, Male[MatureAge12Male]])
IF MatureAge13Malecount GT 0. THEN SNSsumout[512, *] = TOTAL(SNS[4, Male[MatureAge13Male]])
IF MatureAge14Malecount GT 0. THEN SNSsumout[513, *] = TOTAL(SNS[4, Male[MatureAge14Male]])
IF MatureAge15Malecount GT 0. THEN SNSsumout[514, *] = TOTAL(SNS[4, Male[MatureAge15Male]])
IF MatureAge16plusMalecount GT 0. THEN SNSsumout[515, *] = TOTAL(SNS[4, Male[MatureAge16plusMale]])

; Female
IF MatureAge6Femalecount GT 0. THEN SNSsumout[516, *] = TOTAL(SNS[4, Female[MatureAge6Female]])
IF MatureAge7Femalecount GT 0. THEN SNSsumout[517, *] = TOTAL(SNS[4, Female[MatureAge7Female]])
IF MatureAge8Femalecount GT 0. THEN SNSsumout[518, *] = TOTAL(SNS[4, Female[MatureAge8Female]])
IF MatureAge9Femalecount GT 0. THEN SNSsumout[519, *] = TOTAL(SNS[4, Female[MatureAge9Female]])
IF MatureAge10Femalecount GT 0. THEN SNSsumout[520, *] = TOTAL(SNS[4, Female[MatureAge10Female]])
IF MatureAge11Femalecount GT 0. THEN SNSsumout[521, *] = TOTAL(SNS[4, Female[MatureAge11Female]])
IF MatureAge12Femalecount GT 0. THEN SNSsumout[522, *] = TOTAL(SNS[4, Female[MatureAge12Female]])
IF MatureAge13Femalecount GT 0. THEN SNSsumout[523, *] = TOTAL(SNS[4, Female[MatureAge13Female]])
IF MatureAge14Femalecount GT 0. THEN SNSsumout[524, *] = TOTAL(SNS[4, Female[MatureAge14Female]])
IF MatureAge15Femalecount GT 0. THEN SNSsumout[525, *] = TOTAL(SNS[4, Female[MatureAge15Female]])
IF MatureAge16plusFemalecount GT 0. THEN SNSsumout[526, *] = TOTAL(SNS[4, Female[MatureAge16plusFemale]])

;PRINT, 'SNSsumout'
;PRINT, TRANSPOSE(SNSsumout[*, *])
PRINT, 'SNSsumoutsumstat Ends Here'
RETURN, SNSsumout; TURN OFF WHEN TESTING
END