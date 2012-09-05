<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />

  <xsl:param name="rooted" select="false()" />

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
    <xsl:choose>
      <xsl:when test="@rel='start' and $root != ''" />
      <xsl:otherwise>
        <link>
          <xsl:apply-templates select="@*">
            <xsl:with-param name="root" select="$root" />
          </xsl:apply-templates>
        </link>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="head//script[@src] | script[@src]">
    <xsl:param name="root" />
    <script>
      <xsl:apply-templates select="@*">
        <xsl:with-param name="root" select="$root" />
      </xsl:apply-templates>
    </script>
  </xsl:template>

  <xsl:template match="body//script[@src]">
    <xsl:param name="root" />
    <link rel="tag">
      <xsl:apply-templates select="@src | @type">
        <xsl:with-param name="root" select="$root" />
        <xsl:with-param name="attr" select="'href'" />
      </xsl:apply-templates>
    </link>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy />
  </xsl:template>

  <xsl:template name="make-data-local">
    <xsl:param name="path" />
    <xsl:for-each select="..">
      <xsl:attribute name="data-local">
        <xsl:value-of select="$path" />
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="@href | @src">
    <xsl:param name="root" />
    <xsl:param name="attr" select="local-name()" />
    <xsl:choose>
      <xsl:when test="$rooted and not(contains(../@class,'extra'))">
        <xsl:attribute name="{$attr}">
          <xsl:value-of select="." />
        </xsl:attribute>
        <xsl:if test="$root!='' and not(../@data-src)">
          <xsl:call-template name="make-data-local">
            <xsl:with-param name="path" select="concat($root,.)" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="{$attr}">
          <xsl:value-of select="concat($root,.)" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@data-src">
    <xsl:attribute name="data-src">
      <xsl:choose>
        <xsl:when test="/manifest and not(starts-with(.,'http'))">
          <xsl:value-of select="concat(/manifest/@data-src-prefix,.)" />
        </xsl:when>
        <xsl:when test="//head/@data-src-prefix and not(starts-with(.,'http'))">
          <xsl:value-of select="concat(//head/@data-src-prefix,.)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="." />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
