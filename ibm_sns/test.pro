    SexSkew = 0.
    NewAge1array = ROUND(RANDOMU(seed, 1000))
    Male = WHERE(NewAge1array EQ 0., malecount, complement = female, ncomplement = femalecount)
    ;SexSkew = 0.5; proportional reduction in females becasue of androgenic EDC
    m = ROUND(femalecount * SexSkew)
    
    print, 'femalecount',femalecount
    print, 'm', m
    
    IF (femalecount GT 0) and (sexskew GT 0.) THEN begin 
      arr = RANDOMU(seed, femalecount) 
      ind = REVERSE(SORT(arr))
      FemaleToMale = female[ind[0:m-1]]
      print, 'number of femaletomale',n_elements(FemaleToMale)
      PRINT, 'FemaleToMale', FemaleToMale
      IF n_elements(FemaleToMale) GT 0. THEN NewAge1array[FemaleToMale] = 0
      Male = WHERE(NewAge1array EQ 0., malecount, complement = female, ncomplement = femalecount)
         
    endif

        
    print, 'femalecount',femalecount
    
    end