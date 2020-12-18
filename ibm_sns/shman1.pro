; SHMAN1.PRO
; Model is a spatially explicit IBM of steelhead for the SALMOD project.
; Model runs for 1 year with stages: spawning, egg, alvein, fry, parr
; Fry and parr stages are true individuals. Egg & alevin, redd-cohorts

DEVICE, retain=2, decomposed=0 ;Correct the "refresh' problem
LOADCT,13 ;Load color table for graph

PRINT,'SHMan v. 1.2'
PRINT,'Steelhead model for the Manistee River.'
PRINT,'J.A. Tyler, E.S. Rutherford'
PRINT,' Updated June 2006'
PRINT,''

; Initial Setup
cellnum=100
endday=364
batflg=0 ; batch flag
pi=3.141592654

;LENGTH-WEIGHT parameters  L = a W^b  from Clark
  lwa=46.37
  lwb=0.337
  delta=0.5	;Memory factor 0.5 roughly equal to five days.

; initial values for FRY
  fryinitlen=20.00   ; 20mm=0.08247g 25mm=0.159907g
  fryinitwt=0.0825
  fryinitpredest=0.0091  ; from Clark&Rose equation for 25mm fish 
  fryinitpest=0.75         ;arbitrary
  fryinitdwtest=0.1

;Critical floater densities based on station densities from Grant & Kramer 1990
fryfcrit= 100.0 *0.5   ; 50% of station number
parrfcrit= 10 * 0.5 
    
;USER INPUTS -----------------------------------------
READINPUTS: 
SH_INPUT1V,idum,idumenv,batflg,spnum,tempflg,flowflg,flowfac,vrespflg,vrespcv,$
    outputdir,befile,statfile,filnumstr
if(idum eq -9999) then goto, NORUN

idum1=idum
idumenv1=idumenv
idumGF=idum+1000  ; idumGF is only for use by the gradfry routine

; set up files
RESTORE,befile
close,10
openw,10,statfile

stagefile=outputdir+'stage'+filnumstr+'.dat'
close,11
openw,11,stagefile  ; end of file setup -----------------

; stage arrays ----------
; stage identifiers: 0=egg 1=alevin 2=fry 3=parr
stnum=dblarr(5) ; number entering stage
stday=dblarr(5) ; sum of day stage starts.  
stdur=dblarr(5) ; sum of the durations of survivors in each stage
; to compute actual durations, stdu/stnum

; --------Set ENVIRONMENT
; NOTE========= Always set up env before population so that the random number
;     ======= sequence used to set up the env is the same for each idum.

parrpreyday=fltarr(365)
parrpreydist=fltarr(cellnum)
SH_PARRPREY,frypreyday,parrpreyday

frypreyday=frypreyday*SApreyfac
parrpreyday=parrpreyday*SApreyfac

; add variation with 10%CV on prey densities
tmnt=moment(frypreyday)
fmxpdev=tmnt(0)*0.1 ;fry max prey deviation 
fmnpdev=fmxpdev*.1  ; fry min prey deviation
tvec=frypreyday
vartemp,idumenv,tvec,fmxpdev,fmnpdev,vvec
mfrypreyday=frypreyday
frypreyday=vvec

tmnt=moment(parrpreyday)
pmxpdev=tmnt(0)*0.1 ;parr max prey deviation 
pmnpdev=pmxpdev*0.1 ; parr min prey deviation
tvec=parrpreyday
vartemp,idumenv,tvec,pmxpdev,pmnpdev,vvec
mparrpreyday=parrpreyday
parrpreyday=vvec

SH_MDISCH1,idumenv,flowflg,basedisch,vdisch
;mdisch=vdisch

SH_MANISTEE,idumenv,tempflg,flowfac,vdisch,cellnum,$
  depth,dst,width,areayoy,mtemp,wvel,wvelday,wvelhist,grvl,$
  fstanum,pstanum,ystanum,basemtemp,basemwvel

mfrreddscr=fltarr(endday)
mxfrreddscr=fltarr(endday)
mnfrreddscr=fltarr(endday)
eggmortday=fltarr(4,endday) ; 0=total 1=pred 2=scour 3=temp
alvmortday=fltarr(4,endday)

carea=width*0. ; carea=cell area, dimension: (cellnun,days)
for id=0,endday do carea(*,id)=width(*,id)*dst

frynumcell=lonarr(cellnum)
numfrysta=lonarr(cellnum)
numfryflt=lonarr(cellnum)
parrnumcell=lonarr(cellnum)
numparrsta=lonarr(cellnum)
numparrflt=lonarr(cellnum)
redddist=intarr(cellnum,endday+1)
eggdist=redddist
alvdist=redddist

ZLIGHT,44.25,frlight ;get fraction of the day with light, 44.25 is lat of Manistee
hrlight=25.*frlight  ; hours of the day with light
SH_EGGDEV1, mtemp, eggdevarr, alvdevarr

;Set up ARRAYS ------------------------------------------
; Spawners
SH_SPPOP1, idum,spnum,splen,spday,sparea,speggs
spday1=spday  ; save spawning day.  Actual spday gets reset
tmnt=moment(spday)
mnspday=min(spday)
mxspday=max(spday)
print,'spnum spday ',spnum,mnspday,tmnt(0),mxspday

; Egg & Alevin
SH_MKCOHORT,spnum,eggnum,eggday,eggdev,alvnum,alvday,alvdev,$
      reddloc,reddarea,reddspid
SH_MKCOHARR, eggtotday,meggdevday,mxeggdevday,mneggdevday, $
      alvtotday,malvdevday,mxalvdevday,mnalvdevday

; fry & parr use same arrays
SH_SETUPPARR,parrlen,parrwt,parrdwt,parrloc,parrstate,parrdeath,parrsta,parrday,$
  parrppred,parrpest,parrpredest,parrdwtest,parrdday,$
  parrstage,parrilen,fryday
  
; FRY population arrays for plotting
SH_MKPOPARR,cellnum,frytotday,frystaday,fryfltday,frymortday,$
  frystarvday,frydist,frydists,frydistf,frymovnum,frymovs,frymovf,$
  mfrylen,mfrywt,mfrydwt,mfrycmax,mfrycons,mfryggcons,mfryresp,$
  mfryrespfac,mfryp,mfryeges,$
  mfryexcr,mfrysda,mfrypest,mfrypredest,mfrydwtest,$
  vfrylen,vfrywt,vfrydwt,vfryrespfac,vfryresp,$
  mnfrylen,mnfrywt,mnfrydwt,mnfrycmax,mnfrycons,mnfryggcons,$
  mnfryresp,mnfryrespfac,mnfryp,mnfrypest,mnfrypredest,mxfrylen,mxfrywt,$
  mxfrydwt,mxfrycmax,mxfrycons,mxfryggcons,mxfryresp,mxfryrespfac,$
  mxfryp,mxfrypest,mxfrypredest,$
  mfrylens,mfrywts,mfrydwts,mfryconss,mfryggconss,mfryps,mfrypests,$
  mfrypredests,mfrydwtests,$
  mnfrylens,mnfrywts,mnfrydwts,mnfryconss,mnfryggconss,mnfryps,$
  mnfrypests,mnfrypredests,mxfrylens,mxfrywts,mxfrydwts,$
  mxfryconss,mxfryggconss,mxfryps,mxfrypests,mxfrypredests,mfrylenf,mfrywtf,$
  mfrydwtf,mfryconsf,mfryggconsf,mfrypf,mfrypestf,mfrypredestf,mfrydwtestf,$
  mnfrylenf,mnfrywtf,mnfrydwtf,mnfryconsf,mnfryggconsf,mnfrypf,mnfrypestf,$
  mnfrypredestf,mxfrylenf,mxfrywtf,mxfrydwtf,mxfryconsf,mxfryggconsf,mxfrypf,$
  mxfrypestf,mxfrypredestf

; Parr population arrays for plotting
SH_MKPOPARR,cellnum,parrtotday,parrstaday,parrfltday,parrmortday,$
  parrstarvday,parrdist,parrdists,parrdistf,parrmovnum,parrmovs,parrmovf,$
  mparrlen,mparrwt,mparrdwt,mparrcmax,mparrcons,mparrggcons,mparresp,$
  mparrespfac,mparrp,$
  mparreges,mparrexcr,mparrsda,mparrpest,mparrpredest,mparrdwtest,$
  vparrlen,vparrwt,vparrdwt,vparrespfac,vparresp,$
  mnparrlen,mnparrwt,mnparrdwt,mnparrcmax,mnparrcons,mnparrggcons,$
  mnparresp,mnparrespfac,mnparrp,mnparrpest,mnparrpredest,mxparrlen,mxparrwt,$
  mxparrdwt,mxparrcmax,mxparrcons,mxparrggcons,mxparresp,mxparrespfac,$
  mxparrp,mxparrpest,mxparrpredest,$
  mparrlens,mparrwts,mparrdwts,mparrconss,mparrggconss,mparrps,mparrpests,$
  mparrpredests,mparrdwtests,$
  mnparrlens,mnparrwts,mnparrdwts,mnparrconss,mnparrggconss,mnparrps,$
  mnparrpests,mnparrpredests,mxparrlens,mxparrwts,mxparrdwts,$
  mxparrconss,mxparrggconss,mxparrps,mxparrpests,mxparrpredests,mparrlenf,mparrwtf,$
  mparrdwtf,mparrconsf,mparrggconsf,mparrpf,mparrpestf,mparrpredestf,$
  mparrdwtestf,mnparrlenf,mnparrwtf,mnparrdwtf,mnparrconsf,mnparrggconsf,$
  mnparrpf,mnparrpestf,mnparrpredestf,mxparrlenf,mxparrwtf,mxparrdwtf,$
  mxparrconsf,mxparrggconsf,mxparrpf, mxparrpestf,mxparrpredestf

  ; arrays for output data on combined fry + parr len & wt
  ; combined fry + parr = yoy
  myoylen=mfrylen*0
  myoywt=mfrywt*0
  vyoylen=mfrylen*0
  vyoywt=mfrylen*0

