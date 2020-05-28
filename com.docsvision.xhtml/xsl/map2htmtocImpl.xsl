<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="dita-ot ditamsg"
                >

<!-- Include error message template -->
<xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
<xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
<xsl:import href="plugin:org.dita.base:xsl/common/dita-textonly.xsl"/>

<xsl:output method="html" indent="no" encoding="UTF-8"/>

<!-- Set the prefix for error message numbers -->
<xsl:variable name="msgprefix">DOTX</xsl:variable>

<!-- *************************** Command line parameters *********************** -->
<xsl:param name="OUTEXT" select="'.html'"/><!-- "htm" and "html" are valid values -->
<xsl:param name="WORKDIR" select="'./'"/>
<xsl:param name="DITAEXT" select="'.xml'"/>
<xsl:param name="FILEREF" select="'file://'"/>
<xsl:param name="contenttarget" select="'contentFrame'"/>
<xsl:param name="CSS"/>
<xsl:param name="CSSPATH"/>
<xsl:param name="OUTPUTCLASS"/>   <!-- class to put on body element. -->
<!-- the path back to the project. Used for c.gif, delta.gif, css to allow user's to have
  these files in 1 location. -->
<xsl:param name="PATH2PROJ">
  <xsl:apply-templates select="/processing-instruction('path2project-uri')[1]" mode="get-path2project"/>
</xsl:param>
<xsl:param name="genDefMeta" select="'no'"/>
<xsl:param name="YEAR" select="'2015'"/>
<!-- Define a newline character -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<!-- *********************************************************************************
     Setup the HTML wrapper for the table of contents
     ********************************************************************************* -->
  <xsl:template match="/">
    <xsl:call-template name="generate-toc"/>
  </xsl:template>
<!--  -->
<xsl:template name="generate-toc">
  <html><xsl:value-of select="$newline"/>
  <head><xsl:value-of select="$newline"/>
    <xsl:if test="string-length($contenttarget)>0 and
	        $contenttarget!='NONE'">
      <base target="{$contenttarget}"/>
      <xsl:value-of select="$newline"/>
    </xsl:if>
    <!-- initial meta information -->

    <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->   
	<xsl:text disable-output-escaping='yes'><![CDATA[
	<link rel="stylesheet" type="text/css" href="css/menu.css"/>
	<script type="text/javascript" src="js/minit.js"></script>
]]></xsl:text>
</head>
   <xsl:value-of select="$newline"/>
  <body>
    <xsl:value-of select="$newline"/>
	<xsl:apply-templates/>
	<xsl:value-of select="$newline"/>
   </body>
   <xsl:value-of select="$newline"/>
  </html>
</xsl:template>

<xsl:template name="generateCharset">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <xsl:value-of select="$newline"/>
</xsl:template>

<!-- If there is no copyright in the document, make the standard one -->
<xsl:template name="generateDefaultCopyright">
  <xsl:if test="not(//*[contains(@class,' topic/copyright ')])">
    <meta name="copyright">
      <xsl:attribute name="content">
        <xsl:text>(C) </xsl:text>
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Copyright'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text><xsl:value-of select="$YEAR"/>
      </xsl:attribute>
    </meta>
    <xsl:value-of select="$newline"/>
    <meta name="DC.rights.owner">
      <xsl:attribute name="content">
        <xsl:text>(C) </xsl:text>
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Copyright'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text><xsl:value-of select="$YEAR"/>
      </xsl:attribute>
    </meta>
    <xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>

<xsl:template name="copyright"></xsl:template>
<!-- *********************************************************************************
     If processing only a single map, setup the HTML wrapper and output the contents.
     Otherwise, just process the contents.
     ********************************************************************************* -->
<!-- Deprecated: use "toc" mode instead -->
<xsl:template match="/*[contains(@class, ' map/map ')]">
  <xsl:param name="pathFromMaplist"/>
  <xsl:if test=".//*[contains(@class, ' map/topicref ')]
					[not(@toc='no')]
					[not(@processing-role='resource-only')]">

	  <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="generateMapTitle">
  <!-- Title processing - special handling for short descriptions -->
  <xsl:if test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')] or /*[contains(@class,' map/map ')]/@title">
  <title>
    <xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
    <xsl:choose>
      <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
        <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
      </xsl:when>
      <xsl:when test="/*[contains(@class,' map/map ')]/@title">
        <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
      </xsl:when>
    </xsl:choose>
  </title><xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>

<xsl:template name="gen-user-panel-title-pfx">
  <xsl:apply-templates select="." mode="gen-user-panel-title-pfx"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-panel-title-pfx">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed immediately after TITLE tag, in the title -->
