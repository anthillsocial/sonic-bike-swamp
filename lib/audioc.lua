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

module("audioc", package.seeall)

local mt = { __index = {} }

---
local function send(message)
 
   local pipe = io.open("/tmp/dodo", "w")
   if pipe then
      --print("audioc writing: "..message)
      pipe:write(message.."\n")
   else
      print("audioc failed to open pipe")
      return false
   end

   pipe:close()
   return true
end

---
function load(id)
  send("load "..id)
end

function unload(id)
  send("unload "..id)
end

function play(id, channel)
  local message
  if not channel then
     message = "play "..id
  else
     message = "play_"..channel.." "..id
  end
  print("sending "..message)
  send(message)
end

function loop(id, channel)
  local message
  if not channel then
     message = "loop "..id
  else
     message = "loop_"..channel.." "..id
  end
  send(message)
end


---
function stop(id)
  local message = "stop "..id
  send(message)
end


---
function shift(id, channel)
  local message
     message = channel.." "..id
     send(message)
end


---
function fadeout(id)
  local message = "fadeout "..id
  send(message)
end


---
function pitch(id, speed)
   local message = speed.." "..id
   send(message)
end