; FLAGS
  dpflg=0 ;flag for distribution picture 0=windows not created 1=windows created
  peflg=0 ;flag for environment plots 0=windows not created 1=windows created

;------- End Array setup

nextoutput=0.
outputint=1 ;days between printing
nextpause=-1 ; set to -1 for no pauses
pauseint=50 ; days between pauses

; write initial conditions to statXX.dat
sttime=systime(1)
printf,10,'shman v 1.1',systime(0),'  ==== ',filnumstr,' ==='
form0='(2(a10,i7,2x))'
form1='(a25,2(i6,2x),f5.2)'
form2='(a25,i5,2x,f7.1,2x,2(f6.2,2x),f4.1)'
printf,10,format=form0,'idum= ',idum1,'idumenv= ',idumenv1
printf,10,'spnum= ',spnum
printf,10,'vresp: flag range: ',vrespflg,vrespcv
printf,10,format=form1,'Tempflg Flowflg flowfac: ',tempflg,flowflg,flowfac
printf,10,"Prey multiplier for sensitivity analysis: ',SApreyfac

tmnt=moment(width)
tmwid=tmnt(0)
tmnt=moment(depth)
tmdep=tmnt(0)
tmnt=moment(dst)
tmdst=tmnt(0)
totdst=total(dst)
printf,10,format=form2,'cellnum totdst mdst mwid mdep mdst: ',$
   cellnum,totdst,tmdst,tmwid,tmdep

nspdone=0

egsiltmortot=0.
scoureggday=fltarr(endday+1)
scouralvday=fltarr(endday+1)

;print,'Stations: ',total(pstanum)
;========================================

FOR iday=0,endday DO BEGIN  ;LOOP OVER DAYS BEGINS -------------------------------------

; SPAWNING FIRST ---------------------------
  if (iday lt mnspday-1 or iday gt 175) then goto, NOSPAWN ; spawning days
  tt=where(spday lt 9999,spleft) 
  if (spleft le 0) then begin
;     print,'spleft = ',spleft
     goto, NOSPAWN 
  endif

  ; check temp criteria. spawning occures 2-13 deg C -Jager 
  if((mtemp(iday) lt 2.) or (mtemp(iday) gt 14.00)) then begin
;     print,'mtemp out of spawning range. mtemp= ',mtemp(iday)
     goto, NOSPAWN
  endif

;determine area available for spawning, csparea
; spawn1 proc will update csparea as spawning occurs today
  csparea=fltarr(cellnum)
  frsparea=0.2 ; fraction of area available for spawning in each cell
  for iloc=0,cellnum-1 do begin
    GETCSPAREA:
    spclst=where((eggnum gt 0) or (alvnum gt 0) and (reddloc eq iloc),ntredd)
    if (ntredd gt 0) then tsparea=total(reddarea(spclst)) $
         else tsparea=0
    csparea(iloc)=(carea(iloc,iday)*frsparea)-tsparea
    
    if (csparea(iloc) lt 0) then begin ; must kill some redds
      tt1=indgen(ntredd)*1./(ntredd*1.)
      tran=randomn(idum)
      ttl=where(tt1 le tran,nttl)
      if(nttl eq 0) then ttid=0 else ttid=max(ttl)
      reddid=spclst(ttid)
      if (eggnum(reddid) gt 0) then begin
         eggnum(reddid)=0
         eggdev(reddid)=-666
      endif
      if (alvnum(reddid) gt 0) then begin
         alvnum(reddid)=0
         alvdev(reddid)=-666
      endif
      goto,GETCSPAREA
    endif
  endfor

  spawnerlst=where(spday le iday,nspawn) ; list of those elegible to spawn today
  if(nspawn eq 0) then begin
;    print,'no elegible spawners today. nspawn= ',nspawn
    goto, NOSPAWN
  endif

  ;get list of viable spawning locations
  SH_sploc1,depth,wvel(*,iday),csparea,grvl(*,iday),sploclst
    if(max(sploclst) ge 0) then spawncells=n_elements(sploclst) $
      else spawncells=0
    if(spawncells eq 0) then begin
        totcsparea=0
        print,'totcsparea = ',totcsparea
    endif   else totcsparea=total(csparea(sploclst))
  if (totcsparea eq 0) then goto, NOSPAWN  ; no space for spawning
  
  nspdone=nspdone+nspawn
  
  SH_SPAWN1,idum,iday,spawnerlst,sploclst,speggs,spday,sparea,csparea, $
    eggnum,eggdev,eggday,reddloc,reddarea,reddspid
;  print,'nspdone nspawn cells ',nspdone,nspawn, reddloc(spawnerlst)
  ttans=''
;  read,'Pause. ENTER to continue ',ttans
      
  ttegg=total(eggnum(spawnerlst))
  stnum(0)=stnum(0)+ttegg
  stday(0)=stday(0)+(iday*ttegg)
    
;  print,'spleft nspawn ',spleft,nspawn
  
NOSPAWN:   ; --------- END SPAWNING ---------

; EGG & Alevin development & mortality

egglst=where(eggnum gt 0 and eggdev gt 0,negg)
alvlst=where(alvnum gt 0 and alvdev gt 0,nalv)

;print,'negg nalv ',negg,nalv

if((negg le 0) and (nalv le 0)) then goto, NOEGGALV

  ;egg development
  if(negg gt 0) then begin
     eggdev(egglst)=eggdev(egglst)+(eggdevarr(iday)) ; develop eggs
     ;compute development statistics
     egfrac=eggnum(egglst)/total(eggnum(egglst))
     meggdevday(iday)=total(eggdev(egglst)*egfrac)
     mxeggdevday(iday)=max(eggdev)
     mneggdevday(iday)=min(eggdev(egglst))
  endif

  ;alvin development
  if(nalv gt 0) then begin    ;nalv computed with alvlst above
     alvdev(alvlst)=alvdev(alvlst)+(alvdevarr(iday)) ; develop alevins
     ;compute development statistics
     alvfrac=alvnum(alvlst)/total(alvnum(alvlst))
     malvdevday(iday)=total(alvdev(alvlst)*alvfrac)
     mxalvdevday(iday)=max(alvdev)
     mnalvdevday(iday)=min(alvdev(alvlst))
  endif
  
  ;Redd Scouring
  ; D50 function estimated function using table from table of Church et al.
  ; and Consumers Energy substrate data
  ; D50 values altered 12/2005.  Originals in comment
  ta=-1.2  ; -1.25 
  tb=7.8  ;  7.2
  D50=exp(ta+tb*grvl(*,iday))/1000. ; convert from mm to m
; jat 12/2005 3 parameter equation for D50
; ta=0.33
; tb=85. ;200.
; tc=1.75 ;3.15
; D50=(ta+tb*grvl(*,iday)^tc)/1000.

; shear vel (SVel),shear force (SF) and mobilty ratio (MR) computation from M. Wiley
  SVel=(((wvel(*,iday)/100.)-0.01)/(alog10(depth(*,iday)*.4)-alog10(0.02)))/5.75
  troh=1000.
  SF=SVel^2*troh
  ttheta=0.06
  MR=SF/(16.18155*D50*ttheta)
  ; PSC20 function from Lapointe et al. CJFAS 57:112  
  PSC20= -0.2+0.3*MR  ; p scour to 20cm = 0.2 fr redd loss  
