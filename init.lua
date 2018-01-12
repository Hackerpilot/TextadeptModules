require('textadept.editing.editorconfig')
require('textredux').hijack()
local c = _SCINTILLA.constants

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------

textadept.file_types.extensions["tla"] = "tlaplus"
textadept.file_types.extensions["tach"] = "tachikoma"
textadept.file_types.extensions["ll"] = "llvm"
textadept.file_types.extensions["sml"] = "sml"
textadept.editing.comment_string.sml = '(*|*)'
textadept.editing.strip_trailing_spaces = true
ui.tabs = false
if not _G.CURSES then
	buffer.set_theme('eigengrau')
end


-------------------------------------------------------------------------------
-- Key bindings
-------------------------------------------------------------------------------

keys.cr = nil

function getSelectedLineRange()
	if #buffer.get_sel_text(buffer) == 0 then
		return buffer:line_from_position(buffer.current_pos),
			buffer:line_from_position(buffer.current_pos)
	else
		startLine = buffer:line_from_position(buffer.selection_start)
		endLine = buffer:line_from_position(buffer.selection_end)
		if startLine > endLine then
			startLine, endLine = endLine, startLine
		end
		return startLine, endLine
	end
end

-- Deletes the currently selected lines
keys.cl = function()
	buffer:begin_undo_action()
	local startLine, endLine = getSelectedLineRange()
	if buffer.current_pos == buffer.selection_end then
	end
	for i = startLine, endLine do
		buffer:home()
		buffer:del_line_right()
		if buffer:line_from_position(buffer.current_pos) == 0 then
			buffer:line_down()
			buffer:home()
			buffer:delete_back()
		else
			buffer:delete_back()
			buffer:line_down()
		end
	end
	buffer:end_undo_action()
end

keys['cleft'] = function()
	buffer:word_part_left()
end

keys['cright'] = function()
	buffer:word_part_right()
end

keys['csleft'] = function()
	buffer:word_part_left_extend()
end

keys['csright'] = function()
	buffer:word_part_right_extend()
end

keys['cdown'] = function()
	buffer:line_down()
	buffer:line_down()
	buffer:line_down()
	buffer:line_down()
	buffer:line_down()
end

keys['cup'] = function()
	buffer:line_up()
	buffer:line_up()
	buffer:line_up()
	buffer:line_up()
	buffer:line_up()
end

keys['csup'] = function()
	buffer:line_up_extend()
	buffer:line_up_extend()
	buffer:line_up_extend()
	buffer:line_up_extend()
	buffer:line_up_extend()
end

keys['csdown'] = function()
	buffer:line_down_extend()
	buffer:line_down_extend()
	buffer:line_down_extend()
	buffer:line_down_extend()
	buffer:line_down_extend()
end

keys['c\b'] = function()
	buffer:word_part_left_extend()
	buffer:delete_back()
end

keys['cdel'] = function()
	buffer:word_part_right_extend()
	buffer:delete_back()
end

keys['{'] = function()
	local startPos = buffer.selection_start
	local endPos = buffer.selection_end
	if startPos == endPos then return false end
	local startLine = buffer:line_from_position(startPos)
	local endLine = buffer:line_from_position(endPos)
	local i = 0
	if buffer.use_tabs then i = buffer.tab_width else i = buffer.indent end
	local j = i * (endLine - startLine + 1)
	buffer:begin_undo_action()
	if buffer.char_at[startPos] == string.byte('{')
			and buffer.char_at[endPos - 1] == string.byte('}') then
		local b = buffer:line_from_position(startPos)
		local a = buffer:line_from_position(endPos)
		for l = startLine, endLine do
			buffer.line_indentation[l] = buffer.line_indentation[l] - i
		end
		buffer:goto_line(a)
		buffer:line_delete()
		buffer:goto_line(b)
		buffer:line_delete()
	else
		buffer:goto_pos(endPos)
		buffer:new_line()
		buffer:insert_text(buffer.current_pos, '}')
		buffer:goto_pos(startPos)
		buffer:insert_text(buffer.current_pos, '{')
		buffer:goto_pos(buffer.current_pos + 1)
		buffer:new_line()
		for l = startLine, endLine do
			buffer.line_indentation[l + 1] = buffer.line_indentation[l + 1] + i
		end
	end
	buffer:line_end()
	buffer:end_undo_action()
