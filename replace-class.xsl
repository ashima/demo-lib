<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="class-utils.xsl" />

  <xsl:param name="class" /> <!-- the class we are eliding -->
  <xsl:param name="manifest" /> <!-- the manifest path we are inserting -->

  <xsl:template match="link | script">
    <xsl:variable name="b">
      <xsl:call-template name="has_class">
        <xsl:with-param name="class" select="$class" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$b='false'"><xsl:copy-of select="." /></xsl:if>
  </xsl:template>

  <xsl:template match="manifest">
    <xsl:copy>
      <xsl:apply-templates />
      <link rel="manifest" type="text/xml" href="{$manifest}" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