;  PSC30= -0.11+0.17*MR ; p scour to 30cm = 0.5 fr redd loss
;  tmfr= 0.8/(PSC30-PSC20) ; slop of fraction loss
;  ranvec=RANDOMU(idum,cellnum)
;  frreddscr= tmfr*(ranvec-PSC20)+0.2
;  frreddscr=fltarr(cellnum)
  frreddscr=PSC20;*0.2 
  ttl=where(frreddscr lt 0,nttl)
     if(nttl gt 0) then frreddscr(ttl) = 0.
  ttl=where(frreddscr gt 1.0,nttl)
     if(nttl gt 0) then frreddscr(ttl) = 1.0
  scrlst=where(frreddscr gt 0.0,nreddscr) ; scour list
  tmnt=moment(frreddscr)
  mfrreddscr(iday)=tmnt(0)
  mxfrreddscr(iday)=max(frreddscr)
  mnfrreddscr(iday)=min(frreddscr)

  tegg=total(eggnum)  ; used to compute eggmortday
  t1egg=tegg
  
  ; egg mortality
  ; 3% mortality/day - Clark
  ;2.25% per day implemented
  if(negg gt 0) then begin
     eggnum(egglst)=0.9775*eggnum(egglst)  ; predation mortality
     t1egg=total(eggnum)
     t2egg=t1egg
     
     if(nreddscr gt 0) then begin
        ttteggnum=total(eggnum)
        eggnum(egglst)=(1.-frreddscr(reddloc(egglst)))*eggnum(egglst) ; scour mortality
        t2egg=total(eggnum)
        scoureggday(iday)=ttteggnum-t2egg
     endif
     t3egg=t2egg
        
    ;siltation related mortality,
    ; Meyer 2003 j.fish.biol 62:534
     tgr=grvl(*,iday) ; fraction of substrate that is gravel/cobble
     ta=-1.8326
     tb=-13.863
     fines=exp(ta+tb*tgr)  ; calibrated function
     ; silt/fines mortality from Meyer, J.Fish.Biol 62:534
     tma=0.
     tmb=6.95
     tmc=-20.5
     tdur=35. ; duration
     esmort=(tma+tmb*fines+tmc*fines^2)/tdur
     hlst=where(esmort gt 1.0,nh)
     if(nh gt 0) then esmort(hlst)=1.
     llst=where(esmort lt 0.00,nl)
     if(nl gt 0) then esmort(llst)=0.
     egsiltsrv=1.0-esmort ; convert daily mort to surv
     tnum=eggnum
     cegsiltsrv=egsiltsrv(reddloc(egglst))  ; cohort egg slit survival
     eggnum(egglst)=eggnum(egglst)*cegsiltsrv(egglst)
     egsiltmortot= total(tnum-eggnum)+egsiltmortot
     siltlst=where(tnum gt .5 and eggnum lt 0.5)

     nmortlst=where(eggnum lt 1.0 and eggdev gt 0,nttm)
      ; flag eggdev for mort source
        if(max(nmortlst) ge 0) then eggdev(nmortlst)=-999
        if(max(siltlst) ge 0) then eggdev(siltlst)=-888
      ;temp extreme redd loss
        if((mtemp(iday) lt 0.1) or (mtemp(iday) gt 21)) then begin
           ranvec=randomu(idum,negg)
           ttl=where(ranvec ge 0.5)
           if(max(ttl) ge 0) then begin
             eggnum(egglst(ttl))=0.
             eggdev(egglst(ttl))=-777
             t3egg=total(eggnum)
           endif
        endif
     eggmortday(0,iday)=tegg-t3egg  ; total
     eggmortday(1,iday)=t1egg-t2egg ; scour
     eggmortday(2,iday)=tegg-t1egg  ; predation
     eggmortday(3,iday)=t2egg-t3egg ; temperature
              
  endif  ; if(negg gt 0)

  talv=total(alvnum)
  t1alv=talv

  ; alvine mortality
  ; 3% mortality/day - Clark
  ;2.25% per day implemented
  oalvnum=alvnum
  if(nalv gt 0) then begin
     talv=total(alvnum)
     alvnum(alvlst)=0.9775*alvnum(alvlst)
     t1alv=total(alvnum)
     t2alv=t1alv
     if(nreddscr gt 0.) then begin
        tttalvnum=total(alvnum)
        alvnum(alvlst)=(1-frreddscr(reddloc(alvlst)))*alvnum(alvlst)  ; scour mortality
        t2alv=total(alvnum)
        scouralvday(iday)=tttalvnum-t2alv
     endif  
     t3alv=t2alv             
     
    ;siltation related mortality,
    ; Meyer 2003 j.fish.biol 62:534
     tgr=grvl(*,iday) ; fraction of substrate that is gravel/cobble
     ta=-1.8326
     tb=-13.863
     fines=exp(ta+tb*tgr)  ; calibrated function
     ; silt/fines mortality from Meyer, J.Fish.Biol 62:534
     tma=0.
     tmb=6.95
     tmc=-20.5
     tdur=35. ; duration
     alsmort=(tma+tmb*fines+tmc*fines^2)/tdur * 0.75 ; alvine 25% less mortality
     hlst=where(alsmort gt 1.0,nh)
     if(nh gt 0) then alsmort(hlst)=1.
     llst=where(alsmort lt 0.0001,nl)
     if(nl gt 0) then alsmort(llst)=0.
     alsiltsrv=1.0-alsmort ; convert alvine daily mort to daily survival
     tnum=alvnum
     calsiltsrv=alsiltsrv(reddloc(alvlst)) ; cohort alvine silt surv
     alvnum(alvlst)=alvnum(alvlst)*calsiltsrv(alvlst)
     siltlst=where(tnum gt .5 and alvnum lt 0.5)

     nmortlst=where(alvnum lt 1.0 and alvdev gt 0)
      ; flag alvdev for mort source
        if(max(nmortlst) ge 0) then alvdev(nmortlst)=-999
        if(max(siltlst) ge 0) then alvdev(siltlst)=-888
      ;temp extreme redd loss
        if((mtemp(iday) lt 0.1) or (mtemp(iday) gt 21)) then begin
           ranvec=randomu(idum,nalv)
           ttl=where(ranvec ge 0.5)
           if(max(ttl) ge 0) then begin
             alvnum(alvlst(ttl))=0.
             alvdev(alvlst(ttl))=-777
             t3alv=total(alvnum)
           endif
        endif
     alvmortday(0,iday)=talv-t3alv  ; total
     alvmortday(1,iday)=t1alv-t2alv ; scour
     alvmortday(2,iday)=talv-t1alv  ; predation
     alvmortday(3,iday)=t2alv-t3alv ; temperature
  endif  ; if(nalv gt 0)

  ;compute egg & alv pop numbers
   tlst=where(eggnum gt 0,ttn)
   if(ttn gt 0) then eggtotday(iday)=total(eggnum(tlst))
   tlst=where(alvnum gt 0,ttn)
   if(ttn gt 0) then alvtotday(iday)=total(alvnum(tlst))

NOEGGALV:  ; end of egg & alevin development & mortlity

; compute redddist
lvredlst=where(eggnum gt 1 or alvnum gt 1,nlredd)
reddstate=intarr(spnum)
if(nlredd gt 0) then reddstate(lvredlst)=1
for ic=0,cellnum-1 do begin 
   trdlst=where(reddloc eq ic and reddstate eq 1,nrdlst)
   if(nrdlst gt 0) then begin
      redddist(ic,iday)=nrdlst
      eggdist(ic,iday)=total(eggnum(trdlst))
      alvdist(ic,iday)=total(alvnum(trdlst))
   endif   
endfor


;---- Fry & PARR ---------- fry --- parr --- fry --- parr --- fry --- parr

frylst=where((parrstage eq 0) and (parrstate eq 1), nfry)
parrlst=where((parrstage eq 1) and (parrstate eq 1), nparr)
yoylst=where(parrstate eq 1,nyoy)

if(((nyoy+negg+nalv) eq 0) and (iday gt 175)) then begin
   print,'POPULATION CRASH  day ',iday
   goto, POPCRASH
endif

if (nyoy gt 0) then BEGIN
  ; Fry/PARR-CELLNUM number of parr per cell / NUMPARRSTA (num with stations per cell) / NUMPARRFLT (num of floaters)
  frynumcell(*)=0 ;
  numfrysta(*)=0
  numfryflt(*)=0
  parrnumcell(*)=0 ; Erase previous PARRNUM
  parrsta(*)=0 ; Erase previous PARRSTA
  numparrsta(*)=0
  numparrflt(*)=0

  FOR ic=0,cellnum-1 DO BEGIN ;===== Loop over cells/assign stations ==============
   if(nfry gt 0) then begin ; assign stations to fry
    tlist=WHERE(parrloc EQ ic AND parrstate EQ 1 AND parrstage EQ 0, ttn)
     ttstn=fstanum(ic)
     IF(ttn gt 0) THEN BEGIN
      ttwt=parrwt(tlist)
      ttsta=parrsta(tlist)
      PARR_STA, ttstn, ttwt, ttsta
      parrsta(tlist)=ttsta
      frynumcell(ic)=TOTAL(parrstate(tlist))
      numfrysta(ic)=TOTAL(parrsta(tlist))          ;Number of fry stations hoders
      numfryflt(ic)=frynumcell(ic)-numfrysta(ic) ;Number of fry floaters
     ENDIF ELSE BEGIN
      frynumcell(ic)=0
      numfrysta(ic)=0
      numfryflt(ic)=0
     ENDELSE
   endif ; nfry > 0

   if(nparr gt 0) then begin ; assign stations to parr
    tlist=WHERE(parrloc EQ ic AND parrstate EQ 1 AND parrstage EQ 1, ttn)
     ttstn=pstanum(ic)
     IF(ttn gt 0) THEN BEGIN
      ttpwt=parrwt(tlist)
      ttsta=parrsta(tlist)
      PARR_STA, ttstn, ttpwt, ttsta
      parrsta(tlist)=ttsta
      parrnumcell(ic)=TOTAL(parrstate(tlist))
      numparrsta(ic)=TOTAL(parrsta(tlist))          ;Number of stations hoders
      numparrflt(ic)=parrnumcell(ic)-numparrsta(ic) ;Number of floaters
     ENDIF ELSE BEGIN
      parrnumcell(ic)=0
      numparrsta(ic)=0
      numparrflt(ic)=0
     ENDELSE
   endif ; nparr > 0
  ENDFOR ;========================================== End of loop over cells ====================

