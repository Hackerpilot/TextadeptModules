local buffer = buffer
local property, property_int = buffer.property, buffer.property_int
local colors, styles = lexer.colors, lexer.styles


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
property['font'], property['fontsize'] = 'Fira Code', 11
--property['font'], property['fontsize'] = 'DejaVu Sans Mono', 10
--property['font'], property['fontsize'] = 'Source Code Pro', 10
if WIN32 then
  property['font'] = 'Consolas'
elseif OSX then
  property['font'], property['fontsize'] = 'Monaco', 12
end

-- Token styles.
styles.nothing      = ''
styles.class        = 'fore:%(color.yellow1)'
styles.comment      = 'fore:%(color.base2),italics'
styles.constant     = 'fore:%(color.magenta2),bold'
styles.error        = 'fore:%(color.red1),italics,bold,underline'
styles.function     = 'fore:%(color.blue1)'
styles.keyword      = 'fore:%(color.green1),bold'
styles.label        = 'fore:%(color.base3)'
styles.number       = 'fore:%(color.teal2)'
styles.operator     = 'fore:%(color.base3),bold'
styles.regex        = 'fore:%(color.teal1)'
styles.string       = 'fore:%(color.teal1)'
styles.preprocessor = 'fore:%(color.magenta1)'
styles.type         = 'fore:%(color.orange1),bold'
styles.variable     = 'fore:%(color.base3),italics'
styles.whitespace   = ''
styles.embedded     = '%(style.tag),back:%(color.base2)'
styles.identifier   = '%(style.nothing)'

-- Predefined styles.
styles.default     = 'font:%(font),size:%(fontsize),'..
                                'fore:%(color.base4),back:%(color.base0)'
styles.linenumber  = 'fore:%(color.base2),back:%(color.base0)'
styles.bracelight  = 'fore:%(color.base2),back:%(color.green1),bold'
styles.bracebad    = 'fore:%(color.text0),back:%(color.red1),bold'
styles.controlchar = '%(style.nothing)'
styles.indentguide = 'fore:%(color.base1)'
styles.calltip     = 'fore:%(color.base4),back:%(color.base0)'

-- Multiple Selection and Virtual Space
--view.additional_sel_alpha =
--view.additional_sel_fore =
--view.additional_sel_back =
--view.additional_caret_fore =

-- Caret and Selection Styles.
view:set_sel_fore(true, property_int['color.base0'])
view:set_sel_back(true, property_int['color.base2'])
--view.sel_alpha =
view.caret_fore = property_int['color.base4']
view.caret_line_back = property_int['color.base3']
view.caret_line_back_alpha = 32

-- Fold Margin.
view:set_fold_margin_colour(true, property_int['color.base1'])
view:set_fold_margin_hi_colour(true, property_int['color.base1'])

-- Fold Margin Markers.
local c = _SCINTILLA.constants

view.marker_fore[c.MARKNUM_FOLDEROPEN] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDEROPEN] = property_int['color.base1']

view.marker_fore[c.MARKNUM_FOLDER] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDER] = property_int['color.base1']

view.marker_fore[c.MARKNUM_FOLDERSUB] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDERSUB] = property_int['color.base1']

view.marker_fore[c.MARKNUM_FOLDERTAIL] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDERTAIL] = property_int['color.base1']

view.marker_fore[c.MARKNUM_FOLDEREND] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDEREND] = property_int['color.base1']

view.marker_fore[c.MARKNUM_FOLDEROPENMID] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDEROPENMID] = property_int['color.base1']

view.marker_fore[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.base4']
view.marker_back[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.base1']

-- Long Lines.
view.edge_color = property_int['color.base1']

view.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = 0x627e8c
view.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 128
view.indic_style[textadept.editing.INDIC_HIGHLIGHT] = view.INDIC_ROUNDBOX
