local pdtest = require("pdtest")

if arg[1] == nil then 
   print("First argument must be OS type:\nie: linux, macos, win")
   os.exit()
end


-- the OS in use
local platform = arg[1]

local tests = assert(pdtest.get_fields("./suite.txt"))


print("TESTS:")
for k, v in ipairs(tests) do print(k, v) end
print()

-- in case there are flags to pass to the test
local flags = {}
if #arg > 1 then
   for i = 2, #arg do
      table.insert(flags, arg[i])
   end
end

pdtest.run(tests, platform, flags)