; save distribution data for fry & parr
   frydist(*,iday)=frynumcell
   frydists(*,iday)=numfrysta
   frydistf(*,iday)=numfryflt
   parrdist(*,iday)=parrnumcell
   parrdists(*,iday)=numparrsta
   parrdistf(*,iday)=numparrflt
   
   totfcnum=total(frynumcell)
   if(totfcnum ne nfry) then begin
      tpslst=where(parrsta EQ 1 and parrstage EQ 0,nfsta)
      tpflst=where(parrsta EQ 0 and parrstage EQ 0,nfflt)
      print,'totfcnum nfry ',totfcnum,nfry,nfsta,nfflt
      ttans=''
      read,'ENTER to continue, S to stop ',ttans
      if(ttans eq 'S' or ttans eq 's') then stop
   endif

   totpcnum=total(parrnumcell)
   if(totpcnum ne nparr) then begin
      tpslst=where(parrsta EQ 1 and parrstage EQ 1,npsta)
      tpflst=where(parrsta EQ 0 and parrstage EQ 1,npflt)
      print,'totpcnum nparr ',totpcnum,nparr,npsta,npflt
      ttans=''
      read,'ENTER to continue, S to stop ',ttans
      if(ttans eq 'S' or ttans eq 's') then stop
   endif

  ;compute floater density in each cell for fry & parr
  fryfltcellden=numfryflt/areayoy(0,*)
  parrfltcellden=numparrflt/areayoy(1,*)
  stalst=where(parrsta EQ 1, nsta)

;  set up BIOENERGETIC arrays for life fry & parr
   parrcons=FLTARR(nyoy)  ;Resize PARRCONS
   parrggcons=FLTARR(nyoy);Resize PARRGGCONS
   parrp=FLTARR(nyoy)     ;Resize PARRP
   parrcmax=FLTARR(nyoy)  ;Resize PARRCMAX
   parresp=FLTARR(nyoy)  ;Resize PARRRESP
   parreges=FLTARR(nyoy)  ;Resize PARREGES
   parrexcr=FLTARR(nyoy)  ;Resize PARREXCR
   parrsda=FLTARR(nyoy)   ;Resize PARRSDA
   parrcosts=FLTARR(nyoy) ;Resize PARRCOSTS
   parrdwt=FLTARR(nyoy)   ;Resize PARRDWT

   ; CONSUMPTION  --------- cons --- cons --- cons --- cons --- cons 
   ; VOLUME SEARCHED for CONSUMPTION
   parrwvel=wvel(parrloc, iday);Velocity m/sec each experiences based on parrloc
   Lcyl=parrwvel*3600*hrlight(iday)  ;(60*60*hr) wvel times daylight hrs in seconds
   rd=parrlen
   mxrd=50.0
   rdlst=where(rd gt mxrd,nrd)
   if(nrd gt 0) then rd(rdlst)= mxrd       ; RD max
   rd=rd/1000.  ; convert rd from mm to m
   Vol=(pi*(rd^2)*Lcyl)  ; Volume Searched in m^3
   Vol=Vol*1000000.   ; convert to L
   
   ;compute floater penalty.  Based on Grant 1990 & arbitrary density function
   fryrden=fryfltcellden/fryfcrit ; ratio of density to cirtical density
   fryfpenalty=0.9-0.3*fryrden
   hilst=where(fryfpenalty gt 0.6,nhi)
   if(nhi gt 0) then fryfpenalty(hilst) = 0.6  ; minimum penalty
   lolst=where(fryfpenalty lt 0.1,nlo)
   if(nlo gt 0) then fryfpenalty(lolst) = 0.1 ; maximum penalty

   parrrden=parrfltcellden/parrfcrit ; ratio of density to cirtical density
   parrfpenalty=0.975-0.325*parrrden
   hilst=where(parrfpenalty gt 0.65,nhi)
   if(nhi gt 0) then parrfpenalty(hilst) = 0.65  ; minimum penalty
   lolst=where(parrfpenalty lt 0.1,nlo)
   if(nlo gt 0) then parrfpenalty(lolst) = 0.1 ; maximum penalty

   preyden=fltarr(nyoy)  ; prey density for each fish 
   if(nfry gt 0) then preyden(frylst)=frypreyday(iday)
   if(nparr gt 0) then preyden(parrlst)=parrpreyday(iday)

   fltpenalty=fltarr(nyoy); floater penalty for each fish. Only used for floaters
   if(nfry gt 0) then fltpenalty(frylst)=fryfpenalty(parrloc(frylst))
   if(nparr gt 0) then fltpenalty(parrlst)=parrfpenalty(parrloc(parrlst))

   SH_CONSYOY,fltpenalty,parrsta,parrstate, parrloc, parrlen, $
      Vol,preyden,mtemp(iday),wvel(*,iday),parrcons
   tlst=WHERE(parrcons LE 0,ntl2)
   IF(ntl2 GT 0) THEN parrcons(tlst)=0.

   ;parr CMAX
   twt=parrwt
   GRPCMAX1,twt,parm,mtemp(iday),tcmx
   parrcmax=tcmx*twt  ; cmax returned in g/g/d. must X wt to get operational cmax

   ; Cap per capita consumption by Cmax
   clist=WHERE(parrcons GT parrcmax, cn)
   IF(cn GT 0) THEN parrcons(clist)=parrcmax(clist)
   
   parrggcons=parrcons/parrwt

   ;parr P
   parrp=parrcons/parrcmax
   ttl=WHERE(parrp GT 1.0,nttl)
   IF(nttl GT 0) THEN  parrp(ttl)=1.0  ;put a cap on P

   ;parr RESP
   GRPRESP1,twt,parm,mtemp(iday),tresp
   parresp=tresp*twt ;resp returned in g/g/d. X twt to get operational resp
   trespvar=parresp*parrespfac*vrespflg ; var in resp. vrespflg=0 when var=0
   parresp=parresp + trespvar  ; individual variability on resp
                               ; respfac values set in sh_gradfry

   ;parr EGEX, EXCR, SDA
   tttemp=mtemp(iday)
   if (tttemp lt .00001) then tttemp = .00001 ; grpegex does not work for negative temperatures.
   GRPEGEX1,parm,tttemp,parrcons,parrp, $
      parreges,parrexcr,parrsda          ; all returned in g/g/d
   parreges=parreges;*parrwt
   parrexcr=parrexcr;*parrwt
   parrsda=parrsda;*parrwt
   
   tne1=n_elements(parrcons)
   tne2=n_elements(parreges)
   if(tne1 ne tne2) then begin
      print,'array size for excr eges sda incorrect'
      print,'nyoy, array size: ',nyoy,tne2
      stop
   endif 

   ;parr GROWTH   
   parrcosts=parresp+parreges+parrexcr+parrsda
   parrdwt=parrcons-parrcosts
   maxloss=-0.15 ;15% maximum weight loss/day... Clark

   invaliddwt=where(parresp lt 0,ninvaliddwt) ; if temp > maximum temp
   if(ninvaliddwt gt 0) then parrdwt(invaliddwt)=parrwt(invaliddwt)*maxloss

   tfr=parrdwt/parrwt
   mxlst=WHERE(tfr LE maxloss)
   IF(MAX(mxlst)GT 0) THEN parrdwt(mxlst)=maxloss*parrwt(mxlst)
   
   ;Update weight
   parrwt=parrwt+parrdwt 
   ;dwtest used for movement. Fry/Parr losing weight over 5 days move
   parrdwtest=parrdwtest*0.5+parrdwt*0.5 

   ;UPDATE parr length
   parrolen=parrlen  ; save length for check of length loss
   tlen=parrlen*0
   twt=parrwt
   LWCNV,tlen,twt,lwa,lwb
   parrlen=tlen
   tslenlst=where(parrlen lt parrolen,nslen)
   if(nslen gt 0) then parrlen(tslenlst)=parrolen(tslenlst)

   ;MORTALITY --- mort --- mort --- mort --- mort --- mort --- mort 
   ;PARRDEATH CODE:
   ;0 = alive, 1=starvation, 2=predation(stationholder), 3=predation(floater)

   ; STARVATION  ------ starve --- starve --- starve --- starve --- starve 
   ; - If parrwt less 0.5 of expected WT OR half initial WT
   crit=0.5
   expwt=parrwt*0.0
   LWCNV,parrlen,expwt,lwa,lwb
   strv=WHERE(parrwt LT (crit*expwt) OR parrwt LT 0.05, d)
   IF(d GT 0) THEN BEGIN
     parrstate(strv)=0  ; Change parrstate to DEAD
     parrdeath(strv)=1  ; Indicate death from starvation
     if(nfry gt 0) then stvfrylst=where(parrdeath(frylst) EQ 1,nfrystv) $
        else nfrystv = 0
     if(nparr gt 0) then stvparrlst=where(parrdeath(parrlst) EQ 1,nparrstv) $
        else nparrstv = 0
     frystarvday(iday)=nfrystv  ; # fry starved each day
     parrstarvday(iday)=nparrstv  ; # parr starved each day
   ENDIF

   ;PREDATION ------ pred ---- pred ---- pred ---- pred ---- pred ---- pred 

   ; baseline Predation probaility for all fish
