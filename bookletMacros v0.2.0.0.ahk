;MACRO interface for making booklets

IfNotExist, settings.ini
    gosub, createSettingsINIFile

IniRead, evenOdd, settings.ini, order, evenOdd
IniRead, oddEven, settings.ini, order, oddEven
IniRead, oddEvenReversed, settings.ini, order, oddEvenReversed
; IniRead, clickSpeed, settings.ini,speed,clickSpeed
global evenOdd
global oddEven
global oddEvenReversed
; global clickSpeed


; Makes sure that CAPS doesn't get stuck on
SetCapsLockState, AlwaysOff

; This creates the menus/tabs that each contain 15 buttons.
Gui, Add, Tab2,x-4 y-3 w520 h330 vTabGroup  AltSubmit, Menu 1|Settings

; includes my customized macros for AHK... Things that let me write code better (better check/uncheck checkboxes)
#Include, ahkCustomMacros.ahk
#Include, bookletMacrosFunctions.ahk


global fileNameLayout:="booklet_%N"
global fileNameLayoutjPDFodd:="odd_<FX>"
global fileNameLayoutjPDFeven:="even_<FX>"
global treeNaming:=1

; 1. even 2. odd (face down to face down)
; 1. odd 2. even (face up to face up)
; 1. odd 2. even (reversed) (face up to face down)

; This part creates each button for each menu/tab.

global defaultTextButtonSize:="w100 h90"
global defaultPictureButtonSize:=""


Gui, Tab, 1
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, 1. make booklet
Gui, Add, Button, x106 y37 %defaultTextButtonSize% gButton102, 2. separate even and odd
Gui, Add, Button, x206 y37 %defaultTextButtonSize% gButton103 , 3. merge
; Gui, Add, Button, x306 y37 %defaultTextButtonSize% gButton104 , 
; Gui, Add, Button, x406 y37 %defaultTextButtonSize% gButton105 , 
; Gui, Add, Button, x6 y127 %defaultTextButtonSize% gButton106 , 1. m
; Gui, Add, Button, x106 y127 %defaultTextButtonSize% gButton107 , 2. shape booklet for 12x18
; Gui, Add, Button, x206 y127 %defaultTextButtonSize% gButton108 , oooooooo
; Gui, Add, Button, x306 y127 %defaultTextButtonSize% gButton109 , oooooooo
; Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton110 , oooooooo
; Gui, Add, Button, x6 y217 %defaultTextButtonSize% gButton111 , oooooooo
; Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton112 , 2. shape booklet for custom size
; Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton113 , oooooooo
; Gui, Add, Button, x306 y217 %defaultTextButtonSize% gButton114 , oooooooo
; Gui, Add, Button, x406 y217 %defaultTextButtonSize% gButton115 , oooooooo


; ;------------------------SETTINGS------------------------

Gui, Tab, 10
Gui, Add, GroupBox, r4 w300 0, How does the paper come out of your printer?

Gui, Add, Radio, vevenOdd checked%evenOdd% x20 yp+20 r1, face down to face down  (1. even, 2. odd)
Gui, Add, Radio, voddEven checked%oddEven% yp+20 r1, face up to face up (1. odd, 2. even)
Gui, Add, Radio, voddEvenReversed checked%oddEvenReversed% yp+20 r1, face up to face down (1. odd, 2. even-reversed)

; Gui, Add, Text, x16 y140, How fast should should the mouse go?
; Gui, Add, Text, x16 y170, Fast
; Gui, Add, Text, x180 y170, Slow
; Gui, Add, Slider, vclickSpeed Range0-15 x48 y170, %clickSpeed%

Gui, Add, Button, x55 y280 gSave, Save
Gui, Add, Button, x400 y280 gRestoreDefaults, Restore Defaults
GuiControl, Choose, TabGroup, 1


;not sure why it is necessary to put something here...
#If (WinActive("Finale"))
F5::!NumpadSub
F6::!NumpadAdd
#If

