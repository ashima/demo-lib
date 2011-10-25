<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />

  <xsl:template match="/">
    <manifest>
      <xsl:apply-templates />
    </manifest>
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

  <xsl:template match="link | a">
    <xsl:param name="root" />
    <xsl:call-template name="relativize">
      <xsl:with-param name="root" select="$root" />
      <xsl:with-param name="attr">href</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="script">
    <xsl:param name="root" />
    <xsl:call-template name="relativize">
      <xsl:with-param name="root" select="$root" />
      <xsl:with-param name="attr">src</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