;   parrppred=c+0.0012*EXP(-parrlen/89.52) ; clark
;   parrppred=0.02
   parrppred=0.0375+3.0*parrlen^(-1.9)
   tnpp=n_elements(parrppred)
   
   fryfpredpen=fryrden*2   ; fry floater predation penalty
   lolst=where(fryfpredpen lt 2.0,nlo)
   if(nlo gt 0) then fryfpredpen(lolst) = 2.0

   parrfpredpen=parrrden*2   ; parr floater predation penalty
   lolst=where(parrfpredpen lt 2.0,nlo)
   if(nlo gt 0) then parrfpredpen(lolst) = 2.0

   ; Predation for floaters = stationholder pred * floater penalty
   fryfltlst=where((parrsta EQ 0) AND (parrstage EQ 0),nfflt)
   IF(nfflt GT 0) THEN BEGIN
     parrppred(fryfltlst)=parrppred(fryfltlst)*fryfpredpen(parrloc(fryfltlst))
   ENDIF ;predation for fry floaters

   parrfltlst=where((parrsta EQ 0) AND (parrstage EQ 1),npflt)
   IF(npflt GT 0) THEN BEGIN
     parrppred(parrfltlst)=parrppred(parrfltlst)*parrfpredpen(parrloc(parrfltlst))
   ENDIF ;predation for parr floaters

; compute predation and change state for fish that die
   ranpred=RANDOMU(idum,nyoy)
   deadlst=where(ranpred LE parrppred,ndead)
   dstalst=where(ranpred LE parrppred AND parrsta EQ 1,nstadead)
   dfltlst=where(ranpred LE parrppred AND parrsta EQ 0,nfltdead)

   fracpred=(nstadead*1.0+nfltdead*1.0)/(nparr*1.0)

    if(ndead GT 0) then BEGIN
       parrstate(deadlst) = 0 
       dstalst1=where(parrstate EQ 0 and parrsta EQ 1,ndsta)
       dfltlst1=where(parrstate EQ 0 and parrsta EQ 0,ndflt)
       if(ndsta gt 0) then parrdeath(dstalst1)=2
       if(ndflt gt 0) then parrdeath(dfltlst1)=3
       parrsta(deadlst)=0
    endif       
 
   ; Temperature based motality ------------ tempmort ----------------
   SH_TEMPMORT,idum,mtemp(iday),parrlen,parrstate,parrdeath

   ;compute mortalities today by stage, death type
   nfrydlst= where(parrstage eq 0 and parrstate eq 0,nfrydead)
   nfstvlst= where(parrstage eq 0 and parrdeath eq 1,nfrystv)
   nfpredlst=where(parrstage eq 0 and (parrdeath eq 2 or parrdeath eq 3),nfrypred)
   nftemplst=where(parrstage eq 0 and parrdeath eq 4,nfrytmort)
   frymortday(0,iday)=nfrydead
   frymortday(1,iday)=nfrystv
   frymortday(2,iday)=nfrypred
   frymortday(3,iday)=nfrytmort

   nparrdlst=where(parrstage eq 1 and parrstate eq 0,npardead)
   npstvlst= where(parrstage eq 1 and parrdeath eq 1,nparstv)
   nppredlst=where(parrstage eq 1 and (parrdeath eq 2 or parrdeath eq 3),nparpred)
   nptemplst=where(parrstage eq 1 and parrdeath eq 4,npartmort)
   parrmortday(0,iday)=npardead
   parrmortday(1,iday)=nparstv
   parrmortday(2,iday)=nparpred
   parrmortday(3,iday)=npartmort
   ; END of Mortality -------------

; Fill PLOT Arrays ---- plotfill ---- plotfill ---- plotfill ---- plotfill 
;FILL Arrays for FRY plots
  if(nfry gt 0) then $
    SH_POPPLTARR,iday,'FRY',parrlen,parrwt,parrstage,parrsta,parrdwt,$
      parrcons,parrggcons,parrp,parrpest,parrpredest,parrdwtest,parrcmax,$
      parresp,parrespfac,$
      parreges,parrexcr,parrsda,frytotday,frystaday,fryfltday,$
      mfrylen,mfrywt,mfrydwt,mfrycons,mfryggcons,mfrycmax,mfryresp,$
      mfryrespfac,mfryp,$
      mfryeges,mfryexcr,mfrysda,mfrypest,mfrypredest,mfrydwtest,$
      vfrylen,vfrywt,vfrydwt, $
      mnfrylen,mnfrywt,mnfrydwt,mnfrycons,mnfryggcons,mnfrycmax,$
      mnfryresp,mnfryrespfac,vfryrespfac,vfryresp,$
      mxfrylen,mxfrywt,mxfrydwt,mxfrycons,mxfryggcons,mxfrycmax,$
      mxfryresp,mxfryrespfac,$
      mfrylens,mfrywts,mfrydwts,mfryconss,mfryggconss,mfryps,$
      mfrypests,mfrypredests,mfrydwtests,$
      mnfrylens,mnfrywts,mnfrydwts,mnfryconss,mnfryggconss,$
      mxfrylens,mxfrywts,mxfrydwts,mxfryconss,mxfryggconss,$
      mfrylenf,mfrywtf,mfrydwtf,mfryconsf,mfryggconsf,mfrypf,$
      mfrypestf,mfrypredestf,mfrydwtestf,$
      mnfrylenf,mnfrywtf,mnfrydwtf,mnfryconsf,mnfryggconsf,$
      mxfrylenf,mxfrywtf,mxfrydwtf,mxfryconsf,mxfryggconsf
      
;FILL Arrays for parr plots
  if(nparr gt 0) then $
    SH_POPPLTARR,iday,'PARR',parrlen,parrwt,parrstage,parrsta,parrdwt,$
      parrcons,parrggcons,parrp,parrpest,parrpredest,parrdwtest,parrcmax,$
      parresp,parrespfac,$
      parreges,parrexcr,parrsda,parrtotday,parrstaday,parrfltday,$
      mparrlen,mparrwt,mparrdwt,mparrcons,mparrggcons,mparrcmax,mparresp,$
      mparrespfac,mparrp,$
      mparreges,mparrexcr,mparrsda,mparrpest,mparrpredest,mparrdwtest,$
      vparrlen,vparrwt,vparrdwt,$
      mnparrlen,mnparrwt,mnparrdwt,mnparrcons,mnparrggcons,mnparrcmax,$
      mnparresp,mnparrespfac,vparrespfac,vparresp,$
      mxparrlen,mxparrwt,mxparrdwt,mxparrcons,mxparrggcons,mxparrcmax,$
      mxparresp,mxparrespfac,$
      mparrlens,mparrwts,mparrdwts,mparrconss,mparrggconss,mparrps,$
      mparrpests,mparrpredests,mparrdwtests,$
      mnparrlens,mnparrwts,mnparrdwts,mnparrconss,mnparrggconss,$
      mxparrlens,mxparrwts,mxparrdwts,mxparrconss,mxparrggconss,$
      mparrlenf,mparrwtf,mparrdwtf,mparrconsf,mparrggconsf,mparrpf,$
      mparrpestf,mparrpredestf,mparrdwtestf,$
      mnparrlenf,mnparrwtf,mnparrdwtf,mnparrconsf,mnparrggconsf,$
      mxparrlenf,mxparrwtf,mxparrdwtf,mxparrconsf,mxparrggconsf

; combined fry-parr mean & var on wt & len
      if (nyoy) gt 2 then begin
         tmnt=moment(parrlen(yoylst))
         myoylen(iday)=tmnt(0)
         vyoylen(iday)=tmnt(1)
         tmnt=moment(parrwt(yoylst))
         myoywt(iday)=tmnt(0)
         vyoywt(iday)=tmnt(1)
      endif

