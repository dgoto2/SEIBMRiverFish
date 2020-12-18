FUNCTION SNSFishArray1D, SNS, nSNS, nGridcell
; Create a fish array for potential competitors 
; Biomass for eggs and yolksac larvae is 0 (no adjustment is necessary)

PRINT, 'SNSFishArray1D BEGINS HERE'
;tstart = SYSTIME(/seconds)

FISHCOMARRAY = FLTARR(20L, nGridcell)
FISHCellIDcount = FLTARR(2L, nGridcell)

; NUMBER OF INDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL

; SHOVELNOSE STURGEON
FOR ID = 0L, nGridcell-1L DO BEGIN
  multiSI = WHERE((SNS[17, *] EQ ID) AND (SNS[7, *] GT 0.), multiSIcount); SNS[17, *] = grid cell ID#
  
  IF multiSIcount GT 0 THEN BEGIN
;   YAO = WHERE(SNS[6, multiSI] GT 0., YAOcount, COMPLEMENT = YOY, NCOMPLEMENT = YOYcount)
;  
;   IF YAOcount GT 0 THEN BEGIN; create an array for YAO sturgeon
;   ;FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin;
;    ;multiSIprey = WHERE(SNS[4, multiSI] GT 0., multiSIpreycount)
;    ;IF multiSIprey2count gt 0 THEN print, multiSI[multiSIprey2]
;    
;    ;IF multiSIpreycount GT 0 THEN BEGIN
;;      FISHCOMARRAY[0, multiSI[ID2]] = YP[0, PreyFishID]; ABUNDANCE
;      FISHCOMARRAY[1, ID] = MEAN(SNS[7, multiSI[YAO]]); SNS[1, RandomFishID]; LENGTH
;      FISHCOMARRAY[2, ID] = MEAN(SNS[8, multiSI[YAO]]); SNS[2, RandomFishID]; WEIGHT   
;;      FISHCOMARRAY[3, multiSI[ID2]] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
;;      
;    ; DETERMINE TOTAL FISH ABUNDANCE AND BIOMASS IN EACH CELL
;      FISHCellIDcount[0, ID] = N_ELEMENTS(multiSI[YAO]); NUMBER OF SIs
;      FISHCOMARRAY[4, ID] = TOTAL(SNS[4, multiSI[YAO]]); ABUNDANCE, SNS[4, *] = #individuals
;      FISHCOMARRAY[5, ID] = TOTAL(SNS[8, multiSI[YAO]] * SNS[4, multiSI[YAO]]); BIOMASS, SNS[8, *] = weight     
;    ENDIF 
;    
;    IF YOYcount GT 0 THEN BEGIN; create an array for YOY sturgeon     
;      FISHCOMARRAY[6, ID] = MEAN(SNS[7, multiSI[YOY]]); SNS[1, RandomFishID]; LENGTH
;      FISHCOMARRAY[7, ID] = MEAN(SNS[8, multiSI[YOY]]); SNS[2, RandomFishID]; WEIGHT     
;            
;    ; DETERMINE TOTAL FISH ABUNDANCE AND BIOMASS IN EACH CELL
;      FISHCOMARRAY[8, ID] = TOTAL(SNS[4, multiSI[YOY]]); ABUNDANCE, SNS[4, *] = #individuals
;      FISHCOMARRAY[9, ID] = TOTAL(SNS[8, multiSI[YOY]] * SNS[4, multiSI[YOY]]); BIOMASS, SNS[8, *] = weight       
;    ENDIF 
    
     ; Create and array for age clasess
     FISHCOMARRAY[6, ID] = MEAN(SNS[7, multiSI]); SNS[1, RandomFishID]; LENGTH
     FISHCOMARRAY[7, ID] = MEAN(SNS[8, multiSI]); SNS[2, RandomFishID]; WEIGHT     
            
    ; DETERMINE TOTAL FISH ABUNDANCE AND BIOMASS IN EACH CELL
     FISHCOMARRAY[8, ID] = TOTAL(SNS[4, multiSI]); ABUNDANCE, SNS[4, *] = #individuals
     FISHCOMARRAY[9, ID] = TOTAL(SNS[8, multiSI] * SNS[4, multiSI]); BIOMASS, SNS[8, *] = weight     
   ENDIF
ENDFOR
; PRINT, 'SNS abundance'
; PRINT, TRANSPOSE(FISHCOMARRAY[4, *])
; PRINT, 'SNS biomass'
; PRINT, TRANSPOSE(FISHCOMARRAY[5, *])


;t_elapsed = SYSTIME(/seconds) - tstart
;PRINT, 'Elapesed time (seconds):', t_elapsed 
;PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'SNSFishArray1D ENDS HERE'
RETURN, FISHCOMARRAY
END