end

-- Buffer list
keys.cm = ui.switch_buffer

-- Bookmarks
local m_bookmarks = textadept.bookmarks
keys.cb = m_bookmarks.toggle
keys.cB = function() m_bookmarks.goto_mark(true) end
keys.caB = function() m_bookmarks.goto_mark(false) end

local m_editing = textadept.editing
keys['('] = function()
	if #buffer.get_sel_text(buffer) == 0 then
		return false
	else
		m_editing.enclose("(", ")")
	end
end

keys['"'] = function()
	if #buffer.get_sel_text(buffer) == 0 then
		return false
	else
		m_editing.enclose('"', '"')
	end
end

keys['['] = function()
	if #buffer.get_sel_text(buffer) == 0 then
		return false
	else
		m_editing.enclose("[", "]")
	end
end

keys["'"] = function()
	if #buffer.get_sel_text(buffer) == 0 then
		return false
	else
		m_editing.enclose("'", "'")
	end
end

local function toggle_comment(char)
	buffer:begin_undo_action()
	for i = 0,  buffer.selections - 1 do
		buffer:set_target_range(buffer.selection_n_start[i],
			buffer.selection_n_end[i])
		local text = buffer.target_text
		if #text > 0 then
			first = text:match("/%"..char.."(.-)%"..char.."/")
			if first == nil then
				buffer:replace_target("/"..char..text..char.."/")
			else
				buffer:replace_target(first)
			end
		end
	end
	buffer:end_undo_action()
end

keys["*"] = function()
	if #buffer.get_sel_text(buffer) == 0 then
		return false
	else
		toggle_comment("*")
	end
end

keys["+"] = function()
	if #buffer.get_sel_text(buffer) == 0 then
		return false
	else
		toggle_comment("+")
	end
end

keys["aright"] = function() ui.goto_view(1, true) end
keys["aleft"] = function() ui.goto_view(-1, true) end

function goto_nearest_occurrence(reverse)
	local buffer = buffer
	local s, e = buffer.selection_start, buffer.selection_end
	if s == e then
		s, e = buffer:word_start_position(s), buffer:word_end_position(s)
	end
	local word = buffer:text_range(s, e)
	if word == '' then return end
	buffer.search_flags = _SCINTILLA.constants.FIND_WHOLEWORD
		+ _SCINTILLA.constants.FIND_MATCHCASE
	if reverse then
		buffer.target_start = s - 1
		buffer.target_end = 0
	else
		buffer.target_start = e + 1
		buffer.target_end = buffer.length
	end
	if buffer:search_in_target(word) == -1 then
		if reverse then
			buffer.target_start = buffer.length
			buffer.target_end = e + 1
		else
			buffer.target_start = 0
			buffer.target_end = s - 1
		end
		if buffer:search_in_target(word) == -1 then return end
	end
	buffer:set_sel(buffer.target_start, buffer.target_end)
	buffer:vertical_centre_caret()
end

keys.ck = function() goto_nearest_occurrence(false) end
keys.cK = function() goto_nearest_occurrence(true) end

if not _G.CURSES then
	keys.cq = nil
end
keys.cW = nil
keys['chome'] = function() return true end
keys['cend'] = function() return true end
keys['cshome'] = function() return true end
keys['csend'] = function() return true end

keys.cat = function()
	terminalString = "tilix"
	pathString = "~"
	if buffer.filename then
		pathString = buffer.filename:match(".+/")
	end
	io.popen(terminalString.." --working-directory="..pathString.." &")
