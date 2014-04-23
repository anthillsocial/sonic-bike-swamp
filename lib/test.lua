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

require 'poly'
require 'map'
require 'std'

ZONES = map.load()

--print(angle(1,2,1,1))


--local ZONES = {

--{
--{ x = 2, y = 3 } ,
--{ x = 3, y = 7 },
--{ x = 5, y = 6 },
--{ x = 7, y = 6 },
--{ x = 8, y = 2 },
--{ x = 5, y = 1 },
--},
--
--}



--local polygon = {
--
--{ 3.73725 , 51.04295 },
--{ 3.73696 , 51.04325 },
--{ 3.73738 , 51.04338 },
--{ 3.73770 , 51.04313 },
--
--}

--for i, polygon in ipairs(ZONES) do
--    print(poly.is_in_polygon(polygon, 51.04939 , 3.73439))
--end

std.dumptable(ZONES)

-- std.dumptable(poly.polygon_shift(ZONES[1], "west"))
