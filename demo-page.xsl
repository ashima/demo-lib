<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
      <xsl:when test="$id='ok'">
	<button onclick="run()">
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
  
  <xsl:template match="manifest">
    <xsl:variable name="html" select="document(a[@rel='start']/@href)/html" />
    <head>
      <xsl:for-each
	  select="$html/head/*[not(@rel) or (@rel!='prefetch' and @rel!='tag')]">
	<xsl:copy-of select="." />
      </xsl:for-each>
      <xsl:for-each select="link[@rel='prefetch' or @rel='tag']">
	<link>
	  <xsl:copy-of select="@*[local-name(.)!='data-src']" />
	</link>
      </xsl:for-each>

      <xsl:copy-of select="$exprs/head/*" />
      <script type="text/javascript"
	      src="demo-lib/webgl-diagnostic/js/webgldiagdata.js"></script>
      <script type="text/javascript"
	      src="demo-lib/webgl-diagnostic/js/webgldiagnostic.js"></script>
      <script type="text/javascript"
	      src="demo-lib/js/diag.js"></script>
      <script type="text/javascript"
	      src="demo-lib/js/run.js"></script>
    </head>
    <body onload="WebGLDiagnostic.diagnose(diag_out)">
      <article>
	<xsl:attribute name="style">display: none</xsl:attribute>
	<xsl:copy-of select="$html/body/article/@*" />
	<xsl:copy-of select="$html/body/article/node()" />
      </article>
      <div id="demo-frontis">
	<h1><xsl:value-of select="$html/head/title" /></h1>
	<h2><xsl:copy-of select="$demo-text/messages/*[@id='subtitle']/node()" /></h2>
	<xsl:call-template name="webgl-diagnostic">
	  <xsl:with-param name="overlay" select="$demo-text/messages" />
	</xsl:call-template>
      </div>
    </body>
  </xsl:template>
</xsl:stylesheet>
