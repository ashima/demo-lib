<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" indent="no" />

  <xsl:include href="class-utils.xsl" />

  <xsl:param name="class" /> <!-- the class we are extracting -->

  <xsl:template match="link">
    <xsl:variable name="b">
      <xsl:call-template name="has_class">
        <xsl:with-param name="class" select="$class" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$b='true'">
      <xsl:value-of select="@href" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="script">
    <xsl:variable name="b">
      <xsl:call-template name="has_class">
        <xsl:with-param name="class" select="$class" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$b='true'">
      <xsl:value-of select="@src" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" />

</xsl:stylesheet>
