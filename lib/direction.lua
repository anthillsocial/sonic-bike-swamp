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

package.path = package.path..";./?.lua;../lib/?.lua"

module("direction", package.seeall)

--require 'std'
require 'utils'
require 'poly'

function resolve(degree)
    local dirs = {

    --{ low =-22.5 , high =22.5, name = "EAST" },
    --{ low = 46 , high =135, name = "NORTH" },
    --{ low =136 , high =180 , name = "WEST" },
    --{ low =-179 , high =-135, name = "WEST" },
    --{ low =-136 , high =-45 , name = "SOUTH" },

    { low=-22.5, high=22.5, name="s" },
    { low=22.5, high=67.5, name="se" },
    { low=67.5, high=112.5, name="e" },
    { low=112.5, high=157.5, name="ne" },
    -- { low=-157.5, high=157.5, name="n" }, wraps
    { low=-157.5, high=-112-5, name="nw" },
    { low=-112.5, high=-67.5, name="w" },
    { low=-67.5, high=-22.5, name="sw" },
    }

    for i, deg in pairs(dirs) do
        if std.round(degree, 0) >= deg.low and 
           std.round(degree,0) <= deg.high then
            return deg.name
        end
    end
    return "n"
end

function pan(dir,src)
    if (poly.dot(dir,src)>0) then return "right" end
    return "left"
end

function is_compass(c)
    return (c=="n" or c=="ne" or c=="e" or c=="se" or
            c=="s" or c=="sw" or c=="w" or c=="nw")
end

function pan_from(dir,compass)
    local dirs={ 
        n={lat=1, lng=0},
        ne={lat=1, lng=-1},
        e={lat=0, lng=-1},
        se={lat=-1, lng=-1},
        s={lat=-1, lng=0},
        sw={lat=-1, lng=1},
        w={lat=0, lng=1},
        nw={lat=1, lng=1}
    }

    -- reverse direction components to get perpendicular vector
    return pan(poly.normalise(dirs[compass]),
               poly.normalise({lat=dir.lng, lng=dir.lat}))
end


function test()
   local d={lat=1, lng=0}
   print("pan_from n/w=left: "..pan_from(d,"w"))
   local d2={lat=0, lng=1}
   print("dot(1,0 0,1)="..poly.dot(d,d2))
end

--test()