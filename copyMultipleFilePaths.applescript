-- from here: http://www.mactips.info/2010/11/how-to-easily-copy-the-path-of-a-file

set the_items to {}
tell application "Finder" to set selected_items to the selection as alias list
repeat with i from 1 to count of the selected_items
	copy (POSIX path of (item i of the selected_items)) to the end of the_items
end repeat
set text item delimiters to return
set the clipboard to the_items as text