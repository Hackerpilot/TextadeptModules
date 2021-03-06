--------------------------------------------------------------------------------
-- Functions for C-style languages such as C,C++,C#,D, and Java
--------------------------------------------------------------------------------

local M = {}

local comments = require 'common.comments'
local continue_block_comment = comments.continue_block_comment
local continue_line_comment = comments.continue_line_comment


--------------------------------------------------------------------------------
-- Selects the scope that the cursor is currently inside of.
--------------------------------------------------------------------------------
function M.selectScope()
	local cursor = buffer.current_pos
	local depth = -1
	while depth ~= 0 do
		buffer:search_anchor()
		if buffer:search_prev(2097158, "[{}()]") < 0 then break end
		if buffer.current_pos == 0 then break end
		if buffer:get_sel_text():match("[)}]") then
			depth = depth - 1
		else
			depth = depth + 1
		end
	end
	local scopeBegin = buffer.current_pos
	local scopeEnd = buffer:brace_match(buffer.current_pos)
	buffer:set_sel(scopeBegin, scopeEnd + 1)
end

-- Returns true if other functions should try to handle the event
function M.indent_after_brace()
	local buffer = buffer
	local line_num = buffer:line_from_position(buffer.current_pos)
	local prev_line = buffer:get_line(line_num - 1)
	local curr_line = buffer:get_line(line_num)
	if prev_line:find("{%s*$") then
		local indent = buffer.line_indentation[line_num - 1]
		if curr_line:find("}") then
			buffer:new_line()
			buffer.line_indentation[line_num] = indent + buffer.indent
			buffer.line_indentation[line_num + 1] = indent
			buffer:line_up()
			buffer:line_end()
		else
			buffer.line_indentation[line_num] = indent + buffer.indent
			buffer:line_end()
		end
		return false
	else
		return true
	end
end

-- Matches the closing } character with the indent level of its corresponding {
-- Does not properly handle the case of an opening brace inside a string.
function M.match_brace_indent()
	local buffer = buffer
	local style = buffer.style_at[buffer.current_pos]
	-- Don't do this if in a comment or string
	if style == 3 or style == 2 then return false end
	buffer:begin_undo_action()
	local line_num = buffer:line_from_position(buffer.current_pos)
	local brace_count = 1 -- +1 for closing, -1 for opening
	for i = line_num,0,-1 do
		local il = buffer:get_line(i)
		if il:find("{") then
			brace_count = brace_count - 1
		elseif il:find("}") then
			brace_count = brace_count + 1
		end
		if brace_count == 0 then
			buffer:line_up()
			buffer.line_indentation[line_num] = buffer.line_indentation[i]
			buffer:line_down()
			break
		end
	end
	buffer:end_undo_action()
	return false
end

-- Called this when the enter key is pressed
function M.enter_key_pressed()
	if buffer:auto_c_active() then return false end
	buffer:new_line()
	buffer:begin_undo_action()
	local cont = M.indent_after_brace()
	if cont then
		cont = continue_block_comment("/**", "*", "*/", "/%*", "%*", "%*/")
	end
	if cont then
		cont = continue_block_comment("/+", "+", "+/", "/%+", "%+", "%+/")
	end
	if cont then
		cont = continue_line_comment("//", "//")
	end
	buffer:end_undo_action()
end

function M.endline_semicolon()
	buffer:begin_undo_action()
	buffer:line_end()
	buffer:add_text(';')
	buffer:end_undo_action()
end

function M.newline_semicolon()
	buffer:begin_undo_action()
	buffer:line_end()
	buffer:add_text(';')
	buffer:new_line()
	buffer:end_undo_action()
end

function M.newline()
	buffer:begin_undo_action()
	buffer:line_end()
	buffer:new_line()
	buffer:end_undo_action()
end

-- allmanStyle: true to newline before opening brace, false for K&R style
function M.openBraceMagic(allmanStyle)
	buffer:begin_undo_action()
	buffer:line_end()
	if allmanStyle then
		buffer:new_line()
	else
		if buffer.char_at[buffer.current_pos - 1] ~= string.byte(" ") then
			buffer:add_text(" ")
		end
	end
	buffer:add_text("{}")
	buffer:char_left()
	M.enter_key_pressed()
	buffer:end_undo_action()
end

local function skipBalanced(start, finish, open, close)
	local s, f = start, finish
	if buffer.char_at[s - 1] == string.byte(close) then
		f = f - 1
		local depth = -1
		while depth < 0 and f >= 0 do
			f = f - 1
			local style = buffer.style_at[finish]
			if style ~= 3 and style ~= 2 then
				if buffer.char_at[f] == string.byte(close) then depth = depth - 1 end
				if buffer.char_at[f] == string.byte(open) then depth = depth + 1 end
			end
		end
		s = f
	end
	return s, f
end

-- Retruns a table consisting of the parts of a chained function call based on
-- the current cursor position.
-- For instance
-- instance.property.method(1, "123", var)
-- will return {"instance", "property", "method"}
function M.callStack(pos)
	if buffer.style_at[pos] == 3 or buffer.style_at[pos] == 2 then
		return {}
	end
	local stack = {}
	local finish = pos
	if string.char(buffer.char_at[pos - 1]):match("%s") then
		finish = buffer:word_start_position(pos, false)
	end
	local start = finish
	while start >= 0 do
		-- skip balanced parens
		start, finish = skipBalanced(start, finish, "(", ")")
		start, finish = skipBalanced(start, finish, "[", "]")
		start = buffer:word_start_position(finish)
		local part = buffer:text_range(start, finish):gsub("^%p+", "")
		if #part > 0 then
			table.insert(stack, 1, part)
		end
		finish = start
		if buffer.char_at[start - 1] ~= string.byte(".") then
			break
		else
			start = start - 1
			finish = finish - 1
		end
	end
	return stack
end

return M