</xsl:template>

<xsl:template name="navtitle">
  <xsl:apply-templates select="." mode="get-navtitle"/>
</xsl:template>
<xsl:template match="*" mode="get-navtitle">
  <xsl:variable name="WORKDIR">
    <xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
  </xsl:variable>
  <xsl:choose>

    <!-- If navtitle is specified, use it (!?but it should only be used when locktitle=yes is specifed?!) -->
    <xsl:when test="*[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]">
      <xsl:apply-templates 
        select="*[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]" 
        mode="dita-ot:text-only"/>
    </xsl:when>
    <xsl:when test="not(*[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]) and @navtitle"><xsl:value-of select="@navtitle"/></xsl:when>

    <!-- If this references a DITA file (has @href, not "local" or "external"),
         try to open the file and get the title -->
    <xsl:when test="@href and not(@href='') and 
                    not ((ancestor-or-self::*/@scope)[last()]='external') and
                    not ((ancestor-or-self::*/@scope)[last()]='peer') and
                    not ((ancestor-or-self::*/@type)[last()]='external') and
                    not ((ancestor-or-self::*/@type)[last()]='local')">
      <xsl:apply-templates select="." mode="getNavtitleFromTopic">
        <xsl:with-param name="WORKDIR" select="$WORKDIR"/>
      </xsl:apply-templates>
    </xsl:when>

    <!-- If there is no title and none can be retrieved, check for <linktext> -->
    <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
      <xsl:apply-templates 
        select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"
        mode="dita-ot:text-only"/>
    </xsl:when>

    <!-- No local title, and not targeting a DITA file. Could be just a container setting
         metadata, or a file reference with no title. Issue message for the second case. -->
    <xsl:otherwise>
      <xsl:if test="@href and not(@href='')">
          <xsl:apply-templates select="." mode="ditamsg:could-not-retrieve-navtitle-using-fallback">
            <xsl:with-param name="target" select="@href"/>
            <xsl:with-param name="fallback" select="@href"/>
          </xsl:apply-templates>
          <xsl:value-of select="@href"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="getNavtitleFromTopic">
  <xsl:param name="WORKDIR"/>
  <!-- Need to worry about targeting a nested topic? Not for now. -->
  <xsl:variable name="FileWithPath">
    <xsl:choose>
      <xsl:when test="@copy-to and not(contains(@chunk, 'to-content'))">
        <xsl:value-of select="$WORKDIR"/><xsl:value-of select="@copy-to"/>
        <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
          <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="contains(@href,'#')">
        <xsl:value-of select="$WORKDIR"/><xsl:value-of select="substring-before(@href,'#')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$WORKDIR"/><xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="TargetFile" select="document($FileWithPath,/)"/>

  <xsl:choose>
    <xsl:when test="not($TargetFile)">   <!-- DITA file does not exist -->
      <xsl:choose>
        <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">  <!-- attempt to recover by using linktext -->
          <xsl:apply-templates
             select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"
             mode="dita-ot:text-only"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="ditamsg:missing-target-file-no-navtitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- First choice for navtitle: topic/titlealts/navtitle -->
    <xsl:when test="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]">
      <xsl:apply-templates 
        select="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]"
        mode="dita-ot:text-only"/>
    </xsl:when>
    <!-- Second choice for navtitle: topic/title -->
    <xsl:when test="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
      <xsl:apply-templates 
        select="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]"
        mode="dita-ot:text-only"/>
    </xsl:when>
    <!-- This might be a combo article; modify the same queries: dita/topic/titlealts/navtitle -->
    <xsl:when test="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]">
      <xsl:apply-templates 
        select="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]"
        mode="dita-ot:text-only"/>
    </xsl:when>
    <!-- Second choice: dita/topic/title -->
    <xsl:when test="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
      <xsl:apply-templates 
        select="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]"
        mode="dita-ot:text-only"/>
    </xsl:when>
    <!-- Last choice: use the linktext specified within the topicref -->
    <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
      <xsl:apply-templates 
        select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"
        mode="dita-ot:text-only"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="ditamsg:could-not-retrieve-navtitle-using-fallback">
        <xsl:with-param name="target" select="$FileWithPath"/>
        <xsl:with-param name="fallback" select="'***'"/>
      </xsl:apply-templates>
      <xsl:text>***</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Link to user CSS. -->
<!-- Test for URL: returns "url" when the content starts with a URL;
  Otherwise, leave blank -->
