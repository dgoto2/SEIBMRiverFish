FUNCTION SNSDeadPreyArray1D, SNSenc, SNS, nSNS, nGridcell
; Creat a fish prey array eaten by shovelnose sturgeon

PRINT, 'SNSFishDeadPreyArray1D BEGINS HERE'
tstart = SYSTIME(/seconds)

; Assign array structure
FISHPREY = FLTARR(40L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)

FOR ID = 0L, nGridcell-1L DO BEGIN
  SNSloc = WHERE((SNS[17, *] EQ ID), SNSloccount); 
    
  IF SNSloccount GT 0. THEN BEGIN
    SNSprey0 = WHERE(SNSenc[0, SNSloc] GT 0., SNSprey0count);
    SNSprey1 = WHERE(SNSenc[1, SNSloc] GT 0., SNSprey1count);
    SNSprey2 = WHERE(SNSenc[2, SNSloc] GT 0., SNSprey2count);
    SNSprey3 = WHERE(SNSenc[3, SNSloc] GT 0., SNSprey3count);
    SNSprey4 = WHERE(SNSenc[4, SNSloc] GT 0., SNSprey4count);
          
    IF SNSprey0count GT 0 THEN FISHPREY[0, ID] = TOTAL(SNSenc[0, SNSloc[SNSprey0]]); total biomass consumed
    IF SNSprey1count GT 0 THEN FISHPREY[1, ID] = TOTAL(SNSenc[1, SNSloc[SNSprey1]])
    IF SNSprey2count GT 0 THEN FISHPREY[2, ID] = TOTAL(SNSenc[2, SNSloc[SNSprey2]])
    IF SNSprey3count GT 0 THEN FISHPREY[3, ID] = TOTAL(SNSenc[3, SNSloc[SNSprey3]])
    IF SNSprey4count GT 0 THEN FISHPREY[4, ID] = TOTAL(SNSenc[4, SNSloc[SNSprey4]])
    
    FISHPREY[5, ID] = FISHPREY[0, ID] + FISHPREY[1, ID] + FISHPREY[2, ID] + FISHPREY[3, ID] + FISHPREY[4, ID]
    
;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = YEPmultiSIpreycount
;      im = YEPmultiSI[YEPmultiSIprey]; input array
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
      ;print, ind[0:m-1]
      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      ;FISHPREY[0, ID] = YP[0, PreyFishID]; ABUNDANCE
      ;FISHPREY[1, ID] = YP[1, PreyFishID]; LENGTH
      ;FISHPREY[2, ID] = YP[2, PreyFishID]; WEIGHT
      ;FISHPREY[3, ID] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      ;FISHCellIDcount[0, ID] = n_elements(YEPmultiSI[YEPmultiSIprey]); NUMBER OF SIs
      ;FISHPREY[4, ID] = ROUND(TOTAL(YEPenc[45, YEPmultiSI[YEPmultiSIprey]])/n_elements(YEPmultiSI[YEPmultiSIprey])); ABUNDANCE
      ;FISHPREY[5, ID] = TOTAL(YP[2, YEPmultiSI[YEPmultiSIprey]] * YP[0, YEPmultiSI[YEPmultiSIprey]]); BIOMASS
    ;ENDIF
  ENDIF
ENDFOR


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
;PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'SNSDeadPreyArray1D ENDS HERE'
RETURN, FISHPREY
END