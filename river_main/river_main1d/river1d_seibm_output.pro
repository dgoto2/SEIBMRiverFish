FUNCTION river1d_seibm_output, counter, LiveIndiv2count, LiveIndiv2count2, SNS, TotDriftBio, EndDisChem, DensityDependence, Time, Rep
         
PRINT, 'OutputFiles BEGINS HERE'
tstart = SYSTIME(/seconds)
 
 
;***Creat an output file for SNS*********************************************************
;counter =  iday - 182L; Same as the initial day of a daily loop 
;PRINT, 'Counter', counter

;ALIVEdata = WHERE(SNS[4, *] GT 0., ALIVEDATAcount)
;nSNS = ALIVEDATAcount
PRINT, LiveIndiv2count; rowS

;iDay = STRING(iDay)
;iHour = STRING(iHour)

data = SNS

;IF ALIVEDATAcount GT 0. THEN data = SNS[*, ALIVEdata]

;nLonTran = 162L; the number of longitudianl grid cells
;pointer0 = nLonTran * counter; 1st line to read in

;pointer0 = counter; 1st line to read in 
;Driftdata = (Total(TotDriftBio, 1))


; Set up variables.
OutputSNS1='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
filename1 = OutputSNS1
OutputSNS2='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_2.csv'
filename2 = OutputSNS2
OutputSNS3='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_3.csv'
filename3 = OutputSNS3
OutputSNS4='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_4.csv'
filename4 = OutputSNS4
OutputSNS5='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_5.csv'
filename5 = OutputSNS5
OutputSNS6='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_6.csv'
filename6 = OutputSNS6
OutputSNS7='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_7.csv'
filename7 = OutputSNS7
OutputSNS8='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_8.csv'
filename8 = OutputSNS8
OutputSNS9='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_9.csv'
filename9 = OutputSNS9
OutputSNS10='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_10.csv'
filename10 = OutputSNS10
OutputSNS11='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_11.csv'
filename11 = OutputSNS11
OutputSNS12='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_12.csv'
filename12 = OutputSNS12
OutputSNS13='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_13.csv'
filename13 = OutputSNS13
OutputSNS14='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_14.csv'
filename14 = OutputSNS14
OutputSNS15='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_15.csv'
filename15 = OutputSNS15
OutputSNS16='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_16.csv'
filename16 = OutputSNS16
OutputSNS17='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_17.csv'
filename17 = OutputSNS17
OutputSNS18='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_18.csv'
filename18 = OutputSNS18
OutputSNS19='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_19.csv'
filename19 = OutputSNS19

;OutputDrift='Rep_'+Rep+Time+'_IDLoutputDrift.csv'
;filename0 = OutputDrift

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 1600
comma = ","

;s2 = Size(Driftdata, /Dimensions)
;xsize2 = s2[0]
;lineWidth = 1600
;comma = ","

