local M = {}

cstyle = require "common.cstyle"
dcd = require "dmd.dcd"

if type(_G.snippets) == 'table' then
  _G.snippets.dmd = {}
end

if type(_G.keys) == 'table' then
  _G.keys.dmd = {}
end


textadept.editing.comment_string.dmd = '//'
textadept.run.compile_commands.dmd = 'dmd -c -o- %(filename)'
textadept.run.error_patterns.dmd = {
	pattern = '^(.-)%((%d+)%): (.+)$',
	filename = 1, line = 2, message = 3
}

events.connect(events.CHAR_ADDED, function(ch)
	if ch > 255 then return end
	if string.char(ch) == '(' or string.char(ch) == '.' then
		dcd.autocomplete(ch)
	end
end)

events.connect(events.FILE_AFTER_SAVE, function()
	if buffer:get_lexer() ~= "dmd" then return end
	buffer:annotation_clear_all()
	local command = "dscanner --styleCheck 2>&1 " .. buffer.filename
	local p = io.popen(command)
	for line in p:lines() do
		lineNumber, column, level, message = string.match(line, "^.-%((%d+):(%d+)%)%[(%w+)%]: (.+)$")
		if lineNumber == nil then return end
		local l = tonumber(lineNumber) - 1
		if l >= 0 then
			local c = tonumber(column)
			if level == "error" then
				buffer.annotation_style[l] = 8
			elseif buffer.annotation_style[l] ~= 8 then
				buffer.annotation_style[l] = 2
			end

			local t = buffer.annotation_text[l]
			if #t > 0 then
				buffer.annotation_text[l] = buffer.annotation_text[l] .. "\n" .. message
			else
				buffer.annotation_text[l] = message
			end
		end
	end
end)

local function expandContext(meta)
	local patterns = {"struct:(%w+)", "class:([%w_]+)", "template:([%w_]+)",
		"interface:([%w_]+)", "union:([%w_]+)", "function:([%w_]+)"}
	if meta == nil or meta == "" then return "" end
	for item in meta:gmatch("%w+:[%w%d_]+") do
		for _, pattern in ipairs(patterns) do
			local result = item:match(pattern)
			if result ~= nil then return result end
		end
	end
	return ""
end

local function expandCtagsType(tagType)
    if tagType == "g" then return "enum"
    elseif tagType == "e" then return ""
    elseif tagType == "v" then return "variable"
    elseif tagType == "i" then return "interface"
    elseif tagType == "c" then return "class"
    elseif tagType == "s" then return "struct"
    elseif tagType == "f" then return "function"
    elseif tagType == "u" then return "union"
    elseif tagType == "T" then return "template"
	else return "" end
end

local function symbolIndex()
	local fileName = os.tmpname()
	local tmpFile = io.open(fileName, "w")
	tmpFile:write(buffer:get_text():sub(1, buffer.length))
	tmpFile:flush()
	tmpFile:close()
	local command = "dscanner --ctags " .. fileName
	local p = io.popen(command, "r")
	local r = p:read("*a")
	p:close()
	os.remove(fileName)
	local symbolList = {}
	local i = 0
	local lineDict = {}
	for line in r:gmatch("(.-)\n") do
		if not line:match("^!") then
			local name, file, lineNumber, tagType, meta = line:match("([~%w_]+)\t([%w/_ ]+)\t(%d+);\"\t(%w)\t?(.*)")
			table.insert(symbolList, name)
			table.insert(symbolList, expandCtagsType(tagType))
			table.insert(symbolList, expandContext(meta))
			table.insert(symbolList, lineNumber)
			lineDict[i + 1] = tonumber(lineNumber - 1)
			i = i + 1
		end
	end
	local button, i = ui.dialogs.filteredlist{
		title = "Go to symbol",
		columns = {"Name", "Type", "Context", "Line"},
		items = symbolList
	}
	if i ~= nil then
		buffer:goto_line(lineDict[i])
	end
end

local function autocomplete()
	dcd.registerImages()
	dcd.autocomplete()
	if not buffer:auto_c_active() then
		textadept.editing.autocomplete("word")
	end
