<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html" doctype-public="XSLT-compat" omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />
  <xsl:template match="root">
    <html>
      <head>
        <link rel="stylesheet" href="webfile.css" />
      </head>
      <body>
        <div id="header">
          <h1><a href="/">https://file.localhost.localdomain</a></h1>
        </div>
        <div id="main">
          <xsl:apply-templates />
          <div id="footer">(c) 2017, WebFile</div>
        </div>
      </body>
    </html>
	</xsl:template>

  <xsl:template match="upload">
    <form action="upload" method="post" enctype="multipart/form-data">
        <h1>Отправить</h1>
        <input type="file" name="fName[]" multiple="true" />
        <input type="submit" value="Отправить" />
        <div class="progress">
            <div class="bar"></div >
            <div class="percent">0%</div >
        </div>
        <p class="note">* В сумме - не более 10 Гбайт.</p>
    </form>

    <script src="jquery.js" />
    <script src="jquery.form.js" />
    <script src="webfile.js" />
  </xsl:template>

  <xsl:template match="download">
    <h1>Получить</h1>
    <ol class="files">
      <xsl:apply-templates />
    </ol>
  </xsl:template>

  <xsl:template match="file">
    <li class="file">
      <a>
        <xsl:attribute name = "href"><xsl:value-of select = "@dir"/>/<xsl:value-of select = "@name"/></xsl:attribute>
        <xsl:value-of select = "@name"/>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
