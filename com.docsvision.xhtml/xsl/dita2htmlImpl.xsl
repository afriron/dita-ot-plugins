<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet [  
<!ENTITY gt            "&gt;">
<!ENTITY lt            "&lt;">
<!ENTITY rbl           " ">
<!ENTITY nbsp          "&#xA0;">
<!-- &#160; -->
<!ENTITY quot          "&#34;">
<!ENTITY copyr         "&#169;">]>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" 
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html" 
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" 
  xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
  exclude-result-prefixes="xs dita-ot dita2html ditamsg related-links">
  
  <xsl:variable name="rowsep" select="'1'"/>
  <xsl:variable name="colsep" select="'1'"/>
  
  <xsl:variable name="current-file" select="translate(if ($FILEDIR = '.') then $FILENAME else concat($FILEDIR, '/', $FILENAME), '\', '/')"/>
	
  <xsl:template match="*" mode="chapterHead">
    <head>
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="generateCharset"/>
      <xsl:call-template name="generateCssLinks"/>
      <xsl:call-template name="gen-user-head" />
      <xsl:call-template name="gen-user-scripts" />
      <xsl:call-template name="gen-user-styles" />
      <xsl:call-template name="processHDF"/>
    </head>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  
  <xsl:template match="*" mode="gen-user-scripts">
	<xsl:variable name="currentPath">
      <xsl:call-template name="replace-extension">
        <xsl:with-param name="filename" select="$current-file"/>
        <xsl:with-param name="extension">.html</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
	
    <script type="text/javascript">window.addEventListener?window.top.postMessage("<xsl:value-of select="$currentPath"/>","*"):window.parent.openTree("<xsl:value-of select="$currentPath"/>");</script>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' topic/note ')]" name="topic.note">
    <xsl:choose>
      <xsl:when test="@type='important' or @type='restriction' or @type='remember' or @type='attention' or @type='caution' or @type='danger' or @type='warning'">
        <div class="noteblock_important">
          <div class="notecontent">
            <xsl:apply-templates/>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="noteblock_note">
          <div class="notecontent">
            <xsl:apply-templates/>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template match="*[contains(@class, ' topic/div ')]">
    <xsl:choose>
      <xsl:when test="@outputclass='warn'">
        <div class="noteblock_important">
          <div class="notecontent">
            <xsl:apply-templates/>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="noteblock_note">
          <div class="notecontent">
            <xsl:apply-templates/>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="*" mode="add-custom-link-attributes">
    <xsl:if test="@scope = 'local' and lower-case(@format) = 'zip'">
      <xsl:attribute name="target">_blank</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="gen-endnotes">
    <xsl:if test="count(//*[contains(@class, ' topic/fn ')][not( (ancestor::*[contains(@class, ' topic/draft-comment ')] or ancestor::*[contains(@class, ' topic/required-cleanup ')]) and $DRAFT = 'no')]) &gt; 0">
      <div class="fncontainer">
        <xsl:apply-templates select="//*[contains(@class, ' topic/fn ')][not( (ancestor::*[contains(@class, ' topic/draft-comment ')] or ancestor::*[contains(@class, ' topic/required-cleanup ')]) and $DRAFT = 'no')]" mode="genEndnote"/>
      </div>
    </xsl:if>
  </xsl:template>
  

<xsl:template match="*[contains(@class, ' topic/fig ')]" name="topic.fig">
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
  <figure>
    <xsl:attribute name="class">fig</xsl:attribute>
    <xsl:call-template name="setscale"/>
    <xsl:call-template name="setidaname"/>
    <div class="figimage">
      <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ') or contains(@class, ' topic/desc ')]"/>
    </div>
    <xsl:call-template name="place-fig-lbl"/>
  </figure>
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  <xsl:value-of select="$newline"/>
</xsl:template>



<xsl:template name="place-fig-lbl">
<xsl:param name="stringName"/>
  <!-- Number of fig/title's including this one -->
  <xsl:variable name="fig-count-actual" select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"/>
  <xsl:variable name="ancestorlang">
    <xsl:call-template name="getLowerCaseLang"/>
  </xsl:variable>

      <div class="figcap">
    
           <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Figure'"/>
           </xsl:call-template>
           <xsl:text> </xsl:text>
           <xsl:value-of select="$fig-count-actual"/>
           <xsl:text>. </xsl:text>
    
       <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle"/>
      </div>
</xsl:template>



<xsl:template match="*[contains(@class, ' topic/image ')]" name="topic.image">
  <xsl:choose>
    <xsl:when test="@placement = 'break'">
       <figure>
        <xsl:attribute name="class">fig</xsl:attribute>
        <xsl:call-template name="setscale"/>
        <xsl:call-template name="setidaname"/>
        <div class="figimage">
            <xsl:call-template name="setaname"/>
            <xsl:call-template name="topic-image"/>
        </div>
      </figure>
    </xsl:when>
    <xsl:otherwise>
        <xsl:call-template name="setaname"/>
        <xsl:call-template name="topic-image"/>
    </xsl:otherwise>
  </xsl:choose>