; RECOVER PARR ARRAYS ---- recover--- recover--- recover--- recover--- recover
; eliminate data for dead YOY
  yoylivelst=where(parrstate eq 1, nlyoy)
  if(nlyoy gt 0) then begin  
    parrlen=parrlen(yoylivelst)
    parrwt=parrwt(yoylivelst)
    parrdwt=parrdwt(yoylivelst)
    parrloc=parrloc(yoylivelst)
    parrstate=parrstate(yoylivelst)
    parrdeath=parrdeath(yoylivelst)
    parrsta=parrsta(yoylivelst)
    parrday=parrday(yoylivelst)
    parrcons=parrcons(yoylivelst)
    parrp=parrp(yoylivelst)
    parrggcons=parrggcons(yoylivelst)
    parrppred=parrppred(yoylivelst)
    parrpest=parrpest(yoylivelst)
    parrpredest=parrpredest(yoylivelst)
    parrdwtest=parrdwtest(yoylivelst)
    parrdday=parrday(yoylivelst)
    parrstage=parrstage(yoylivelst)
    fryday=fryday(yoylivelst)
    parrespfac=parrespfac(yoylivelst)
  endif ; nlyoy gt 0

   ; MOVEMENT ------ move --- move --- move --- move --- move --- move 
   ; - Determine whether a fish moves and calculate distace
   oldloc=parrloc
   if(total(parrstate) gt 0.0) then BEGIN
      movflg=parrstate*0  ; flag for moving used only for compute numbers moving
      SH_MOV,delta,cellnum,parrstate,parrsta,parrloc,parrstage,parrp, $
        parrdwt,parrppred,parrpest,parrpredest,parrdwtest,movflg
    ENDIF  ;else print,'No Parr Alive, iday= ',iday
    offlst=where(parrloc gt cellnum or parrloc lt 0,noff)
    if noff gt 0 then begin
       print,'fish off stream ',noff
       stop
    endif       
   
   ; update Pest & predest used for movement
   parrPest=(delta*parrPest)+((1-delta)*parrP)
   parrpredest=(delta*parrpredest)+((1-delta)*parrppred)

   ; compute numbers moved
   if(nfry gt 0) then begin
      frymovnum(iday)=total(movflg(frylst))
      ttl=where(movflg eq 1 and parrstage eq 0 and parrsta eq 1,ttn)
      frymovs(iday)=ttn
      ttl=where(movflg eq 1 and parrstage eq 0 and parrsta eq 0,ttn)
      frymovf(iday)=ttn
   endif
   if(nparr gt 0) then begin
      parrmovnum(iday)=total(movflg(parrlst))
      ttl=where(movflg eq 1 and parrstage eq 1 and parrsta eq 1,ttn)
      parrmovs(iday)=ttn
      ttl=where(movflg eq 1 and parrstage eq 1 and parrsta eq 0,ttn)
      parrmovf(iday)=ttn
   endif
            
ENDIF; NYOY gt 0
   
; GRADUATION -------- grad ---- grad ---- grad ---- grad ---- grad ---- grad 
;all graduation must occur at the end of the day so that no idividual 
;  runs through a day twice, once at an early stage and again through a later stage

; graduate eggs to alevins
if (negg gt 0) then BEGIN  ; egg cohorts exist
    newalvlst=where(eggdev ge 1.0,ntalv)
    if(ntalv gt 0) then begin
      alvnum(newalvlst)=eggnum(newalvlst)
      alvday(newalvlst)=iday
      alvdev(newalvlst) = 0.0001             ; initiate alvdev
      eggdev(newalvlst)=-111
      eggnum(newalvlst)=0.
 ; stage data
      ttalv=total(alvnum(newalvlst)) 
      stnum(1)=stnum(1)+ttalv
      stday(1)=stday(1)+(iday*ttalv)
      tegdur=(alvday(newalvlst)-eggday(newalvlst))*1.0*alvnum(newalvlst)
      ttdur=total(tegdur)
      if(ttdur lt 0) then begin
        print,'ttdur ',ttdur
        stop
      endif
      stdur(0)=stdur(0)+ttdur      
    endif
ENDIF  ; negg gt 0

; graduate alevins to fry (step 1 of 2)
if (nalv gt 0) then BEGIN ; alevin cohorts exist
    newfrylst=where(alvdev ge 1.0,newfrycoh)
    if(newfrycoh gt 0) then begin  ; set up new fry cohorts
       newfrytot=total(alvnum(newfrylst))
       newfrynum=alvnum(newfrylst)
       newfryloc=reddloc(newfrylst)
       newfrydur=iday-alvday(newfrylst)
       alvnum(newfrylst)=0.
       alvdev(newfrylst)=-111
       
; below is now superfluous because csparea gets recomputed in spawning code each day       
; return reddarea to cell spawning area (csparea)
;       for ialv=0,newfrycoh-1 do begin
;          loc=reddloc(ialv)
;          csparea(loc)=csparea(loc)+reddarea(ialv)
;       endfor

;      call CREATE for each new cohort of fry
       for icoh = 0, newfrycoh-1 do begin
         if(newfrynum(icoh) gt 0) then begin
         SH_GRADFRY,idumGF,iday,newfrynum(icoh),fryinitlen,fryinitwt, $
           newfryloc(icoh),fryinitpest,fryinitpredest,fryinitdwtest,$
           parrlen,parrwt,parrloc,parrstate,parrdeath,parrsta,parrday, $
           parrpest,parrpredest,parrdwtest,parrdday,parrstage,parrilen,$
           fryday,vrespflg,vrespcv,parrespfac
         endif
       endfor  ; icoh
 ; stage data
       stnum(2)=stnum(2)+newfrytot
       stday(2)=stday(2)+total(iday*newfrytot)
       stdur(1)=stdur(1)+total(newfrydur*newfrynum)           
;       print,newfrydur,newfrynum,newfrydur*newfrynum,stdur(1)
     endif ; newfrycoh gt 0
ENDIF  ; nalv gt 0

; Graduate Fry to Parr
; changes state of the parrstage variable, 0=fry, 1=parr
mnpgradlen = 35.0
mxpgradlen = 45.0
grm = (1-0.25)/(mxpgradlen-mnpgradlen)
grb=1.0-(grm*mxpgradlen)

;tpgradlst=where(parrlen ge mnpgradlen and parrstage eq 0, ngrad)
tpgradlst=where(parrlen ge 40.0 AND parrstage eq 0, ngrad)
if(ngrad gt 0) then begin
;  pgrad=grm*parrlen + grb ; probability of graduating
;  tsz=n_elements(parrlen)
;  tvec=RANDOMU(idum,tsz)
;  nplst=where(tvec le pgrad,np)
  if (ngrad gt 0) then begin
      parrstage(tpgradlst)= 1  ; set to 'parr'
      parrday(tpgradlst)=iday ; set day fish becomes a parr
      parrilen(tpgradlst)=parrlen(tpgradlst)  ; initial parr len for stage growth rate
      stnum(3)=stnum(3)+ngrad
      stday(3)=stday(3)+(iday*ngrad)
      stdur(2)=stdur(2)+total(iday-fryday(tpgradlst))      
  endif
endif

if (iday eq 275) then begin  ; compute stage data for growing season
    stnum(4)=nyoy
    stdur(3)=total(iday-parrday)
    ttn=total(parrstate)
    if(ttn gt 1) then begin
      tmnt=moment(parrlen) 
      tmnt1=moment(parrwt)
    endif else begin
          tmnt=fltarr(2)
          tmnt(0)=parrlen
          tmnt(0)=0.
          tmnt1=fltarr(2)
          tmnt1(0)=parrwt
          tmnt1(0)=0.
    endelse
    mlen275=tmnt(0)
    vlen275=tmnt(1)
    mwt275=tmnt1(0)
    vwt275=tmnt1(1)
    parrlen275=parrlen
    parrwt275=parrwt
endif
     
DONEDAY: ; Done when zero fish are alive to compute bioenergetics

if(iday ge nextoutput) then begin
   nextoutput=nextoutput+outputint
   formday='(a9,1x,a4,1x,i3,a3,1x,4(i7,1x),a5,1x,2(f5.1,1x),a8)'
   print,format=formday,filnumstr,'day:',iday,' #:',eggtotday(iday),$
      alvtotday(iday),frytotday(iday),parrtotday(iday),$
      ' len:',mfrylen(iday),mparrlen(iday)     
endif

if(iday ge nextpause AND nextpause ge 0) then begin
   ttp=''
   read,'.... ENTER to continue "S" to stop  ',ttp
   ttp=strupcase(ttp)
   if ttp eq 'S' then stop
   nextpause=nextpause + pauseint
endif   

;if(outdayscount lt outdays) then begin
;   if (iday eq outdayarr(outdayscount)) then begin
;     ; output station number, holders, floaters
;     form15='(i5,2x,4(f9.1,2x))'
;     for ic=0,cellnum-1 do printf,15,format=form15, $
;            iday,pstanum(ic),parrnumcell(ic),numparrsta(ic),numparrflt(ic)
;     outdayscount=outdayscount+1
;   endif
;endif

ENDFOR ; END OF IDAY LOOP -----------------------------------------------
;======================================================================

POPCRASH:  ; population crashed, end run
if(iday lt 275) then begin
  stnum(4)=0
  stdur(3)=0
  mlen275=0
  vlen275=0
  mwt275=0
  vwt275=0
