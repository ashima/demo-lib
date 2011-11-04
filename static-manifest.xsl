<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />

  <xsl:template match="/">
    <manifest>
      <xsl:apply-templates />
    </manifest>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="link[@rel='manifest']">
    <xsl:param name="root" />
    <xsl:apply-templates select="document(@href)/manifest/node()">
      <xsl:with-param name="root">
	<xsl:call-template name="dirname">
	  <xsl:with-param name="reldir" select="$root" />
	  <xsl:with-param name="path" select="@href" />
	</xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="link">
    <xsl:param name="root" />
    <link href="{concat($root,@href)}">
      <xsl:apply-templates select="@*" />
    </link>
  </xsl:template>

  <xsl:template match="head//script[@src] | script[@src]">
    <xsl:param name="root" />
    <script src="{concat($root,@src)}">
      <xsl:apply-templates select="@*" />
    </script>
  </xsl:template>

  <xsl:template match="body//script[@src]">
    <xsl:param name="root" />
    <link rel="tag" href="{concat($root,@src)}">
      <xsl:apply-templates select="@type" />
    </link>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy />
  </xsl:template>

  <xsl:template match="@href | @src" />

  <xsl:template match="@data-src">
    <xsl:attribute name="data-src">
      <xsl:choose>
        <xsl:when test="/manifest">
          <xsl:value-of select="concat(/manifest/@data-src-prefix,.)" />
        </xsl:when>
        <xsl:when test="//head/@data-src-prefix">
          <xsl:value-of select="concat(//head/@data-src-prefix,.)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