</xsl:template>


 <xsl:variable name="newline">
    <xsl:text></xsl:text>
  </xsl:variable>
   
  <xsl:template name="parentlinks">
    <xsl:for-each select="descendant-or-self::*[contains(@class, ' topic/related-links ') or contains(@class, ' topic/linkpool ')][*[@role = 'parent']]">
      <xsl:for-each select="*[@href][@role = 'parent']">
        <xsl:apply-templates select="*[contains(@class, ' topic/linktext ')]"/>
        <xsl:text> / </xsl:text>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:apply-templates select="*[contains(@class, ' topic/title ')][1]" mode="text-only"/>
  </xsl:template>
  
 <xsl:template name="ul-child-links">
    <xsl:variable name="children"
                  select="descendant::*[contains(@class, ' topic/link ')]
                                       [@role = ('child', 'descendant')]
                                       [not(parent::*/@collection-type = 'sequence')]
                                       [not(ancestor::*[contains(@class, ' topic/linklist ')])]"/>
    <xsl:if test="$children">
	 <strong>На уровень ниже:</strong>
      <xsl:value-of select="$newline"/>
      <ul class="ullinks">
        <xsl:value-of select="$newline"/>
        <!--once you've tested that at least one child/descendant exists, apply templates to only the unique ones-->
        <xsl:apply-templates select="$children[generate-id(.) = generate-id(key('link', related-links:link(.))[1])]"/>
      </ul>
      <xsl:value-of select="$newline"/>
    </xsl:if>
  </xsl:template>
  
	<xsl:template match="*[contains(@class, ' topic/link ')][@role = ('child', 'descendant')]" priority="2" name="topic.link_child">
    <li class="ulchildlink">
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="'ulchildlink'"/>
      </xsl:call-template>
      <!-- Allow for unknown metadata (future-proofing) -->
      <xsl:apply-templates select="*[contains(@class, ' topic/data ') or contains(@class, ' topic/foreign ')]"/>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

        <xsl:apply-templates select="." mode="related-links:unordered.child.prefix"/>
        <xsl:apply-templates select="." mode="add-link-highlight-at-start"/>
        <a>
          <xsl:apply-templates select="." mode="add-linking-attributes"/>
          <xsl:apply-templates select="." mode="add-hoverhelp-to-child-links"/>

          <!--use linktext as linktext if it exists, otherwise use href as linktext-->
          <xsl:choose>
            <xsl:when test="*[contains(@class, ' topic/linktext ')]">
              <xsl:apply-templates select="*[contains(@class, ' topic/linktext ')]"/>
            </xsl:when>
            <xsl:otherwise>
              <!--use href-->
              <xsl:call-template name="href"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:apply-templates select="." mode="add-link-highlight-at-end"/>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      <br/>
      <xsl:value-of select="$newline"/>
      <!--add the description on the next line, like a summary-->
      <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"/>
    </li>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' task/stepsection ')]">
    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' hi-d/b ')]" name="topic.hi-d.b">
	<strong class="b">
		<xsl:call-template name="setidaname"/>
		<xsl:apply-templates/>
	</strong>
	</xsl:template>

	<xsl:template match="*[contains(@class,' hi-d/i ')]" name="topic.hi-d.i">
	 <em class="i">
	  <xsl:call-template name="setidaname"/>
	  <xsl:apply-templates/>
	  </em>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/term ')]" mode="output-term">
  <!-- Deprecated since 2.1 -->
  <xsl:param name="displaytext"/>
  
  <span class="term">
    <xsl:call-template name="commonattributes"/>
    <xsl:call-template name="setidaname"/>
    <xsl:choose>
      <xsl:when test="normalize-space($displaytext)">
        <xsl:value-of select="$displaytext"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>
	
 <xsl:template match="*[contains(@class, ' topic/lq ')]" name="topic.lq">
    <div class="noteblock_note">
          <div class="notecontent">
            <xsl:apply-templates/>
          </div>
        </div>
  </xsl:template>	

<xsl:template match="*[contains(@class, ' pr-d/codeblock ')]" name="topic.pr-d.codeblock">
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
  <xsl:call-template name="spec-title-nospace"/>

  <pre>
    <xsl:call-template name="commonattributes"/>
    <xsl:call-template name="setscale"/>
    <xsl:call-template name="setidaname"/>
    <xsl:apply-templates/>
  </pre>

  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
</xsl:template>
	
</xsl:stylesheet>