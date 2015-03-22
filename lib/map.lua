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

module("map", package.seeall)

require 'std'
require 'poly'
require 'json'
require 'utils'
require 'posix'
require 'engine'
require 'utils'

local close_distance=0.0015

function blend_zone(zone,t)
    --print("t="..t)
    local poly=poly.blend_polygon(zone.vertices[1],
                                  zone.vertices[2], t)
    --utils.table_print(poly)
    new_zone=utils.deepcopy(zone)
    if poly then
        new_zone.vertices={poly}
    else
        engine.log("vertex count wrong for "..zone.name..": "..#zone.vertices[1]..
                   " vs "..#zone.vertices[2])
    end
    return new_zone
end

function resolve_ghost_zones(pos,layer,t)
    -- first isolate the ghost zones
    local post_ghost={}
    local ghosts={}
    for zone_index,zone in pairs(layer.zones) do
        if utils.find_value("Sample Parameters:Ghost",zone.categories) then
            table.insert(post_ghost,blend_zone(zone,t))
        else
  	    table.insert(post_ghost,zone)
        end
    end
    return post_ghost
end

-- do a position lookup in each zone in the layer
-- returns list of zones we are in
function get_zones_from_layer(pos,layer,t)
    local zones=resolve_ghost_zones(pos,layer,t)
    local zones_found={}
    for zone_index,zone in pairs(zones) do
	if poly.is_in_polygon(zone.vertices[1], pos.lat , pos.lng) then
	   table.insert(zones_found,zone)
	end
    end
    return zones_found
end

-- search the current layer for events
function get_events_from_layer(pos,state,layer,events,new_state,t)
    local current_zones=get_zones_from_layer(pos,layer,t)
    local last_zone_names=state[layer.name]

    -- for the first time round
    if not last_zone_names then
        last_zone_names={}
    end

    local new_events={}
    local current_zone_names={}

    -- check for new zones
    for i,zone in pairs(current_zones) do
        -- if the current location was not seen last time
        if not utils.find_value(zone.name,last_zone_names) then
   	        print("--------------------- playing "..zone.name.." -------")
      	    table.insert(new_events,{type="entered-zone",
                                     layer_name=layer.name,
	    			     zone_name=zone.name,
				     zone_colour=zone.colour,
				     zone_categories=zone.categories})
        end
        -- build list of names
        table.insert(current_zone_names,zone.name)
    end

    -- check for zones we have left
    for i,zone_name in pairs(last_zone_names) do
        if not utils.find_value(zone_name,current_zone_names) then
            table.insert(new_events,{type="left-zone",
                                     layer_name=layer.name,
	    			     zone_name=zone_name,
                                     zone_colour="",
				     zone_categories={"None"}})
        end
    end

    -- update the state
    new_state[layer.name]=current_zone_names
    events[layer.name]=new_events

    return events,new_state
end

----------------------------------------------------------------------------
-- proximity events - loading/unloading samples based on radius

function get_prox_zones_from_layer(pos,layer,t)
    local zones=resolve_ghost_zones(pos,layer,t)
    local zones_found={}
    for zone_index,zone in pairs(zones) do
	if poly.is_close_polygon(zone.vertices[1], pos.lat , pos.lng, close_distance) then
	   table.insert(zones_found,zone)
	end
    end
    return zones_found
end

-- search the current layer for sample load/unload events
function get_prox_samples_from_layer(pos,state,layer,events,new_state,t)
    local current_zones=get_prox_zones_from_layer(pos,layer,t)
    local last_zone_names=state[layer.name]

    -- for the first time round
    if not last_zone_names then
        last_zone_names={}
    end

    local new_events={}
    local current_zone_names={}

    -- check for new zones
    for i,zone in pairs(current_zones) do
        -- if the current location was not seen last time
        if not utils.find_value(zone.name,last_zone_names) then
	    print("--------------------- entering area around "..zone.name.." for loading -------")
      	    table.insert(new_events,{type="entered-zone",
                                     layer_name=layer.name,
	    			     zone_name=zone.name,
				     zone_colour=zone.colour})
        end
        -- build list of names
        table.insert(current_zone_names,zone.name)
    end

    -- check for zones we have left
    for i,zone_name in pairs(last_zone_names) do
        if not utils.find_value(zone_name,current_zone_names) then
            table.insert(new_events,{type="left-zone",
                                     layer_name=layer.name,
	    			     zone_name=zone_name,
                                     zone_colour=""})
        end
    end

    -- update the state
    new_state[layer.name]=current_zone_names
    events[layer.name]=new_events

    return events,new_state
end

-- returns a new state and a list of events
function get_sample_events(pos,state,map,t)
    local events={}
    local new_state={}
    -- for each layer
    for layer_index,layer in pairs(map) do
    	-- collect events and state from each layer
	events,new_state=get_prox_samples_from_layer(pos,state,layer,events,new_state,t)
    end
    return new_state,events
end


-- state is a table mapping layer names to lists of last zones we are in
-- events is a table mapping layer names to lists of zones left and entered

-- returns a new state and a list of events
function get_events(pos,state,map,t)
    local events={}
    local new_state={}
    -- for each layer
    for layer_index,layer in pairs(map) do
    	-- collect events and state from each layer
	events,new_state=get_events_from_layer(pos,state,layer,events,new_state,t)
    end
    return new_state,events
end

function test_map(map, logfile)
    for layer_index,layer in pairs(map) do
    	for zone_index,zone in pairs(layer.zones) do
	    print("checking: "..zone.name) 
            local file=CONFIG.audio_path..zone.name..".wav";
	    -- utils.table_print(zone)

	    if utils.find_value("Sample Parameters:Ghost",zone.categories) then
	        print("is ghost")

		print(#zone.vertices[1])
		print(#zone.vertices[2])
		if #zone.vertices[1] ~= #zone.vertices[2] then
		   print("ERROR WRONG VERTEX COUNT, TELL DAVE")
		end
	    end

	    if posix.stat(file) then
                print("map check found: "..zone.name)
            else
                msg = "ERROR - map check failed to find: "..file
                print(msg)
                utils.log(logfile, msg)
            end
	end
    end
end


function test()
    local map=utils.load_json("../../maps/penryn-test.json")
    state,events=get_events({lat=50.1729952601643,lng=-5.106239318847656},{},map)
    table_print(events)
    state,events=get_events({lat=50.1729952601643,lng=-5.106239318847656},
			state,map)
    table_print(events)
    state,events=get_events({lat=54.1729952601643,lng=-5.106239318847656},
			state,map)
    table_print(events)
end

--test()
