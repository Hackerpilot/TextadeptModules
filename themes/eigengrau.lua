local view, colors, styles = view, lexer.colors, lexer.styles

-- required colors
colors.yellow   = 0x66bab2 -- highlight color from editing.lua
colors.orange   = 0x222222 -- highlight color from editing.lua
colors.red      = 0x6161c2 -- diff lexer
colors.green    = 0x81cc81 -- diff lexer

colors.base0    = 0x1d1616
colors.base1    = 0x544f4f
colors.base2    = 0x8c8484
colors.base3    = 0xc4b9b9
colors.base4    = 0xf0e1e1
colors.blue1    = 0xceb49b
colors.green1   = 0x93cc93
colors.magenta1 = 0xa680ce
colors.magenta2 = 0xce86ce
colors.orange1  = 0x6192c2
colors.red1     = 0x6161c2
colors.teal1    = 0xcece69
colors.teal2    = 0x999900
colors.yellow1  = 0x66bab2

-- Default font.
font = 'Fira Code'
size = 11
if WIN32 then
  font = 'Consolas'
elseif OSX then
  font = 'Monaco'
end

-- Predefined styles.
styles.default     = {font = font, size = size, fore = colors.base4, back = colors.base0}
styles.line_number  = {fore = colors.base2, back = colors.base0}
styles.brace_light  = {fore = colors.base2, back = colors.green1, bold = true}
styles.brace_bad    = {fore = colors.text0, back = colors.red1, bold = true}
styles.indent_guide = {fore = colors.base1}
styles.call_tip     = {fore = colors.base4, back = colors.base0}

-- Token styles.
styles.nothing      = {}
styles.class        = {fore = colors.yellow1}
styles.comment      = {fore = colors.base2, italics = true}
styles.constant     = {fore= colors.magenta2, bold = true}
styles.error        = {fore = colors.red1, italics = true, bold = true, underline = true}
styles['function']     = {fore = colors.blue1}
styles.keyword      = {fore = colors.green1, bold = true}
styles.label        = {fore = colors.base3}
styles.number       = {fore = colors.teal2}
styles.operator     = {fore = colors.base3, bold = true}
styles.regex        = {fore = colors.teal1}
styles.string       = {fore = colors.teal1}
styles.preprocessor = {fore = colors.magenta1}
styles.type         = {fore = colors.orange1, bold = true}
styles.variable     = {fore = colors.base3, italics = true}
styles.whitespace   = {}
styles.embedded     = {back = colors.base2}
styles.identifier   = {}


-- Caret and Selection Styles.
view:set_sel_fore(true, colors.base0)
view:set_sel_back(true, colors.base2)
view.caret_fore = colors.base4
view.caret_line_back = colors.base3
view.caret_line_back_alpha = 32

-- Fold Margin.
view:set_fold_margin_color(true, colors.base1)
view:set_fold_margin_hi_color(true, colors.base1)

-- Markers.
view.marker_fore[textadept.bookmarks.MARK_BOOKMARK] = colors.base4
view.marker_back[textadept.bookmarks.MARK_BOOKMARK] = colors.dark_blue
view.marker_fore[textadept.run.MARK_WARNING] = colors.base4
view.marker_back[textadept.run.MARK_WARNING] = colors.light_yellow
view.marker_fore[textadept.run.MARK_ERROR] = colors.base4
view.marker_back[textadept.run.MARK_ERROR] = colors.light_red
for i = buffer.MARKNUM_FOLDEREND, buffer.MARKNUM_FOLDEROPEN do -- fold margin
  view.marker_fore[i] = colors.base4
  view.marker_back[i] = colors.base1
  view.marker_back_selected[i] = colors.grey_black
end

-- Long Lines.
view.edge_color = colors.base1

view.indic_fore[ui.find.INDIC_FIND] = colors.yellow
view.indic_alpha[ui.find.INDIC_FIND] = 128
view.indic_fore[textadept.editing.INDIC_BRACEMATCH] = colors.grey
view.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = colors.orange
view.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 128
view.indic_fore[textadept.snippets.INDIC_PLACEHOLDER] = colors.grey_black
