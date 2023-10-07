--require('textadept.editing.editorconfig')
--require('textredux').hijack()
local c = _SCINTILLA.constants

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------

--lexer.detect_patterns["tla"] = "tlaplus"
--lexer.detect_patterns["tach"] = "tachikoma"
--lexer.detect_patterns["ll"] = "llvm"
--lexer.detect_patterns["sml"] = "sml"
--textadept.editing.comment_string.sml = '(*|*)'
--textadept.editing.strip_trailing_spaces = true
ui.tabs = false
if not CURSES then
	view:set_theme('eigengrau')
end

-------------------------------------------------------------------------------
-- Key bindings
-------------------------------------------------------------------------------

keys['ctrl+r'] = nil

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
keys['ctrl+l'] = function()
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

keys['ctrl+left'] = function()
	buffer:word_part_left()
end

keys['ctrl+right'] = function()
	buffer:word_part_right()
end

keys['ctrl+shift+left'] = function()
	buffer:word_part_left_extend()
end

keys['ctrl+shift+right'] = function()
	buffer:word_part_right_extend()
end

keys['ctrl+down'] = function()
	buffer:line_down()
	buffer:line_down()
	buffer:line_down()
	buffer:line_down()
	buffer:line_down()
end

keys['ctrl+up'] = function()
	buffer:line_up()
	buffer:line_up()
	buffer:line_up()
	buffer:line_up()
	buffer:line_up()
end

keys['ctrl+shift+up'] = function()
	buffer:line_up_extend()
	buffer:line_up_extend()
	buffer:line_up_extend()
	buffer:line_up_extend()
	buffer:line_up_extend()
end

keys['ctrl+shift+down'] = function()
	buffer:line_down_extend()
	buffer:line_down_extend()
	buffer:line_down_extend()
	buffer:line_down_extend()
	buffer:line_down_extend()
end

keys['ctrl+\b'] = function()
	buffer:word_part_left_extend()
	buffer:delete_back()
end

keys['ctrl+del'] = function()
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
keys['ctrl+m'] = ui.switch_buffer

-- Bookmarks
local m_bookmarks = textadept.bookmarks
keys['ctrl+b'] = m_bookmarks.toggle
keys['ctrl+B'] = function() m_bookmarks.goto_mark(true) end
keys['ctrl+alt+B'] = function() m_bookmarks.goto_mark(false) end

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

keys["alt+right"] = function() ui.goto_view(1, true) end
keys["alt+left"] = function() ui.goto_view(-1, true) end

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
	view:vertical_center_caret()
end

keys['ctrl+k'] = function() goto_nearest_occurrence(false) end
keys['ctrl+K'] = function() goto_nearest_occurrence(true) end

if not _G.CURSES then
	keys.cq = nil
end
keys.cW = nil
keys['ctrl+home'] = function() return true end
keys['ctrl+end'] = function() return true end
keys['ctrl+shome'] = function() return true end
keys['ctrl+send'] = function() return true end

keys['ctrl+alt+t'] = function()
	terminalString = "tilix"
	pathString = "~"
	if buffer.filename then
		pathString = buffer.filename:match(".+/")
	end
	io.popen(terminalString.." --working-directory="..pathString.." &")
end

keys['ctrl+h'] = textadept.editing.highlight_words
keys['ctrl+g'] = textadept.editing.goto_line

keys['ctrl+C'] = function()
	local text = buffer:get_sel_text()
	text = text:gsub("([^\n]+)$", "\"%1\"")
	text = text:gsub("%s*([^\n]+)(\r?\n)", "\"%1\",%2")
	buffer:replace_sel(text)
end

keys['ctrl+I'] = function()
	local text = buffer:get_sel_text()
	text = text:gsub("([^\n]+)$", "<li>%1</li>")
	text = text:gsub("%s*([^\n]+)(\r?\n)", "<li>%1</li>%2")
	buffer:replace_sel(text)
end

keys['ctrl+?'] = function()
	local text = buffer:get_sel_text()
	local replacement = "/*\n * " .. text:gsub("\n", "\n * ") .. "\n */"
	buffer:replace_sel(replacement)
end

keys['ctrl+,'] = function()
	local text = buffer:get_sel_text()
	local replacement = text:gsub("([%w.]+)", "%1,")
	buffer:replace_sel(replacement)
end

keys['ctrl+t'] = function()
	textadept.editing.select_word()
	view:vertical_center_caret()
end

keys['ctrl+T'] = function()
	buffer:drop_selection_n(buffer.selections - 1)
	view:vertical_center_caret()
end

keys['ctrl+j'] = function()
	textadept.editing.select_word(true)
	view:vertical_center_caret()
end

keys['\n'] = function()
	buffer:begin_undo_action()
	buffer:new_line()
	buffer:end_undo_action()
end

-- Insert unicode arrow characters
keys['alt+c'] = {
	['right'] = function() buffer:add_text("→") end,
	['up'] = function() buffer:add_text("↑") end,
	['left'] = function() buffer:add_text("←") end,
	['down'] = function() buffer:add_text("↓") end,
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

view:set_x_caret_policy(1, 20) -- CARET_SLOP
view:set_y_caret_policy(13, 5) -- CARET_SLOP | CARET_STRICT | CARET_EVEN
if not _G.CURSES then
	view.margin_width_n[0] = 4 + 4 * view:text_width(view.STYLE_LINENUMBER, '9')
	view.margin_width_n[1] = 14
	view.margin_width_n[2] = 10
end

-- line length marker
view.edge_column = 80
view.edge_mode = 1

view.fold_flags = 17
buffer.mod_event_mask = c.MOD_CHANGEFOLD

-- autocomplete
buffer.auto_c_choose_single = true
buffer.auto_c_cancel_at_start = false
buffer.auto_c_ignore_case = true
view.auto_c_max_width = 60
view.auto_c_max_height = 10

-- multiple selections
if not WIN32 and not OSX then view.rectangular_selection_modifier = 8 end
buffer.multiple_selection = true
buffer.multi_paste = 1
textadept.editing.paste_reindents = false
buffer.additional_selection_typing = true
view.additional_carets_visible = true
buffer.selection_mode = 2

-- wrapping
view.wrap_visual_flags = 1
view.wrap_visual_flags_location = 1

-- annotations
view.annotation_visible = 2

-- indent guides
view.indentation_guides = 3

-- folding
view.property['fold'] = '1'

-- tabs and indentation
buffer.tab_width = 4
buffer.use_tabs = true
buffer.indent = 4
buffer.tab_indents = true
buffer.back_space_un_indents = true

view.end_at_last_line = false

