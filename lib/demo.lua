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

require 'audioc'
require 'posix'


os.execute("clear")

print("playing...")
audioc.play(1)

posix.sleep(5)

print("sound goes to left...")
audioc.shift(1, "left")

posix.sleep(5)

print("jumps to right...")
audioc.shift(1, "right")

posix.sleep(5)

print("some radio sound on the left...")
audioc.play(7, "left")

posix.sleep(5)

print("suddenly playing faster...")
audioc.pitch(1, "fast")

posix.sleep(4)

print("back to normal...")
audioc.pitch(1, "normal")

posix.sleep(5)

print("an elephant on the right side...!")
audioc.play(8, "right")

posix.sleep(5)

print("then very sloooow...")
audioc.pitch(1, "slow")

posix.sleep(5)

print("slightly fading out and stopping")
audioc.fadeout(1)


