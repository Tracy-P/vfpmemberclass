DEFINE CLASS ProcessClassLibraryBaseGrid as ProcessClassBase OF ProcessClassBase.prg 
   
   PROCEDURE Init 
      this.baseGridClass = LOWER(this.baseGridClass)
      this.baseGridClassLibrary = LOWER(this.baseGridClassLibrary)
      this.baseColumnClass = LOWER(this.baseColumnClass)
      this.baseHeaderClass = LOWER(this.baseHeaderClass)
   ENDPROC 

   FUNCTION ProcessClassLibrary
      LPARAMETERS currentLibrary as VisualFoxpro.IFoxPrjFile
      USE (currentLibrary.Name) IN SELECT("csrLibrary") ALIAS csrLibrary shared  
      LOCATE FOR class = this.baseGridClass
      DO WHILE FOUND()
         this.ProcessGridChangesInLibrary()
         CONTINUE 
      ENDDO 
      USE IN SELECT("csrLibrary")
      COMPILE CLASSLIB (currentLibrary.Name)
   ENDFUNC 
   
   FUNCTION ProcessGridChangesInLibrary
      IF NOT USED("csrLibrary") OR csrLibrary.Class <> this.baseGridClass
         RETURN .F.
      ENDIF 
      SELECT csrLibrary
      LOCAL controlPath
      controlPath = ALLTRIM(csrLibrary.parent) + "." + ALLTRIM(csrLibrary.Objname) + "."
      IF this.UpdateGridProperties()
*!*	         this.AddToCheckMethodsArray(csrLibrary.parent, csrLibrary.objName)
*!*	         SKIP 1 IN csrLibrary
*!*	         SCAN REST WHILE ALLTRIM(csrLibrary.Parent) = controlPath
*!*	            this.UpdateGridMember(controlpath)
*!*	         ENDSCAN 
      ENDIF 
   ENDFUNC 
   
   FUNCTION AddToCheckMethodsArray
      LPARAMETERS className, controlName
      LOCAL arrayLen
      arrayLen = ALEN(this.classesToCheckMethods, 1)
      IF arrayLen > 1 OR NOT EMPTY(this.classesToCheckMethods[1, 1])
         arrayLen = arrayLen + 1
      ENDIF 
      DIMENSION this.classesToCheckMethods[arrayLen, 2]
      this.classesToCheckMethods[arrayLen, 1] = GETWORDNUM(className, 1, ".")
      this.classesToCheckMethods[arrayLen, 2] = controlName
   ENDFUNC 

ENDDEFINE 