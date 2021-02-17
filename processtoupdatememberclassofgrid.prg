LOCAL processControl as processClass
processControl = CREATEOBJECT("processClass")
IF TYPE("processControl.Name") = "C"
   processControl.Run()
ENDIF 

processControl = NULL

CLEAR CLASS processClass
CLEAR CLASS ProcessClassLibraryBaseGrid 
CLEAR CLASS ProcessClassLibrarySubclassedGrid 
CLEAR CLASS ProcessClassBase

CLEAR CLASS formwithsubclass
CLEAR CLASS modulegridcontainer
CLEAR CLASSLIB modulelibrary

CLEAR CLASS baseButton
CLEAR CLASS baseGrid
CLEAR CLASS baseContainer
CLEAR CLASS baseForm
CLEAR CLASSLIB baseLibrary

DEFINE CLASS processClass as Session 
   baseGridClass = "basegrid"
   baseGridClassLibrary = "baselibrary"
   baseColumnClass = "basecolumn"
   baseHeaderClass = "baseheader"
   *classesToCheckMethods[1] = ""
   ProcessClassLibraryBaseGrid  = null
   ProcessClassLibrarySubclassedGrid = null
   
   PROCEDURE Init 
      this.baseGridClass = LOWER(this.baseGridClass)
      this.baseGridClassLibrary = LOWER(this.baseGridClassLibrary)
      this.baseColumnClass = LOWER(this.baseColumnClass)
      this.baseHeaderClass = LOWER(this.baseHeaderClass)
   ENDPROC 

   PROCEDURE Error
      LPARAMETERS errorNumber, methodName, lineNumber
      LOCAL messageText, errorStack[1], ii
      messageText = "Error: " + TRANSFORM(errorNumber) + " " + MESSAGE() + CHR(13) ;
         + "Method: " + TRANSFORM(methodName) + CHR(13) ;
         + "Line: " + TRANSFORM(lineNumber)
      FOR ii = ASTACKINFO("ErrorStack")-1 TO 2 STEP -1
         messageText = messageText + CHR(13) + TRANSFORM(errorStack[ii,3]) ;
            + " " + TRANSFORM(errorStack[ii,5]) 
      NEXT 
      MESSAGEBOX(messageText, 0, "Error")
      RETURN TO MASTER 
   ENDPROC 

   PROCEDURE Run
      LOCAL activeProject
      activeProject = this.getActiveProject()
      IF ISNULL(activeProject)
         RETURN 
      ENDIF 
      LOCAL ProcessClassLibraryBaseGrid as ProcessClassLibraryBaseGrid OF ProcessClassLibraryBaseGrid.prg
      ProcessClassLibraryBaseGrid = NEWOBJECT("ProcessClassLibraryBaseGrid", "ProcessClassLibraryBaseGrid.prg")
      IF !ProcessClassLibraryBaseGrid.ProcessClassLibraries(activeProject)
         RETURN
      ENDIF 
      LOCAL ProcessClassLibrarySubclassedGrid as ProcessClassLibrarySubclassedGrid OF ProcessClassLibrarySubclassedGrid.prg
      ProcessClassLibrarySubclassedGrid = NEWOBJECT("ProcessClassLibrarySubclassedGrid", "ProcessClassLibrarySubclassedGrid.prg")
      IF !EMPTY(ProcessClassLibraryBaseGrid.classesToCheckMethods)
         ACOPY(ProcessClassLibraryBaseGrid.classesToCheckMethods, ProcessClassLibrarySubclassedGrid.classesToCheckMethods)
         IF !ProcessClassLibrarySubclassedGrid.ProcessClassLibraries(activeProject)
            RETURN 
         ENDIF 
      ENDIF 
      LOCAL ProcessFormsBaseClass as ProcessFormsBaseClass OF ProcessFormsBaseClass.prg
      ProcessFormsBaseClass = NEWOBJECT("ProcessFormsBaseClass", "ProcessFormsBaseClass.prg")
      IF !ProcessFormsBaseClass.ProcessForms(activeProject)
         RETURN 
      ENDIF 
      LOCAL ProcessFormsSubclassedGrid as ProcessFormsSubclassedGrid OF ProcessFormsSubclassedGrid.prg
      ProcessFormsSubclassedGrid = NEWOBJECT("ProcessFormsSubclassedGrid", "ProcessFormsSubclassedGrid.prg")
      IF !EMPTY(ProcessClassLibraryBaseGrid.classesToCheckMethods)
         ACOPY(ProcessClassLibraryBaseGrid.classesToCheckMethods, ProcessFormsSubclassedGrid.classesToCheckMethods)
         IF !ProcessFormsSubclassedGrid.ProcessForms(activeProject)
            RETURN 
         ENDIF 
      ENDIF 
   ENDPROC 
   
   FUNCTION GetActiveProject
      IF TYPE("_vfp.activeproject") == "O" AND TYPE("_vfp.ActiveProject.BaseClass") = "C"
         RETURN _vfp.ActiveProject 
      ENDIF 
      RETURN NULL
   ENDFUNC 
   


ENDDEFINE 
