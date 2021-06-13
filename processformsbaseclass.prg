DEFINE CLASS ProcessFormsBaseClass as ProcessClassBase OF ProcessClassBase.prg
   FUNCTION ProcessForms
      LPARAMETERS activeProject as VisualFoxpro.IFoxProject
      LOCAL ii
      FOR ii = 1 TO activeProject.Files.Count
         IF activeProject.Files.Item(ii).Type = "K"
            this.processForm(activeProject.Files.Item(ii))
         ENDIF 
      NEXT 
   ENDFUNC 

   FUNCTION ProcessForm
      LPARAMETERS currentFile as VisualFoxpro.IFoxPrjFile
      LOCAL hasChange
      hasChange = .F.
      USE (currentFile.Name) IN SELECT("csrLibrary") ALIAS csrLibrary SHARED 
      LOCATE FOR class = this.baseGridClass
      DO WHILE FOUND()
         hasChange = .T.
         this.ProcessGridChangesInForm()
         CONTINUE 
      ENDDO 
      USE IN SELECT("csrLibrary")
      IF hasChange
         COMPILE FORM (currentFile.Name)
      ENDIF 
   ENDFUNC 

   FUNCTION ProcessGridChangesInForm
      SELECT csrLibrary
      LOCAL controlPath
      controlPath = ALLTRIM(csrLibrary.Parent) + "." + ALLTRIM(csrLibrary.Objname) + "."
      IF this.UpdateGridProperties()
*!*	         SKIP 1 IN csrLibrary
*!*	         SCAN REST WHILE ALLTRIM(csrLibrary.Parent) = controlPath
*!*	            this.UpdateGridMember(controlPath)
*!*	         ENDSCAN 
      ENDIF 
   ENDFUNC    

ENDDEFINE 
