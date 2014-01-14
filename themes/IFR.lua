-- IFR (Instrument Flight Rules) Theme for Textadept

local buffer = buffer
local property, property_int = buffer.property, buffer.property_int

property['color.text'] = 0xa0a0a0
property['color.background'] = 0x3a3230
property['color.darkgrey'] = 0x807070
property['color.bluegrey'] = 0x99816b
property['color.comment'] = 0x808059
property['color.grey'] = 0x444444
property['color.lightgrey'] = 0xbbbbbb
property['color.white'] = 0xd0d0d0
property['color.black'] = 0x000000
property['color.operator'] = 0x7a9999
property['color.red'] = 0x5151cc
property['color.orange'] = 0x1F70BF
property['color.brown'] = 0x3d6a99
property['color.yellow'] = 0x51cccc
property['color.chartreuse'] = 0x6bb38f
property['color.green'] = 0x51cc51
property['color.aquamarine'] = 0x8fcc51
property['color.cyan'] = 0xcccc51
property['color.azure'] = 0xcc9966
property['color.blue'] = 0xE68A5C
property['color.violet'] = 0xcc518f
property['color.magenta'] = 0xcc51cc
property['color.rose'] = 0x8F6BB3

-- Default font.
property['font'], property['fontsize'] = 'DejaVu Sans Mono', 10
if WIN32 then
  property['font'] = 'Consolas'
elseif OSX then
  property['font'], property['fontsize'] = 'Monaco', 12
end

-- Token styles.
property['style.nothing'] = ''
property['style.class'] = 'fore:%(color.cyan),bold'
property['style.comment'] = 'fore:%(color.comment)'
property['style.constant'] = 'fore:%(color.aquamarine)'
property['style.error'] = 'fore:%(color.red),italics,bold,underline'
property['style.function'] = 'fore:%(color.bluegrey)'
property['style.keyword'] = 'fore:%(color.white),bold'
property['style.label'] = 'fore:%(color.white)'
property['style.number'] = 'fore:%(color.orange),bold'
property['style.operator'] = 'fore:%(color.operator),bold'
property['style.regex'] = 'fore:%(color.chartreuse)'
property['style.string'] = 'fore:%(color.chartreuse)'
property['style.preprocessor'] = 'fore:%(color.magenta),bold'
property['style.type'] = 'fore:%(color.brown),bold'
property['style.variable'] = 'fore:%(color.text),italic'
property['style.whitespace'] = ''
property['style.embedded'] = '%(style.tag),back:%(color.grey)'
property['style.identifier'] = '%(style.nothing)'

-- Predefined styles.
property['style.default'] = 'font:%(font),size:%(fontsize),'..
                            'fore:%(color.text),back:%(color.background)'
property['style.linenumber'] = 'fore:%(color.darkgrey),back:%(color.background)'
property['style.bracelight'] = 'fore:%(color.black),back:%(color.green),bold'
property['style.bracebad'] = 'fore:%(color.black),back:%(color.red),bold'
property['style.controlchar'] = '%(style.nothing)'
property['style.indentguide'] = 'fore:%(color.grey)'
property['style.calltip'] = 'fore:%(color.text),back:%(color.background)'

-- Multiple Selection and Virtual Space
--buffer.additional_sel_alpha =
--buffer.additional_sel_fore =
--buffer.additional_sel_back =
--buffer.additional_caret_fore =

-- Caret and Selection Styles.
buffer:set_sel_fore(true, 0x2a2525)
buffer:set_sel_back(true, 0x988B85)
--buffer.sel_alpha =
buffer.caret_fore = 0xaaaaaa
buffer.caret_line_back = 0xffffff
buffer.caret_line_back_alpha = 32

-- Fold Margin.
buffer:set_fold_margin_colour(true, property_int['color.background'])
buffer:set_fold_margin_hi_colour(true, property_int['color.background'])

-- Fold Margin Markers.
local c = _SCINTILLA.constants

buffer.marker_fore[c.SC_MARKNUM_FOLDEROPEN] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDEROPEN] = property_int['color.text']

buffer.marker_fore[c.SC_MARKNUM_FOLDER] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDER] = property_int['color.text']

buffer.marker_fore[c.SC_MARKNUM_FOLDERSUB] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDERSUB] = property_int['color.text']

buffer.marker_fore[c.SC_MARKNUM_FOLDERTAIL] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDERTAIL] = property_int['color.text']

buffer.marker_fore[c.SC_MARKNUM_FOLDEREND] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDEREND] = property_int['color.text']

buffer.marker_fore[c.SC_MARKNUM_FOLDEROPENMID] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDEROPENMID] = property_int['color.text']

buffer.marker_fore[c.SC_MARKNUM_FOLDERMIDTAIL] = property_int['color.background']
buffer.marker_back[c.SC_MARKNUM_FOLDERMIDTAIL] = property_int['color.text']

-- Long Lines.
buffer.edge_colour = 0x4D4141
