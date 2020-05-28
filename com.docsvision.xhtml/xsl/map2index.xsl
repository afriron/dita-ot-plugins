<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">
	<xsl:output method="html" indent="no" encoding="UTF-8"/>
	<!-- *************************** Command line parameters *********************** -->
	<xsl:param name="OUTEXT" select="'.html'"/>
	<xsl:param name="WORKDIR" select="'./'"/>
	<xsl:param name="DITAEXT" select="'.xml'"/>
	<xsl:param name="CSS"/>
	<xsl:param name="CSSPATH"/>
	<xsl:template match="/">

<xsl:text disable-output-escaping='yes'><![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.w3.org/MarkUp/SCHEMA/xhtml11.xsd">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<title>]]></xsl:text><xsl:value-of select="//*[contains(@class, ' topic/othermeta ') and @name='doctype']/@content"/><xsl:text disable-output-escaping='yes'><![CDATA[</title>
	<link rel="shortcut icon" type="image/x-icon" href="media/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="css/basestyle.css" />
	<script type="text/javascript" src="js/init.js"></script>
</head>
<body>
	<div>
		<div class="header-container">
			<a href="cover.html" target="contentFrame" class="link-to-index-page"><img src="media/logo.png" alt="Docsvision 5"/></a>
			<div class="search-container">
				<form onsubmit="Search();return false">
					<input id="textToSearch" type="text" class="search-string" />
					<input id="search-btn" type="image" src="media/search.png" alt="Поиск" />
				</form>
			</div>
			<div id="currentLink" onclick="SelectLink(); return false;" class="link-to-current-topic"></div>
		</div>
		<div class="body-container">
			<div class="menu-container">
				<iframe id="menuFrame" name="menuFrame" src="tocnav.html" frameBorder="0" frameborder="0"></iframe>
			</div>
			<div class="content-container">
				<iframe id="contentFrame" name="contentFrame" src="cover.html" frameBorder="0" frameborder="0"></iframe>
			</div>
		</div>
	</div>
</body>

</html>]]></xsl:text>
	</xsl:template>
</xsl:stylesheet>