<xsl:template name="url-string">
  <xsl:param name="urltext"/>
  <xsl:choose>
    <xsl:when test="contains($urltext,'http://')">url</xsl:when>
    <xsl:when test="contains($urltext,'https://')">url</xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<!-- Can't link to commonltr.css or commonrtl.css because we don't know what language the map is in. -->
<xsl:template name="generateCssLinks">
  <xsl:variable name="urltest">
    <xsl:call-template name="url-string">
      <xsl:with-param name="urltext">
        <xsl:value-of select="concat($CSSPATH,$CSS)"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="string-length($CSS)>0">
  <xsl:choose>
    <xsl:when test="$urltest='url'">
      <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}" />
    </xsl:when>
    <xsl:otherwise>
      <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}" />
    </xsl:otherwise>
  </xsl:choose><xsl:value-of select="$newline"/>   
  </xsl:if>
</xsl:template>

<!-- To be overridden by user shell. -->

<xsl:template name="gen-user-head">
  <xsl:apply-templates select="." mode="gen-user-head"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-head">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the HEAD section of the XHTML. -->
</xsl:template>

<xsl:template name="gen-user-header">
  <xsl:apply-templates select="." mode="gen-user-header"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-header">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the running heading section of the XHTML. -->
</xsl:template>

<xsl:template name="gen-user-footer">
  <xsl:apply-templates select="." mode="gen-user-footer"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-footer">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the running footing section of the XHTML. -->
</xsl:template>

<xsl:template name="gen-user-sidetoc">
  <xsl:apply-templates select="." mode="gen-user-sidetoc"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-sidetoc">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- Uncomment the line below to have a "freebie" table of contents on the top-right -->
</xsl:template>

<xsl:template name="gen-user-scripts">
  <xsl:apply-templates select="." mode="gen-user-scripts"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-scripts">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed before the ending HEAD tag -->
  <!-- see (or enable) the named template "script-sample" for an example -->
</xsl:template>

<xsl:template name="gen-user-styles">
  <xsl:apply-templates select="." mode="gen-user-styles"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-styles">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed before the ending HEAD tag -->
</xsl:template>

<xsl:template name="gen-user-external-link">
  <xsl:apply-templates select="." mode="gen-user-external-link"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-external-link">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed after an external LINK or XREF -->
</xsl:template>

<!-- These are here just to prevent accidental fallthrough -->
<!-- Deprecated: use "toc" mode instead -->
<xsl:template match="*[contains(@class, ' map/navref ')]"/>
<xsl:template match="*[contains(@class, ' map/anchor ')]"/>
<xsl:template match="*[contains(@class, ' map/reltable ')]"/>
<xsl:template match="*[contains(@class, ' map/topicmeta ')]"/>
<!--xsl:template match="*[contains(@class, ' map/topicref ') and contains(@class, '/topicgroup ')]"/-->

<!-- Deprecated: use "toc" mode instead -->
<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<!-- Convert the input value to lowercase & return it -->
<xsl:template name="convert-to-lower">
 <xsl:param name="inputval"/>
 <xsl:value-of select="translate($inputval,
                                  '-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                  '-abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz')"/>
</xsl:template>

<!-- Template to get the relative path to a map -->
<xsl:template name="getRelativePath">
  <xsl:param name="remainingPath" select="@file"/>
  <xsl:choose>
    <xsl:when test="contains($remainingPath,'/')">
      <xsl:value-of select="substring-before($remainingPath,'/')"/><xsl:text>/</xsl:text>
      <xsl:call-template name="getRelativePath">
        <xsl:with-param name="remainingPath" select="substring-after($remainingPath,'/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($remainingPath,'\')">
      <xsl:value-of select="substring-before($remainingPath,'\')"/><xsl:text>/</xsl:text>
      <xsl:call-template name="getRelativePath">
        <xsl:with-param name="remainingPath" select="substring-after($remainingPath,'\')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="ditamsg:missing-target-file-no-navtitle">
  <xsl:call-template name="output-message">
    <xsl:with-param name="msgnum">008</xsl:with-param>
    <xsl:with-param name="msgsev">W</xsl:with-param>
    <xsl:with-param name="msgparams">%1=<xsl:value-of select="@href"/></xsl:with-param>
   </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="ditamsg:could-not-retrieve-navtitle-using-fallback">
  <xsl:param name="target"/>
  <xsl:param name="fallback"/>
  <xsl:call-template name="output-message">
    <xsl:with-param name="msgnum">009</xsl:with-param>
    <xsl:with-param name="msgsev">W</xsl:with-param>
    <xsl:with-param name="msgparams">%1=<xsl:value-of select="$target"/>;%2=<xsl:value-of select="$fallback"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
