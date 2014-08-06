local M = {}

local c = _SCINTILLA.constants

---
-- Returns a list of the start and end locations of the occurrences of the word
-- under the caret
function M.find_all_occurrences()
	local locations = {}
	local buffer = buffer
	local s, e = buffer.selection_start, buffer.selection_end
	if s == e then
		s, e = buffer:word_start_position(s), buffer:word_end_position(s)
	end
	local word = buffer:text_range(s, e)
	if word == '' then return end
	buffer.search_flags = c.FIND_WHOLEWORD + c.FIND_MATCHCASE
	buffer.target_start = 0
	buffer.target_end = buffer.length
	while buffer:search_in_target(word) > 0 do
		table.insert(locations, {buffer.target_start, buffer.target_end})
		buffer.target_start = buffer.target_end
		buffer.target_end = buffer.length
	end
	return locations
end

return M
