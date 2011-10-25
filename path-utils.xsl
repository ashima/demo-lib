<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="dirname">
    <xsl:param name="reldir" />
    <xsl:param name="path" />
    <xsl:choose>
      <xsl:when test="contains($path,'/')">
        <xsl:variable name="pathel" select="substring-before($path,'/')" />
        <xsl:call-template name="dirname">
          <xsl:with-param name="reldir" select="concat($reldir,$pathel,'/')" />
          <xsl:with-param name="path"
                          select="substring($path,string-length($pathel)+2)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$reldir" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="relativize">
    <xsl:param name="root" />
    <xsl:param name="attr" />
    <xsl:element name="{local-name(.)}">
      <xsl:for-each select="@*">
        <xsl:choose>
          <xsl:when test="local-name(.)=$attr">
            <xsl:attribute name="{$attr}">
              <xsl:value-of select="concat($root,.)" />
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="." />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>