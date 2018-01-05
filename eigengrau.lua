local buffer = buffer
local property, property_int = buffer.property, buffer.property_int

-- required colors
property['color.yellow']   = 0x66bab2 -- highlight color from editing.lua
property['color.orange']   = 0x222222 -- highlight color from editing.lua
property['color.red']      = 0x6161c2 -- diff lexer
property['color.green']    = 0x81cc81 -- diff lexer

property['color.base0']    = 0x1d1616
property['color.base1']    = 0x544f4f
property['color.base2']    = 0x8c8484
property['color.base3']    = 0xc4b9b9
property['color.base4']    = 0xf0e1e1
property['color.blue1']    = 0xceb49b
property['color.green1']   = 0x93cc93
property['color.magenta1'] = 0xa680ce
property['color.magenta2'] = 0xce86ce
property['color.orange1']  = 0x6192c2
property['color.red1']     = 0x6161c2
property['color.teal1']    = 0xcece69
property['color.teal2']    = 0x999900
property['color.yellow1']  = 0x66bab2

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
property['style.nothing']      = ''
property['style.class']        = 'fore:%(color.yellow1)'
property['style.comment']      = 'fore:%(color.base2),italics'
property['style.constant']     = 'fore:%(color.magenta2),bold'
property['style.error']        = 'fore:%(color.red1),italics,bold,underline'
property['style.function']     = 'fore:%(color.blue1)'
property['style.keyword']      = 'fore:%(color.green1),bold'
property['style.label']        = 'fore:%(color.base3)'
property['style.number']       = 'fore:%(color.teal2)'
property['style.operator']     = 'fore:%(color.base3),bold'
property['style.regex']        = 'fore:%(color.teal1)'
property['style.string']       = 'fore:%(color.teal1)'
property['style.preprocessor'] = 'fore:%(color.magenta1)'
property['style.type']         = 'fore:%(color.orange1),bold'
property['style.variable']     = 'fore:%(color.base3),italics'
property['style.whitespace']   = ''
property['style.embedded']     = '%(style.tag),back:%(color.base2)'
property['style.identifier']   = '%(style.nothing)'

-- Predefined styles.
property['style.default']     = 'font:%(font),size:%(fontsize),'..
                                'fore:%(color.base4),back:%(color.base0)'
property['style.linenumber']  = 'fore:%(color.base2),back:%(color.base0)'
property['style.bracelight']  = 'fore:%(color.base2),back:%(color.green1),bold'
property['style.bracebad']    = 'fore:%(color.text0),back:%(color.red1),bold'
property['style.controlchar'] = '%(style.nothing)'
property['style.indentguide'] = 'fore:%(color.base1)'
property['style.calltip']     = 'fore:%(color.base4),back:%(color.base0)'

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