Save:
	Gui, Submit, NoHide
	IniWrite, %evenOdd%, settings.ini, order, evenOdd
	IniWrite, %oddEven%, settings.ini, order, oddEven
	IniWrite, %oddEvenReversed%, settings.ini, order, oddEvenReversed
	IniWrite, %clickSpeed%, settings.ini, speed, clickSpeed
	changesSaved()
Return


RestoreDefaults:
	gosub, createSettingsINIFile
	changesSaved()
Return
;------------------------/////////------------------------


; These are instructions for what to do when each hotkey is pressed.
Button101:
	goToMacro()
	makeBooklets()
return

Button102:
    goToMacro()
    separateEvenOdd()
return

Button103:
	goToMacro()
	mergeSelectedFiles()
return

Button104:
	goToMacro()
	; print("11x17")
return

Button105:
    goToMacro()
    ; print("12x18")
return

Button106:
	goToMacro()
	
return

Button107:
	goToMacro()
	
return

Button108:
    goToMacro()
	
return

Button109:
	goToMacro()
	
return

Button110:
	goToMacro()
	
return

Button111:
    goToMacro()
    
return

Button112:
	goToMacro()
	
return

Button113:
	goToMacro()
	
return

Button114:
    goToMacro()
	
return

Button115:
	goToMacro()
	
return




#if (!WinActive("Finale") and !WinActive("Finale Hotkey Interface")) ;---------------------------------------
	; This part assigns the key that makes the interface appear and disappear.
	CapsLock::
	IfWinExist, Booklet Macros
	{
		Gui, Cancel
		Return
	}
	Else
	{
		Gui, Show, x326 y205 h315 w514, Booklet Macros

		Return
	}
	Return
#If ;-------------------------------------------------------------------


; #if (WinExist("MMR Width") and WinActive("Finale")) ;------------------
; 	e::
; 	changeMMRWidth(10)
; 	Return
; 	d::
; 	changeMMRWidth(-10)
; 	Return
; 	+e::
; 	changeMMRWidth(2)
; 	Return
; 	+d::
; 	changeMMRWidth(-2)
; 	Return
; 	CapsLock::
; 	WinClose, MMR Width
; 	Return
; #If ;-------------------------------------------------------------------




; If the interface isn't the active window, none of the keys on the grid will affect anything.
GuiControlGet,Current_Tab,,TabGroup
#if (WinActive("Booklet Macros") && (Current_Tab() != 10)) ;-------------------------------
	{
	; This assigns hotkeys 1-9 to the menus/tabs.
	1::GuiControl, Choose, TabGroup, 1
	; 2::GuiControl, Choose, TabGroup, 2
	; 3::GuiControl, Choose, TabGroup, 3
	; 4::GuiControl, Choose, TabGroup, 4
	; 5::GuiControl, Choose, TabGroup, 5
	; 6::GuiControl, Choose, TabGroup, 6
	; 7::GuiControl, Choose, TabGroup, 7
	; 8::GuiControl, Choose, TabGroup, 8
	; 9::GuiControl, Choose, TabGroup, 9
	; 0::GUIControl, Choose, TabGroup, 10

	; This dynamically changes the button label based on which tab is open.  Basically, it makes
	; it possible to use any given hotkey on the grid MULTIPLE TIMES depending on which menu/tab
	; is selected.

	q::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%01
	return
	w::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%02
	return
	e::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%03
	return
	r::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%04
	return
	t::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%05
	return
	a::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%06
	return
	s::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%07
	return
	d::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%08
	return
	f::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%09
	return
	g::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%10
	return
	z::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%11
	return
	x::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%12
	return
	c::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%13
	return
	v::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%14
	return
	b::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%15
	return


}
#If ;-------------------------------------------------------------------



GuiClose:
ExitApp

createSettingsINIFile:
#Include, defaultSettings.ahk