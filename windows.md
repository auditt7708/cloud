---
title: windows
description: 
published: true
date: 2021-06-09T16:11:27.414Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:11:22.248Z
---

# Kosolen Kommandos 

## xcopy

**syntax**

`Xcopy <Source> [<Destination>] [/w] [/p] [/c] [/v] [/q] [/f] [/l] [/g] [/d [:MM-DD-YYYY]] [/u] [/i] [/s [/e]] [/t] [/k] [/r] [/h] [{/a | /m}] [/n] [/o] [/x] [/exclude:FileName1[+[FileName2]][+[FileName3]] [{/y | /-y}] [/z] [/b] [/j]`

1. Kopiere alle Dateien in ein Unterverzeichnis ( Inklusive aller leeren Unterverzeichnisse) von drive A zu drive B:

`xcopy a: b: /s /e `

2. Um alle System oder versteckten Datein in dem vorangegangenen Beispiel mit zu Kopieren: 

`xcopy a: b: /s /e /h`

3. Um Datein in dem Verzeichnis _\Reports_  mit den Datein im Verzeichnis _\Rawdata_ die sich seit December 29, 1993 verändert haben zu ersetzen :

`xcopy \rawdata \reports /d:12-29-1993`

4. Um alle Dateien zu Aktualisieren die im Verzeichnis _\Reports_ :

`xcopy \rawdata \reports /u`


5. Ausgabe einer Lister der Datein files die Kopiert wurden (ohne Sie zu Kopiren) :

`xcopy \rawdata \reports /d:12-29-1993 /l > xcopy.out`

Die Datei xcopy.out listet alle Datei die Kopiert wurden auf.

6. To copy the \Customer directory and all subdirectories to the directory \\Public\Address on network drive H:, retain the read-only attribute, and be prompted when a new file is created on H:, type:

`xcopy \customer h:\public\address /s /e /k /p`

7. To issue the previous command, ensure that xcopy creates the \Address directory if it does not exist, and suppress the message that appears when you create a new directory, add the /i command-line option as follows:

`xcopy \customer h:\public\address /s /e /k /p /i`

8. You can create a batch program to perform xcopy operations and use the batch if command to process the exit code if an error occurs. For example, the following batch program uses replaceable parameters for the xcopy source and destination parameters:

```
@echo off
rem COPYIT.BAT transfers all files in all subdirectories of
rem the source drive or directory (%1) to the destination
rem drive or directory (%2)
xcopy %1 %2 /s /e
if errorlevel 4 goto lowmemory
if errorlevel 2 goto abort
if errorlevel 0 goto exit
:lowmemory
echo Insufficient memory to copy files or
echo invalid drive or command-line syntax.
goto exit
:abort
echo You pressed CTRL+C to end the copy operation.
goto exit
:exit 
```

To use the preceding batch program to copy all files in the C:\Prgmcode directory and its subdirectories to drive B, type:

`copyit c:\prgmcode b:`

The command interpreter substitutes C:\Prgmcode for %1 and B: for %2, then uses xcopy with the /e and /s command-line options. If xcopy encounters an error, the batch program reads the exit code and goes to the label indicated in the appropriate IF ERRORLEVEL statement, then displays the appropriate message and exits from the batch program.

9. This example all the non-empty directories, plus files whose name match the pattern given with the asterisk symbol.

`xcopy .\toc*.yml ..\..\Copy-To\ /S /Y`

rem Output example.

```
rem  .\d1\toc.yml
rem  .\d1\d12\toc.yml
rem  .\d2\toc.yml
rem  3 File(s) copied
```

In the preceding example, this particular source parameter value .\toc*.yml copy the same 3 files even if its two path characters .\ were removed. However, no files would be copied if the asterisk wildcard was removed from the source parameter, making it just .\toc.yml.

Quellen: 

* [xcopy ](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy)
