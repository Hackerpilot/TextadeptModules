local buffer = buffer
local property, property_int = buffer.property, buffer.property_int

-- required colors
property['color.yellow'] =         0x627e8c -- highlight color from editing.lua
property['color.orange'] =         0x222222 -- highlight color from editing.lua
property['color.red'] =            0x62628c -- diff lexer
property['color.green'] =          0x628c62 -- diff lexer


-- 0x%w+ %-%- #(%w%w)(%w%w)(%w%w)
-- 0x%3%2%1 -- #%1%2%3
property['color.c00'] = 0x161616 -- #161616
property['color.c01'] = 0xBFBFBF -- #BFBFBF
property['color.c02'] = 0x7777d9 -- #BF6969
property['color.c03'] = 0x4B4BA6 -- #A64B4B
property['color.c04'] = 0x3F3F8C -- #8C3F3F
property['color.c05'] = 0xBF7C9E -- #9E7CBF
property['color.c06'] = 0xA66C89 -- #896CA6
property['color.c07'] = 0x8C5B74 -- #745B8C
property['color.c08'] = 0x404040 -- #404040
property['color.c09'] = 0x666666 -- #666666
property['color.c0a'] = 0x7CAEBF -- #BFAE7C
property['color.c0b'] = 0x6C97A6 -- #A6976C
property['color.c0c'] = 0x5B808C -- #8C805B
property['color.c0d'] = 0x8DBF7C -- #7CBF8D
property['color.c0e'] = 0x7AA66C -- #6CA67A
property['color.c0f'] = 0x678C5B -- #5B8C67

-- Default font.
--property['font'], property['fontsize'] = 'DejaVu Sans Mono', 10
--property['font'], property['fontsize'] = 'Source Code Pro', 10
property['font'], property['fontsize'] = 'FiraCode', 10
if WIN32 then
  property['font'] = 'Consolas'
elseif OSX then
  property['font'], property['fontsize'] = 'Monaco', 12
end

-- Token styles.
property['style.nothing'] = ''
property['style.class'] = 'fore:%(color.c06),bold'
property['style.comment'] = 'fore:%(color.c09)'
property['style.constant'] = 'fore:%(color.c0d)'
property['style.error'] = 'fore:%(color.c02),italics,bold,underline'
property['style.function'] = 'fore:%(color.c05)'
property['style.keyword'] = 'fore:%(color.c03),bold'
property['style.label'] = 'fore:%(color.c01)'
property['style.number'] = 'fore:%(color.c0c),bold'
property['style.operator'] = 'fore:%(color.c01),bold'
property['style.regex'] = 'fore:%(color.c01)'
property['style.string'] = 'fore:%(color.c0a)'
property['style.preprocessor'] = 'fore:%(color.c0f),bold'
property['style.type'] = 'fore:%(color.c02),bold'
property['style.variable'] = 'fore:%(color.c01),italic'
property['style.whitespace'] = ''
property['style.embedded'] = '%(style.tag),back:%(color.edge)'
property['style.identifier'] = '%(style.nothing)'

-- Predefined styles.
property['style.default'] = 'font:%(font),size:%(fontsize),'..
                            'fore:%(color.c01),back:%(color.c00)'
property['style.linenumber'] = 'fore:%(color.c09),back:%(color.c00)'
property['style.bracelight'] = 'fore:%(color.c07),back:%(color.c01),bold'
property['style.bracebad'] = 'fore:%(color.c04),back:%(color.c01),bold'
property['style.controlchar'] = '%(style.nothing)'
property['style.indentguide'] = 'fore:%(color.c08)'
property['style.calltip'] = 'fore:%(color.c01),back:%(color.c00)'


-- Caret and Selection Styles.
buffer:set_sel_fore(true, property_int['color.c00'])
buffer:set_sel_back(true, property_int['color.c01'])
buffer.caret_fore = property_int['color.c01']
buffer.caret_line_back = property_int['color.c01']
buffer.caret_line_back_alpha = 32

-- Fold Margin.
buffer:set_fold_margin_colour(true, property_int['color.c00'])
buffer:set_fold_margin_hi_colour(true, property_int['color.c00'])

-- Fold Margin Markers.
local c = _SCINTILLA.constants

buffer.marker_fore[c.MARKNUM_FOLDEROPEN] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDEROPEN] = property_int['color.c09']

buffer.marker_fore[c.MARKNUM_FOLDER] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDER] = property_int['color.c09']

buffer.marker_fore[c.MARKNUM_FOLDERSUB] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDERSUB] = property_int['color.c09']

buffer.marker_fore[c.MARKNUM_FOLDERTAIL] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDERTAIL] = property_int['color.c09']

buffer.marker_fore[c.MARKNUM_FOLDEREND] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDEREND] = property_int['color.c09']

buffer.marker_fore[c.MARKNUM_FOLDEROPENMID] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDEROPENMID] = property_int['color.c09']

buffer.marker_fore[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.c08']
buffer.marker_back[c.MARKNUM_FOLDERMIDTAIL] = property_int['color.c09']

-- Long Lines.
buffer.edge_colour = property_int['color.c08']

buffer.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = 0xBF8D7C
buffer.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 128
buffer.indic_style[textadept.editing.INDIC_HIGHLIGHT] = c.INDIC_ROUNDBOX
