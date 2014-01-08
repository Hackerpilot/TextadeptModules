local M = {}

local xml = require "common.xml"

if type(_G.snippets) == "table" then
  _G.snippets.xml = {}
end

if type(_G.keys) == "table" then
  _G.keys.xml = {}
end

function M.set_buffer_properties()
	buffer.indent = 2
end

_G.keys.xml = {
	[keys.LANGUAGE_MODULE_PREFIX] = {
		m = {io.open_file, (_USERHOME.."/modules/xml/init.lua"):iconv("UTF-8", _CHARSET)}
	},
	['cs\n'] = {xml.completeClosingTag},
	['<'] = {xml.autoTag},
	['/'] = {xml.singleTag},
	['!'] = {xml.completeComment},
	['?'] = {xml.completePHP},
	[' '] = {xml.handleSpace},
	['\b'] = {xml.handleBackspace},
	['c/'] = {xml.toggleLineComment},
	cR = {xml.reformat},
	ce = {xml.encloseTag},
	cM = {xml.selectToMatching}
}

_G.snippets.xml = {
	xml = [[<?xml version="1.0" encoding="%1(UTF-8)"?>]],
	xsfe = [[<xsl:for-each select="%1">
	%0
</xsl:for-each>]],
	xsch= [[<xsl:choose>
	%0
</xsl:choose>]],
	xswh = [[<xsl:when test="%1">
	%0
</xsl:when>]],
	xsoth = [[<xsl:otherwise>
	%0
</xsl:otherwise>]],
	xsct = [[<xsl:call-template name="%0">
	%0
</xsl:call-template>]],
	xswp = [[<xsl:with-param name="%1" select="%0"/>]],
	xsvo = [[<xsl:value-of select="%0"/>]],
	xsif = [[<xsl:if test="%1">
	%0
</xsl:if>]],
	cdata = '<![CDATA[%0]]>',
}

return M
