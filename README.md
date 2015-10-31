# bookletMacro
- [Overview](#overview)
      - [What is it?](#what-is-it)
      - [How it works in a nutshell.](#how-it-works-in-a-nutshell)
- [Mac OS X Installation](#mac-os-x-installation)
- [Mac OS X Usage](#mac-os-x-usage)
- [Windows Installation](#windows-installation)
- [Windows Usage](#windows-usage)
- [It messed up...](#it-messed-up)
      - [Just try it again and it should work.](#just-try-it-again-and-it-should-work)
- [Uninstall](#Uninstall)


# Overview
This repository contains both the Windows and Mac files. FYI. And it requires Java 5 or higher. 

#### What is it?
Basically, I wrote a wrapper for Michael Schierl's jPDFTweak that makes booklet printing simple. The exact use in an example: You have 20 music parts in 9 x 12 (or whatever page size)... say for an orchestra. Without a large-format printer that ALSO auto-duplexes, this is difficult and tricky. This makes it simple, however. 

#### How it works in a nutshell.
Both osx and windows versions work in almost the same way. Using jPDFTweak, it takes your files and makes booklets for each PDF. To make printing on a basic printer simple, it breaks apart each booklet into even and odd pages. Then it combines all of the evens into one file and all of the odds into another. Then you print one file, put those pages back into the printer (depends on your printer, but the program helps you) and print the other file on the other side. Fold and staple and you're done.

# Mac OS X Installation
####
[updated 2015-10-30]  
Install is dead simple. Run the command below in the terminal. Give it a second to download. It will ask you to install a service. Click Okay a time or two. DONE.

`curl -s https://raw.githubusercontent.com/jsphweid/bookletMacro/master/mac-osx/install | bash`

Alright, so you don't know what a "terminal" is? I'll spell it out.  
1. Copy the above code (highlight and hit ⌘ + c)  
2. Hit ⌘ + SPACE for spotlight search and type "terminal"  
3. Paste (⌘ + v) and hit enter.

# Mac OS X Usage
####
[updated 2015-10-30]  
Now that the script should be registered as a Service, whenever you right-click (okay... two-finger tap) a file or group of PDFs (and only PDFs...), at the bottom you should see "Booklet Macro." Click it and wait for your two files to appear. (Should take some seconds, unless you gave it a lot to do, then maybe a minute).

# Windows Installation
####
1. Download and extract .zip to WHEREVER

# Windows Usage
####
1. If you don't autohotkey installed, just run bookletMacros v0.2.0.exe. The script is now running.
2. Hit CAPS, which brings up the GUI (hitting CAPS again will hide it). Go to the "Settings" tab, select the correct setting for your printer (you may have to experiment) and click "Save"
3. Select the files you want to use it on and push CAPS. Click "1. make booklet"
4. This will make new files in that folder with a "__" at the beginning of the file name. Select all of those, push CAPS, now click "2. separate even and odd"
5. This will create more new files with "__even" and "__odd" added on. Now select all the "__even", hit CAPS, click "3. merge" and do the same for the "__odd".
6. This will create your final product at the top of all of those files called "___1-odd.pdf" and "___2-even (and reversed" or something slightly different, depending on your settings in step 2.


# It messed up...
#### Just try it again and it should work.
The resulting booklet size is determined by the first PDF that it processes... meaning they all have to be the same size. I.E. Don't select some 8.5 x 11's and 9 x 12's at the same time and run the macro. This would be a bad idea...
Something else happened? Make an issue on github or contact me some other way.

You'll use these to select your PDFs in finder and then run the AppleScripts that use jPDFTweak

# Uninstall
#### 

For Mac OSX, just run this command in the terminal like you did to install it. It will remove the service and associated folders automatically. 
`curl -s https://raw.githubusercontent.com/jsphweid/bookletMacro/master/mac-osx/uninstall | bash`