end

keys.ch = textadept.editing.highlight_word
keys.cg = textadept.editing.goto_line

keys.cC = function()
	local text = buffer:get_sel_text()
	text = text:gsub("([^\n]+)$", "\"%1\"")
	text = text:gsub("%s*([^\n]+)(\r?\n)", "\"%1\",%2")
	buffer:replace_sel(text)
end

keys.cI = function()
	local text = buffer:get_sel_text()
	text = text:gsub("([^\n]+)$", "<li>%1</li>")
	text = text:gsub("%s*([^\n]+)(\r?\n)", "<li>%1</li>%2")
	buffer:replace_sel(text)
end

keys["c?"] = function()
	local text = buffer:get_sel_text()
	local replacement = "/*\n * " .. text:gsub("\n", "\n * ") .. "\n */"
	buffer:replace_sel(replacement)
end

keys["c,"] = function()
	local text = buffer:get_sel_text()
	local replacement = text:gsub("([%w.]+)", "%1,")
	buffer:replace_sel(replacement)
end

keys['ct'] = function()
	textadept.editing.select_word()
	buffer:vertical_centre_caret()
end

keys['cT'] = function()
	buffer:drop_selection_n(buffer.selections - 1)
	buffer:vertical_centre_caret()
end

keys['cj'] = function()
	textadept.editing.select_word(true)
	buffer:vertical_centre_caret()
end

keys['\n'] = function()
	buffer:begin_undo_action()
	buffer:new_line()
	buffer:end_undo_action()
end

