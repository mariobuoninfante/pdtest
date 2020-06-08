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



INFO
---
The Pd patch "test.pd" will automatically quit Pd after few seconds, if you want to edit it you can do one of the following:

Method 1
  - open the patch in a text editor
  - search for "quit" and turn it into "/quit" (or whatever else that is not "quit")
  - don't forget to set it back to "quit" once the changes have been completed

Method 2
  - launch the patch from terminal using the following command: 
    > pd -send "autoexitoff 1;" test.pd


