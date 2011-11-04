<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="has_class">
    <xsl:param name="class" />
    <xsl:variable name="classes" select="normalize-space(@class)" />
    <xsl:variable name="lens" select="string-length($classes)" />
    <xsl:variable name="len" select="string-length($class)" />
    <xsl:choose>
      <xsl:when test="contains($classes, ' $class ')
                      or substring($classes, 1, $len + 1) = '$class '
                      or substring($classes, $lens - $len) = ' $class'
                      or $classes = $class">
        <xsl:value-of select="true()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>