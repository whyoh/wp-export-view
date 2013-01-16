<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="/">
   <html>
   <head>
   <!-- firefox doesn't support disable-output-escaping (bug 98168) so doing this the hard way -->
   <!-- from https://bugzilla.mozilla.org/show_bug.cgi?id=98168#c62 -->
    <xsl:if test="system-property('xsl:vendor')='Transformiix'">
      <!-- Mozilla ignores disable-output-escaping -->
      <script type="text/javascript">
        function onload_cb() {
            var elements = document.getElementsByTagName('div');
            for (var i = 0; i &lt; elements.length; i++) {
                var el = elements[i];
                if (el.className == 'content') {
                    el.innerHTML = el.firstChild.data;
                }
            }
        }
      </script>
    </xsl:if>
    <style>
      body {
    		margin: 20px 100px;
    		font-family: sans-serif;
    		background: lightgrey;
    		color: darkgrey;
    	}
    	h2 {
    		margin: 1em 0 0;
    	}
    	.itemid {
    		font-style: italic;
    		font-weight: normal;
    		margin-left: 1em;
    		font-family: serif;
    	}
    	.item {
    		color: black;
    		background: white;
    		padding: 20px;
    	}
    	.content h1 {
    		font-weight: bold;
    		font-size: 1.15em;
    	}
    	.content h2 {
    		font-weight: bold;
    		font-style: italic;
    		font-size: 1.1em;
    	}
    	.content h4 {
    		font-style: italic;
    		font-weight: bold;
    	}
    	.clear {
    		clear: both;
    	}
    	.shortcode {
    		color: grey;
    		font-style: italic;
    		font-family: monospace;
    	}
    	.field {
    		font-weight: bold;
    	}
    </style>
   </head>
  <body>
    <xsl:if test="system-property('xsl:vendor')='Transformiix'">
      <xsl:attribute name="onload">onload_cb()</xsl:attribute>
    </xsl:if>
   <h1><xsl:value-of select="/rss/channel/title"/></h1>
			<xsl:apply-templates select="/rss/channel/item"/>
	</body>
	</html>
   </xsl:template>

	<xsl:template match="/rss/channel/item">
   <h2><xsl:value-of select="./title"/><span class='itemid'>(ID: <xsl:value-of select="./*[local-name() = 'post_id' and namespace-uri() = 'http://wordpress.org/export/1.1/']"/>)</span></h2>
   <div class="item"><div class='content'><xsl:call-template name="tag-shortcodes"><xsl:with-param name="text" select="./*[local-name() = 'encoded' and namespace-uri() = 'http://purl.org/rss/1.0/modules/content/']"/></xsl:call-template></div><div class='clear'/></div>
	</xsl:template>

<xsl:template name="tag-shortcodes">
  <xsl:param name="text" />
  <xsl:choose>
    <xsl:when test="contains($text, '[') and contains($text, ']')">
      <xsl:variable name='before' select="substring-before($text, '[')" />
      <xsl:variable name='therest' select="substring-after($text, '[')" />
      <xsl:variable name='middle' select="substring-before($therest, ']')" />
      <xsl:variable name='after' select="substring-after($therest, ']')" />
      <xsl:value-of select="$before" disable-output-escaping="yes" />
      <xsl:choose>
          <xsl:when test="system-property('xsl:vendor')='Transformiix'">&lt;span class='shortcode'&gt;[<xsl:call-template name="tag-field"><xsl:with-param name="text" select="$middle" />
      </xsl:call-template>]&lt;/span&gt;</xsl:when>
	      <xsl:otherwise><span class='shortcode'>[<xsl:call-template name="tag-field"><xsl:with-param name="text" select="$middle" />
      </xsl:call-template>]</span></xsl:otherwise>
      </xsl:choose> <xsl:call-template name="tag-shortcodes">
        <xsl:with-param name="text" select="$after" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" disable-output-escaping="yes" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tag-field">
  <xsl:param name="text" />
  <xsl:variable name="start">field='</xsl:variable>
  <xsl:variable name="end">'</xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text, $start)">
      <xsl:variable name='before' select="substring-before($text, $start)" />
      <xsl:variable name='therest' select="substring-after($text, $start)" />
      <xsl:variable name='middle' select="substring-before($therest, $end)" />
      <xsl:variable name='after' select="substring-after($therest, $end)" />
      <xsl:value-of select="$before" disable-output-escaping="yes" />
      <xsl:value-of select="$start" disable-output-escaping="yes" />
      <xsl:choose>
          <xsl:when test="system-property('xsl:vendor')='Transformiix'">&lt;span class='field'&gt;<xsl:value-of select="$middle" disable-output-escaping="yes" />&lt;/span&gt;</xsl:when>
	      <xsl:otherwise><span class='field'><xsl:value-of select="$middle" disable-output-escaping="yes" /></span></xsl:otherwise>
      </xsl:choose> <xsl:value-of select="$end" disable-output-escaping="yes" />
		<xsl:value-of select="$after" disable-output-escaping="yes" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" disable-output-escaping="yes" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:transform>
