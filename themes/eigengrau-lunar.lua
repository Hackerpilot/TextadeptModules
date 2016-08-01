local buffer = buffer
local property, property_int = buffer.property, buffer.property_int

-- required colors
property['color.yellow'] =         0x627e8c -- highlight color from editing.lua
property['color.orange'] =         0x222222 -- highlight color from editing.lua
property['color.red'] =            0x62628c -- diff lexer
property['color.green'] =          0x628c62 -- diff lexer

property['color.background'] =     0x1d1616
property['color.text0'] =          0x696970
property['color.text1'] =          0x9f9fa8
property['color.text2'] =          0xadadc4
property['color.text3'] =          0x899dc4
property['color.white'] =          0xe0d3d3
property['color.black'] =          0x000000
property['color.green1'] =         0x628c62
property['color.green2'] =         0x76a876
property['color.red1'] =           0x62628c
property['color.red2'] =           0x7676a8
property['color.yellow1'] =        0x627e8c
property['color.yellow2'] =        0x89b1c4
property['color.orange1'] =        0x54678c
property['color.orange2'] =        0x6592a8
property['color.brown1'] =         0x8c8c62
property['color.brown2'] =         0x76a8a8
property['color.blue1'] =          0x8c6754
property['color.blue2'] =          0xa89265
property['color.cyan1'] =          0x628c8c
property['color.cyan2'] =          0xa8a876
property['color.caret_fore'] =     0xc4b9b9
property['color.selection_fore'] = 0x382b2b
property['color.selection_back'] = 0xc4acac
property['color.edge'] =           0x382b2b

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
property['style.class'] = 'fore:%(color.text3),bold'
property['style.comment'] = 'fore:%(color.text0)'
property['style.constant'] = 'fore:%(color.yellow2)'
property['style.error'] = 'fore:%(color.red1),italics,bold,underline'
property['style.function'] = 'fore:%(color.text3)'
property['style.keyword'] = 'fore:%(color.blue1),bold'
property['style.label'] = 'fore:%(color.text2)'
property['style.number'] = 'fore:%(color.green2),bold'
property['style.operator'] = 'fore:%(color.text2),bold'
property['style.regex'] = 'fore:%(color.green1)'
property['style.string'] = 'fore:%(color.green1)'
property['style.preprocessor'] = 'fore:%(color.red2),bold'
property['style.type'] = 'fore:%(color.blue2),bold'
property['style.variable'] = 'fore:%(color.text1),italic'
property['style.whitespace'] = ''
property['style.embedded'] = '%(style.tag),back:%(color.edge)'
property['style.identifier'] = '%(style.nothing)'

-- Predefined styles.
property['style.default'] = 'font:%(font),size:%(fontsize),'..
                            'fore:%(color.text1),back:%(color.background)'
property['style.linenumber'] = 'fore:%(color.text0),back:%(color.background)'
property['style.bracelight'] = 'fore:%(color.text0),back:%(color.green2),bold'
property['style.bracebad'] = 'fore:%(color.text0),back:%(color.red1),bold'
property['style.controlchar'] = '%(style.nothing)'
property['style.indentguide'] = 'fore:%(color.edge)'
property['style.calltip'] = 'fore:%(color.text1),back:%(color.background)'

-- Multiple Selection and Virtual Space
--buffer.additional_sel_alpha =
--buffer.additional_sel_fore =
--buffer.additional_sel_back =
--buffer.additional_caret_fore =

-- Caret and Selection Styles.
buffer:set_sel_fore(true, property_int['color.selection_fore'])
buffer:set_sel_back(true, property_int['color.selection_back'])
--buffer.sel_alpha =
buffer.caret_fore = property_int['color.caret_fore']
buffer.caret_line_back = property_int['color.text0']
buffer.caret_line_back_alpha = 32

-- Fold Margin.
buffer:set_fold_margin_colour(true, property_int['color.background'])
buffer:set_fold_margin_hi_colour(true, property_int['color.background'])

-- Fold Margin Markers.
local c = _SCINTILLA.constants

buffer.marker_fore[c.MARKNUM_FOLDEROPEN] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDEROPEN] = property_int['color.text1']

buffer.marker_fore[c.MARKNUM_FOLDER] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDER] = property_int['color.text1']

buffer.marker_fore[c.MARKNUM_FOLDERSUB] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDERSUB] = property_int['color.text1']

buffer.marker_fore[c.MARKNUM_FOLDERTAIL] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDERTAIL] = property_int['color.text1']

buffer.marker_fore[c.MARKNUM_FOLDEREND] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDEREND] = property_int['color.text1']

buffer.marker_fore[c.MARKNUM_FOLDEROPENMID] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDEROPENMID] = property_int['color.text1']

buffer.marker_fore[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.background']
buffer.marker_back[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.text1']

-- Long Lines.
buffer.edge_colour = property_int['color.edge']

buffer.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = 0x627e8c
buffer.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 128
buffer.indic_style[textadept.editing.INDIC_HIGHLIGHT] = c.INDIC_ROUNDBOX
