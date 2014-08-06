--------------------------------------------------------------------------------
-- This file provides functions that will automatically close XML tags.
--
-- See the comments above each function for the key bindings that should be used
-- with the various functions. I do not recommend using autoTag in combination
-- with completeClosingTagBracket. The two functions are designed for two
-- different usage styles.
--------------------------------------------------------------------------------

local M = {}

--------------------------------------------------------------------------------
-- Selects all text within the tag containing the cursor
--------------------------------------------------------------------------------
function M.selectToMatching()
	local buffer = buffer
	local oldPos = buffer.current_pos
	local pattern = "<[^>!?]*[^/>]>"
	local count = 1
	local tagName = nil
	-- Search forward, finding all tags. Stop when an end tag is found that did
	-- not have a matching opening tag during this search.
	while count ~= 0 do
		buffer:search_anchor()
		-- Prevent an infinite loop in the (likely) event of malformed xml
		if buffer:search_next(0x00200000, pattern) == -1 then
			buffer:set_sel(oldPos, oldPos)
			return
		end
		if buffer:get_sel_text():match("^</") then
			count = count - 1
		else
			count = count + 1
		end
		-- Note the name of the ending tag so that the next loop can run a bit
		-- faster.
		tagName = buffer:get_sel_text():match("^</(%S+)>$")
		buffer:char_right()
	end
	-- Save the end position of the ending tag
	local endPos = buffer.current_pos
	-- Back up the position of the cursor to before the ending tag
	buffer:search_anchor()
	buffer:search_prev(4, "<")
	-- Search for the matching opening tag
	local startPattern = "</?"..tagName
	count = 1
	while count ~= 0 do
		buffer:search_anchor()
		-- Prevent an infinite loop in the (likely) event of malformed xml
		if buffer:search_prev(0x00200000, startPattern) == -1 then
			buffer:set_sel(oldPos, oldPos)
			return
		end
		if buffer:get_sel_text():match("</") then
			count = count + 1
		else
			count = count - 1
		end
	end
	local startPos = buffer.current_pos
	-- Set the selection
	buffer:set_sel(startPos, endPos)
end

