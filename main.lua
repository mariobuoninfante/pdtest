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


pdtest.run(tests, platform, timestamp)