end

-- D-specific key commands.
keys.dmd = {
	[keys.LANGUAGE_MODULE_PREFIX] = {
		m = { io.open_file,
		(_USERHOME..'/modules/dmd/init.lua'):iconv('UTF-8', _CHARSET) },
	},
	['a\n'] = {cstyle.newline},
	['s\n'] = {cstyle.newline_semicolon},
	['c;'] = {cstyle.endline_semicolon},
	['}'] = {cstyle.match_brace_indent},
	['c{'] = {cstyle.openBraceMagic, true},
	['cM'] = {cstyle.selectScope},
	['\n'] = {cstyle.enter_key_pressed},
	['c\n'] = {autocomplete},
	['cH'] = {dcd.showDoc},
	['down'] = {dcd.cycleCalltips, 1},
	['up'] = {dcd.cycleCalltips, -1},
	['cG'] = {dcd.gotoDeclaration},
	['cM'] = {symbolIndex}
}

local snippets = _G.snippets

if type(snippets) == 'table' then
	snippets.dmd = {
		gpl = [[/*******************************************************************************
 * Authors: %1(Your name here)
 * Copyright: %1
 * Date: %[date | cut -c 5-10] %[date | cut -c 25-]
 *
 * License:
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License version
 * 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 * MA 02111-1307, USA.
 ******************************************************************************/

%0]],
			gpl3 = [[/*******************************************************************************
 * Authors: %1(Your name here)
 * Copyright: %1
 * Date: %[date | cut -c 5-10] %[date | cut -c 25-]
 *
 * License:
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/

%0]],
		mit = [[/*******************************************************************************
 * The MIT License
 *
 * Copyright (c) %[date | cut -c 25-] %1(Your name here)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

%0]],
		boost = [[/*******************************************************************************
 * Boost Software License - Version 1.0 - August 17th, 2003
 *
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 *
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/
]],
		banner = [[/%<string.rep("*", buffer.edge_column - buffer.column[buffer.current_pos] - 1)>
 * %0
 %<string.rep("*", buffer.edge_column - buffer.column[buffer.current_pos] - 2)>/]],
		fun = [[%1(return type) %2(name)(%3(parameters))
{
	%0
	return ;
}]],
		vfun = [[void %1(name)(%2(parameters))
{
	%0
}]],
		main = [[void main(string[] args)
{
	%0
}]],
		['for'] = [[for (%1(initilization); %2(condition); %3(increment))
{
	%0
}]],
		fore = [[foreach (%1(var); %2(range))
{
	%0
}]],
		forei = [[foreach (%1(i); 0..%2(n))
{
	%0
}]],
		forr = [[foreach (ref %1(var); %2(range))
{
	%0
}]],
		fori = [[for (size_t i = 0; i != %1(condition); ++i)
{
	%0
}]],
		['while'] = [[while (%1(condition))
{
	%0
}]],
		['if'] = [[if (%1(condition))
{
	%0
}]],
		dw = [[do
{
	%0
} while (%1(condition));]],
		switch = [[switch (%1(value))
{
%0
default:
	break;
}]],
		fswitch = [[final switch (%1(value))
{
%0
default:
	break;
}]],
		case = [[case %1:
	%0
	break;]],
		class = [[class %1(name)
{
public:

private:
	%0
}]],
		struct = [[struct %1(name)
{
	%0
}]],
		mem = 'm_%1 = %1;\n%0',
		wf = 'writef(%0);',
		wl = 'writeln(%0);',
		wfl = 'writefln(%0);',
		imp = 'import',
		sta = 'static',
		st = 'string',
		wch = 'wchar',
		dch = 'dchar',
		ch = 'char',
		dou = 'double',
		fl = 'float',
		by = 'byte',
		ret = 'return',
		im = 'immutable',
		co = 'const',
		ty = 'typeof',
		iit = [[if(is(typeof(%1)))
{
	%0
}]],
		itc = [[if(__traits(compiles, %1))
{
	%0
}]],
		sif = [[static if(%1)
{
	%0
}]],
	}
end


function M.set_buffer_properties()
end

return M
