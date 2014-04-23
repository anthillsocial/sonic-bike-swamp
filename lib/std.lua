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

module("std", package.seeall)


---
-- @param command
function stdout(command)
  local f = io.popen(command)
  local l = f:read("*a")
  f:close()

return l
end


---
--@param num 
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

---
function trim(s)
 if s then
    s = string.gsub(s, "^%s*(.-)%s*$", "%1")
    if string.len(s) > 0 then
       return s
    end
 end
 return false
end -- end trim


---
function split(str, pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

---
function dumptable(t, indent)
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']')
    if type(value)=="table" then io.write(':\n') dumptable(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end -- end showtable


---
function normalize_string(s)

s = string.gsub(s, "%s%s", " ") 

return s
end


---
function iterate_string(s)
local word_t
for word in string.gmatch(s, "(%w+)") do
  table.insert(word_t, word)
end

return word_t
end
