local buffer = buffer
local c = _SCINTILLA.constants

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
