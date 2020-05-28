<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:exsl="http://exslt.org/common"
	xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
	xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
	xmlns:opentopic="http://www.idiominc.com/opentopic"
	xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:opentopic-vars="http://www.idiominc.com/opentopic/vars"
	xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder" exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs" version="2.0">

	<!-- титульный лист -->
	<xsl:template name="createFrontMatter">
		<fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="__force__page__count">
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container top="-3px" left="0mm" absolute-position="absolute">
					<fo:block>
						<fo:external-graphic src="url(Customization/OpenTopic/common/artwork/cover.png)"/>
					</fo:block>
				</fo:block-container>

				<fo:block xsl:use-attribute-sets="__frontmatter">

					<!-- Название платформы -->
					<fo:block xsl:use-attribute-sets="__frontmatter__platform">
						<xsl:text>Docsvision 5</xsl:text>
					</fo:block>

					<!-- Название программы/модуля/приложения -->

					<xsl:if test="(/*/opentopic:map//*[contains(@class, ' topic/prodname ')])[1]">
						<fo:block xsl:use-attribute-sets="__frontmatter__modname">
							<xsl:value-of select="(/*/opentopic:map//*[contains(@class, ' topic/prodname ')])[1]"/>

							<xsl:if test="(/*/opentopic:map//*[contains(@class, ' topic/prognum ')])[1]">
								<xsl:text>&#160;</xsl:text>
								<xsl:value-of select="(/*/opentopic:map//*[contains(@class, ' topic/prognum ')])[1]"/>
							</xsl:if>
						</fo:block>
					</xsl:if>
			

					<!-- Название документа -->
					<fo:block xsl:use-attribute-sets="__frontmatter__doctype">
						<xsl:value-of select="/*/opentopic:map//*[contains(@class,' topic/title ')][1]" />
					</fo:block>

					<xsl:choose>
						<xsl:when test="$pbuild">
							<fo:block xsl:use-attribute-sets="__frontmatter__build">
								<xsl:text>в версии&#160;</xsl:text>
								<xsl:value-of select="$pbuild"/>
							</fo:block>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>


					<xsl:if test="(/*/opentopic:map//*[contains(@class, ' topic/othermeta ') and @name='docver']/@content)[1]">
						<fo:block xsl:use-attribute-sets="__frontmatter__version">
							<xsl:text>Редакция документа&#160;</xsl:text>
							<xsl:value-of select="(/*/opentopic:map//*[contains(@class, ' topic/othermeta ') and @name='docver']/@content)[1]"/>
						</fo:block>
					</xsl:if>

					
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>



	<!-- Шапка Оглавления -->
	<xsl:template name="insertTocStaticContents">
		<!-- Подвал Оглавления-->
		<fo:static-content flow-name="odd-toc-footer">
			<xsl:call-template name="insertFooter"/>
		</fo:static-content>
	</xsl:template>

	<!-- шапка и подвал страниц -->
	<xsl:template name="insertBodyStaticContents">
		<xsl:call-template name="insertBodyFootnoteSeparator"/>
		<fo:static-content flow-name="odd-body-header">
			<fo:block xsl:use-attribute-sets="_header_label_into">
				<fo:retrieve-marker retrieve-class-name="chapterTitle"/>
			</fo:block>
		</fo:static-content>

		<fo:static-content flow-name="odd-body-footer">
			<xsl:call-template name="insertFooter"/>
		</fo:static-content>
	</xsl:template>


	<!-- новая глава - новая страница. неплохо бы унифицировать-->
	<xsl:template match="*" mode="processTopic">
		<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
		<xsl:choose>
			<xsl:when test="$level = 1">
				<fo:block xsl:use-attribute-sets="concept" break-before="page">
					<fo:marker marker-class-name="chapterTitle">
						<xsl:value-of select="title" />
					</fo:marker>
					<xsl:apply-templates select="." mode="commonTopicProcessing"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="concept">
					<xsl:apply-templates select="." mode="commonTopicProcessing"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/dl ')]">
		<fo:block xsl:use-attribute-sets="dl">
			<fo:block xsl:use-attribute-sets="dl__body">
				<xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]"/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/dlentry ')]">
		<fo:block xsl:use-attribute-sets="dlentry">
			<xsl:call-template name="commonattributes"/>
			<fo:block xsl:use-attribute-sets="dlentry.dt">
				<xsl:apply-templates select="*[contains(@class, ' topic/dt ')]"/>
			</fo:block>
			<fo:block xsl:use-attribute-sets="dlentry.dd">
				<xsl:apply-templates select="*[contains(@class, ' topic/dd ')]"/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/lq ')]">
		<fo:table xsl:use-attribute-sets="note_block">
			<fo:table-column column-width="3mm"/>
			<fo:table-column/>

			<fo:table-body>
				<fo:table-row>
					<fo:table-cell background-color="{$brand_color_gray}"/>
					<fo:table-cell>
						<fo:block xsl:use-attribute-sets="note_content" >
								<xsl:apply-templates/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/note ')]" name="insertNote">
		<xsl:choose>
			<xsl:when test="@type='important' or @type='restriction' or @type='remember' or @type='attention' or @type='caution' or @type='danger' or @type='warning'">
				<fo:table xsl:use-attribute-sets="note_block">
					<fo:table-column column-width="3mm"/>
					<fo:table-column/>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell background-color="{$brand_color_red}"/>
							<fo:table-cell>
								<fo:block xsl:use-attribute-sets="note_content" >
										<xsl:apply-templates/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</xsl:when>
			<xsl:otherwise>

				<fo:table xsl:use-attribute-sets="note_block">
					<fo:table-column column-width="3mm"/>
					<fo:table-column/>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell background-color="{$brand_color_gray}"/>
							<fo:table-cell>
								<fo:block xsl:use-attribute-sets="note_content" >
										<xsl:apply-templates/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>




	<xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/image ')]" mode="placeImage">
		<xsl:param name="imageAlign"/>
		<xsl:param name="href"/>
		<xsl:param name="height" as="xs:string?"/>
		<xsl:param name="width" as="xs:string?"/>
		
		<fo:external-graphic src="url({$href})" xsl:use-attribute-sets="image">
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
			<xsl:attribute name="content-height">100%</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
			<xsl:attribute name="text-indent">0em</xsl:attribute>
			<xsl:attribute name="start-indent">0em</xsl:attribute>
			<xsl:attribute name="scaling-method">integer-pixels</xsl:attribute>

			<xsl:apply-templates select="node() except (*[contains(@class, ' topic/alt ') or
                                                        contains(@class, ' topic/longdescref ')])"/>
		</fo:external-graphic>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/image ')][@placement = 'break']" mode="placeImage">
		<xsl:param name="imageAlign"/>
		<xsl:param name="href"/>
		<xsl:param name="height" as="xs:string?"/>
		<xsl:param name="width" as="xs:string?"/>
	
		<fo:external-graphic src="url({$href})" xsl:use-attribute-sets="image">
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
			<xsl:attribute name="content-height">100%</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
			<xsl:attribute name="text-indent">0em</xsl:attribute>
			<xsl:attribute name="start-indent">0em</xsl:attribute>
			<xsl:attribute name="scaling-method">integer-pixels</xsl:attribute>

			<xsl:apply-templates select="node() except (*[contains(@class, ' topic/alt ') or
                                                        contains(@class, ' topic/longdescref ')])"/>
		</fo:external-graphic>
	</xsl:template>


	<xsl:template match="text()">
		<xsl:choose>
			<xsl:when test="$textWrapping = '1'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="text1" select="replace(.,'\.','.&#x200B;')"/>
				<xsl:variable name="text2" select="replace($text1,'-','-&#x200B;')"/>
				<xsl:variable name="text3" select="replace($text2,'&#x002F;','&#x002F;&#x200B;')"/>
				<xsl:variable name="text4" select="replace($text3,'&#x200B;&#x20;','&#x20;')"/>
				<xsl:variable name="text5" select="replace($text4,'&#x002F;&#x200B;&#x002F;','&#x002F;&#x002F;')"/>
				<xsl:variable name="text6" select="replace($text5,'\.&#x200B;.&#x20;','..&#x20;')"/>
				<xsl:value-of select="$text6"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- перенос строк в таблице -->
	<xsl:template match="text()[ancestor::*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]]">
		<xsl:choose>
			<xsl:when test="$textWrapping = '1'">
				<xsl:call-template name="intersperse-with-zero-spaces">
					<xsl:with-param name="str" select="."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="intersperse-with-zero-spaces">
		<xsl:param name="str"/>
		<xsl:variable name="spacechars">&#x20;&#x9;&#xA;&#xD;&#x2000;&#x2001;&#x2002;&#x2003;&#x2004;&#x2005;&#x2006;&#x2007;&#x2008;&#x2009;&#x200A;&#x200B;</xsl:variable>

		<xsl:if test="string-length($str) &gt; 0">
			<xsl:variable name="c1" select="substring($str, 1, 1)"/>
			<xsl:variable name="c2" select="substring($str, 2, 1)"/>

			<xsl:value-of select="$c1"/>
			<xsl:if test="$c2 != '' and not(contains($spacechars, $c1) or contains($spacechars, $c2))">
				<xsl:text>&#x200B;</xsl:text>
			</xsl:if>
			<xsl:call-template name="intersperse-with-zero-spaces">
				<xsl:with-param name="str" select="substring($str, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- временный хак. не формируется страница с индексами-->
	<xsl:template match="*" priority="10" mode="index-entries"/>

	<xsl:template name="createBookmarks">
		<xsl:variable name="bookmarks" as="element()*">
			<xsl:choose>
				<xsl:when test="$retain-bookmap-order">
					<xsl:apply-templates select="/" mode="bookmark"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="/*/*[contains(@class, ' topic/topic ')]">
						<xsl:variable name="topicType">
							<xsl:call-template name="determineTopicType"/>
						</xsl:variable>
						<xsl:if test="$topicType = 'topicNotices'">
							<xsl:apply-templates select="." mode="bookmark"/>
						</xsl:if>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="$generate-toc = false()">
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$map//*[contains(@class,' bookmap/toc ')][@href]"/>
								<xsl:when test="$map//*[contains(@class,' bookmap/toc ')]
                              | /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
									<fo:bookmark internal-destination="{$id.toc}">
										<fo:bookmark-title>
											<xsl:call-template name="getVariable">
												<xsl:with-param name="id" select="'Table of Contents'"/>
											</xsl:call-template>
										</fo:bookmark-title>
									</fo:bookmark>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="/*/*[contains(@class, ' topic/topic ')] |
                                  /*/ot-placeholder:glossarylist |
                                  /*/ot-placeholder:tablelist |
                                  /*/ot-placeholder:figurelist">
						<xsl:variable name="topicType">
							<xsl:call-template name="determineTopicType"/>
						</xsl:variable>
						<xsl:if test="not($topicType = 'topicNotices')">
							<xsl:apply-templates select="." mode="bookmark"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="exists($bookmarks)">
			<fo:bookmark-tree>
				<xsl:copy-of select="$bookmarks"/>
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>


	<!-- создание документа из карты-->

	<xsl:template match="*[contains(@class, ' map/map ')]" mode="generatePageSequences">
		<!-- Титульный лист-->
		<xsl:call-template name="createFrontMatter"/>
		<xsl:call-template name="createAnnotation"/>

		<!-- Оглавление -->
		<xsl:call-template name="createToc"/>
		<!--xsl:choose>
			<xsl:when test="$skipToc = '1'">
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="createToc"/>
			</xsl:otherwise>
		</xsl:choose-->

		<!-- Основной документ -->
		<fo:page-sequence master-reference="ditamap-body-sequence" xsl:use-attribute-sets="page-sequence.body">
			<xsl:call-template name="startPageNumbering"/>
			<xsl:call-template name="insertBodyStaticContents"/>
			<fo:flow flow-name="xsl-region-body">
				<xsl:for-each select="opentopic:map/*[contains(@class, ' map/topicref ')][not(@props = 'annotation')]">
					<xsl:for-each select="key('topic-id', @id)">
						<xsl:apply-templates select="." mode="processTopic"/>
					</xsl:for-each>
				</xsl:for-each>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>

<xsl:template name="createToc">
      <xsl:if test="$generate-toc=true()">
        <xsl:variable name="toc">
            <xsl:choose>
                <xsl:when test="$map//*[contains(@class,' bookmap/toc ')][@href]"/>
                <xsl:when test="$map//*[contains(@class,' bookmap/toc ')]">
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:when>
                <xsl:when test="/*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                    <xsl:apply-templates select="/" mode="toc"/>
                    <xsl:call-template name="toc.index"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="count($toc/*) > 0">
            <fo:page-sequence master-reference="toc-sequence" xsl:use-attribute-sets="page-sequence.toc">
                <xsl:call-template name="insertTocStaticContents"/>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="createTocHeader"/>
                    <fo:block>
                        <fo:marker marker-class-name="current-header">
                          <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Table of Contents'"/>
                          </xsl:call-template>
                        </fo:marker>
                        <xsl:apply-templates select="." mode="customTopicMarker"/>
                        <xsl:copy-of select="$toc"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </xsl:if>
      </xsl:if>
    </xsl:template>



	<xsl:template name="createAnnotation">
		<xsl:choose>
			<xsl:when test="exists(opentopic:map/*[contains(@class, ' map/topicref ')][@props = 'annotation'])">
				<fo:page-sequence master-reference="back-cover" xsl:use-attribute-sets="__force__page__count">
					<fo:flow flow-name="xsl-region-body">
						<xsl:variable name="topicrefid" select="key('topic-id', opentopic:map/*[contains(@class, ' map/topicref ')][@props = 'annotation'][1]/@id)"/>
						<xsl:for-each select="$topicrefid">
							<xsl:apply-templates select="." mode="processTopic"/>
						</xsl:for-each>
					</fo:flow>
				</fo:page-sequence>
			</xsl:when>
			<!-- для совместимости со старыми документами -->
			<!-- (/*/opentopic:map//*[contains(@class, ' topic/othermeta ') and @name='shortdesc']/@content)[1] -->
			<xsl:when test="exists(/*/opentopic:map//*[contains(@class, ' map/shortdesc ')])">
				<fo:page-sequence master-reference="back-cover" xsl:use-attribute-sets="__force__page__count">
					<fo:flow flow-name="xsl-region-body">
						<fo:block xsl:use-attribute-sets="__frontmatter__anothead">
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'Introduction Label'"/>
							</xsl:call-template>
						</fo:block>
						<fo:block xsl:use-attribute-sets="_content_into">
							<xsl:apply-templates select="/*/opentopic:map//*[contains(@class, ' map/shortdesc ')]/node()"/>
						</fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- Добавлен пропуск аннотации в TOC -->
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="toc">
		<xsl:param name="include"/>
		<xsl:variable name="topicLevel" as="xs:integer">
			<xsl:apply-templates select="." mode="get-topic-level"/>
		</xsl:variable>
		<xsl:if test="$topicLevel &lt; $tocMaximumLevel">
			<xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
			<xsl:choose>
		
				<xsl:when test="$retain-bookmap-order and $mapTopicref/self::*[contains(@class, ' bookmap/notices ')]"/>
				<xsl:when test="$mapTopicref[@props = 'annotation']"/>
				<xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                              (not($mapTopicref) and $include = 'true')">
					<fo:block xsl:use-attribute-sets="__toc__indent">
						<xsl:variable name="tocItemContent">
							<fo:basic-link xsl:use-attribute-sets="__toc__link">
								<xsl:attribute name="internal-destination">
									<xsl:call-template name="generate-toc-id"/>
								</xsl:attribute>
								<xsl:apply-templates select="$mapTopicref" mode="tocPrefix"/>
								<fo:inline xsl:use-attribute-sets="__toc__title">
									<xsl:call-template name="getNavTitle" />
								</fo:inline>
								<fo:inline xsl:use-attribute-sets="__toc__page-number">
									<fo:leader xsl:use-attribute-sets="__toc__leader"/>
									<fo:page-number-citation>
										<xsl:attribute name="ref-id">
											<xsl:call-template name="generate-toc-id"/>
										</xsl:attribute>
									</fo:page-number-citation>
								</fo:inline>
							</fo:basic-link>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="not($mapTopicref)">
								<xsl:apply-templates select="." mode="tocText">
									<xsl:with-param name="tocItemContent" select="$tocItemContent"/>
									<xsl:with-param name="currentNode" select="."/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$mapTopicref" mode="tocText">
									<xsl:with-param name="tocItemContent" select="$tocItemContent"/>
									<xsl:with-param name="currentNode" select="."/>
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
					<xsl:apply-templates mode="toc">
						<xsl:with-param name="include" select="'true'"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="toc">
						<xsl:with-param name="include" select="'true'"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


	<!-- заполнение TOC -->
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="bookmark">
		<xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
		<xsl:variable name="topicTitle">
			<xsl:call-template name="getNavTitle"/>
		</xsl:variable>

		<xsl:choose>
		
			<xsl:when test="$mapTopicref[@props = 'annotation']"/>
			<xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                          not($mapTopicref)">
				<fo:bookmark>
					<xsl:attribute name="internal-destination">
						<xsl:call-template name="generate-toc-id"/>
					</xsl:attribute>
					<xsl:if test="$bookmarkStyle!='EXPANDED'">
						<xsl:attribute name="starting-state">hide</xsl:attribute>
					</xsl:if>
					<fo:bookmark-title>
						<xsl:value-of select="normalize-space($topicTitle)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="*[contains(@class, ' topic/tgroup ')]" name="tgroup">
		<xsl:if test="not(@cols)">
			<xsl:call-template name="output-message">
				<xsl:with-param name="msgnum">006</xsl:with-param>
				<xsl:with-param name="msgsev">E</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<fo:block>
			<xsl:attribute name="margin">.5pt</xsl:attribute>
			<fo:table xsl:use-attribute-sets="table.tgroup">
				<xsl:call-template name="commonattributes"/>

				<xsl:call-template name="displayAtts">
					<xsl:with-param name="element" select=".."/>
				</xsl:call-template>

				<xsl:attribute name="start-indent">0pt</xsl:attribute>
				<xsl:attribute name="end-indent">0pt</xsl:attribute>
				<xsl:attribute name="width">auto</xsl:attribute>
				<xsl:apply-templates/>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/table ') and ancestor-or-self::*[contains(@class, ' topic/li ')]]">
		<fo:block start-indent="0px">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>


	<xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]">
		<fo:block xsl:use-attribute-sets="section.title">
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>



	<xsl:template match="*[contains(@class, ' task/stepsection ')]">
		<fo:list-item space-after="1em" space-before="1em">
			<xsl:call-template name="commonattributes"/>
			<fo:list-item-label>
				<fo:block/>
			</fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/unknown ')]">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Фомирование заголовка топика -->
	<xsl:template match="*" mode="getTitle">
		<xsl:variable name="topic" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]" />
		<xsl:variable name="id" select="$topic/@id" />
		<xsl:variable name="mapTopics" select="key('map-id', $id)" />

		<xsl:choose>
			<xsl:when test="$mapTopics[1][@props = 'annotation' or @props = 'appendix']">

			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$mapTopics[1]" mode="topicTitleNumber"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[contains(@class, ' bookmap/chapter ')] | *[contains(@class, ' map/topicref ')][not(ancestor-or-self::*[contains(@class,' bookmap/frontmatter ')])]" mode="topicTitleNumber">
		<xsl:number format="1. " count="*[contains(@class, ' map/topicref ')][not(@props = 'annotation')]" level="multiple"/>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' bookmap/chapter ')] | *[contains(@class, ' bookmap/bookmap ')]/opentopic:map/*[contains(@class, ' map/topicref ')]" mode="tocPrefix"/>



	<xsl:template name="insertFooter">
		<fo:table>
			<fo:table-column column-width="20mm"/>
			<fo:table-column/>

			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block>
							<!--fo:external-graphic src="url(Customization/OpenTopic/common/artwork/corner.png)"/-->
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after">
						<fo:block xsl:use-attribute-sets="_footer_pagenum">
							<fo:page-number/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>


 <xsl:template match="*" mode="insertReferenceTitle" priority="-1">
        <xsl:apply-templates select="*[not(contains(@class,' topic/desc '))]|text()"/>
    </xsl:template>

 <xsl:template match="*[contains(@class,' sw-d/filepath ')]">
 	<fo:inline xsl:use-attribute-sets="filepathblock">
      <fo:inline xsl:use-attribute-sets="filepath">
        <xsl:call-template name="commonattributes"/>
        <xsl:apply-templates/>
      </fo:inline>
       	</fo:inline>
    </xsl:template>

 <xsl:template match="*[contains(@class,' pr-d/codeph ')]">
 	<fo:inline xsl:use-attribute-sets="filepathblock">
      <fo:inline xsl:use-attribute-sets="filepath">
        <xsl:call-template name="commonattributes"/>
        <xsl:apply-templates/>
      </fo:inline>
       	</fo:inline>
    </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/div ')]">

  	<xsl:choose>
			<xsl:when test="@outputclass='warn'">
				<fo:table xsl:use-attribute-sets="note_block">
					<fo:table-column column-width="3mm"/>
					<fo:table-column/>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell background-color="{$brand_color_red}"/>
							<fo:table-cell>
								<fo:block xsl:use-attribute-sets="note_content" >
										<xsl:apply-templates/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</xsl:when>
			<xsl:otherwise>

				<fo:table xsl:use-attribute-sets="note_block">
					<fo:table-column column-width="3mm"/>
					<fo:table-column/>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell background-color="{$brand_color_gray}"/>
							<fo:table-cell>
								<fo:block xsl:use-attribute-sets="note_content" >
										<xsl:apply-templates/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>

			</xsl:otherwise>
		</xsl:choose>


    <!--fo:block xsl:use-attribute-sets="div" >
    	 <xsl:attribute name="type">
                   <xsl:value-of select="@outputclass"/>
                    </xsl:attribute>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates/>
    </fo:block-->
  </xsl:template>

</xsl:stylesheet>
