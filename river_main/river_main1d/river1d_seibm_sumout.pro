FUNCTION river1d_seibm_sumout, counter, nSNS, SNSsumout, TotDriftBio, PopSpace, ReproFPopSpace, SwimupPopSpace, ReproFloc, EndDisChem, DensityDependence, Time, Rep
         
PRINT, 'Summary OutputFiles BEGINS HERE'
tstart = SYSTIME(/seconds)
 
 
;***Creat a summary output file for SNS***
;PRINT, 'Counter', counter

; choose output to export
Summarydata = SNSsumout
Driftdata = (Total(TotDriftBio, 1))

Spacedata = TRANSPOSE(PopSpace[0, *])
ReproFSpace = TRANSPOSE(ReproFPopSpace[0, *])
SpacedataN = TRANSPOSE(PopSpace[1, *])
ReproFSpaceN = TRANSPOSE(ReproFPopSpace[1, *])
ReproFloc = TRANSPOSE(ReproFloc)
;PRINT, 'Number of reproductive females', N_ELEMENTS(ReproFloc)
;PRINT, 'Spacedata',Spacedata
SwimupSpace = TRANSPOSE(SwimupPopSpace[0, *])
SwimupSpaceN = TRANSPOSE(SwimupPopSpace[1, *])

;nLonTran = 162L; the number of longitudianl grid cells
;pointer0 = nLonTran * counter; 1st line to read in 
pointer0 = counter; 1st line to read in 


; Set up variables
; Create output file name
OutputSum='Rep_'+Rep+Time+'_IDLoutputSNSSummary.csv'
filename0 = OutputSum
OutputDrift='Rep_'+Rep+Time+'_IDLoutputDrift.csv'
filename1 = OutputDrift
OutputSpace='Rep_'+Rep+Time+'_IDLoutputSpace.csv'
filename2 = OutputSpace
OutputRepSpace='Rep_'+Rep+Time+'_IDLoutputRepSpace.csv'
filename3 = OutputRepSpace
OutputSpaceN='Rep_'+Rep+Time+'_IDLoutputSpaceN.csv'
filename4 = OutputSpaceN
OutputRepSpaceN='Rep_'+Rep+Time+'_IDLoutputRepSpaceN.csv'
filename5 = OutputRepSpaceN
OutputRepFLoc='Rep_'+Rep+Time+'_IDLoutputRepFLoc.csv'
filename6 = OutputRepFLoc
OutputSwimupSpace='Rep_'+Rep+Time+'_IDLoutputSwimupSpace.csv'
filename7 = OutputSwimupSpace
OutputSwimupSpaceN='Rep_'+Rep+Time+'_IDLoutputSwimupSpaceN.csv'
filename8 = OutputSwimupSpaceN


;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
;s = Size(data, /Dimensions)
;xsize = s[0]
;lineWidth = 1600
;comma = ","


; Open the data file for writing.
; Write the summary data to the file.
s0 = Size(Summarydata, /Dimensions)
xsize0 = s0[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename0, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename0, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData0 = StrTrim(Summarydata, 2)
sData0[0:xsize0-2, *] = sData0[0:xsize0-2, *] + comma
PrintF, lun, sData0

; Close the file.
Free_Lun, lun
PRINT, '"Your Summary Output File is Ready"'


; Write the drift data to the file.
s1 = Size(Driftdata, /Dimensions)
xsize1 = s1[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData1 = StrTrim(Driftdata, 2)
sData1[0:xsize1-2, *] = sData1[0:xsize1-2, *] + comma
PrintF, lun, sData1

; Close the file.
Free_Lun, lun
PRINT, '"Your Drift prey Output File is Ready"'


; Write the space data to the file.
s2 = Size(Spacedata, /Dimensions)
xsize2 = s2[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename2, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename2, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData2 = StrTrim(Spacedata, 2)
sData2[0:xsize2-2, *] = sData2[0:xsize2-2, *] + comma
PrintF, lun, sData2

; Close the file.
Free_Lun, lun
PRINT, '"Your spacial distribution Output File is Ready"'


; Write the space data to the file.
s3 = Size(ReproFSpace, /Dimensions)
xsize3 = s3[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename3, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename3, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData3 = StrTrim(ReproFSpace, 2)
sData3[0:xsize3-2, *] = sData3[0:xsize3-2, *] + comma
PrintF, lun, sData3

; Close the file.
Free_Lun, lun
PRINT, '"Your Reproductive female spacial distribution Output File is Ready"'


; Write the N space data to the file.
s4 = Size(SpacedataN, /Dimensions)
xsize4 = s4[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename4, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename4, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData4 = StrTrim(SpacedataN, 2)
sData4[0:xsize4-2, *] = sData4[0:xsize4-2, *] + comma
PrintF, lun, sData4

; Close the file.
Free_Lun, lun
PRINT, '"Your spacial N distribution Output File is Ready"'


; Write the N space data to the file.
s5 = Size(ReproFSpaceN, /Dimensions)
xsize5 = s5[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename5, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename5, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData5 = StrTrim(ReproFSpaceN, 2)
sData5[0:xsize5-2, *] = sData5[0:xsize5-2, *] + comma
PrintF, lun, sData5

; Close the file.
Free_Lun, lun
PRINT, '"Your Reproductive female N spacial distribution Output File is Ready"'


;; Write the reproductive female location data to the file.
;s6 = Size(ReproFloc, /Dimensions)
;xsize6 = s6[0]
;lineWidth = 16000
;comma = ","
;IF counter EQ 0L THEN BEGIN; 
;   OpenW, lun, filename6, /Get_Lun, Width=lineWidth
;ENDIF
;IF counter GT 0L THEN BEGIN; 
;  OpenU, lun, filename6, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer0, /lines
;  READF, lun
;ENDIF
;sData6 = StrTrim(ReproFloc, 2)
;sData6[0:xsize6-2, *] = sData6[0:xsize6-2, *] + comma
;PrintF, lun, sData6
;
;; Close the file.
;Free_Lun, lun
;PRINT, '"Your Reproductive female spacial location Output File is Ready"'

; Write the swimup space data to the file.
s7 = Size(SwimupSpace, /Dimensions)
xsize7 = s7[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename7, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename7, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData7 = StrTrim(SwimupSpace, 2)
sData7[0:xsize7-2, *] = sData7[0:xsize7-2, *] + comma
PrintF, lun, sData7

; Close the file.
Free_Lun, lun
PRINT, '"Your spacial swimup distribution Output File is Ready"'


; Write the swimup N space data to the file.
s8 = Size(SwimupSpaceN, /Dimensions)
xsize8 = s8[0]
lineWidth = 16000
comma = ","
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename8, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename8, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer0, /lines
  READF, lun
ENDIF
sData8 = StrTrim(SwimupSpaceN, 2)
sData8[0:xsize8-2, *] = sData8[0:xsize8-2, *] + comma
PrintF, lun, sData8

; Close the file.
Free_Lun, lun
PRINT, '"Your Reproductive female N spacial distribution Output File is Ready"'


t_elapsed = SYSTIME(/seconds) - tstart
;PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Summary OutputFiles ENDS HERE'
;RETURN
END