PREREQUISITES
---
Lua 5.3: https://www.lua.org/download.html
Pd 0.51-0: http://msp.ucsd.edu/software.html

On MacOS make sure that Pd-0.51-0 is in the Application folder.
Check that Lua is properly installed running the following command from terminal

> lua -v

This should return something that looks like this:
> Lua 5.3.5  Copyright (C) 1994-2018 Lua.org, PUC-Rio



HOW TO USE
---
Launch the terminal and run the following commands:

> cd 'folder/containing/this/README/file'
> lua main.lua "platform"

where "platform" is:
- linux
- macos
- win



SUITE AND TESTS
---
A suite is a text file called "suite.txt" that contains a list of all the tests to run.
Each field (aka test) consists of the test name without extension (ie mytest_t) - see next section about tests for more info about the different file extensions.

Tests are pairs of Pd patches and text files sharing the same name but different extension (.pd and .txt).
For example "mytest_t" would be composed by the following files, placed in the /tests folder:
- mytest_t.pd - actual Pd patch to test
- mytest_t.txt - text file containing the expected results

The text file (ie mytest_t.txt) is a list of expected messages received from the correspondent Pd patch (ie mytest_t.pd).
It has 2 mandatory fields:
- teststart
- testend

All the other fields must be placed in between these 2 (see text files in /tests for some example).

The order of the fields in the .txt file should match the order of execution in the .pd file.
That means if the Pd patch sends the following messages:

1. teststart
2. append
3. float 23
4. banana
5. testend

the correspondent test .txt file should be:

```
teststart
append
float 23
banana
testend
```

to be noticed that the Pd test patch must always start the test sending "teststart" and finish it sending "testend". 


Both "suite.txt" and the test files (.txt) can't contain "newline" and "carriage return" ("\n" and "\r") due to the way that they are parsed.
Comments are allowed and start with "--" (ie "-- This is a comment!").

In the Pd patch (ie mytest_t.pd) results are passed to Lua via [stdout -cr].





INFO
---
All the test patches will automatically quit Pd after few seconds, if you want to edit it you can do one of the following:

Method 1
  - open the patch in a text editor
  - search for "quit" and turn it into "/quit" (or whatever else that is not "quit")
  - don't forget to set it back to "quit" once the changes have been completed

Method 2
  - launch the patch from terminal using the following command: 
    > pd -send "autoexitoff 1;" mytest_t.pd
    where "mytest_t.pd" is the name of the patch to edit

