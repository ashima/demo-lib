<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="path-utils.xsl" />
  <xsl:include href="webgl-diagnostic/lang/message.xsl" />

  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:param name="lang" select="'en'" />
  <xsl:variable
      name="exprs"
      select="document(concat('webgl-diagnostic/lang/',$lang,'.xml'))/diagnostic" />

  <xsl:template name="webgl-diagnostic">
    <xsl:param name="overlay" />
    <xsl:apply-templates
	select="document('webgl-diagnostic.xhtml')" mode="webgl-diag">
      <xsl:with-param name="overlay" select="$overlay" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@* | node()" mode="webgl-diag">
    <xsl:param name="overlay" />
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="webgl-diag">
	<xsl:with-param name="overlay" select="$overlay" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="message" mode="webgl-diag">
    <xsl:param name="overlay" />
    <xsl:variable name="id" select="@id" />
    <xsl:choose>
      <xsl:when test="$id='ok' or $id='override'">
	<button onclick="run(main, pause)">
	  <xsl:apply-templates select="$overlay/message[@id=$id]">
	    <xsl:with-param name="messages" select="$overlay" />
	  </xsl:apply-templates>
	</button>
      </xsl:when>
      <xsl:when test="$overlay/message[@id=$id]">
	<xsl:apply-templates select=".">
	  <xsl:with-param name="messages" select="$overlay" />
	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">
    <!-- TODO: test, connect validator to build system -->
    <!--<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html>
    </xsl:text>-->
    <html>
      <xsl:apply-templates />
    </html>
  </xsl:template>
  
  <xsl:template match="link" mode="manifest">
    <link>
      <xsl:copy-of select="@*[local-name(.)!='data-src']" />
    </link>
  </xsl:template>
  <xsl:template match="script" mode="manifest">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="@*|node()" mode="article">
    <xsl:copy-of select="." />
  </xsl:template>
  <xsl:template match="*" mode="article">
    <xsl:param name="root" />
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="node()|@*" mode="article">
	<xsl:with-param name="root" select="$root" />
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  <xsl:template match="script/@src" mode="article">
    <xsl:param name="root" />
    <xsl:attribute name="src">
      <xsl:value-of select="concat($root,.)" />
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="img/@src" mode="article">
    <xsl:param name="root" />
    <xsl:attribute name="src">
      <xsl:choose>
        <xsl:when test="substring(.,1,4)='http'">
          <xsl:copy />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($root,.)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="manifest">
    <xsl:variable name="root">
      <xsl:call-template name="dirname">
	<xsl:with-param name="reldir" />
	<xsl:with-param name="path" select="link[@rel='start']/@href" />	
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="html" select="document(link[@rel='start']/@href)/html" />
    <head>
      <xsl:for-each
	  select="$html/head/*[local-name(.)!='link' and local-name(.)!='script']">
	<xsl:copy-of select="." />
      </xsl:for-each>

      <xsl:apply-templates select="link | script" mode="manifest" />

      <xsl:copy-of select="$exprs/head/*" />
    </head>
    <body onload="WebGLDiagnostic.diagnose(diag_out)">
      <article>
	<xsl:attribute name="style">display: none</xsl:attribute>
	<xsl:copy-of select="$html/body/article/@*" />
	<xsl:apply-templates select="$html/body/article/*" mode="article">
	  <xsl:with-param name="root" select="$root" />
	</xsl:apply-templates>
      </article>
      <div id="demo-frontis">
	<h1 class="demo-title"><xsl:value-of select="$html/head/title" /></h1>
	<h2 class="demo-subtitle"><xsl:copy-of select="$demo-text/messages/*[@id='subtitle']/node()" /></h2>
	<xsl:call-template name="webgl-diagnostic">
	  <xsl:with-param name="overlay" select="$demo-text/messages" />
	</xsl:call-template>
      </div>
    </body>
  </xsl:template>
</xsl:stylesheet>
