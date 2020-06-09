	2020-06-08
	---
	#ADDED
	- [list] test
	- main.lua - look for arg[1] before running any test
	
	#CHANGED
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