--------------------------------------------------------------------------------
-- For internal use. Returns the name of any tag open at the cursor position
--------------------------------------------------------------------------------
local function findOpenTag()
	local buffer = buffer
	local stack = {}
	local endLine = buffer:line_from_position(buffer.current_pos)
	for i = 0, endLine do
		local first = 0;
		local last = 0;
		text = buffer:get_line(i)
		first, last = text:find("</?[^%s>%?!]+.->", last)
		while first ~= nil and text:sub(first, last):find("/>") == nil do
			local tagName = text:match("<(/?[^%s>%?!]+).->", first)
			if tagName:find("^/") then
				if #stack == 0 then
					return nil
				elseif "/"..stack[#stack] == tagName then
					table.remove(stack)
				else
					break
				end
			else
				table.insert(stack, tagName)
			end
			first, last = text:find("</?[^%s>%?!]+.->", last)
		end
	end
	return stack[#stack]
end

--------------------------------------------------------------------------------
-- Call this one whenever you want a tag closed
--------------------------------------------------------------------------------
function M.completeClosingTag()
	buffer:begin_undo_action()
	local buffer = buffer
	local tagName = findOpenTag()
	if tagName ~= nil then
		buffer:add_text("</"..tagName..">")
	end
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Call this function when a '>' character is inserted. It is not recommended to
-- use this with autoTag.
--
-- ['>'] = {completeClosingTagBracket},
--------------------------------------------------------------------------------
function M.completeClosingTagBracket()
	buffer:begin_undo_action()
	local buffer = buffer
	local pos = buffer.current_pos
	buffer:insert_text(pos, ">")
	local tagName = findOpenTag()
	if tagName ~= nil then
		buffer:set_selection(pos + 1, pos + 1)
		buffer:add_text("</"..tagName..">")
	end
	buffer:set_sel(pos + 1, pos + 1)
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Uses the multiple-cursor feature to close tags as you type them. It is not
-- recommended to use this with completeClosingTagBracket
--
-- ['<'] = {autoTag},
--------------------------------------------------------------------------------
function M.autoTag()
	buffer:begin_undo_action()
	local pos = buffer.current_pos
	buffer:insert_text(pos, "<></>")
	buffer:set_selection(pos + 4, pos + 4, 0)
	buffer:add_selection(pos + 1, pos + 1)
	buffer:end_undo_action()
end

local function toggleComment()
	buffer:begin_undo_action()
	local text = buffer:get_sel_text()
	local first = text:match("<!%-%-(.-)%-%->")
	if first == nil then
		buffer:replace_sel("<!--"..text.."-->")
	else
		buffer:replace_sel(first)
	end
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Opens an XML/HTML comment. Use this only if using autoTag.
--
-- ['!'] = {completeComment},
--------------------------------------------------------------------------------
function M.completeComment()
	buffer:begin_undo_action()
	local text = buffer:get_sel_text()
	if #text > 0 then
		toggleComment()
	else
		local pos = buffer.current_pos
		buffer:set_selection(pos, pos + 4)
		if buffer:get_sel_text() == "></>" then
			buffer:replace_sel("!--  -->")
			buffer:set_selection(pos + 4, pos + 4)
		else
			buffer:set_selection(pos, pos)
			buffer:add_text("!")
		end
	end
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Call this in response to a ? being inserted. Use this only if using autoTag.
--
-- ['?'] = {completePHP},
--------------------------------------------------------------------------------
function M.completePHP()
	buffer:begin_undo_action()
	local pos = buffer.current_pos
	buffer:set_selection(pos, pos + 4)
	if buffer:get_sel_text() == "></>" then
		buffer:replace_sel("?php  ?>")
		buffer:set_selection(pos + 5, pos + 5)
	else
		buffer:set_selection(pos, pos)
		buffer:add_text("?")
	end
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Bind this to a '/' character being inserted. This cancels the above function
-- for tags like <br/>. Use this only if using autoTag.
--
-- ['/'] = {singleTag},
--------------------------------------------------------------------------------
function M.singleTag()
	buffer:begin_undo_action()
	if buffer.selections > 1 then
		local pos = buffer.current_pos
		buffer:set_sel(pos - 1, pos)
		if buffer:get_sel_text() =="<" then
			buffer:set_selection(pos, pos + 4)
			if buffer:get_sel_text() == "></>" then
				buffer:replace_sel("/>")
				buffer:set_selection(pos + 1, pos + 1)
				buffer:end_undo_action()
				return
			else
				buffer:set_selection(pos, pos)
			end
		else
			buffer:set_selection(pos, pos)
		end
		buffer:set_sel(pos, pos + 2)
		local text = buffer:get_sel_text()
		if text == "><" then
			local doKill = true
			while text:find("></[^>%s]+>") == nil do
				if buffer.selection_end == buffer.line_end_position then
					doKill = false
				end
				buffer:char_right_extend()
				text = buffer:get_sel_text()
			end
			buffer:replace_sel("/>")
			buffer:set_selection(pos, pos)
		else
			buffer:set_selection(pos, pos)
			buffer:add_text("/")
		end
	else
		buffer:add_text("/")
	end
	buffer:end_undo_action()
end

function M.handleBackspace()
	if buffer.selections == 2 then
		buffer:begin_undo_action()
		local pos1 = buffer.current_pos
		buffer:rotate_selection()
		local pos2 = buffer.current_pos
		buffer:set_sel(pos1 - 1, pos1 + 5)
		if buffer:get_sel_text() == "<></>" then
			buffer:replace_sel("")
			buffer:goto_pos(pos1)
			buffer:end_undo_action()
		else
			buffer:set_sel(pos2, pos2)
			buffer:add_selection(pos1, pos1)
			buffer:end_undo_action()
			return false
		end
	else
		return false
	end
end

--------------------------------------------------------------------------------
-- Call this when the spacebar is pressed. Use this only if using autoTag.
--
-- [' '] = {handleSpace},
--------------------------------------------------------------------------------
function M.handleSpace()
	buffer:begin_undo_action()
	local pos = buffer.current_pos
	if buffer.selections > 1 then
		buffer:clear_selections()
		buffer:set_sel(pos, pos)
		buffer:add_text(" ")
	else
		if #buffer:get_sel_text() > 0 then
			buffer:replace_sel(" ")
		else
			buffer:add_text(" ")
		end
	end
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Enclose the selection in a tag
--------------------------------------------------------------------------------
function M.encloseTag()
	buffer:begin_undo_action()
	local text = buffer:get_sel_text()
	local start = buffer.selection_start
	buffer:replace_sel("<>"..text.."</>")
	local leftCursorPos = start + 1
	local rightCursorPos = start + 4 + #text
	buffer:set_selection(rightCursorPos, rightCursorPos)
	buffer:add_selection(leftCursorPos, leftCursorPos)
	buffer:end_undo_action()
end

--------------------------------------------------------------------------------
-- Toggles line comments on the selected lines
--------------------------------------------------------------------------------
function M.toggleLineComment()
	buffer:begin_undo_action()
	local initial = buffer:line_from_position(buffer.current_pos)
	local first = initial
	local last = buffer:line_from_position(buffer.anchor)
	if first > last then first, last = last, first end
	for i = first, last do
		buffer:goto_line(i)
		buffer:home()
		buffer:line_end_extend()
		toggleComment()
	end
	buffer:goto_line(initial)
	buffer:end_undo_action()
end

function M.reformat()
	buffer:begin_undo_action()
	local fileName = os.tmpname()
	local p = io.popen("xmllint --format - > " .. fileName, "w")
	local b = buffer:get_text():gsub("\t%d$", "")
	p:write(b)
	p:flush()
	p:close()
	local f = io.open(fileName, "r")
	if f ~= nil then
		local t = f:read("*a")
		buffer:select_all()
		buffer:clear()
		buffer:add_text(t)
	end
	os:remove(fileName)
	buffer:end_undo_action()
end

local pcall = pcall
local highlightMatchingTagName = highlightMatchingTagName

-- This variable helps prevent stack overflows
local lockdepth = 0
function highlightEvent()
	local buffer = buffer
	lockdepth = lockdepth + 1
	if lockdepth == 1 then
		local ok, lexLang = pcall(buffer.get_lexer, buffer)
		if lexLang == "xml" or lexLang == "hypertext" or lexLang == "php" then
			-- Use pcall because it's impossible to guarantee that the buffer
			-- will be valid when calling highlightMatchingTagName
			pcall(highlightMatchingTagName)
		end
	end
	lockdepth = lockdepth - 1
end
events.connect(events.UPDATE_UI, highlightEvent)

return M