local function bisectLeft()
	local cp = math.min(buffer.current_pos, math.min(buffer.selection_start, buffer.selection_end))
	local ln = buffer:line_from_position(cp)
	local lineLength = buffer:line_length(ln)
	local col = buffer.column[cp]
	local beg = buffer.position_from_line(ln)
	return math.max(beg, cp - (lineLength // 3))
end

keys['caleft'] = function()
	buffer:goto_pos(bisectLeft())
end

local function bisectRight()
	local cp = math.max(buffer.current_pos, math.max(buffer.selection_start, buffer.selection_end))
	local ln = buffer:line_from_position(cp)
	local lineLength = buffer:line_length(ln)
	local col = buffer.column[cp]
	local lineEnd = buffer.line_end_position[ln]
	return math.min(lineEnd, cp + (lineLength // 3))
end

keys['caright'] = function()
	buffer:goto_pos(bisectRight())
end

keys['casleft'] = function()
	for i = math.min(buffer.selection_start, buffer.selection_end), bisectLeft(), -1 do
		buffer:char_left_extend()
	end
end

keys['casright'] = function()
	for i = math.max(buffer.selection_start, buffer.selection_end), bisectRight() do
		buffer:char_right_extend()
	end
end

-- Insert unicode arrow characters
keys.ac = {
	["right"] = function() buffer:add_text("→") end,
	["up"] = function() buffer:add_text("↑") end,
	["left"] = function() buffer:add_text("←") end,
	["down"] = function() buffer:add_text("↓") end,
}

keys['f9'] = reset

-- Horizontally align space-separated data.
keys['f8'] = function()
	for selIndex = 0, buffer.selections - 1 do
		local startPos = math.min(buffer.selection_n_start[selIndex],
			buffer.selection_n_end[selIndex])
		local endPos = math.max(buffer.selection_n_start[selIndex],
			buffer.selection_n_end[selIndex])
		if startPos ~= endPos then
			local text = buffer:get_sel_text()
			local leadingWhitespace = {}
			local words = {}
			local maxWordLengths = {}
			local lineCount = 0
			for line in string.gmatch(text, "([^\n]+)") do
				table.insert(words, {})
				lineCount = lineCount + 1

				local leading = string.match(line, "^(%s+)")
				table.insert(leadingWhitespace, leading or "")
				if leading ~= nil then
					line = string.sub(line, string.len(leading))
				end

				local wordIndex = 1
				for word in string.gmatch(line, " *([^%s]+)") do
					table.insert(words[#words], word)
					if wordIndex <= #maxWordLengths then
						maxWordLengths[wordIndex] = math.max(
							maxWordLengths[wordIndex], string.len(word))
					else
						maxWordLengths[wordIndex] = string.len(word)
					end
					wordIndex = wordIndex + 1
				end
			end
			buffer:begin_undo_action()
			buffer:delete_range(startPos, endPos - startPos)
			buffer:goto_pos(startPos)

			for i = 1, lineCount do
				buffer:add_text(leadingWhitespace[i] or "")
				for j, word in ipairs(words[i]) do
					local paddingSpaceCount = maxWordLengths[j] - string.len(word) + 1
					buffer:add_text(word)
					if j + 1 <= #words[i] then
						for k = 1, paddingSpaceCount do buffer:add_text(" ") end
					end
				end
				if i < lineCount then buffer.add_text("\n") end
			end
			buffer:end_undo_action()
		end
	end
end

buffer:set_x_caret_policy(1, 20) -- CARET_SLOP
buffer:set_y_caret_policy(13, 5) -- CARET_SLOP | CARET_STRICT | CARET_EVEN
if not _G.CURSES then
	buffer.margin_width_n[0] = 4 + 4 * buffer:text_width(c.STYLE_LINENUMBER, '9')
	buffer.margin_width_n[1] = 14
	buffer.margin_width_n[2] = 10
end


buffer.margin_type_n[2] = c.MARGIN_SYMBOL
buffer.margin_mask_n[2] = c.MASK_FOLDERS
buffer.margin_sensitive_n[2] = true
buffer:marker_define(c.MARKNUM_FOLDEROPEN, c.MARK_BOXMINUS)
buffer:marker_define(c.MARKNUM_FOLDER, c.MARK_BOXPLUS)
buffer:marker_define(c.MARKNUM_FOLDERSUB, c.MARK_VLINE)
buffer:marker_define(c.MARKNUM_FOLDERTAIL, c.MARK_LCORNERCURVE)
buffer:marker_define(c.MARKNUM_FOLDEREND, c.MARK_BOXPLUSCONNECTED)
buffer:marker_define(c.MARKNUM_FOLDEROPENMID, c.MARK_BOXMINUSCONNECTED)
buffer:marker_define(c.MARKNUM_FOLDERMIDTAIL, c.MARK_TCORNER)
buffer:marker_define(textadept.bookmarks.MARK_BOOKMARK, c.MARK_BOOKMARK)

-- line length marker
buffer.edge_column = 80
buffer.edge_mode = 1

buffer.fold_flags = 17
buffer.mod_event_mask = c.MOD_CHANGEFOLD

-- autocomplete
buffer.auto_c_choose_single = true
buffer.auto_c_cancel_at_start = false
buffer.auto_c_ignore_case = true
buffer.auto_c_max_width = 60
buffer.auto_c_max_height = 10

-- multiple selections
if not WIN32 and not OSX then buffer.rectangular_selection_modifier = 8 end
buffer.multiple_selection = true
buffer.multi_paste = 1
buffer.paste_reindents = true
buffer.additional_selection_typing = true
buffer.additional_carets_visible = true
buffer.selection_mode = 2

-- wrapping
buffer.wrap_visual_flags = 1
buffer.wrap_visual_flags_location = 1

-- annotations
buffer.annotation_visible = 2

-- indent guides
buffer.indentation_guides = 3

-- folding
buffer.property['fold'] = '1'

-- tabs and indentation
buffer.tab_width = 4
buffer.use_tabs = true
buffer.indent = 4
buffer.tab_indents = true
buffer.back_space_un_indents = true

buffer.end_at_last_line = false