;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;; Write the data to the file.
;sData = StrTrim(data,2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;Free_Lun, lun

IF counter EQ 1L THEN pointer1 = LiveIndiv2count 
IF counter EQ 21L THEN pointer2 = LiveIndiv2count 
IF counter EQ 41L THEN pointer3 = LiveIndiv2count 
IF counter EQ 61L THEN pointer4 = LiveIndiv2count 
IF counter EQ 81L THEN pointer5 = LiveIndiv2count
IF counter EQ 101L THEN pointer6 = LiveIndiv2count 
IF counter EQ 121L THEN pointer7 = LiveIndiv2count 
IF counter EQ 141L THEN pointer8 = LiveIndiv2count 
IF counter EQ 161L THEN pointer9 = LiveIndiv2count
IF counter EQ 181L THEN pointer10 = LiveIndiv2count 
IF counter EQ 201L THEN pointer11 = LiveIndiv2count 
IF counter EQ 221L THEN pointer12 = LiveIndiv2count 
IF counter EQ 241L THEN pointer13 = LiveIndiv2count 
IF counter EQ 261L THEN pointer14 = LiveIndiv2count 
IF counter EQ 281L THEN pointer15 = LiveIndiv2count 
IF counter EQ 301L THEN pointer16 = LiveIndiv2count 
IF counter EQ 321L THEN pointer17 = LiveIndiv2count 
IF counter EQ 341L THEN pointer18 = LiveIndiv2count 
IF counter EQ 361L THEN pointer19 = LiveIndiv2count 


; Open the data file for writing.
IF counter EQ 0L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L AND counter LT 20L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  pointer1 = LiveIndiv2count2
  SKIP_LUN, lun, pointer1, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 20L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename2, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 20L AND counter LT 40L THEN BEGIN; 
  OpenU, lun, filename2, /Get_Lun, Width=lineWidth 
  pointer2 = LiveIndiv2count2
  SKIP_LUN, lun, pointer2, /lines
  READF, lun  
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 40L THEN BEGIN;
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename3, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 40L AND counter LT 60L THEN BEGIN; 
  OpenU, lun, filename3, /Get_Lun, Width=lineWidth
  pointer3 = LiveIndiv2count2
  SKIP_LUN, lun, pointer3, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count 
ENDIF
IF counter EQ 60L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename4, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 60L AND counter LT 80L THEN BEGIN; 
  OpenU, lun, filename4, /Get_Lun, Width=lineWidth  
  pointer4 = LiveIndiv2count2
  SKIP_LUN, lun, pointer4, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count 
ENDIF
IF counter EQ 80L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename5, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 80L AND counter LT 100L THEN BEGIN; 
  OpenU, lun, filename5, /Get_Lun, Width=lineWidth  
  pointer5 = LiveIndiv2count2
  SKIP_LUN, lun, pointer5, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count 
ENDIF
IF counter EQ 100L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename6, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 100L AND counter LT 120L THEN BEGIN; 
  OpenU, lun, filename6, /Get_Lun, Width=lineWidth  
  pointer6 = LiveIndiv2count2
  SKIP_LUN, lun, pointer6, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count  
ENDIF
IF counter EQ 120L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename7, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 120L AND counter LT 140L THEN BEGIN; 
  OpenU, lun, filename7, /Get_Lun, Width=lineWidth  
  pointer7 = LiveIndiv2count2
  SKIP_LUN, lun, pointer7, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 140L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename8, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 140L AND counter LT 160L THEN BEGIN; 
  OpenU, lun, filename8, /Get_Lun, Width=lineWidth  
  pointer8 = LiveIndiv2count2
  SKIP_LUN, lun, pointer8, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 160L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename9, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 160L AND counter LT 180L THEN BEGIN; 
  OpenU, lun, filename9, /Get_Lun, Width=lineWidth  
  pointer9 = LiveIndiv2count2
  SKIP_LUN, lun, pointer9, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 180L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename10, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 180L AND counter LT 200L THEN BEGIN; 
  OpenU, lun, filename10, /Get_Lun, Width=lineWidth  
  pointer10 = LiveIndiv2count2
  SKIP_LUN, lun, pointer10, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count 
ENDIF
IF counter EQ 200L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename11, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 200L AND counter LT 220L THEN BEGIN; 
  OpenU, lun, filename11, /Get_Lun, Width=lineWidth 
  pointer11 = LiveIndiv2count2
  SKIP_LUN, lun, pointer11, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 220L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename12, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 220L AND counter LT 240L THEN BEGIN; 
  OpenU, lun, filename12, /Get_Lun, Width=lineWidth
  pointer12 = LiveIndiv2count2
  SKIP_LUN, lun, pointer12, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 240L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename13, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 240L AND counter LT 260L THEN BEGIN; 
  OpenU, lun, filename13, /Get_Lun, Width=lineWidth  
  pointer13 = LiveIndiv2count2
  SKIP_LUN, lun, pointer13, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count  
ENDIF
IF counter EQ 260L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename14, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 260L AND counter LT 280L THEN BEGIN; 
  OpenU, lun, filename14, /Get_Lun, Width=lineWidth
  pointer14 = LiveIndiv2count2
  SKIP_LUN, lun, pointer14, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 280L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename15, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 280L AND counter LT 300L THEN BEGIN; 
  OpenU, lun, filename15, /Get_Lun, Width=lineWidth
  pointer15 = LiveIndiv2count2
  SKIP_LUN, lun, pointer15, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 300L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename16, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 300L AND counter LT 320L THEN BEGIN; 
  OpenU, lun, filename16, /Get_Lun, Width=lineWidth
  pointer16 = LiveIndiv2count2
  SKIP_LUN, lun, pointer16, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 320L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename17, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 320L AND counter LT 340L THEN BEGIN; 
  OpenU, lun, filename17, /Get_Lun, Width=lineWidth
  pointer17 = LiveIndiv2count2
  SKIP_LUN, lun, pointer17, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 340L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename18, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 340L AND counter LT 360L THEN BEGIN; 
  OpenU, lun, filename18, /Get_Lun, Width=lineWidth  
  pointer18 = LiveIndiv2count2
  SKIP_LUN, lun, pointer18, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
ENDIF
IF counter EQ 360L THEN BEGIN; 
  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename19, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 360L AND counter LT 380L THEN BEGIN; 
  OpenU, lun, filename19, /Get_Lun, Width=lineWidth  
  pointer19 = LiveIndiv2count2
  SKIP_LUN, lun, pointer19, /lines
  READF, lun
  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count 
ENDIF


; Write the data to the file.
sData = StrTrim(data, 2)
sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
PrintF, lun, sData

; Close the file.
Free_Lun, lun
PRINT, '"Your SNS Output File is Ready"'


;; Write the drift data to the file.
;IF counter EQ 0L THEN BEGIN; 
;   OpenW, lun, filename0, /Get_Lun, Width=lineWidth
;ENDIF
;IF counter GT 0L THEN BEGIN; 
;  OpenU, lun, filename0, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer0, /lines
;  READF, lun
;ENDIF
;
;sData2 = StrTrim(Driftdata, 2)
;sData2[0:xsize2-2, *] = sData2[0:xsize2-2, *] + comma
;PrintF, lun, sData2
;
;; Close the file.
;Free_Lun, lun
;PRINT, '"Your Drift prey Output File is Ready"'

;****************************************************************************************

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'OutputFiles ENDS HERE'
;RETURN
END