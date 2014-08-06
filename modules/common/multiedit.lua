--------------------------------------------------------------------------------
-- Code that allows for access to Textadept's multiple cursors
--------------------------------------------------------------------------------

local M = {}

local findall = require "common.findall"

local find_all_occurrences = findall.find_all_occurrences

function M.select_all_occurences()
	local current = buffer.current_pos
	local mainstart, mainend = buffer.current_pos, buffer.current_pos
	local locations = find_all_occurrences()
	if #locations == 1 then
		buffer:set_selection(locations[1][1], locations[1][2])
		return
	end
	for index, value in ipairs(locations) do
		if current <= value[2] and current >= value[1] then
			mainstart = value[1]
			mainend = value[2]
		elseif index == 1 then
			buffer:set_selection(value[1], value[2])
		else
			buffer:add_selection(value[1], value[2])
		end
	end
	buffer:add_selection(mainstart, mainend)
end

return M
