FUNCTION SNSresp, age, Tamb, Weight, length, ts, nSNS, SNS, LiveIndiv;, Discharge, Width, Depth, DepthSE
; function to determine respiration for shovelnose sturgeon
; Respiration for eggs and yolksac larvae is 0 (no adjustment is necessary).

PRINT, 'SNSresp Begins Here'

; >>>>> DURING WINTERS, FISH ARE ASSUMED TO BE INACTIVE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; >>>>>NEED swimming speed-based activity cost >>>>>> EXPORT FROM THE FORAGING SUBROUTINE<<<<<<<
; >>>>>>>>>INCLUDE SWIMMING AND POSITION-HOLDING COSTS FROM THE FORAGING SUBROUTINE<<<<<<<<<<<<<

; Assign array structure
ACT = FLTARR(nSNS)
Respiration = FLTARR(3, nSNS)

; Parameter values
OxyCal1 = 13560.; J/ O2 g
OxyCal2 = 13.56; J/ O2 mg
RA = 7.13; (for white sturgeon, Bevelhimer 2002. J Appl. Ichthyol)
RB = 0.78
RQ = 0.0693
MaxLarvaL = 43.
MaxJuvL = 400.
ActLarva = 4.
ActJuv = 3.4
ActAdult = 1.2 


; Foraging cost
SwimCost = SNS[41, *]; steady swimming cost, J/d, this is already part of preycapcost in the foraging model
;PRINT, 'CHECK ARRAY#', N_ELEMENTS(SNS[41, *])
PreyCapCost = (SNS[42, *] + SNS[43, *] + SNS[44, *] + SNS[45, *] + SNS[46, *]); total capture cost for drift prey  J/d
;PRINT, 'CHECK ARRAY#', N_ELEMENTS(PreyCapCost)

; >>>>>>metabolic rate and feeding rate increased between 10 and 30C then sharply declined.

;; Q10 effect (based on cownose rays) from Neer et al. 2007
 ;KQ10 = 2.5; RQ; Q10 value
 ;Tstress = Tamb - TacclR
 ;Q10func = KQ10^(Tstress/10.)
;PRINT, 'Q10func'
;PRINT, Q10func

;>Respiration function with swimming speed
;Vmax = FLTARR(nSNS)
;LengthGT225 = WHERE(length GT 225., LengthGT225count, complement = LengthLE225, ncomplement = LengthLE225count)
;; Individuals <225mm
;IF LengthLE225count GT 0. THEN Vmax[LiveIndiv[LengthLE225]] = 1.5 * 0.001 * 13.86 * (((30.5 - Tamb[LengthLE225])/3.92)^0.43) $
;                                         * EXP(0.24 *(1 - ((30.5 - Tamb[LengthLE225])/3.52))) * (Length[LengthLE225]/10.)^0.63
;; Individuals >=225mm, derived from white sturgeon study by 
;IF LengthGT225count GT 0. THEN Vmax[LiveIndiv[LengthGT225]] = (25.512 + (0.214 * Length[LengthGT225]/10.) - ( 0.762 $
;                                              * Tamb[LengthGT225]) + (0.0342 * Tamb[LengthGT225] * Length[LengthGT225]/10.))/100.
;;PRINT, 'Max sustainable fish velocity (Vmax, m/s)'
;;PRINT, Vmax[0:99]


;; metabolic cost based on juvenile white sturgeon by Geist et al., 2005 in J/d
;Resp = EXP(3.39 + 1.54 * (ALOG(Weight/1000.)) + 0.052 * Tamb) + 0.00914 * 0.2*Vmax[LiveIndiv]*100 * 24 * OxyCal2
; with swimming speed

; Respiration function with ACT
Larva = WHERE((length LE MaxLarvaL), Larvacount)
IF (Larvacount GT 0.) THEN ACT[LiveIndiv[Larva]] = ActLarva
Juv = WHERE((length GT MaxLarvaL) AND (length LE MaxJuvL), Juvcount)
IF (Juvcount GT 0.) THEN ACT[LiveIndiv[Juv]] = ActJuv
Adult = WHERE((length GT MaxJuvL), Adultcount)
IF (Adultcount GT 0.0) THEN ACT[LiveIndiv[Adult]] = ActAdult

Resp = EXP(3.39 + 1.54 * (ALOG(Weight/1000.)) + 0.052 * Tamb) * 24. * OxyCal2 * ACT[LiveIndiv]; without swimming speed

; The original unit of the following funciton is cal/d, which is conveted to J/d
;V = (RTM - TacclR) / (RTM - RTO); temp = acclimated temp 
;natRQ = ALOG(RQ)
;Z = natRQ * (RTM - RTO)
;Y = natRQ * (RTM - RTO + 2.0)
;X= (Z^2.0 * (1.0 + (1.0 + 40.0 / Y)^0.5)^2.0) / 400.0
;TempFunc = V^X * EXP(X * (1.0 - V))
TempFunc = EXP(Tamb * RQ)
;PRINT, 'TempFunc'
;PRINT, TempFunc

;ACT = 3.5; >>>>NEED TO CALIBRATE 3 - 3.5
;Resp = RA * Weight^RB * TempFunc * Act[LiveIndiv] * 4.1868;* OxyCal1; * Q10func;units are J/d without DO function

;ActResp = WHERE(PreyCapCost GT Resp, ActRespcount, complement = RestResp, ncomplement = RestRespcount)
;IF ActRespcount GT 0. THEN Resp[ActResp] = (PreyCapCost[ActResp])
;IF RestRespcount GT 0. THEN Resp[RestResp] = (Resp[RestResp])

;Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight) ;puts units in terms of a J/time step
Resp = TRANSPOSE(Resp); daily respiration rate
;PRINT, 'Resp (J/g)'
;PRINT, TRANSPOSE(Resp)

Respiration[0, LiveIndiv] = Resp
;Respiration[1, LiveIndiv] = SwimCost; 
;Respiration[2, LiveIndiv] = PreyCapCost;
;PRINT, 'Respiration'
;PRINT, Respiration[*, 0:199];

PRINT, 'SNSresp Ends Here'
RETURN, Respiration; TURN OFF WHEN TESTING
END