<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

    <!-- Параметры, поступающие из консоли -->
	<xsl:param name="textWrapping" />
	<xsl:param name="skipToc"/>
    <xsl:param name="pbuild"/>


    <xsl:variable name="page-width">210mm</xsl:variable>
    <xsl:variable name="page-height">297mm</xsl:variable>


    <xsl:variable name="default-font-size">12pt</xsl:variable>
    <xsl:variable name="default-line-height">16pt</xsl:variable>

    <xsl:variable name="page-margin-inside">15mm</xsl:variable>
    <xsl:variable name="page-margin-outside">15mm</xsl:variable>
    <xsl:variable name="page-margin-top">24mm</xsl:variable>
    <xsl:variable name="page-margin-bottom">20mm</xsl:variable>

 <xsl:attribute-set name="region-before">
    <xsl:attribute name="extent">20mm</xsl:attribute>
    <xsl:attribute name="display-align">before</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="region-after">
    <xsl:attribute name="extent">20mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
  </xsl:attribute-set>

    <xsl:variable name="generate-back-cover" select="true()"/>
    <xsl:variable name="generate-toc">
        <xsl:choose>
            <xsl:when test="$skipToc = '1'">
                <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="true()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!--<xsl:when test="$skipToc = '1'"> -->


    <!-- базовый размер шрифта -->

    <xsl:variable name="default-block-padding">1em</xsl:variable>
    <!-- По умолчанию таблицы с границами -->
    <xsl:variable name="table.rowsep-default" select="'1'"/>
    <xsl:variable name="table.colsep-default" select="'1'"/>

    <!-- Цвета из брендбука Docsvision -->
    <xsl:variable name="brand_color_violent">#271f47</xsl:variable>
    <xsl:variable name="brand_color_green">#bbd02d</xsl:variable>
    <xsl:variable name="brand_color_red">#ca3625</xsl:variable>
    <xsl:variable name="brand_color_orange">#f18a00</xsl:variable>
    <xsl:variable name="brand_color_blue">#00adbb</xsl:variable>
    <xsl:variable name="brand_color_gray">#333333</xsl:variable>
	<xsl:variable name="brand_color_black">#141414</xsl:variable>

    <xsl:attribute-set name="region-body__frontmatter.odd" use-attribute-sets="region-body.odd">
        <xsl:attribute name="margin-top">0pt</xsl:attribute>
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="base-font">
        <xsl:attribute name="font-size">inherited-property-value(font-size)</xsl:attribute>
        <xsl:attribute name="font-family">Verdana</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">16pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__fo__root">
        <xsl:attribute name="font-family">Verdana</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
    </xsl:attribute-set>


    <!-- Информационные блоки -->
    <xsl:attribute-set name="note_block">
        <xsl:attribute name="margin-top">1em</xsl:attribute>
        <xsl:attribute name="margin-bottom">1em</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note_content">
        <xsl:attribute name="padding">3pt</xsl:attribute>
        <xsl:attribute name="padding-left">1em</xsl:attribute>
        <xsl:attribute name="margin">0pt</xsl:attribute>
        <xsl:attribute name="text-indent">0pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>


    <!-- Введение -->
    <!-- текст в шапке -->
    <xsl:attribute-set name="_header_label_into">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">10mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>

    <!-- краткое содержание -->
    <xsl:attribute-set name="_content_into">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">4mm</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="line-height">150%</xsl:attribute>
    </xsl:attribute-set>

    <!-- отступы строк в TOC -->
    <xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:value-of select="concat(string(number($level) * 10), 'pt')"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <!-- раздел 1-го уровня -->
    <xsl:attribute-set name="__toc__chapter__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="_footer_modname">
        <xsl:attribute name="margin-top">0mm</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <!-- номер страницы в подвале-->
    <xsl:attribute-set name="_footer_pagenum">
        <xsl:attribute name="margin-bottom">10mm</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:attribute-set>
    <!-- Чтобы номер страницЫ в TOC не выводился арабскими -->
    <xsl:attribute-set name="page-sequence.toc" use-attribute-sets="__force__page__count">
        <xsl:attribute name="format"/>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title.base">
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$default-block-padding"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_black"/>
        </xsl:attribute>
        <xsl:attribute name="hyphenate">true</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title" use-attribute-sets="topic.title.base">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="text-transform">uppercase</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="topic.title.base">
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <!-- hack -->
        <xsl:attribute name="border-bottom">none</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="padding-top">16pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.topic.topic.topic.topic.topic.topic.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="section" use-attribute-sets="base-font">
        <xsl:attribute name="space-after">1em</xsl:attribute>
        <xsl:attribute name="space-before">0em</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section.title" use-attribute-sets="topic.title.base"/>
    <xsl:attribute-set name="example.title" use-attribute-sets="topic.title.base"/>

    <!-- отступ для первой строки абзаца -->
    <xsl:attribute-set name="p">
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
        <xsl:attribute name="space-after">0em</xsl:attribute>
    </xsl:attribute-set>

    <!-- я сам контролирую отступы в блоках -->
    <xsl:attribute-set name="common.block">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dl">
         <xsl:attribute name="space-after">
            <xsl:value-of select="$default-block-padding"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dt">
    
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dt__content">
            <xsl:attribute name="space-before">
            <xsl:value-of select="$default-block-padding"/>
        </xsl:attribute>

         <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/dl ')])"/>
            <xsl:value-of select="concat(number($level), 'em')"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dd">
    </xsl:attribute-set>
    <xsl:attribute-set name="dlentry.dd__content">
        <xsl:attribute name="space-after">0em</xsl:attribute>
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
         <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/dl ')])"/>
            <xsl:value-of select="concat(number($level), 'em')"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul">
        <xsl:attribute name="space-after">
        <xsl:value-of select="$default-block-padding"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li">
        <xsl:attribute name="space-after">0em</xsl:attribute>
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol" use-attribute-sets="common.block">
        <xsl:attribute name="provisional-distance-between-starts">2em</xsl:attribute>
        <xsl:attribute name="space-after">
        <xsl:value-of select="$default-block-padding"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li">
        <xsl:attribute name="space-after">0em</xsl:attribute>
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
        <xsl:attribute name="relative-align">baseline</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__label__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="steps.step" use-attribute-sets="ol.li">
    </xsl:attribute-set>


    <xsl:attribute-set name="sl">
        <xsl:attribute name="provisional-distance-between-starts">0pt</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli">
        <xsl:attribute name="space-after">0em</xsl:attribute>
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
    </xsl:attribute-set>

    <!--Links-->
    <xsl:attribute-set name="xref">
        <xsl:attribute name="text-decoration">underline</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="text-indent">1pt</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="space-before">1em</xsl:attribute>
        <xsl:attribute name="margin-bottom">1em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.title">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
        <xsl:attribute name="space-after">0em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="line-height">220%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__platform">
        <xsl:attribute name="margin-top">90mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1em</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-size">48pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_green"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__modname">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-size">22pt</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
        <xsl:attribute name="margin-left">5mm</xsl:attribute>
        <xsl:attribute name="margin-right">5mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1em</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__frontmatter__subsystem">
        <xsl:attribute name="font-size">27pt</xsl:attribute>
        <xsl:attribute name="font-family">Verdana Bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__component">
        <xsl:attribute name="margin-top">4mm</xsl:attribute>
        <xsl:attribute name="font-size">26pt</xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__build">
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__version">
        <xsl:attribute name="margin-top">3em</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="__frontmatter__subname">
        <xsl:attribute name="margin-top">2mm</xsl:attribute>
        <xsl:attribute name="margin-left">20mm</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>

    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__doctype">
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
        <xsl:attribute name="text-transform">uppercase</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>

    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__anothead" use-attribute-sets="topic.title"/>

    <xsl:attribute-set name="body__toplevel">
        <xsl:attribute name="start-indent">0px</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="body__secondLevel">
        <xsl:attribute name="start-indent">0px</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="body">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="stepresult">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="keyword">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="apiname">
        <xsl:attribute name="font-size">from-parent(font-size)</xsl:attribute>
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="systemoutput">
        <!--xsl:attribute name="font-family">Verdana</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute-->
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
        <xsl:attribute name="font-size">from-parent(font-size)</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="userinput">
     <!--xsl:attribute name="font-family">Verdana</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute-->
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
        <xsl:attribute name="font-size">from-parent(font-size)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="filepathblock">
        <xsl:attribute name="background-color">#F2F2F2</xsl:attribute>
        <xsl:attribute name="padding-left">3pt</xsl:attribute>
        <xsl:attribute name="padding-right">3pt</xsl:attribute>
        <xsl:attribute name="padding-top">1px</xsl:attribute>
        <xsl:attribute name="padding-bottom">1px</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="filepath">
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
        <!--xsl:attribute name="font-size">from-parent(font-size)</xsl:attribute-->
        <xsl:attribute name="font-size">10px</xsl:attribute>
        <xsl:attribute name="vertical-align">middle</xsl:attribute>
    </xsl:attribute-set>

    <!--выравнивание картинок с кнопками в списке-->
    <xsl:attribute-set name="image">
        <xsl:attribute name="vertical-align">middle</xsl:attribute>
    </xsl:attribute-set>

     <xsl:attribute-set name="image__block">
        <xsl:attribute name="vertical-align">middle</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="start-indent">0em</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="space-before">1.0em</xsl:attribute>
        <xsl:attribute name="space-after">1.0em</xsl:attribute>
    </xsl:attribute-set>


    <!-- Блоки кода -->
    <xsl:attribute-set name="pre">
        <xsl:attribute name="space-before">1.2em</xsl:attribute>
        <xsl:attribute name="space-after">0.8em</xsl:attribute>
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <xsl:attribute name="background-color">#f0f0f0</xsl:attribute>
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="fn__body">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__callout">
        <xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
        <xsl:attribute name="font-size">60%</xsl:attribute>
        <xsl:attribute name="vertical-align">bottom</xsl:attribute>
    </xsl:attribute-set>


    <!-- Блоки кода -->
    <xsl:attribute-set name="codeblock">
        <xsl:attribute name="margin">0pt</xsl:attribute>
        <xsl:attribute name="background-color">#f0f0f0</xsl:attribute>
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="hyphenate">false</xsl:attribute>
        <xsl:attribute name="start-indent">8pt</xsl:attribute>
        <xsl:attribute name="end-indent">8pt</xsl:attribute>
        <xsl:attribute name="padding">4pt</xsl:attribute>
    </xsl:attribute-set>

    <!--pr-domain-attr.xsl-->
    <xsl:attribute-set name="parmname">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="msgblock">
        <xsl:attribute name="space-before">0.4em</xsl:attribute>
        <xsl:attribute name="space-after">0.8em</xsl:attribute>
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <xsl:attribute name="background-color">#f0f0f0</xsl:attribute>
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    <!--static-content-attr.xsl-->
    <!--First-->
    <xsl:attribute-set name="__frontmatter__first__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">20mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__first__picture">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">14mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__last__footer">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__last__header">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__even__footer">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__even__header">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__odd__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__frontmatter__odd__header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <!--TOC-->
    <xsl:attribute-set name="__toc__odd__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__footer">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__header">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
    </xsl:attribute-set>
    <!--Index-->
    <xsl:attribute-set name="__index__odd__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__footer">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-bottom">6mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__header">
        <xsl:attribute name="margin-left">15mm</xsl:attribute>
        <xsl:attribute name="margin-top">9mm</xsl:attribute>
    </xsl:attribute-set>
    <!--toc-attr.xsl-->
    <!-- текст оглавления -->
    <xsl:attribute-set name="__toc__header" use-attribute-sets="topic.title"/>
    <xsl:attribute-set name="__toc__link">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
             <xsl:attribute name="line-height">130%</xsl:attribute>
         <!--xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">15pt</xsl:when>
                <xsl:when test="$level = 2">14pt</xsl:when>
                <xsl:otherwise>12pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute-->
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__topic__content">
        <xsl:attribute name="text-indent">-.2in</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="line-height">130%</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.1in</xsl:attribute>
    </xsl:attribute-set>
    <!--index-attr.xsl-->
    <xsl:attribute-set name="__index__label" use-attribute-sets="topic.title"/>
    <xsl:attribute-set name="__index__letter-group">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0.1in</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    <!--Задание цвета ссылок related-links в PDF-->
    <xsl:attribute-set name="link__content">
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="glossterm">
        <xsl:attribute name="color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
    <!-- pr_domain-attr.xsl-->
    <xsl:attribute-set name="syntaxdiagram">
        <xsl:attribute name="background-color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="syntaxdiagram.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="background-color">
            <xsl:value-of select="$brand_color_gray"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pt">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="end-indent">24pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pt__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pd">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <xsl:attribute name="space-before">0.3em</xsl:attribute>
        <xsl:attribute name="space-after">0.5em</xsl:attribute>
        <xsl:attribute name="start-indent">6pc</xsl:attribute>
        <xsl:attribute name="end-indent">24pt</xsl:attribute>
    </xsl:attribute-set>


    <!--tables-attr.xsl-->
    <xsl:attribute-set name="table">
        <xsl:attribute name="space-after">0.5em</xsl:attribute>
        <xsl:attribute name="space-before">0.5em</xsl:attribute>
        <xsl:attribute name="padding">1em</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table.title">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__tableframe__top" use-attribute-sets="common.border__top">
        <xsl:attribute name="border-before-color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="common.border__bottom">
        <xsl:attribute name="border-after-color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__tableframe__left" use-attribute-sets="common.border__left">
        <xsl:attribute name="border-start-color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__tableframe__right" use-attribute-sets="common.border__right">
        <xsl:attribute name="border-end-color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table__tableframe__top" use-attribute-sets="__tableframe__top"/>
    <xsl:attribute-set name="table__tableframe__bottom" use-attribute-sets="__tableframe__bottom"/>
    <xsl:attribute-set name="table__tableframe__right" use-attribute-sets="__tableframe__right">
        <xsl:attribute name="border-end-color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table__tableframe__left" use-attribute-sets="__tableframe__left"/>
    <xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="__tableframe__bottom"/>
    <xsl:attribute-set name="thead.row.entry">
        <xsl:attribute name="background-color">
            <xsl:value-of select="$brand_color_violent"/>
        </xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="thead.row.entry__content">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="tbody.row">
        <xsl:attribute name="display-align">before</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="tbody.row.entry">
        <xsl:attribute name="padding-left">0pt</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="tbody.row.entry__content">
        <xsl:attribute name="padding-left">0pt</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="stepxmp">
        <xsl:attribute name="space-before">3pt</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
    </xsl:attribute-set>




</xsl:stylesheet>