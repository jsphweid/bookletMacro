changesSaved()
{
	SplashTextOn, 400,80, , The Changes Saved.  Script restarting...
	Sleep, 1500
	SplashTextOff
	Reload
}

Current_Tab()
{
	GuiControlGet,Current_Tab,,TabGroup
	return Current_Tab
}

ultimatum(functionToPerform)
{
	MsgBox,5,Error,Couldn't find the right things.`nPress Retry or Cancel to reload the script
	IfMsgBox Retry
		%functionToPerform%(dummy1,dummy2,dummy3)
	Else
		IfMsgBox Cancel
		{
			Reload
			Sleep 1000 
			MsgBox, Sorry.  Couldn't reload the script.
			return
		}
}

; activate Finale
goToMacro()
{
	Gui, Cancel
}

waitForCursorToGoFromHourGlassToArrow()
{	
	timeOutCounter:=0
	while ((A_cursor != "Wait") && (timeOutCounter < 1000))
	{
		sleep 10
		timeOutCounter++
	}
	while ((A_cursor = "Wait") && (timeOutCounter < 1000))
	{
		sleep 10
		timeOutCounter++
	}
}

waitForCursorToBePointerForABit()
{
	timeOutCounter:=0
	Loop
	{
		if ((A_Cursor ="Arrow") && (timeOutCounter < 200))
			Continue
		Else
			Break
	}
}

; My custom Toggle Checkbox function...
customToggle(classNN, winTitle)
{
	ControlGet, isOrIsntChecked, Checked,, %classNN%, %winTitle%
	if (isOrIsntChecked = 0){
		Control Check,, %classNN%
	} else {
		Control Uncheck,, %classNN%
	}
}

; My custom Check / Uncheck function...
easyCheck(buttonsNumbersToCheck, winTitle)
{
	Loop, 3
	{
		for k, v in buttonsNumbersToCheck
		{
			Control, Check,, Button%v%, %winTitle%
		}
		if ErrorLevel
			{
				if a_index = 3
					ultimatum(A_ThisFunc)
				sleep 333
				Continue
			}
			Else
				Break
		break
	}
}

easyUncheck(buttonsNumbersToUncheck, winTitle)
{
	Loop, 3
	{
		for k, v in buttonsNumbersToUncheck
		{
			Control, Uncheck,, Button%v%, %winTitle%
		}
		if ErrorLevel
			{
				if a_index = 3
					ultimatum(A_ThisFunc)
				sleep 333
				Continue
			}
			Else
				Break
		break
	}	
}


easyReplaceText(editNumber, replacementText, winTitle)
{
	loop,3
	{
		loop, % editNumber.MaxIndex()
		{
			gg := % editNumber[a_index]
			ControlSetText, Edit%gg%, % replacementText[a_index], %winTitle%
			; MsgBox, Edit%editNumber%
		}
		if ErrorLevel
			{
				if a_index = 3
					ultimatum(A_ThisFunc)
				sleep 333
				Continue
			}
			Else
				Break
		break
	}
}

easyChoose(comboBoxNumber, whichOption, winTitle)
{
	loop, % comboBoxNumber.MaxIndex()
	{
		gg := % comboBoxNumber[a_index]
		Control, Choose,% whichOption[a_index],ComboBox%gg%, %winTitle%
	}
}

; --------------------------------- NOT MY CODE ---------------------------------
/*
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.
	
	
	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder
	
	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return
	
	Joshua A. Kinnison
	2011-04-27, 16:12
*/

Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}
Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}

Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd="",selection=false)
{

	if !(window := Explorer_GetWindow(hwnd))
	{
		MsgBox, I wish I could fix this common `nerror but it is too mysterious. `n`nRe-select file(s) and try again.
		Exit
		; return ErrorLevel := "ERROR"
	}
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}
; --------------------------------- ----------- ---------------------------------

RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /Q /K echo off")
    exec.StdIn.WriteLine(commands "`nexit")  ; Always exit at the end!
    return exec.StdOut.ReadAll()
}