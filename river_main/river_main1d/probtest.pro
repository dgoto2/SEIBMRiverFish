;trial =200L
;sall2 = fltarr(trial)
;for i = 0L, trial-1L do begin
;REPEAT BEGIN
;PrS1 = RANDOMU(seed, /double)
;If PrS1 lt 0.7 then S1 = 1 else s1=0
;;if s1 gt 0 then print, s1*1
;PrS2 = RANDOMU(seed, /double)
;If PrS2 lt 0.1 then S2 = 1 else s2=0
;;if s2 gt 0 then print, s2*2
;PrS3 = RANDOMU(seed, /double)
;If PrS3 lt 0.2 then S3 = 1 else s3=0
;;if s3 gt 0 then print, s3*3
;Sall = s1+s2+s3
;ENDREP UNTIL sall eq 1
;if s1 gt 0 then sall2[i] = s1*1
;if s2 gt 0 then sall2[i] = s2*2
;if s3 gt 0 then sall2[i] = s3*3
;;sall2[i] = sall
;endfor
;;print, sall2
;print, histogram(sall2)*1./trial*1.
HydroChange1 = 0.1; proportional change in frequency of wet conditions
HydroChange2 = 0.3; proportional change in frequency of dry conditions
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
  PRINT, HydroCond

  
  
  end