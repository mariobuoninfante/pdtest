local utils = require("utils")


local patchname = "test.pd"
local cmdlinux = "pd -nogui -stderr " .. patchname
local cmdmac = "/Applications/Pd-0.51-0.app/Contents/Resources/bin/pd -nogui -stderr " .. patchname

local pd

-- io.popen() is system depedent
-- an alternative would be os.execute("cmd > ./log.txt") and then check the log
if arg[1] == "linux" then
   pd = assert(io.popen(cmdlinux))
elseif arg[1] == "macos" then
   pd = assert(io.popen(cmdmac))
elseif arg[1] == "win" then
   print("well, we're not equipped for this yet!")
   os.exit()
else
   print("First argument must be OS type:\nie: linux, macos, win")
   os.exit()
end

-- expected msg from Pd
local expected = utils.get_expected("./test.txt")

-- where we collect what Pd actually sent us
local actual = {}


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
      if result == false then table.insert(failed, v) end
   end


   -- we should generate a log, but let's just print for now
   if #failed > 0 then
      for i=1, #failed do io.write(string.format("\nTEST FAILED: %s\n", failed[i])) end
   else
      print("\nTEST PASSED\n")
   end

-- if for whatever reason we haven't got anythig from Pd
else
   print("\nTEST FAILED - getting nothing from Pd\n")
end

pd:close()
