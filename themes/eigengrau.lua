local buffer = buffer
local property, property_int = buffer.property, buffer.property_int

-- required colors
property['color.yellow'] =         0x627e8c -- highlight color from editing.lua
property['color.orange'] =         0x222222 -- highlight color from editing.lua
property['color.red'] =            0x62628c -- diff lexer
property['color.green'] =          0x628c62 -- diff lexer

property['color.base0'] = 0x1d1616
property['color.base1'] = 0x4d4d4d
property['color.base2'] = 0x808080
property['color.base3'] = 0xe6e6e6
property['color.base4'] = 0xcccccc
property['color.teal1'] = 0xb3b374
property['color.teal2'] = 0xbaba0a
property['color.green1'] = 0x7ead79
property['color.blue1'] = 0xad8a79
property['color.red1'] = 0x4f4fc4
property['color.red2'] = 0x666691
property['color.magenta1'] = 0xc489a4
property['color.yellow1'] = 0x66bab2

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
property['style.nothing'] = ''
property['style.class'] = 'fore:%(color.teal2),bold'
property['style.comment'] = 'fore:%(color.base2)'
property['style.constant'] = 'fore:%(color.yellow1)'
property['style.error'] = 'fore:%(color.red1),italics,bold,underline'
property['style.function'] = 'fore:%(color.blue1)'
property['style.keyword'] = 'fore:%(color.green1),bold'
property['style.label'] = 'fore:%(color.base3)'
property['style.number'] = 'fore:%(color.yellow1),bold'
property['style.operator'] = 'fore:%(color.base3),bold'
property['style.regex'] = 'fore:%(color.teal1)'
property['style.string'] = 'fore:%(color.teal1)'
property['style.preprocessor'] = 'fore:%(color.magenta1),bold'
property['style.type'] = 'fore:%(color.red2),bold'
property['style.variable'] = 'fore:%(color.base2),italic'
property['style.whitespace'] = ''
property['style.embedded'] = '%(style.tag),back:%(color.base2)'
property['style.identifier'] = '%(style.nothing)'

-- Predefined styles.
property['style.default'] = 'font:%(font),size:%(fontsize),'..
                            'fore:%(color.base4),back:%(color.base0)'
property['style.linenumber'] = 'fore:%(color.base2),back:%(color.base0)'
property['style.bracelight'] = 'fore:%(color.base2),back:%(color.green1),bold'
property['style.bracebad'] = 'fore:%(color.text0),back:%(color.red1),bold'
property['style.controlchar'] = '%(style.nothing)'
property['style.indentguide'] = 'fore:%(color.base2)'
property['style.calltip'] = 'fore:%(color.base4),back:%(color.base0)'

-- Multiple Selection and Virtual Space
--buffer.additional_sel_alpha =
--buffer.additional_sel_fore =
--buffer.additional_sel_back =
--buffer.additional_caret_fore =

-- Caret and Selection Styles.
buffer:set_sel_fore(true, property_int['color.base2'])
buffer:set_sel_back(true, property_int['color.base3'])
--buffer.sel_alpha =
buffer.caret_fore = property_int['color.base4']
buffer.caret_line_back = property_int['color.base2']
buffer.caret_line_back_alpha = 32

-- Fold Margin.
buffer:set_fold_margin_colour(true, property_int['color.base1'])
buffer:set_fold_margin_hi_colour(true, property_int['color.base1'])

-- Fold Margin Markers.
local c = _SCINTILLA.constants

buffer.marker_fore[c.MARKNUM_FOLDEROPEN] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDEROPEN] = property_int['color.base1']

buffer.marker_fore[c.MARKNUM_FOLDER] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDER] = property_int['color.base1']

buffer.marker_fore[c.MARKNUM_FOLDERSUB] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDERSUB] = property_int['color.base1']

buffer.marker_fore[c.MARKNUM_FOLDERTAIL] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDERTAIL] = property_int['color.base1']

buffer.marker_fore[c.MARKNUM_FOLDEREND] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDEREND] = property_int['color.base1']

buffer.marker_fore[c.MARKNUM_FOLDEROPENMID] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDEROPENMID] = property_int['color.base1']

buffer.marker_fore[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.base4']
buffer.marker_back[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.base1']

-- Long Lines.
buffer.edge_colour = property_int['color.base1']

buffer.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = 0x627e8c
buffer.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 128
buffer.indic_style[textadept.editing.INDIC_HIGHLIGHT] = c.INDIC_ROUNDBOX
