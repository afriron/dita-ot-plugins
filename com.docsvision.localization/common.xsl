<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:opentopic-vars="http://www.idiominc.com/opentopic/vars"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="opentopic-vars xs">
		
	<xsl:template name="findString">
    <xsl:param name="id" as="xs:string"/>
    <xsl:param name="params" as="node()*"/>
    <xsl:param name="ancestorlang" as="xs:string*"/>
    <xsl:param name="defaultlang" as="xs:string*"/>
    <xsl:param name="originallang" as="xs:string*" select="$ancestorlang[1]"/>
    
	<xsl:variable name="localFiles" select="document('plugin:com.docsvision.localization:common/strings.xml')/langlist/lang" as="element(lang)*"/>
	
		
    <xsl:variable name="l" select="($ancestorlang, $defaultlang)[1]" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="exists($l)">
        <xsl:variable name="variablefile" select="$variableFiles[lower-case(@xml:lang) = lower-case($l)]/@filename" as="xs:string*"/>
		    <xsl:variable name="localizationFile" select="$localFiles[lower-case(@xml:lang) = lower-case($l)]/@filename" as="xs:string*"/>
		
        <xsl:variable name="variable" as="element()*">
          <xsl:for-each select="$variablefile">
            <xsl:sequence select="document(., $variableFiles[1])/*/*[@name = $id or @id = $id]"/>
          </xsl:for-each>
		   </xsl:variable>
       
        <xsl:variable name="plugVariable" as="element()*">
          <xsl:for-each select="$localizationFile">
            <xsl:sequence select="document(., $localFiles[1])/*/*[@name = $id or @id = $id]"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="exists($plugVariable)">
            <xsl:apply-templates select="$plugVariable[last()]" mode="processVariableBody">
              <xsl:with-param name="params" select="$params"/>
            </xsl:apply-templates>
            <xsl:if test="empty($ancestorlang)">
              <xsl:call-template name="output-message">
                <xsl:with-param name="id" select="'DOTX001W'"/>
                <xsl:with-param name="msgparams">%1=<xsl:value-of select="$id"/>;%2=<xsl:value-of select="$originallang"/>;%3=<xsl:value-of select="$DEFAULTLANG"/></xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:when test="exists($variable)">
            <xsl:apply-templates select="$variable[last()]" mode="processVariableBody">
              <xsl:with-param name="params" select="$params"/>
            </xsl:apply-templates>
            <xsl:if test="empty($ancestorlang)">
              <xsl:call-template name="output-message">
                <xsl:with-param name="id" select="'DOTX001W'"/>
                <xsl:with-param name="msgparams">%1=<xsl:value-of select="$id"/>;%2=<xsl:value-of select="$originallang"/>;%3=<xsl:value-of select="$DEFAULTLANG"/></xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="findString">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="params" select="$params"/>
              <xsl:with-param name="ancestorlang" select="$ancestorlang[position() gt 1]"/>
              <xsl:with-param name="defaultlang" select="if (exists($ancestorlang)) then $defaultlang else $defaultlang[position() gt 1]"/>
              <xsl:with-param name="originallang" select="$originallang"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="variablefile" select="$variableFiles[@xml:lang='']/@filename" as="xs:string*"/>
        <xsl:variable name="localizationFile" select="$localFiles[@xml:lang = '']/@filename" as="xs:string*"/>

        <xsl:variable name="variable" as="element()*">
          <xsl:for-each select="$variablefile">
            <xsl:sequence select="document(., $variableFiles[1])/*/*[@name = $id or @id = $id]"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="plugVariable" as="element()*">
          <xsl:for-each select="$localizationFile">
            <xsl:sequence select="document(., $localFiles[1])/*/*[@name = $id or @id = $id]"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="exists($plugVariable)">
            <xsl:apply-templates select="$plugVariable[last()]" mode="processVariableBody">
              <xsl:with-param name="params" select="$params"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:when test="exists($variable)">
            <xsl:apply-templates select="$variable[last()]" mode="processVariableBody">
              <xsl:with-param name="params" select="$params"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$id"/>
            <xsl:call-template name="output-message">
              <xsl:with-param name="id" select="'DOTX052W'"/>
              <xsl:with-param name="msgparams">%1=<xsl:value-of select="$id"/></xsl:with-param>
            </xsl:call-template>            
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>	
		

   <xsl:template name="getLowerCaseLang">
    <xsl:value-of select="lower-case($DEFAULTLANG)"/>
  </xsl:template>
  
  <!-- Support legacy variable namespace -->
  <xsl:template match="opentopic-vars:variable" mode="processVariableBody">
    <xsl:param name="params"/>

    <xsl:for-each select="node()">
      <xsl:choose>
        <xsl:when test="self::opentopic-vars:param">
          <!--Processing parametrized variable-->
          <xsl:variable name="param-name" select="@ref-name"/>
          <!--Copying parameter child as is-->
          <xsl:copy-of select="$params/descendant-or-self::*[local-name() = $param-name]/node()"/>
        </xsl:when>
        <xsl:when test="self::opentopic-vars:variable">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="@id"/>
            <xsl:with-param name="params" select="$params"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
 
  
</xsl:stylesheet>