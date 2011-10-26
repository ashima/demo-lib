<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />
  <xsl:output method="text" indent="no" />
  
  <xsl:template match="/">
    <xsl:text>#!/bin/sh&#xA;&#xA;</xsl:text>
    <xsl:apply-templates mode="fs" />
    <xsl:apply-templates mode="http" />
  </xsl:template>

  <xsl:template match="text()" mode="fs">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="text()" mode="http">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="link[@data-src]" mode="fs">
    <xsl:text>mkdir -p </xsl:text>
    <xsl:call-template name="dirname">
      <xsl:with-param name="reldir" />
      <xsl:with-param name="path" select="@href" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="link[@data-src]" mode="http">
    <xsl:text>wget </xsl:text>
    <xsl:value-of select="@data-src" />
    <xsl:text> -nc -O </xsl:text>
    <xsl:value-of select="@href" />
  </xsl:template>
</xsl:stylesheet>
