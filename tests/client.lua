
while true do

local message = io.stdin:read()

local file = io.open("/tmp/dodo", "w")
      file:write(message)
      file:close()

end

