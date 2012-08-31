<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />
  <xsl:output method="text" indent="no" />

  <xsl:param name="action" select="'create'" />
  
  <xsl:template match="/">
    <xsl:text>#!/bin/sh&#xA;&#xA;</xsl:text>
    <xsl:apply-templates mode="remote" />
    <xsl:apply-templates mode="local" />
  </xsl:template>

  <xsl:template match="text()" mode="remote">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  <xsl:template match="text()" mode="local">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="link[@data-src]" mode="remote">
    <xsl:if test="$action='create'">
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
      <xsl:text> --create-dirs -o </xsl:text>
      <xsl:value-of select="@href" />
      <xsl:text> -z </xsl:text>
      <xsl:value-of select="@href" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="local-fs">
    <xsl:param name="path" />
    <xsl:if test="$action='create'">
      <xsl:text>mkdir -p `dirname </xsl:text>
      <xsl:value-of select="$path" />
      <xsl:text>`&#xA;</xsl:text>
      <xsl:text>cp -f </xsl:text>
      <xsl:value-of select="@data-local" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="$path" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
    <xsl:if test="$action='delete'">
      <xsl:text>rm -rfv </xsl:text>
      <xsl:choose>
        <xsl:when test="contains($path,'/')">
          <xsl:value-of select="substring-before($path,'/')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$path" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="link[@data-local]" mode="local">
    <xsl:call-template name="local-fs">
      <xsl:with-param name="path" select="@href" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="script[@data-local]" mode="local">
    <xsl:call-template name="local-fs">
      <xsl:with-param name="path" select="@src" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
