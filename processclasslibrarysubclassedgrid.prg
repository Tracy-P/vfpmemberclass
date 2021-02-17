DEFINE CLASS ProcessClassLibrarySubclassedGrid as ProcessClassBase OF ProcessClassBase.prg

   FUNCTION processClassLibrary
      LPARAMETERS currentClassLibrary as VisualFoxpro.IFoxPrjFile
      LOCAL ii, hasChange
      hasChange = .F.
      USE (currentClassLibrary.Name) IN SELECT("csrLibrary") ALIAS csrLibrary SHARED 
      FOR ii = 1 TO ALEN(this.classesToCheckMethods,1)
         LOCATE FOR class = this.classesToCheckMethods[ii, 1]
         DO WHILE FOUND()
            hasChange = this.UpdateSubClassMethods(this.classesToCheckMethods[ii, 2]) OR hasChange
            CONTINUE 
         ENDDO 
      NEXT 
      USE IN SELECT("csrLibrary")
      COMPILE CLASSLIB (currentClassLibrary.Name) 
   ENDFUNC 

ENDDEFINE 
