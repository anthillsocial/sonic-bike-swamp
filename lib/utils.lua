-- Swamp Bike Opera embedded system for Kaffe Matthews 
-- Copyright (C) 2012 Wolfgang Hauptfleisch, Dave Griffiths
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

module("utils", package.seeall)

-- Log to CONFIG.install_path/log/sonic.log
function log(file, logmessage)
   print(os.date().." "..logmessage..' In:'..file)
   local  file = io.open(file, "a")
   local logmessage = os.date().." "..logmessage.."\n"
   file:write(logmessage)
   file:close()
end

-- Print anything - including nested tables
function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 4
  if type(tt) == "table" then
    for key, value in pairs (tt) do
      io.write(string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        io.write(string.format("[%s] => table\n", tostring (key)));
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write("(\n");
        table_print (value, indent + 7, done)
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write(")\n");
      else
        io.write(string.format("[%s] => %s\n",
            tostring (key), tostring(value)))
      end
    end
  else
    io.write(tt .. "\n")
  end
end

function load_json(filename)
    local file=io.input(filename)
    map={}
    if file then
       local txt=io.read("*all")
       map = json.decode(txt)
    end        
    return map
end

function find_value(s,t)
    if not(t) then return false end
    for k,v in pairs(t) do
        if v==s then 
	   return true 
	end
    end
    return false
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end