endif

endtime=systime(1)
elapsec=endtime-sttime
elapsmin=elapsec/60.0
partmin=(elapsmin-fix(elapsmin))*60.0

;compute fry/parr fraction moved daily
ttfl=where(frytotday gt 0,ntf)
frfrymov=fltarr(365)-1
if(ntf gt 0) then frfrymov(ttfl)=1.0*frymovnum(ttfl)/frytotday(ttfl)
ttfl=where(parrtotday gt 0,ntf)
frparmov=fltarr(365)-1
if(ntf gt 0) then frparmov(ttfl)=1.0*parrmovnum(ttfl)/parrtotday(ttfl)

; compute area used by redds
creddarea=fltarr(cellnum)  ; area taken up by redds
for ic=0,cellnum-1 do begin
   ttl=where(reddloc eq ic,ntt)
   if(ntt gt 0) then creddarea(ic)=total(reddarea(ttl))
endfor

; output statXX.dat file
mwidth=fltarr(cellnum)
mdepth=fltarr(cellnum)
for ic=0,cellnum-1 do begin
   tmw=moment(width(ic,*))
   mwidth(ic)=tmw(0)
   tmd=moment(depth(ic,*))
   mdepth(ic)=tmd(0)
endfor
totarea=total(mwidth*dst)
parrarea=total(areayoy(1,*))
fryarea=total(areayoy(0,*))
reddtotarea=total(reddarea)
fstatot=total(fstanum)
pstatot=total(pstanum)
ystatot=total(ystanum)

form2='(a20,4(f9.1,2x),f6.4)'
form3='(a20,3(i9,2x))
frrdar=reddtotarea/totarea
printf,10,'                        fry        parr      total     reddtot  fr.redd'
printf,10,format=form2,'Area (m^2): ',fryarea,parrarea,totarea,reddtotarea,frrdar
printf,10,format=form3,'Stations: ',fstatot,pstatot
printf,10,''
printf,10,format='(a20,f8.2)','Elapsed min: ',elapsmin
print,''
print,format='(a15,f8.2)','Elapsed min: ',elapsmin
printf,10,''
print,''
print,'Environmental Flags:'
print,'  temp flow flowfac: ',tempflg,flowflg,flowfac
print,''

; compute stage information

ttdur=fltarr(5)
frsurv=fltarr(5)
for itt=0,3 do begin
  ttdur(itt)=stdur(itt)/stnum(itt+1)
  frsurv(itt)=stnum(itt+1)/stnum(itt)
endfor
frz= -1*ALOG(frsurv(0:3))/ttdur(0:3)

; compute fraction of mortality due to each type, starve, pred, temp
; egg mortality by type
temort=fltarr(4)
for itt=0,3 do temort(itt)=total(eggmortday(itt,*))
efrscr=temort(1)/temort(0)
efrprd=temort(2)/temort(0)
efrtmp=temort(3)/temort(0)
; alevin mortality by type
tamort=fltarr(4)
for itt=0,3 do tamort(itt)=total(alvmortday(itt,*))
afrscr=tamort(1)/tamort(0)
afrprd=tamort(2)/tamort(0)
afrtmp=tamort(3)/tamort(0)

; fry mortality by type
tfmort=fltarr(4)
for itt=0,3 do tfmort(itt)=total(frymortday(itt,*))
ffrstv=tfmort(1)/tfmort(0)
ffrprd=tfmort(2)/tfmort(0)
ffrtmp=tfmort(3)/tfmort(0)
; parr mortality by type
tpmort=fltarr(4)
for itt=0,3 do tpmort(itt)=total(parrmortday(itt,*))
pfrstv=tpmort(1)/tpmort(0)
pfrprd=tpmort(2)/tpmort(0)
pfrtmp=tpmort(3)/tpmort(0)

;compute days pop is present
frypoppres=where(frytotday gt 0)
parrpoppres=where(parrtotday gt 0)

print,'Stage Data'
ttrl=where(reddloc ge 0,reddnum)
print,'spnum: ',spnum,'   reddnum: ',reddnum
print,'                      egg     alevin        fry       parr       d275'
stform1='(a15,5(i10,1x))'
stform2='(a15,4(f10.2,1x),f10.3)'
stform3='(a15,4(f10.4,1x),f10.3)'
stform4='(a15,4(f10.5,1x),f10.3)'
stform5='(a15,5(f10.3,1x))'
print,format=stform1,'init num: ',stnum(0:4)
ttday=stday/stnum
print,format=stform2,'day started: ',ttday(0:3)
print,format=stform2,'duration: ',ttdur(0:3),mlen275
print,format=stform3,'fr. surv.: ',frsurv(0:3),vlen275
print,format=stform4,'daily Z: ',frz(0:3)
print,format=stform5,'fr. stv/scr: ',efrscr,afrscr,ffrstv,pfrstv,mwt275
print,format=stform5,'fr.  pred: ',efrprd,afrprd,ffrprd,pfrprd,vwt275
print,format=stform5,'fr.  temp: ',efrtmp,afrtmp,ffrtmp,pfrtmp

;print to stage file
printf,11,'spnum: ',spnum,'   reddnum: ',reddnum
printf,11,'                      egg     alevin        fry       parr       d275'
printf,11,format=stform1,'init num: ',stnum(0:4)
printf,11,format=stform2,'day started: ',ttday(0:3)
printf,11,format=stform2,'duration: ',ttdur(0:3),mlen275
printf,11,format=stform3,'frac. surv.: ',frsurv(0:3),vlen275
printf,11,format=stform4,'daily Z: ',frz(0:3)
printf,11,format=stform5,'fr. stv/scr: ',efrscr,afrscr,ffrstv,pfrstv,mwt275
printf,11,format=stform5,'fr.  pred: ',efrprd,afrprd,ffrprd,pfrprd,vwt275
printf,11,format=stform5,'fr.  temp: ',efrtmp,afrtmp,ffrtmp,pfrtmp

printf,11,"Prey multiplier for sensitivity analysis: ',SApreyfac

;Population Plot, window 0
SH_PLOTPOP,0,eggtotday,alvtotday,frytotday,frystaday,fryfltday,$
   parrtotday,parrstaday,parrfltday,dst,width

; close output files
close,10,11
close,15

idlsave=0
doexit=0
if(batflg eq 1) then begin
  plotopt=88
  doexit=1
  goto,SKIPPLOT
endif
plotopt=88
goto,SKIPPLOT

;additional outputs
DOPLOTS:
doexit=0
print,''
print,'Additional Outputs Menu '
print,'   1 : Population Plots'
print,'  11 : FRY Length, Weight Plots' 
print,'  12 : PARR Length, Weight Plots'
print,'  21 : FRY Consumption Plots'
print,'  22 : PARR Consumption Plots'
print,'  25 : FRY Bioenergetics Plots'
print,'  26 : PARR Bioenergetics Plots'
print,'  31 : FRY & PARR Mortality & Movement Plots'
print,'  51 : Temporal Environment Plots
print,'  52 : Spatial Environment Plots'
if(idlsave eq 0) then print,'  88 : Save .idldat file ' $
  else print,'       Data were saved in ',idlfile
;print,'   2 : Plot stations holders floaters'
;print,'   3 : Write number, length, weight data files'
print,''
print,'  99 : EXIT '
print,''
read,'   Select Output Option ',plotopt

!P.MULTI = 0

SKIPPLOT:
Case plotopt of
; plotpop uses window 0
   1 : SH_PLOTPOP,0,eggtotday,alvtotday,frytotday,frystaday,fryfltday,$
         parrtotday,parrstaday,parrfltday,dst,width

;  plotlen uses window 1
  11 : SH_PLOTLEN,1,'FRY',mfrylen, mxfrylen, mnfrylen, mfrylens, $
         mxfrylens,mnfrylens,mfrylenf, mxfrylenf, mnfrylenf, mfrywt,$
         mxfrywt,mnfrywt, mfrywts, mxfrywts, mnfrywts,mfrywtf,$
         mxfrywtf,mnfrywtf
         
  12 : SH_PLOTLEN,1,'PARR',mparrlen, mxparrlen, mnparrlen, mparrlens, $
         mxparrlens,mnparrlens,mparrlenf, mxparrlenf, mnparrlenf, mparrwt,$
         mxparrwt,mnparrwt, mparrwts, mxparrwts, mnparrwts,mparrwtf,$
         mxparrwtf,mnparrwtf  

