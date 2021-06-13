*-- Vista popup menu artifact fix
IF OS(3) = "6"
   DECLARE integer GdiSetBatchLimit IN WIN32API integer
   GdiSetBatchLimit(1)
ENDIF

*-- path for quick utils and builders
LOCAL resourcepath
resourcepath = ADDBS(JUSTPATH(SYS(16)))

_VFP.Caption = _VFP.Caption + " (VFP Version: " + Version(4) + ")"

LoadMenu()

PROCEDURE LoadMenu
	LOCAL toolIsIn 
	toolIsIn = STREXTRACT(SYS(16), PROGRAM(PROGRAM(-1)))
	DEFINE PAD Developer OF _MSysMenu PROMPT "Developer"

	DEFINE POPUP Developer MARGIN RELATIVE 
	DEFINE BAR 1 OF Developer PROMPT "Modify Project"
	DEFINE BAR 3 OF Developer PROMPT "Build and run"
	DEFINE BAR 99 OF Developer PROMPT "\-"
	DEFINE BAR 2 OF Developer PROMPT "Reset Windows"
	DEFINE BAR 5 OF Developer PROMPT "Clear Screen"
	DEFINE BAR 98 OF Developer PROMPT "\-"
	DEFINE BAR 4 OF Developer PROMPT "FoxUnit"
	define bar 97 of Developer Prompt "\-"
	define bar 5 of Developer prompt "Modify ProcessClassBase.prg"
	define bar 6 of Developer prompt "Modify ProcessClassLibraryBaseGrid.prg"
	define bar 7 of Developer prompt "Modify ProcessClassLibrarySubclassedGrid.prg"
	define bar 8 of Developer prompt "Modify ProcessFormsBaseClass.prg"
	define bar 9 of Developer prompt "Modify ProcessFormsSubclassedGrid.prg"
	define bar 10 of Developer prompt "Modify ProcessToUpdateMemberClassOfGrid.prg"

	ON PAD Developer OF _MSysMenu ACTIVATE POPUP Developer
	ON SELECTION POPUP Developer DO ProcessMenuSelection in &toolIsIn.

ENDPROC 

PROCEDURE ProcessMenuSelection
	LOCAL selectedBar, toolIsIn
	
	SET MESSAGE TO 
	selectedBar = BAR()
	toolIsIn = STREXTRACT(SYS(16), PROGRAM(PROGRAM(-1)))
	
	DO CASE 
	CASE selectedBar = 1
		DO ModifyProject IN &toolIsIn.
	CASE selectedBar = 2
		DO ResetWindows IN &toolIsIn.
	CASE selectedBar = 3
		DO BuildAndRun IN &toolIsIn.
	CASE selectedBar = 4
		DO c:\work\tools\foxunit
	CASE selectedBar = 5
		modify command processclassbase.prg nowait
	case selectedBar = 6
		modify command processclasslibrarybasegrid.prg nowait
	case selectedBar = 7 
		modify command processclasslibrarysubclassedgrid.prg nowait
	case selectedBar = 8
		modify command processformsbaseclass.prg nowait
	case selectedBar = 9
		modify command processformssubclassedgrid.prg nowait
	case selectedBar = 10
		modify command processtoupdatememberclassofgrid.prg nowait
	OTHERWISE 
		MESSAGEBOX("Not Implemented", 0, "Developer Menu", 3000)
	ENDCASE
	SET MESSAGE TO  
ENDPROC 

PROCEDURE ClearScreen
	ACTIVATE SCREEN 
	CLEAR 
ENDPROC

PROCEDURE ModifyProject
	MODIFY PROJECT "baselibrarytest.pjx" NOWAIT 
ENDPROC 

