<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY gt "&gt;">
	<!ENTITY lt "&lt;">
	<!ENTITY rbl " ">
	<!ENTITY nbsp "&#xA0;">
	<!-- &#160; -->
	<!ENTITY quot "&#34;">
	<!ENTITY copyr "&#169;">
]>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:opentopic="http://www.idiominc.com/opentopic"
	extension-element-prefixes="opentopic">

	<!-- Include error message template -->
	<xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
	<xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
	<xsl:import href="plugin:com.docsvision.localization:common.xsl"/>

	<xsl:import href="plugin:org.dita.xhtml:xsl/dita2html.xsl"/>
	
	

	<xsl:output method="html" indent="no" encoding="UTF-8"/>
	<!-- *************************** Command line parameters *********************** -->
	<xsl:param name="OUTEXT" select="'.html'"/>
	<!-- "htm" and "html" are valid values -->
	<xsl:param name="WORKDIR" select="'./'"/>
	<xsl:param name="DITAEXT" select="'.xml'"/>
	<xsl:param name="contenttarget" select="'contentwin'"/>
	<xsl:param name="CSS"/>
	<xsl:param name="CSSPATH"/>
	<xsl:param name="pbuild" />

	<!-- Define a newline character -->
	<xsl:variable name="newline">
		<xsl:text>
</xsl:text>
	</xsl:variable>
	<xsl:variable name="msgprefix">DOTX</xsl:variable>
	<xsl:variable name="rowsep" select="'1'"/>
	<xsl:variable name="colsep" select="'1'"/>
	
	
	<!-- *********************************************************************************
     Cover processing
     ********************************************************************************* -->
	<xsl:template match="/">
		<html>
			<xsl:value-of select="$newline"/>
			<head>
				<xsl:value-of select="$newline"/>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<style type="text/css"/>
				<link rel="stylesheet" type="text/css" href="css/style.css" />
			</head>
			<xsl:value-of select="$newline"/>
			<body>
				<div>
				
					<div class="coverProdName">
						<xsl:value-of select="(//*[contains(@class, ' topic/prodname ')]/text())[1]"/>&nbsp;<xsl:value-of select="(//*[contains(@class, ' topic/prognum ')]/text())[1]"/>
					</div>
			
					<div class="coverDocumentName">
						<xsl:value-of select="(//*[contains(@class,' topic/title ')])[1]"/>
					</div>



					<xsl:if test="$pbuild">
							<div class="coverDocumentVersion">
								в сборке&nbsp;
								<xsl:value-of select="$pbuild"/>
							</div>
					</xsl:if>

					<xsl:if test="(//*[contains(@class, ' topic/othermeta ') and @name='docver']/@content)[1]">
						<div class="coverDocumentVersion">
								Редакция документа&nbsp;
								<xsl:value-of select="(//*[contains(@class, ' topic/othermeta ') and @name='docver']/@content)[1]"/>
						</div>
					</xsl:if>
				</div>
				
				<xsl:if test="(//*[contains(@class, ' map/shortdesc ')]/node())[1]">
					<div class="coverDescription">
					  <xsl:apply-templates select="//*[contains(@class, ' map/shortdesc ')]/node()"/>
					</div>
				</xsl:if>
				
				
			</body>
		</html>
	</xsl:template>

	
	
	<xsl:template match="*[contains(@class,' topic/unknown ')]">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>
