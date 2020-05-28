<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" 
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" exclude-result-prefixes="dita-ot ditamsg" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-textonly.xsl"/>
  <xsl:variable name="msgprefix">DOTX</xsl:variable>
  <xsl:param name="WORKDIR">
    <xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
  </xsl:param>
  <xsl:param name="PATH2PROJ">
    <xsl:apply-templates select="/processing-instruction('path2project-uri')[1]" mode="get-path2project"/>
  </xsl:param>
  <xsl:template match="/">[                            
    <xsl:apply-templates select="*[contains(@class, ' map/map ')]" mode="toc"/>]              
  </xsl:template>
  <xsl:template match="*[contains(@class, ' map/map ')]" mode="toc">
    <xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')]">
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="*[contains(@class, ' map/topicref ')][not(@processing-role = 'resource-only')]" mode="toc">
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:variable name="content">
      <xsl:apply-templates select="." mode="get-content">
        <xsl:with-param name="WORKDIR" select="$WORKDIR"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="href">
      <xsl:apply-templates select="." mode="get-href"/>
    </xsl:variable>
    <xsl:if test="preceding-sibling::*[contains(@class, ' map/topicref ')] | parent::*[contains(@class, ' map/topicref ')]">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <![CDATA[{]]>"id":"<xsl:value-of select="generate-id()" />",
    "href":"<xsl:value-of select="$href" />",
    "title":"<xsl:value-of select="$title" />",
    "body":"<xsl:value-of select="replace(normalize-space($content),'\{|\}|&quot;|\\',' ')" />"<![CDATA[}]]><![CDATA[ ]]><xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(@processing-role = 'resource-only')]">
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="*" mode="get-navtitle">
    <xsl:choose>
      <!-- If navtitle is specified -->
      <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]">
        <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]" mode="dita-ot:text-only"/>
      </xsl:when>
      <xsl:when test="@navtitle">
        <xsl:value-of select="@navtitle"/>
      </xsl:when>
      <!-- If there is no title and none can be retrieved, check for <linktext> -->
      <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
        <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]" mode="dita-ot:text-only"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="normalize-space(@href)">
          <xsl:apply-templates select="." mode="ditamsg:could-not-retrieve-navtitle-using-fallback">
            <xsl:with-param name="target" select="@href"/>
            <xsl:with-param name="fallback" select="@href"/>
          </xsl:apply-templates>
          <xsl:value-of select="@href"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="get-content">
    <xsl:param name="WORKDIR"/>
    <xsl:variable name="FileWithPath">
      <xsl:choose>
        <xsl:when test="@copy-to and not(contains(@chunk, 'to-content'))">
          <xsl:value-of select="$WORKDIR"/>
          <xsl:value-of select="@copy-to"/>
          <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
            <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="contains(@href,'#')">
          <xsl:value-of select="$WORKDIR"/>
          <xsl:value-of select="substring-before(@href,'#')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$WORKDIR"/>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="TargetFile" select="document($FileWithPath,/)"/>
    <xsl:value-of select="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/body ')]"/>
  </xsl:template>
  <xsl:template match="*" mode="get-href">
    <xsl:choose>
      <xsl:when test="contains(@href,'#')">
        <xsl:call-template name="replace-extension">
          <xsl:with-param name="filename" select="substring-before(@href,'#')"/>
          <xsl:with-param name="extension">.html</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="replace-extension">
          <xsl:with-param name="filename" select="@href"/>
          <xsl:with-param name="extension">.html</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:output method="text" encoding="UTF-8"/>
</xsl:stylesheet>