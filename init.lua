require 'editorconfig'
require('textredux').hijack()
local common = require 'common'

textadept.editing.STRIP_TRAILING_SPACES = true
keys.LANGUAGE_MODULE_PREFIX = "cat"

function get_sel_lines()
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
	local startLine, endLine = get_sel_lines()
	if buffer.current_pos == buffer.selection_end then
		buffer:goto_line(startLine)
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

-- Places cursors on both sides of the selected text
keys.ce = function()
	buffer:begin_undo_action()
	local start = buffer.selection_start
	local sel_end = buffer.selection_end
	buffer:set_selection(sel_end, sel_end)
	buffer:add_selection(start, start)
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
keys.cb = {m_bookmarks.toggle}
keys.cB = {m_bookmarks.goto_mark, true}
keys.caB = {m_bookmarks.goto_mark, false}

-- Editing
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

local m_editing = textadept.editing
keys['('] = {function() if #buffer.get_sel_text(buffer) == 0 then return false else m_editing.enclose("(", ")") end end}
keys['"'] = {function() if #buffer.get_sel_text(buffer) == 0 then return false else m_editing.enclose('"', '"') end end}
keys['['] = {function() if #buffer.get_sel_text(buffer) == 0 then return false else m_editing.enclose("[", "]") end end}
keys["'"] = {function() if #buffer.get_sel_text(buffer) == 0 then return false else m_editing.enclose("'", "'") end end}
keys["*"] = {function() if #buffer.get_sel_text(buffer) == 0 then return false else toggle_comment("*") end end}
keys["+"] = {function() if #buffer.get_sel_text(buffer) == 0 then return false else toggle_comment("+") end end}
keys['f9'] = reset

if not _G.CURSES then
keys.cq = nil
end

-- Insert unicode arrow characters
keys.ac = {
	["right"] = {function() buffer:add_text("→") end},
	["up"] = {function() buffer:add_text("↑") end},
	["left"] = {function() buffer:add_text("←") end},
	["down"] = {function() buffer:add_text("↓") end},
}

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

keys.ck = {goto_nearest_occurrence, false}
keys.cK = {goto_nearest_occurrence, true}

function openTerminalHere()
	terminalString = "xfce4-terminal"
  pathString = "~"
  if buffer.filename then
    pathString = buffer.filename:match(".+/")
  end
  io.popen(terminalString.." --working-directory="..pathString.." &")
end

keys.cat = openTerminalHere

keys.ch = textadept.editing.highlight_word
keys.cg = textadept.editing.goto_line

keys.cO = function ()
	local location
	if buffer.filename then
		if WIN32 then
			location = buffer.filename:match(".+\\")
		else
			location = buffer.filename:match(".+/")
		end
	else
		location = os.getenv("PWD")
	end
	_G.io.snapopen(location)
end

keys.cW = nil

function quoteAndComma()
	local text = buffer:get_sel_text()
	text = text:gsub("([^\n]+)$", "\"%1\"")
	text = text:gsub("%s*([^\n]+)(\r?\n)", "\"%1\",%2")
	buffer:replace_sel(text)
end
keys.cC = quoteAndComma

function itemize()
	local text = buffer:get_sel_text()
	text = text:gsub("([^\n]+)$", "<li>%1</li>")
	text = text:gsub("%s*([^\n]+)(\r?\n)", "<li>%1</li>%2")
	buffer:replace_sel(text)
end
keys.cI = itemize

function blockComment()
	local text = buffer:get_sel_text()
	local replacement = "/*\n * " .. text:gsub("\n", "\n * ") .. "\n */"
	buffer:replace_sel(replacement)
end
keys["c?"] = blockComment

function commaSeparete()
	local text = buffer:get_sel_text()
	local replacement = text:gsub("([%w.]+)", "%1,")
	buffer:replace_sel(replacement)
end
keys["c,"] = commaSeparete

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

keys['am'] = {textadept.editing.match_brace}
keys['aM'] = {textadept.editing.match_brace, true}

if not _G.CURSES then
	ui.set_theme('eigengrau-lunar')
end

if not _G.CURSES then
	keys.cq = nil
end

textadept.file_types.extensions["tla"] = "tlaplus"
textadept.file_types.extensions["tach"] = "tachikoma"
textadept.file_types.extensions["ll"] = "llvm"

-- No tabs
ui.tabs = false

-- adjust line number margin on zoom
events.connect('SCN', function(n)
	if n.code == _SCINTILLA.constants.SCN_ZOOM then
		local buffer = buffer
		local width = #(buffer.line_count..'')
		width = width > 4 and width or 4
		buffer.margin_width_n[0] = 4 + width *
			buffer:text_width(_SCINTILLA.constants.STYLE_LINENUMBER, '9')
	end
end)


