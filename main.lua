local pdtest = require("pdtest")

local tests = assert(pdtest.get_fields("./suite.txt"))


print("TESTS:")
for k, v in ipairs(tests) do print(k, v) end
print()


for k, v in ipairs(tests) do
   pdtest.run(v)
end

