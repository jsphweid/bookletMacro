# define installer name
OutFile "bookletMacro-v0.3.1.exe"
 
# set desktop as install directory
InstallDir "$PROGRAMFILES\bookletMacro"

# directory already exist
!include LogicLib.nsh
Page Directory "" "" DirLeave
Page InstFiles
Function DirLeave
${If} ${FileExists} "$InstDir\*"
    MessageBox MB_YESNO `"$InstDir" already exists, delete it's content and continue installing?` IDYES yep
    Abort
yep:
    RMDir /r "$InstDir"
${EndIf}
FunctionEnd

Section

	# define output path
	SetOutPath $INSTDIR
	 
	# specify file to go in output path
	File "bookletMacro-v0.3.1.exe" # eventually just put the .exe in there for releases
	File "slaveRunner.exe"
	File /r "jPDF"

	# search and install this registry key that makes the script runable in pdf context menu
	ReadRegStr $0 HKCR .pdf ""
	WriteRegExpandStr HKCR "$0\shell\Run bookletMacro\command" "" "$INSTDIR\slaveRunner %1"
	 
	# define uninstaller name
	WriteUninstaller $INSTDIR\uninstaller.exe
	 
	 

SectionEnd
 

Section "Uninstall"
 
	# Always delete uninstaller first
	Delete $INSTDIR\uninstaller.exe

	# Delete the Registry Key I created
	ReadRegStr $0 HKCR .pdf ""
	DeleteRegKey HKCR "$0\shell\Run bookletMacro"

	# now delete installed file
	Delete $INSTDIR\bookletMacro-v0.3.1.exe
	Delete $INSTDIR\slaveRunner.exe

	RMDir /r $INSTDIR\jPDF
	RMDir $INSTDIR
	 
SectionEnd