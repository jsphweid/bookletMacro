# bookletMacro
- [Recent Updates and Fixes](#recent-updates-and-fixes)
- [Overview](#overview)
      - [What is it?](#what-is-it)
      - [How it works in a nutshell.](#how-it-works-in-a-nutshell)
      - [Disclaimer](#disclaimer)
- [Mac OS X Installation](#mac-os-x-installation)
- [Mac OS X Usage](#mac-os-x-usage)
- [Windows Installation](#windows-installation)
- [Windows Usage](#windows-usage)
- [It messed up...](#it-messed-up)
- [Uninstall](#uninstall)
- [Building the Project from source](#building-the-project-from-source)

# Recent Updates and Fixes

v0.3.2 (mac)— released 2015-11-11
- Fixed a small bug in the mac version that would crash the program if you had spaces in any of your folder names…

v0.3.1 (win)-- released 2015-10-31 --
- Update for Win version to make it just like the mac, which is (even easier) to install and easy to run. All driven through the right-click context menu.

v0.3.1 (mac)-- released 2015-10-30 --
- Update for Mac version to make it dead simple to install using curl / terminal. Also, the process has changed to be even simpler. Simply select the pdfs, right click, click "Booklet Macro." DONE.


# Overview
This repository contains both the Windows and Mac files. FYI. And it requires Java 5 or higher. 
[DEMO video here] (https://www.youtube.com/watch?v=Jiq5TR0RN-A)

#### What is it?
Basically, I wrote a wrapper for Michael Schierl's jPDFTweak that makes booklet printing simple. The exact use in an example: You have 20 music parts in 9 x 12 (or whatever page size)... say for an orchestra. Without a large-format printer that ALSO auto-duplexes, this is difficult and tricky. This makes it simple, however. 

#### How it works in a nutshell.
Both osx and windows versions work in almost the same way. Using jPDFTweak, it takes your files and makes booklets for each PDF. To make printing on a basic printer simple, it breaks apart each booklet into even and odd pages. Then it combines all of the evens into one file and all of the odds into another. Then you print one file, put those pages back into the printer (depends on your printer, but the program helps you) and print the other file on the other side. Fold and staple and you're done.

The intermediary PDFs that are created in the process are stored in the "byproductPDFs%DATETIME% folder that you'll see as soon as the macro is run. Plain unseparated booklet files are also stored in this folder. You might find some of these useful for reference. Or you can simply delete it later.

The PDFs that you want will appear in the original folder you ran the macro in (never in the byproduct folder). They will be titled something like "1-odd-mergedPDFs.pdf" and "2-evenAndReversed-mergedPDFs.pdf" (depending on your printer type). Always print 1 first and 2 second, regardless of how the rest of the files are named.

#### Disclaimer.
This is open source. It ain't perfect. It works well most of the time. Having said that, occasionally I see a weird result.  I do not take responsibility for any problems you have because the macros didn't work and you're at the session with strange things on the page. When you make the PDFs, give them a once over to make sure everything looks good. If it doesn't, just delete the garbage files and run it again. If you don't give yourself those seconds and that hawk eye, you're liable to introduce mistakes in any step along the way. So check 'em first.

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
Now that the script should be registered as a Service, whenever you right-click (okay... two-finger tap) a file or group of PDFs (and only PDFs...), at the bottom you should see "Booklet Macro" (if you have a lot of context menu items, it might be under "Services") Click it and wait for your two files to appear.

# Windows Installation
####
[updated 2015-10-31]
[Download the installer here.](https://github.com/jsphweid/bookletMacro/raw/master/windows/releases/bookletMacro-v0.3.1.exe)..

# Windows Usage
####
[updated 2015-10-31]
It's a lot easier now... Just select a group of PDFs, and click "run bookletMacro". The newly created byproduct folder will appear and seconds later your resulting PDFs will be there also.

# It messed up...
#### 

Just try it again and it should work.

The resulting booklet size is determined by the first PDF that it processes... meaning they all have to be the same size. I.E. Don't select some 8.5 x 11's and 9 x 12's at the same time and run the macro. This would be a bad idea...

2016-02-11
UPDATE: 
On OSX, it may bug you to install Java even though you've already went through the motions to install it. If running "java -version" in the terminal tells you no version of Java is installed, JAVA_HOME might not be set properly. You can try to fix that with googling but I've found in one instance that simply installing Java for OSX (from Apple's site, not Oracle's) basically corrects this one way or another.

Also, a PDF can have varying levels of security preventing jPDFTweak from working. If you dealing with these type of files, they need to be cracked first.



Something else happened? Make an issue on github or contact me some other way.

# Uninstall
#### 

For Mac OSX, just run this command in the terminal like you did to install it. It will remove the service and associated folders automatically.  
`curl -s https://raw.githubusercontent.com/jsphweid/bookletMacro/master/mac-osx/uninstall | bash`

For Windows, just go to the place where you installed it and there is an uninstall .exe in the folder.

# Building the Project from source
####
Okay, so you want to modify / contribute.

For the Mac version, the .workflow file (which is the script, but also contains information how the script is started... which is through the context menu) is the actual code that I wrote. So if you change that it is probably best to simply delete the current workflow in ~/Library/Services and execute the .workflow again. jPDF is contained within ~/.bookletMacro.

For the Windows version, you'll need Autohotkey installed to compile those scripts (parts of my script rely on it being compiled and not .ahk file) and NSIS if you want to make an installer. Basically, compile both .ahk scripts, run the .nsi file which will spit out an installer.
