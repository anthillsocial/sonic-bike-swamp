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

module("random", package.seeall)

require 'posix'
require 'socket'

function by_probability(probability)

   local hey = math.random(1, 100)
   if hey <= probability then
      return true
   end

return false
end



function now()

local d = {
    HOUR_OF_DAY = tonumber(os.date("%H")) ,
    DAY_OF_WEEK = tonumber(os.date("%w")) ,
    DAY_OF_MONTH = tonumber(os.date("%d")) ,
    MONTH_OF_YEAR = tonumber(os.date("%m")) 
}

return d
end


function animal()

local a = math.random(31, 39)
return a

end

function channel()

local a = math.random(1,2)
local channel

if a == 1 then
  channel = "left"
else
 channel = "right"
end

return channel

end

--print(now().HOUR_OF_DAY)
--print(now().DAY_OF_MONTH)
--print(now().MONTH_OF_YEAR)
--print(now().DAY_OF_WEEK)
