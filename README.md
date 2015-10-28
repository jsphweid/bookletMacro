# bookletMacros Overview
This repository contains both the Windows and Mac files. FYI. 

#### What is it?
Basically, I wrote a wrapper for Michael Schierl's jPDFTweak that makes booklet printing simple. The exact use in an example: You have 20 music parts in 9 x 12 (or whatever page size)... say for an orchestra. Without a large-format printer that ALSO auto-duplexes, this is difficult and tricky. This makes it simple, however. 

#### How it works in a nutshell.
Both osx and windows versions work in almost the same way. Using jPDFTweak, it takes your files and makes booklets for each PDF. To make printing on a basic printer simple, it breaks apart each booklet into even and odd pages. Then it combines all of the evens into one file and all of the odds into another. Then you print one file, put those pages back into the printer (depends on your printer, but the program helps you) and print the other file on the other side. Fold and staple and you're done.

# Mac OS X Installation
###
1. Download the .zip from this Github page and extract to WHEREVER
2.  I'm trying to simplify this... but currently, you need to create 2 basic services and add them as contexual menu items in the finder. I'll walk you through this basic process.
  1. In the .zip you downloaded, open copyFilePath.applescript in a text editor, select all (⌘ + a), and copy that (⌘ + c).
  2. Use the launch bar (⌘ + spacebar) and open "Automater" and create a new "Service"
  3. From Library on the left, select "Utilities", double-click "Run AppleScript"
  4. Delete what is there and paste in what I told ya to copy (⌘ + v)
  5. Where it says "Service receives selected", choose "files or folders", in "Finder"
  6. Save it with whatever text you want to be on your context menu (which is what comes up when you write click something) (mine are "Copy File Path" and "Copy Multiple File Paths")
  7. Repeat a - f for file "copyMultipleFilePaths.applescript"
3. Whew. Hard part over...

# Mac OS X Usage
####
1. Now select the PDFs you want to print in booklets, right click on them (double tap, whatever), and select either "Copy File Path" or "Copy Multiple File Paths" (whichever is relevant, obviously). The paths to those files are stored in the clipboard.
2. Go to WHEREVER you unzipped this repo and run "makeBookletsForMac-v0.2.0.app"
3. The product will appear in the directory that your original pdfs were...

# It messed up...
#### Just try it again and it should work.
The resulting booklet size is determined by the first PDF that it processes... meaning they all have to be the same size. I.E. Don't select some 8.5 x 11's and 9 x 12's at the same time and run the macro. This would be a bad idea...
Something else happened? Make an issue on github or contact me some other way.

You'll use these to select your PDFs in finder and then run the AppleScripts that use jPDFTweak
