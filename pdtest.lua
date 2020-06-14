local pdtest = {}

local function parse_version(v)
   -- "pd -version" should return something like:
   -- Pd-0.49.1 ("") compiled 23:45:54 Jul 23 2019

   if v == nil then return "" end

   -- look for the apostrophe in the expected string - we can't look for "("
   local v_end = string.find(v, '"')
   if type(v_end) == "number" then
      v_end = v_end - 2
      if v_end > 0 then
	 return string.sub(v, 1, v_end)
      else
	 return ""
      end
   else
      return ""
   end
   
end


local function check_platform(platform)   

   local cmdlinux = "pd "
   local cmdmac = "/Applications/Pd-0.51-0.app/Contents/Resources/bin/pd "
      
   local pd_cmd = ""  
   -- an alternative would be os.execute("cmd > ./log.txt") and then check the log
   if platform == "linux" then
      pd_cmd = cmdlinux 
   elseif platform == "macos" then
      pd_cmd = cmdmac
   elseif platform == "win" then
      print("well, we're not equipped for this yet!")
      os.exit()
   else
      print("First argument must be OS type:\nie: linux, macos, win")
      os.exit()
   end

   return pd_cmd
end



local function check_flags(flags)
   
   -- check flags to pass to Pd 
   local pdflags = {"-nogui", "-gui", "-nomidi", "-stderr", "-noaudio", "-r"} 
   local flags_str, redirect_stderr = "", ""

   if #flags == 0 then
      flags_str = "-nogui -stderr "

      -- redirect stderr to stdout
      redirect_stderr = "2>&1"

   else
      for k, v in ipairs(flags) do
	 for key, val in ipairs(pdflags) do
	    if v == val then
	       flags_str = flags_str .. " " ..  v .. " "

	       -- redirect stderr to stdout
	       if v == "-stderr" then redirect_stderr = "2>&1" end 
	    end
	 end
      end
      if flags_str == "" then flags_str = "-nogui -stderr " end
   end

   return flags_str, redirect_stderr
end




function pdtest.run(tests, platform, flags)
      
   local pd_cmd = check_platform(platform)
   
   flags = flags or {}

   local flags_str, redirect_stderr = check_flags(flags)
   

   
   local pd
   local timestamp = os.date("%Y%m%d_%H_%M_%S")
   local version = pdtest.pd_version(pd_cmd)
   local log = io.open("./logs/log_" .. timestamp .. ".txt", "w")   
   log:write("DATE: " .. os.date("%Y-%m-%d - %H:%M:%S") .. "\nPLATFORM: " .. platform .. "\nVERSION: " .. version .. "\nFLAGS: " .. flags_str .. "\n\n")


   
   -------------------
   -- run the tests --
   -------------------

   for k, testname in ipairs(tests) do
      local patchname = "./tests/" .. testname .. ".pd"
      local actual_cmd = pd_cmd .. flags_str .. patchname .. " " .. redirect_stderr
      
      log:write(string.format("\n---\nTEST: %s ", testname))
      io.write(string.format("\n---\n%s\n---\n", testname))

      -- launch Pd
      -- io.popen() is system depedent
      -- an alternative would be os.execute("cmd > ./log.txt") and then check the log
      pd = assert(io.popen(actual_cmd))

      
      -- expected msg from Pd
      local expected = pdtest.get_fields("./tests/" .. testname .. ".txt")
      if expected == false then
	 log:write("SKIPPED\n")
	 io.write("\nSKIPPED\n")
	 goto continue
      end

      -- where we collect what Pd actually sends us
      local actual = {}
      local pderr = {}


      

      ---------------------
      -- collect from Pd --
      ---------------------

      local line = ""
      local start = false
      local c = 0
      while line ~= nil do
	 if line == "teststart" then
	    start = true
	 end
	 if start then
	    c = c + 1
	    actual[c] = line
	 end

	 -- intercept stderr
	 if string.find(line, "error:") ~= nil then
	    table.insert(pderr, line)
	 end
	 
	 line = pd:read()
      end


      
      -----------------------------
      -- verify things collected --
      -----------------------------

      local failed = {}

      -- check that we actually got something from Pd
      if #actual > 0 then
	 for k, v in ipairs(expected) do
	    local result = actual[k] == v
	    
	    -- if "actual" is different from "expected" capture both
	    if result == false then table.insert(failed, {v, actual[k]}) end
	 end
	 
	 if #failed > 0 then
	    io.write("\nFAILED\n")
	    log:write("FAILED\n")
	    for i=1, #failed do
	       io.write(string.format("- expected: %s | actual: %s\n", failed[i][1], failed[i][2]))
	       log:write(string.format("- expected: %s | actual: %s\n", failed[i][1], failed[i][2]))
	    end
	    io.write("\n")
	 else
	    io.write("\nTEST PASSED\n\n")
	    log:write("PASSED\n")
	 end

	 -- if for whatever reason we haven't got anything from Pd
      else
	 io.write("\nTEST FAILED - getting nothing from Pd\n")
	 log:write("FAILED - getting nothing from Pd\n")
      end

      -- log Pd stderr first
      if #pderr > 0 then
	 log:write("\nPd errors\n")
	 for k, v in ipairs(pderr) do
	    io.write("Pd " .. v, "\n")
	    log:write(v .. "\n")
	 end
      end
      ::continue::
   end

   log:close()
   pd:close()
end



function pdtest.get_fields(filename)
   -- get test expected results from test .txt file

   local file
   
   if filename == nil then
      file = io.open("./expected.txt")
   else
      file = io.open(filename)
   end
   if file == nil then return false end

   
   local expected = {}
   local line = "--"
   while line ~= nil do
      -- skip comments
      if string.sub(line, 1, 2) ~= "--" and line ~= "" then
	 table.insert(expected, line)
      end
      
      if line == "testend" then break end

      -- we skip newline and return
      line = file:read("l")
   end

   return expected
end



function pdtest.pd_version(cmd)
   local pd = io.popen(cmd .. "-version 2>&1")
   local version = ""
   
   local line = ""
   while line ~= nil do
      if line ~= "" then
	 version = parse_version(line)
      end
      line = pd:read("l")
   end

   pd:close()

   return version
end




return pdtest
