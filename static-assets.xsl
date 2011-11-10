<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />
  <xsl:output method="text" indent="no" />
  
  <xsl:template match="/">
    <xsl:text>#!/bin/sh&#xA;&#xA;</xsl:text>
    <xsl:apply-templates mode="http" />
  </xsl:template>

  <xsl:template match="text()" mode="http">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="link[@data-src]" mode="http">
    <xsl:variable name="prefix">
      <xsl:if test="//head/@data-src-prefix">
	<xsl:value-of select="//head/@data-src-prefix" />
      </xsl:if>
      <xsl:if test="/manifest/@data-src-prefix">
	<xsl:value-of select="/manifest/@data-src-prefix" />
      </xsl:if>
    </xsl:variable>
    <xsl:text>curl </xsl:text>
    <xsl:value-of select="concat($prefix,@data-src)" />
    <xsl:text> -o </xsl:text>
    <xsl:value-of select="@href" />
    <xsl:text> -z </xsl:text>
    <xsl:value-of select="@href" />
  </xsl:template>
</xsl:stylesheet>