PROCEDURE ResetWindows 
   PRIVATE plToolBox, plTipWindow, pcCommandPosition, pnCommandDivisor
   plToolBox = .F.
   plTipWindow = .F.
   pcCommandPosition = [3 Window "Document"]
   pnCommandDivisor = 2

   *-- Make sure the windows are open
   Activate Window "View"
   Activate Window "Properties"
   Activate Window "Command"
   Activate Window "Document"
   
   *-- To get the windows back to proper size
   *-- they need to be undocked
   Dock Window "View"         POSITION -1
   Dock Window "Properties"   POSITION -1
   Dock Window "Command"      POSITION -1
   Dock Window "Document"     POSITION -1

   *-- To make things quick, close the tip and toolbox
   If plTipWindow
      Release _oFoxCodeTips
   Endif
   If plToolBox
      If Type("_oToolBox") = "O" And Not Isnull(_oToolBox)
         _oToolBox.Release()
         Release _oToolBox
      Endif 
   Endif 

   *-- Set the sizes needed for the windows
   *-- The View (Data Session) window doesn't display well lower
   *-- than 52 cols wide.
   *-- Save the current Font settings of _Screen
   lcFontName = _Screen.FontName
   lnFontSize = _Screen.FontSize
   *-- Set them to the top window
   _Screen.FontName = Wfont(1,"Command")
   _Screen.FontSize = Wfont(2,"Command")
   Size Window "Command" To Srows()/pnCommandDivisor, Scols()/5
   *-- Set them to the top window
   _Screen.FontName = Wfont(1,"View")
   _Screen.FontSize = Wfont(2,"View")
   Size Window "View"    To Srows()/1.25, Max(52,Scols()/5)
   *-- Set them to the top window
   _Screen.FontName = Wfont(1,"Document")
   _Screen.FontSize = Wfont(2,"Document")
   Size Window "Document"    To Srows()/1.25, Max(52,Scols()/5)
   *-- Reset the font settings.
   _Screen.FontName = lcFontName
   _Screen.FontSize = lnFontSize

   If plToolBox
      *-- Start the ToolBox
      Do (_ToolBox)
      If Val(Version(4)) = 9
         _oToolBox.Dockable = 1
      Endif 
   Endif 

   If plTipWindow
      *-- Open the Tips window
      Public  _oFoxCodeTips
      _oFoxCodeTips=Newobject("frmtips","foxcode.vcx",Home()+"foxcode.app")
      _oFoxCodeTips.Width = _Screen.Width / 5.125
      _oFoxCodeTips.Show
   Endif 

   *-- Now lets do some docking
   Dock Window "View"         POSITION 2
   Dock Window "Document"     POSITION 3 Window "View"
   LOCAL lcPropPosition, lcDock
   lcPropPosition = [4 Window "View"]
   if Val(Version(4)) = 9
      If plToolBox
         *-- To allow compile in VFP 8
         lcDock = [Dock Name   _oToolBox      POSITION 4 Window "Document"]
         &lcDock
         lcPropPosition = [4 Name   _oToolBox]
      Endif 
   endif
   Dock Window "Properties"   POSITION &lcPropPosition
   Dock Window "Command" POSITION &pcCommandPosition

   if Val(Version(4)) = 9
      If plTipWindow
         *-- To allow compile in VFP 8
         lcDock = [Dock Name   _oFoxCodeTips  POSITION  2 Window "Command"]
         &lcDock
      Endif
   endif 

   If plToolBox And Val(Version(4)) = 9
      *-- Put the Toolbox on top
      Activate Window (_oToolBox.Name)
   Endif 
   *-- Make the Command window the last window active
   Activate Window "Command"
ENDPROC 

PROCEDURE BuildAndRun
	IF TYPE("_vfp.ActiveProject.Name") == "C" AND LOWER(JUSTSTEM(_vfp.ActiveProject.Name)) = "baselibrarytest"
		IF _vfp.ActiveProject.Build(ADDBS(JUSTPATH(_vfp.ActiveProject.Name)) + "bin\baselibrarytest.exe", 3, .F., .T., .F.)
			RunExe()
		ELSE 
			?MESSAGE()
		ENDIF
	ELSE
		?"Project not found to build" 
	ENDIF 
ENDPROC 

PROCEDURE RunExe
   Local oShell As wScript.Shell
   oShell = Createobject("wScript.Shell")
   oShell.CurrentDirectory = ADDBS(JUSTPATH(_vfp.ActiveProject.Name)) + "bin"
   oShell.Exec("baselibrarytest")
   oShell.CurrentDirectory = ADDBS(JUSTPATH(_vfp.ActiveProject.Name))
   Release oShell
ENDPROC 