; plotcon uses window 2
  21 : SH_PLOTCON,2,'FRY',mnfrydwt, mxfrydwt, mfrydwt, mnfrydwts, $
           mxfrydwts, mfrydwts,mnfrydwtf, mxfrydwtf, mfrydwtf, $
           mnfrycons, mxfrycons, mfrycons, mnfryconss, mxfryconss,$
           mfryconss, mnfryconsf, mxfryconsf, mfryconsf, mnfryggcons,$
           mxfryggcons,mfryggcons,mnfryggconss,mxfryggconss,mfryggconss,$
           mnfryggconsf,mxfryggconsf,mfryggconsf,mnfryp, $
           mxfryp, mfryp, mnfryps, mxfryps,mfryps, mnfrypf, $
           mxfrypf, mfrypf
          ; ,mfrycmax,mnfrycmax,mxfrycmax,mfryresp,$
          ; mfryeges,mfryexcr,mfrysda
         
  22 : SH_PLOTCON,2,'PARR',mnparrdwt, mxparrdwt, mparrdwt, mnparrdwts, $
           mxparrdwts, mparrdwts,mnparrdwtf, mxparrdwtf, mparrdwtf, $
           mnparrcons, mxparrcons, mparrcons, mnparrconss, mxparrconss,$
           mparrconss, mnparrconsf, mxparrconsf, mparrconsf, mnparrggcons,$
           mxparrggcons,mparrggcons,mnparrggconss,mxparrggconss,mparrggconss,$
           mnparrggconsf,mxparrggconsf,mparrggconsf,mnparrp, $
           mxparrp, mparrp, mnparrps, mxparrps,mparrps, mnparrpf, $
           mxparrpf, mparrpf
          
  25 : SH_PLOTBIOEN,2,'FRY',mfrycmax,mnfrycmax,mxfrycmax,mfryresp,$
           vfryresp,mnfryresp,mxfryresp,mfryrespfac,vfryrespfac,$
           mnfryrespfac,mxfryrespfac,mfryeges,mfryexcr,mfrysda       
           
  26 : SH_PLOTBIOEN,2,'PARR',mparrcmax,mnparrcmax,mxparrcmax,mparresp,$
           vparresp,mnparresp,mxparresp,mparrespfac,vparrespfac,$
           mnparrespfac,mxparrespfac,mparreges,mparrexcr,mparrsda
           
  31 : SH_PLOTMORTMOV,3,frymortday,parrmortday,frymovnum,frymovs,frymovf,$
           frfrymov,parrmovnum,parrmovs,parrmovf,frparmov
           
; plotenv plots use window 5
  51 : SH_PLOTENVTMP,5,mtemp,vdisch,frypreyday,parrpreyday,$
          basemtemp,basedisch,frypoppres,parrpoppres
         
  52 : begin
        SH_PLOTENVSPA,5,cellnum,reddloc,fstanum,pstanum,$
         wvel,wvelhist,grvl,mwidth,mdepth
       end
  88 : begin
         stp=strpos(statfile,'stat')+4
         enp=strpos(statfile,'.dat')
         filid=strmid(statfile,stp,(enp-stp))
         outdir=strmid(statfile,0,(stp-4))
         idlfile=outdir+'shmandat'+filid+'.idldat'
         SAVE,filename=idlfile,$
           eggtotday,alvtotday,frytotday,frystaday,fryfltday,$
           parrtotday,parrstaday,parrfltday,$
           mfrylen, vfrylen,mxfrylen, mnfrylen, mfrylens, $
           mxfrylens,mnfrylens,mfrylenf, mxfrylenf, mnfrylenf, mfrywt,vfrywt,$
           mxfrywt,mnfrywt, mfrywts, mxfrywts, mnfrywts,mfrywtf,$
           mxfrywtf,mnfrywtf,$
           mparrlen, vparrlen,mxparrlen, mnparrlen, mparrlens, $
           mxparrlens,mnparrlens,mparrlenf, mxparrlenf, mnparrlenf, mparrwt,$
           vparrwt,mxparrwt,mnparrwt, mparrwts, mxparrwts, mnparrwts,mparrwtf,$
           mxparrwtf,mnparrwtf,$
           mnfrydwt, mxfrydwt, mfrydwt,vfrydwt, mnfrydwts, $
           mxfrydwts, mfrydwts,mnfrydwtf, mxfrydwtf, mfrydwtf, $
           mnfrycons, mxfrycons, mfrycons, mnfryconss, mxfryconss,$
           mfryconss, mnfryconsf, mxfryconsf, mfryconsf, mnfryggcons,$
           mxfryggcons,mfryggcons,mnfryggconss,mxfryggconss,mfryggconss,$
           mnfryggconsf,mxfryggconsf,mfryggconsf,mnfryp, $
           mxfryp, mfryp, mnfryps, mxfryps,mfryps, mnfrypf, $
           mxfrypf, mfrypf,$
           mnparrdwt, mxparrdwt, mparrdwt,vparrdwt, mnparrdwts, $
           mxparrdwts, mparrdwts,mnparrdwtf, mxparrdwtf, mparrdwtf, $
           mnparrcons, mxparrcons, mparrcons, mnparrconss, mxparrconss,$
           mparrconss, mnparrconsf, mxparrconsf, mparrconsf, mnparrggcons,$
           mxparrggcons,mparrggcons,mnparrggconss,mxparrggconss,mparrggconss,$
           mnparrggconsf,mxparrggconsf,mparrggconsf,mnparrp, $
           mxparrp, mparrp, mnparrps, mxparrps,mparrps, mnparrpf, $
           mxparrpf, mparrpf,$
           mfrycmax,mnfrycmax,mxfrycmax,mfryresp,$
           mfryeges,mfryexcr,mfrysda,$
           mparrcmax,mnparrcmax,mxparrcmax,mparresp,$
           mparreges,mparrexcr,mparrsda,$
           frymortday,parrmortday,frymovnum,frymovs,frymovf,$
           frfrymov,parrmovnum,parrmovs,parrmovf,frparmov,$
           mtemp,wvelday,frypreyday,parrpreyday,$
           basemtemp,basemwvel,basedisch,frypoppres,parrpoppres,$
           redddist,grvl,wvel,fstanum,pstanum,frydist,$
           frydists,frydistf,parrdist,parrdistf,parrdists,$
           cellnum,reddloc,fstanum,pstanum,$
           wvel,wvelhist,grvl,mwidth,mdepth,width,depth,vdisch,dst,$
           mparrpreyday,mfrypreyday,mnfryresp,mxfryresp,mfryrespfac,$
           mnfryrespfac,mxfryrespfac,vfryresp,vfryrespfac,$
           mnparresp,mxparresp,mparrespfac,$
           mnparrespfac,mxparrespfac,vparresp,vparrespfac,$
           parrlen275,parrwt275,spday1,$
           myoylen,vyoylen,myoywt,vyoywt
           
         idlsave=1
       end
                
;  3 : begin
;        popfile=outputdir+'parrpop'+filnumstr+'.dat'
;        lenfile=outputdir+'parrlen'+filnumstr+'.dat'
;        wtfile= outputdir+'parrwt' +filnumstr+'.dat'
;        ttopen=findfile(popfile,count=ttn)
;        ovans='Y'
;        if (ttn ne 0) then begin
;           print,'Preparing to write number, length, weight files.'
;           print,'Files exist with names: '
;           print,popfile, lenfile, wtfile
;           print,''
;           READ,'    Overwrite existing files? (y/n) ',ovans
;           ovans=strupcase(ovans)
;        endif
;        stwriteday=min(parrday)
;        if(ovans ne 'N') then begin  ; write the files
;          print,'writing file ',popfile
;          close,20
;          openw,20,popfile
;          printf,20,'iday     total      hold       flt     starv      pred    totmov   stamov    fltmov'
;          form20='(i4,1x,8(f9.1,1x))'
;          for id=stwriteday,endday do begin
;             printf,20,format=form20,id,parrtotday(id),parrstaday(id),parrfltday(id), $
;                parrstarvday(id),parrpredday(id),parrmovnum(id),stamovday(id),fltmovday(id)
;          endfor
;          close,20
;
;          print,'writing file ',lenfile
;          close,30
;          openw,30,lenfile
;          printf,30,'iday   mlen    mnlen   mxlen   mlenS   mnlenS  mxlenS  mlenF   mnlenF  mxlenF'
;          form30='(i4,1x,9(f7.2,1x))'
;          for id=stwriteday,endday do begin
;             printf,30,format=form30,id,mparrlen(id),mnparrlen(id),mxparrlen(id), $
;               mparrlens(id),mnparrlens(id),mxparrlens(id), $
;               mparrlenf(id),mnparrlenf(id),mxparrlenf(id)
;          endfor
;          close,30
;          close,40
;          print,'writing file ',wtfile
;          close,40
;          openw,40,wtfile
;          printf,40,'iday   mwt    mnwt   mxwt   mwtS   mnwtS  mxwtS  mwtF   mnwtF  mxwtF'
;          form40='(i4,1x,9(f6.2,1x))'
;          for id=stwriteday,endday do begin
;             printf,40,format=form40,id,mparrwt(id),mnparrwt(id),mxparrwt(id), $
;               mparrwts(id),mnparrwts(id),mxparrwts(id), $
;               mparrwtf(id),mnparrwtf(id),mxparrwtf(id)
;          endfor
;          close,40
;        endif ; ovans ne 'N'
;      end
 99 : doexit=1
 else:  print,'Not a selection. Choose another.'
endcase

if (doexit ne 1) then goto, DOPLOTS
if(batflg eq 1) then goto, READINPUTS

NORUN:
print,'... finished'
END
