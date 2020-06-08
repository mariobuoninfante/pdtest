local utils = {}


function utils.get_expected(filename)
   -- get test expected results from expected.txt file

   local file
   
   if filename == nil then
      file = assert(io.open("./expected.txt"))
   else
      file = assert(io.open(filename))
   end
   
   local expected = {}
   local line = ""
   while line ~= nil do
      -- skip comments
      if string.sub(line, 1, 2) ~= "--" and line ~= "" then
	 table.insert(expected, line)
      end
      
      if line == "testend" then break end
      
      line = file:read("l")
   end

   return expected
end


return utils
