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

module("poly", package.seeall)

---
-- define if point is inside a polygon
function is_in_polygon(vertices, x, y)
        local intersectionCount = 0

        local x0 = vertices[#vertices].lat - x
        local y0 = vertices[#vertices].lng - y

        for i=1,#vertices do
                local x1 = vertices[i].lat - x
                local y1 = vertices[i].lng - y

                if y0 > 0 and y1 <= 0 and x1 * y0 > y1 * x0 then
                        intersectionCount = intersectionCount + 1
                end

                if y1 > 0 and y0 <= 0 and x0 * y1 > y0 * x1 then
                        intersectionCount = intersectionCount + 1
                end

                x0 = x1
                y0 = y1
        end

        return (intersectionCount % 2) == 1
end



function blend_polygon(vertsa, vertsb, t)
    if (#vertsa ~= #vertsb) then
       return false
    end

    local ret={}
    for i=1,#vertsa do
        table.insert(ret,lerp(vertsa[i],vertsb[i],t))
    end
    return ret
end

-- is the polygon within the specified radius, in km
function distance_to_polygon_points(vertices, x, y)
    local dist=99999999;
    for i=1,#vertices do
        local d=distance_km(vertices[i].lat,
                            vertices[i].lng,
		            x,y);
	 if d<dist then
	     dist=d
         end
    end
    return dist
end

function distance_to_polygon(vertices, x, y)
        local dist=99999999
        local x0 = vertices[#vertices].lat
        local y0 = vertices[#vertices].lng
        for i=1,#vertices do
                local x1 = vertices[i].lat
                local y1 = vertices[i].lng
		local d=distance_to_line(x,y,x0,y0,x1,y1)
		if (d<dist) then
		   dist=d
		end
                x0 = x1
                y0 = y1
        end
        return dist
end

-- is the polygon within the specified distance, in cartesian lat/lng distance!
function is_close_polygon(vertices, x, y, radius)
    -- in case polygon is larger than radius!
    if (is_in_polygon(vertices,x,y)) then
        return true
    end

    if (distance_to_polygon(vertices,x,y)<radius) then
        return true
    end
    return false
end


-- are the points of the polygon within the specified radius, in km
function is_close_polygon_km(vertices, x, y, radius)
    -- in case polygon is larger than radius!
    if (is_in_polygon(vertices,x,y)) then
        return true
    end

    for i=1,#vertices do
        local d=distance_km(vertices[i].lat,
                            vertices[i].lng,
	 	           x,y);
	if d<radius then
            return true
        end
    end
    return false
end

function distance_km(lat1,lon1,lat2,lon2)
    local R = 6371; -- km
    local la1=lat1*math.pi/180
    local lo1=lon1*math.pi/180
    local la2=lat2*math.pi/180
    local lo2=lon2*math.pi/180
    return math.acos(math.sin(la1)*math.sin(la2) +
           math.cos(la1)*math.cos(la2) *
           math.cos(lo2-lo1)) * R;
end

function distance_to_line(cx,cy,ax,ay,bx,by)
   local r_numerator = (cx-ax)*(bx-ax) + (cy-ay)*(by-ay);
   local r_denomenator = (bx-ax)*(bx-ax) + (by-ay)*(by-ay);
   local r = r_numerator / r_denomenator;

   if ( (r >= 0) and (r <= 1) ) then
       local s =  ((ay-cy)*(bx-ax)-(ax-cx)*(by-ay) ) / r_denomenator;
       return math.abs(s)*math.sqrt(r_denomenator);
   else
        local dist1 = (cx-ax)*(cx-ax) + (cy-ay)*(cy-ay);
        local dist2 = (cx-bx)*(cx-bx) + (cy-by)*(cy-by);
        if (dist1 < dist2) then
            return math.sqrt(dist1);
	else
	    return math.sqrt(dist2);
        end
    end
end

---
-- calculate the centre of a polygon
function centroid(polygon)
  local xsum = 0
  local ysum = 0

for i, p in ipairs(polygon) do
    xsum = xsum + p.x
    ysum = ysum + p.y
end

local k = table.getn(polygon)
local cx = xsum / k
local cy = ysum / k
return cx, cy
end

-- calculate the distance between two coordinates
function distance(a, b)
    local d = math.sqrt(math.pow((b.lat - a.lat), 2) +
                        math.pow((b.lng - a.lng), 2))
    return d
end

function length(x,y)
    return math.sqrt(math.pow(x, 2) +
                     math.pow(y, 2))
end

function length(a)
    return math.sqrt(math.pow(a.lat, 2) +
                     math.pow(a.lng, 2))
end

function normalise(a)
    local len=length(a)
    return {lat=a.lat/len,
            lng=a.lng/len}
end

function direction(a, b)
    local d={
        lat=b.lat-a.lat,
        lng=b.lng-a.lng
    }
    local d=normalise(d)
    local angle = math.atan2(d.lng, d.lat) * 180 / math.pi;
    return angle
end

function angle(a)
    local d=normalise(a)
    local angle = math.atan2(d.lng, d.lat) * 180 / math.pi;
    return angle
end

function lerp(a,b,t)
    return {lat=(1-t)*a.lat+t*b.lat,
            lng=(1-t)*a.lng+t*b.lng}
end

function dot(a,b)
    return a.lng*b.lng + a.lat*b.lat
end

---
-- We can shift(move) a polygon into 4 directions
--
function polygon_shift(polygon, towards, offset)

local offset = offset or 1
local new_polygon = {}

for i, point in ipairs(polygon) do

   if towards == "east" then
      local x = point.x + offset
      table.insert(new_polygon, { x = x, y = point.y } )
   elseif towards == "north" then
      local y = y + offset
      table.insert(new_polygon, { x = point.x, y = y } )
   elseif towards == "west" then
      local x = point.x - offset
      table.insert(new_polygon, { x = x, y = point.y } )
   elseif towards == "south" then
      local y = y - offset
      table.insert(new_polygon, { x = point.x, y = y } )
   end

end

return new_polygon
end

function test()
    local a={lat=0, lng=1}
    local b={lat=0, lng=0}
    print(direction(a, b))

end

test()
