FileAppend, %1%`n, %A_Temp%\make_booklet.txt
Random, r, 1, 1000
Sleep, r
Run, %A_ScriptDir%\bookletMacro-v0.3.1.exe