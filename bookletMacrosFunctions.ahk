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

;-------------actual macros--------------

makeBooklets() {
	sel := Explorer_GetSelected() ; get selected files and put them into a string
	StringSplit, arrayOfFileNamesToProcess,sel,`n ; switch to array

	; createdFiles := "" ; empty array of all made files (to process soon)
	calcDims = true
	i  := 0
	; make booklets but with bad dimensions
	Loop, %arrayOfFileNamesToProcess0%
	{
		i := i + 1
		currentFileName := arrayOfFileNamesToProcess%a_index%

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
		recent := makeBooklet(currentFileName)
		createdFiles = %createdFiles%`n%recent%
	}

	MsgBox, %i%

	While ! FileExist(recent)
		Sleep, 20

	StringSplit, arrayOfFilesToReProcess,createdFiles,`n ; switch to array
	Loop, %arrayOfFilesToReProcess0%
	{
		currentFileName := arrayOfFilesToReProcess%a_index%
		recentTwo := scaleToCorrectSize(currentFileName, w, h)
	}

	; delete intermediary files after new ones are made...
	While ! FileExist(recentTwo)
		Sleep, 20
	Sleep, 200
	Loop, %arrayOfFilesToReProcess0%
	{
		currentFileName := arrayOfFilesToReProcess%a_index%
		FileDelete, %currentFileName%
	}
}

makeBooklet(currentFileName) {
	SplitPath, currentFileName,fileName,fileDir
	Str = %fileDir%\_%fileName%
	run jPDF\jpdftweak.jar -i "%currentFileName%" -scale 1684`,1191`,r  -shuffle -4:!-4L0.707+0`%-100`%`,+1L.707+0`%-200`%`,!+2L0.707+0`%-100`%`,-3L.707+0`%-200`% -rotate R -o "%Str%"
	return Str
}

scaleToCorrectSize(currentFileName, width, height) {
	adjustedWidth := width * 2
	SplitPath, currentFileName,fileName,fileDir
	Str = %fileDir%\_%fileName%
	run jPDF\jpdftweak.jar -i "%currentFileName%" -scale %adjustedWidth%`,%height%`,r -o "%Str%"
	return Str
}

getPageSizeString(fileName) {
	sel := Explorer_GetSelected()
	StringSplit, arrayOfFileNamesToProcess,sel,`n	

	answer := RunWaitMany("
	(
		cd jPDF\
		jpdftweak -i """ fileName """ -moreinfo -
	)")

	StringSplit, Text, answer, %A_Space%
	return Text%Text0% ; get's last "word" in Text
}

makeIT(currentFileName) {
	SplitPath, currentFileName,fileName,fileDir
	run jPDF\jpdftweak.jar -i "%currentFileName%" -scale 1296`,864`,r -o "%fileDir%\donedone.pdf"
	; run jPDF\jpdftweak.jar -i "%fileDir%\donedone.pdf" -rotate R -o "%fileDir%\donedonezz.pdf"
}

;------------------------------
separateEvenOdd() {
	sel := Explorer_GetSelected()
	if ErrorLevel
		separateEvenOdd()
	StringSplit, arrayOfFileNamesToProcess,sel,`n
	Loop, %arrayOfFileNamesToProcess0%
	{
		currentFileName:=arrayOfFileNamesToProcess%a_index%
		separateEach(currentFileName)
	}
}

separateEach(currentFileName) {
	SplitPath, currentFileName,fileName,fileDir
	run jPDF\jpdftweak.jar -ie "%currentFileName%" -o "%fileDir%\__even_%fileName%"
	run jPDF\jpdftweak.jar -io "%currentFileName%" -o "%fileDir%\__odd_%fileName%"
}
;------------------------------
mergeSelectedFiles() {
	sel := Explorer_GetSelected()
	if ErrorLevel
		mergeSelectedFiles()
	path := Explorer_GetPath()
	Sort sel, d`n
	for each, FileName in StrSplit(sel, "`n")
	{
		cmdline .= " -i """ FileName """"
		SplitPath, FileName,fileNameWithExt,fileDir
	}

	IfInString, sel, even
	{
		if (oddEvenReversed = 1)
			inputedText:="___2-even AND UNREVERSED.pdf"
		else if (oddEven = 1)
			inputedText:="___2-even.pdf"
		else if (evenOdd = 1)
			inputedText:="___1-even.pdf"
	}
	Else IfInString, sel, odd
	{
		if (oddEvenReversed = 1)
			inputedText:="___1-odd.pdf"
		else if (oddEven = 1)
			inputedText:="___1-odd.pdf"
		else if (evenOdd = 1)
			inputedText:="___2-odd.pdf"
	}
	Else
		inputedText:="merged.pdf"
	cmdline := SubStr(cmdline, 2)

	StringSplit, arrayOfFileNamesToProcess,sel,`n
	SplitPath, arrayOfFileNamesToProcess1,,fileDir
	runwait jPDF\jpdftweak.jar %cmdline% -o "%fileDir%\%inputedText%"
	if (inputedText = "merged.pdf")
	{
		fakeColon:=Chr(0xA789)
		FormatTime, TimeString,,yyyy-MM-dd_HH%fakeColon%mm%fakeColon%ss
		finalName:="___" . TimeString . "_merged PDFs.pdf"
		FileMove, %fileDir%\%inputedText%, %fileDir%\%finalName%
	}
	if (inputedText = "___2-even AND UNREVERSED.pdf")
	{
		runwait jPDF\jpdftweak.jar -i "%fileDir%\___2-even AND UNREVERSED.pdf" -shuffle 1:!-1N1+0`%+0`% -o "%fileDir%\___2-even (and reversed).pdf"
		FileDelete, %path%\___2-even AND UNREVERSED.pdf
	}


}


print(size) {
	; Send, {Enter}
	WinWaitActive, Print
	; Control, ChooseString,HP LaserJet 5200 UPD PCL 6, ComboBox1, Print
	Control, Choose, 7, ComboBox1, Print
	Send, !p
	WinWaitNotActive, Print
	IfWinActive, PrimoPDF
	{
		Send, {Esc}
		WinWaitActive, Print
		Send, {Tab}
		Send, !p

	}
	WinWaitActive, HP LaserJet
	control, ChooseString,%size%,ComboBox1,HP LaserJet
	Sleep, 100
	Send, {Enter}
	WinWaitActive, Print
	Send, {Enter}



}
