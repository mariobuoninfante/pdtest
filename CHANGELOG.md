	2020-06-10
	---
	#ADDED
	- pdtest.lua - run() now grabs Pd version and add it to the log
	- pdtest.lua - possibility to redirect stderr to stdout
	- float-int_t test

	#CHANGED
	- pdtest.lua - run() started code refactoring 
	- pdtest.lua - pd_version() now gets "platform" argument
	- logs - improved log layout
	- /tests - fixed pdcontrol_t.pd not closing and float-int_t.pd always closing regardless "autoexitoff" 
	- improved logs formatting
	- README.txt / INFO - fixed Method to open "autoclosing" test patches
	- main.lua - flags are not printed on the console anymore since the check happens in pdtest.lua
	- pdtest.lua - fixed issue where only one flag was considered

	2020-06-09
	---
	#ADDED
	- added possibility to pass flags (not all of them) to Pd
	- pdtest.lua - generate basic log.txt
	- added /logs folder
	- [list] test
	- main.lua - look for arg[1] before running any test
	
	#CHANGED
	- pdtest.lua - get_fields() now skips empty strings ("")
	- pdtest.lua - refactored "flag checker"
	- logs - now capture date, platform and flags
	- main.lua - now passes table containing tests to pdtest.lua
	- pdtest.lua - now prints expected vs actual when test fails
	- added failed_t - failing test
	- README.txt - added more info about the test architecture
	- pd test patches - placed all abstractions in /modules
	- pdtest.lua - now receives an arg instead of using arg[1]

	2020-06-08
	---	
	# ADDED
	- added EXIT subpatch to be used in all test patches	
	- /test folder containing few test examples
	- gitignore (just for emacs for now)
	- code ported

	# CHANGED
	- README.txt - added info about SUITE and TESTS	
	- pdtest.lua contains run() that actually runs the tests
	- utils.lua is now pdtest.lua
