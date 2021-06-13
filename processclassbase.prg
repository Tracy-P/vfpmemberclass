DEFINE CLASS ProcessClassBase as Custom 
   baseGridClass = "basegrid"
   baseGridClassLibrary = "baselibrary"
   baseColumnClass = "basecolumn"
   baseHeaderClass = "baseheader"
   DIMENSION classesToCheckMethods[1,2] = ""

   FUNCTION ProcessClassLibraries
      LPARAMETERS activeProject as VisualFoxpro.IFoxProject
      LOCAL ii
      FOR ii = 1 TO activeProject.Files.Count
         IF activeProject.Files.Item(ii).Type = "V"
            this.processClassLibrary(activeProject.Files.Item(ii))
         ENDIF 
      NEXT 
   ENDFUNC 
   
   FUNCTION UpdateGridProperties
      LOCAL lineCount, lineArray[1], output, ii, hasChange
      output = ""
      lineCount = ALINES("lineArray", csrLibrary.Properties)
      hasChange = .F.
      FOR ii = 1 TO lineCount
         IF lineArray[ii] = "Column" AND (not lineArray[ii] = this.baseColumnClass) AND (not lineArray[ii] = "ColumnCount")
            output = output + STRTRAN(lineArray[ii], "Column", this.baseColumnClass, -1, 1, 1)
            hasChange = .T.
         ELSE
            output = output + lineArray[ii]
         ENDIF 
         output = output + CHR(13) + CHR(10)
      NEXT 
      IF hasChange
         replace properties WITH output NEXT 1 IN csrLibrary
      ENDIF 
      RETURN hasChange
   ENDFUNC 
   
   FUNCTION UpdateGridMember
      LPARAMETERS controlParent
      LOCAL newClass, newParent, hasChange
      newClass = csrLibrary.Class
      hasChange = .F.
      IF csrLibrary.Class = "header"
         newClass = this.baseHeaderClass
         hasChange = .T.
      ENDIF 
      newParent = ALLTRIM(csrLibrary.Parent)
      IF LOWER(SUBSTR(csrLibrary.Parent, LEN(controlParent)+1, LEN("column"))) == "column"
         newParent = STUFF(csrLibrary.Parent, LEN(controlParent)+1, LEN("column"), this.baseColumnClass)
         hasChange = .T.
      ENDIF 
      IF hasChange
         replace class WITH newClass, parent WITH newParent IN csrLibrary NEXT 1
      ENDIF 
      RETURN hasChange
   ENDFUNC 
   
   FUNCTION UpdateSubclassMethods
      LPARAMETERS controlName
      LOCAL lineCount, lineArray[1], output, ii, hasChange
      output = ""
      lineCount = ALINES("lineArray", csrLibrary.Methods)
      hasChange = .F.
      FOR ii = 1 TO lineCount
         IF lineArray[ii] = ("PROCEDURE " + controlName) AND ".column" $ LOWER(lineArray[ii])
            output = output + STRTRAN(STRTRAN(lineArray[ii], ".Column", "."+this.baseColumnClass,-1,-1,1), ".Header", "."+this.baseHeaderClass,-1,-1,1) + CHR(13) + CHR(10)
            hasChange = .T.
         ELSE 
            output = output + lineArray[ii] + CHR(13) + CHR(10)
         ENDIF 
      NEXT 
      IF hasChange
         REPLACE methods WITH output NEXT 1 IN csrLibrary
      ENDIF 
      RETURN hasChange
   ENDFUNC 
ENDDEFINE 