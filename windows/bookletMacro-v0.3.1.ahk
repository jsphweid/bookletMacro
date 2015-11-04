#SingleInstance, Ignore
SetTitleMatchMode 2 
Sleep, 300 ; wait for slave files to write

; has a problem with other instances because it is ran from context menus..
killOtherCopies()

FileRead, collection, %A_Temp%\make_booklet.txt ; retrieve selected files 
FileDelete, %A_Temp%\make_booklet.txt ; delete files

StringSplit, tempArr ,collection,`n ; switch to array
Global initialArray := Object()
Loop, %tempArr0% {
	if (StrLen(tempArr%a_index%) > 2) { ; it has something in it...
		StringReplace, minusLineFeeds,tempArr%a_index%,`r,, All ; remove line feeds...
		StringReplace, minusLineFeeds, minusLineFeeds,`n,, All
		initialArray.Push(minusLineFeeds)
	}
}

Global tempFilesDirectory

Gui, Add, Radio, vRadioButtonVariable w200 h25, Face up to face up
Gui, Add, Radio,  w200 h25, Face down to face down
Gui, Add, Radio, Checked w200 h25, Face up to face down
Gui, add, Button, gMakeBooklets w150, Make it So!
Gui, Show
return

MakeBooklets:
Gui, Submit
If (RadioButtonVariable = 1) {
	whichOrientation = 1
}
If (RadioButtonVariable = 2) {
	whichOrientation = 2
}
If (RadioButtonVariable = 3) {
	whichOrientation = 3
}

makeBooklets(whichOrientation)



ExitApp
Return


makeBooklets(whichOrientation) {
	FormatTime, TimeString,R,_yyyy-MM-dd_HHmmss
	newDirString = byproductPDFs%TimeString%
	tempFilesDirectory = %A_WorkingDir%\%newDirString%
	FileCreateDir, %tempFilesDirectory%

	calcDims = true

	; make booklets but with bad dimensions
	halfBakedBooklets := Object()
	calcDims = true
	For index, currentFileName in initialArray {
		; do this first time only
		if (calcDims) {
			sizeString := getPageSizeString(currentFileName)
			w := extractW(sizeString)
			h := extractH(sizeString)
			wInch := w / 72
			hInch := h / 72
			wMod := w * 2
			wInchMod := wInch * 2
			calcDims := !calcDims
			MsgBox, Now making booklets FROM:`n`n%w% x %h% (Postscripts Points)`n%wInch% x %hInch% (inches) `n`n TO:`n`n%wMod% x %h% (Postscripts Points)`n%wInchMod% x %hInch% (inches)
		}

		; do this every time
		halfBakedBooklets.Push(makeBooklet(currentFileName, tempFilesDirectory))
		createdFiles = %createdFiles%`n%recent%
	}

	; fix dimensions
	fullBakedBooklets := Object()
	For halfBakedIndex, halfBakedValue in halfBakedBooklets {
		While ! FileExist(halfBakedValue)
			Sleep, 50
		fullBakedBooklets.Push(scaleToCorrectSize(halfBakedValue, w, h, tempFilesDirectory))
	}

	; separate even and odds
	evens := Object()
	odds := Object()
	for fullBakedIndex, fullBakedValue in fullBakedBooklets {
		While ! FileExist(fullBakedValue)
			Sleep, 50
		evens.Push(separateEven(fullBakedValue, tempFilesDirectory))
		odds.Push(separateOdd(fullBakedValue, tempFilesDirectory))
	}

	; merge evens and odds
	;
	; assign final strings from option
	if (whichOrientation = 1) { ; up up
		evenFileName := "2-even-mergedPDFs.pdf"
		oddFileName := "1-odd-mergedPDFs.pdf"
	}
	if (whichOrientation = 2) { ; down down
		evenFileName := "1-even-mergedPDFs.pdf"
		oddFileName := "2-odd-mergedPDFs.pdf"		
	}
	if (whichOrientation = 3) { ; up down
		evenFileName := "2-evenAndReversed-mergedPDFs.pdf"
		oddFileName := "1-odd-mergedPDFs.pdf"
	}
	; create evens string
	for evensIndex, evensValue in evens {
		While ! FileExist(evensValue)
			Sleep, 50
		evensCmdline .= " -i """ evensValue """"
	}
	evensCmdline := SubStr(evensCmdline, 2)
	; evens normal - merge
	if ((whichOrientation = 1) OR (whichOrientation = 2)) {
		run %A_ScriptDir%\jPDF\jpdftweak.jar %evensCmdline% -o "%A_WorkingDir%/%evenFileName%"
	}
	; evens - merge and reverse
	if (whichOrientation = 3) {
		unreversed = %tempFilesDirectory%\____evenUnreversed.pdf
		run %A_ScriptDir%\jPDF\jpdftweak.jar %evensCmdline% -o "%unreversed%"
		While ! FileExist(unreversed)
			Sleep, 50
		run %A_ScriptDir%\jPDF\jpdftweak.jar -i "%unreversed%" -shuffle 1:!-1N1+0`%+0`%  -o "%A_WorkingDir%\%evenFileName%"
	}
	; create odds string
	for oddsIndex, oddsValue in odds {
		While ! FileExist(oddsValue)
			Sleep, 50
		oddsCmdline .= " -i """ oddsValue """"

	}
	oddsCmdline := SubStr(oddsCmdline, 2)
	; odds merge, same for all of them
	run %A_ScriptDir%\jPDF\jpdftweak.jar %oddsCmdline% -o "%A_WorkingDir%\%oddFileName%"

	; force Close
	ExitApp
}

; tempFilesDirectory vs. A_WorkingDir

makeBooklet(currentFileName, tempFileDir) {
	SplitPath, currentFileName,fileName,fileDir
	Str = %tempFileDir%\_%fileName%
	run %A_ScriptDir%\jPDF\jpdftweak.jar -i "%currentFileName%" -scale 1684`,1191`,r  -shuffle -4:!-4L0.707+0`%-100`%`,+1L.707+0`%-200`%`,!+2L0.707+0`%-100`%`,-3L.707+0`%-200`% -rotate R -o "%Str%"
	return Str ;returns correctly
}

scaleToCorrectSize(currentFileName, width, height, tempFileDir) {
	adjustedWidth := width * 2
	SplitPath, currentFileName,fileName,fileDir
	Str = %tempFileDir%\_%fileName%
	run %A_ScriptDir%\jPDF\jpdftweak.jar -i "%currentFileName%" -scale %adjustedWidth%`,%height%`,r -o "%Str%"
	return Str
}

getPageSizeString(fileName) {
	infoFile := tempFilesDirectory . "\info.txt"
	answer = RunWaitOne(%A_ScriptDir%\jPDF\jpdftweak.jar -i "%fileName%" -moreinfo "%infoFile%")
	run %A_ScriptDir%\jPDF\jpdftweak.jar -i "%fileName%" -moreinfo "%infoFile%"
	keepChecking = true
	While ! FileExist(infoFile)
		Sleep 100
	while (keepChecking) {
		FileGetSize, size, %infoFile%
		Sleep, 100
		if (size != 0) {
			keepChecking := !keepChecking
		}
	}
	FileRead, answer, %infoFile%
	StringSplit, result, answer, %A_Space%
	return result%result0% ; get's last "word" in Text
}

extractW(string) {
	StringSplit, thisArray, string, "x";, %A_Space%%A_Tab%`n
	wString = %thisArray1%
	wNum := ("0" . wString) , wNum += 0
	Return wNum
}

extractH(string) {
	StringSplit, thisArray, string, "x";, %A_Space%%A_Tab%`n
	hString = %thisArray2%
	StringReplace,hString,hString,`n,,A ; kick out the `n or return
	StringReplace,hString,hString,`r,,A
	hNum := ("0" . hString) , hNum += 0
	return hNum
}

separateEven(currentFileName, tempFileDir) {
	SplitPath, currentFileName,fileName,fileDir
	Str = %tempFileDir%\even%fileName%
	run %A_ScriptDir%\jPDF\jpdftweak.jar -ie "%currentFileName%" -o "%Str%"
	return Str
}

separateOdd(currentFileName, tempFileDir) {
	SplitPath, currentFileName,fileName,fileDir
	Str = %tempFileDir%\odd%fileName%
	run %A_ScriptDir%\jPDF\jpdftweak.jar -io "%currentFileName%" -o "%Str%"
	return Str
}

killOtherCopies() {
  	nkilled := 0
  	if (!A_IsCompiled)
  		return
  	PID := DllCall("GetCurrentProcessId")
  	for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
    	if (proc.Name = A_ScriptName) && (proc.ProcessID != PID) {
      		PPID := proc.ProcessID
      		; MsgBox, 4160, , Killing %PPID%, 2
      		Process,close,%PPID%
      		nkilled += 1
    	}
  	return nkilled
}

RunWaitOne(command) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /C " command)
    return exec.StdOut.ReadAll()
}

GuiClose:
ExitApp