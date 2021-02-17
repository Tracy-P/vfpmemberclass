DEFINE CLASS ProcessFormsSubclassedGrid as ProcessClassBase OF ProcessClassBase.prg

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
      LOCAL ii, hasChange
      hasChange = .F.
      ?"Current form: ",currentFile.Name
      USE (currentFile.Name) IN SELECT("csrLibrary") ALIAS csrLibrary SHARED
      SELECT csrLibrary
      FOR ii = 1 TO ALEN(this.classesToCheckMethods, 1)
         LOCATE FOR class = this.classesToCheckMethods[ii, 1]
         DO WHILE FOUND()
            hasChange = this.UpdateSubclassMethods(this.classesToCheckMethods[ii, 2]) OR hasChange
            CONTINUE 
         ENDDO 
      NEXT 
      USE IN SELECT("csrLibrary")
      IF hasChange
         COMPILE FORM (currentFile.Name)
      ENDIF 
   ENDFUNC

ENDDEFINE 