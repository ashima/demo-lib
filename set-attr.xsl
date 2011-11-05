<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="class-utils.xsl" />

  <xsl:param name="rel" /> <!-- a rel predicate to search for -->
  <xsl:param name="attr" /> <!-- the attribute to set -->
  <xsl:param name="v" />

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="@rel=$rel">
	<xsl:copy>
	  <xsl:apply-templates select="@*" mode="set" />
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:apply-templates select="*|@*|text()" />
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*"><xsl:copy /></xsl:template>

  <xsl:template match="@*" mode="set">
    <xsl:choose>
      <xsl:when test="local-name()=$attr">
	<xsl:attribute name="{$attr}">
	  <xsl:value-of select="$v" />
	</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
