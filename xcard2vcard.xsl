<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xcard="urn:ietf:params:xml:ns:vcard-4.0">
  <xsl:output method="text" encoding="UTF-8" indent="no"/>
  <xsl:template match="/">
    <xsl:for-each select="vcards/vcard|vcards/vcard/group">
      <xsl:text>BEGIN:VCARD&#xd;</xsl:text>
      <xsl:text>VERSION:2.1&#xd;</xsl:text>

      <xsl:apply-templates select="uid"/>
      <xsl:apply-templates select="n"/>
      <xsl:apply-templates select="nickname"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="adr" />
      <xsl:apply-templates select="anniversary" />
      <xsl:apply-templates select="bday" />
      <xsl:apply-templates select="caladruri"/>
      <xsl:apply-templates select="caluri"/>
      <xsl:apply-templates select="categories"/>
      <xsl:apply-templates select="clientpidmap"/>
      <xsl:apply-templates select="email"/>
      <xsl:apply-templates select="fburl"/>
      <xsl:apply-templates select="fn"/>
      <xsl:apply-templates select="geo"/>
      <xsl:apply-templates select="impp"/>
      <xsl:apply-templates select="key"/>
      <xsl:apply-templates select="kind"/>
      <xsl:apply-templates select="lang"/>
      <xsl:apply-templates select="logo"/>
      <xsl:apply-templates select="member"/>
      <xsl:apply-templates select="note"/>
      <xsl:apply-templates select="org"/>
      <xsl:apply-templates select="photo"/>
      <xsl:apply-templates select="prodid"/>
      <xsl:apply-templates select="related"/>
      <xsl:apply-templates select="rev"/>
      <xsl:apply-templates select="role"/>
      <xsl:apply-templates select="gender"/>
      <xsl:apply-templates select="sound"/>
      <xsl:apply-templates select="source"/>
      <xsl:apply-templates select="tel"/>
      <xsl:apply-templates select="tz"/>
      <xsl:apply-templates select="url"/>
      
      <xsl:text>END:VCARD&#xd;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- top level tags -->
  <xsl:template match="adr">
    <xsl:text>ADR</xsl:text>

    <!-- save attributes for LABEL -->
    <xsl:variable name="lang">
      <xsl:apply-templates select="parameters/language" />
    </xsl:variable>
    <xsl:copy-of select="$lang" />
    <!-- not in vCard -->
    <!-- <xsl:apply-templates select="parameters/altid" /> -->
    <!-- <xsl:apply-templates select="parameters/pid" /> -->

    <!-- preference level -->
    <!-- vCard only has one level of preference for adr -->
    <xsl:if test="parameters/pref/integer[text() = '1']">
      <xsl:text>;PREF</xsl:text>
    </xsl:if>

    <!-- POSTAL and PARCEL are not xCard attributes -->

    <!-- DOMestic or INTL international -->
    <xsl:variable name="domORintl">
      <xsl:choose>
	<xsl:when test="country">
	  <xsl:text>;INTL</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>;DOM</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy-of select="$domORintl" />

    <!-- HOME or WORK -->
    <xsl:apply-templates select="parameters/type" />
    
    <xsl:text>:</xsl:text>

    <!--Post Office Address (first field)-->
    <xsl:variable name="pobox">
      <xsl:apply-templates  select="pobox" />
    </xsl:variable>
    <xsl:copy-of select="$pobox" />
    <xsl:text>;</xsl:text>
    <!-- Extended Address (second field) -->
    <xsl:variable name="ext">
      <xsl:apply-templates select="ext" />
    </xsl:variable>
    <xsl:copy-of select="$ext" />
    <xsl:text>;</xsl:text>
    <!-- Street (third field) -->
    <xsl:variable name="street">
      <xsl:apply-templates select="street" />
    </xsl:variable>
    <xsl:copy-of select="$street" />
    <xsl:text>;</xsl:text>
    <!-- Locality (fourth field) -->
    <xsl:variable name="locality">
      <xsl:apply-templates select="locality" />
    </xsl:variable>
    <xsl:copy-of select="$locality" />
    <xsl:text>;</xsl:text>
    <!-- Region (fifth field) -->
    <xsl:variable name="region">
      <xsl:apply-templates select="region" />
    </xsl:variable>
    <xsl:copy-of select="$region" />
    <xsl:text>;</xsl:text>
    <!-- Postal Code (six field) -->
    <xsl:variable name="code">
      <xsl:apply-templates select="code" />
    </xsl:variable>
    <xsl:copy-of select="$code" />
    <xsl:text>;</xsl:text>
    <!-- Country (seventh field) -->
    <xsl:variable name="country">
      <xsl:apply-templates select="country" />
    </xsl:variable>
    <xsl:copy-of select="$country" />
    <xsl:text>&#xd;</xsl:text>

    <!-- are there own parameter in vCard -->
    
    <xsl:call-template name="label">
      <xsl:with-param name="lang" select="$lang" />
      <xsl:with-param name="domORintl" select="$domORintl" />
      <xsl:with-param name="pobox" select="$pobox" />
      <xsl:with-param name="ext" select="$ext" />
      <xsl:with-param name="street" select="$street" />
      <xsl:with-param name="locality" select="$locality" />
      <xsl:with-param name="region" select="$region" />
      <xsl:with-param name="code" select="$code" />
      <xsl:with-param name="country" select="$country" />
    </xsl:call-template>

    <xsl:apply-templates select="parameters/geo" />
    <xsl:apply-templates select="parameters/tz" />
    <!-- label shares a lot of the same information with adr -->
  </xsl:template>
  <xsl:template match="anniversary">
  </xsl:template>
  <xsl:template match="bday">
  </xsl:template>
  <xsl:template match="caladruri">
  </xsl:template>
  <xsl:template match="caluri">
  </xsl:template>
  <xsl:template match="categories">
  </xsl:template>
  <xsl:template match="clientpidmap">
  </xsl:template>
  <xsl:template match="email">
  </xsl:template>
  <xsl:template match="fburl">
  </xsl:template>
  <xsl:template match="fn">
  </xsl:template>
  <xsl:template match="geo">
  </xsl:template>
  <xsl:template match="impp">
  </xsl:template>
  <xsl:template match="key">
  </xsl:template>
  <xsl:template match="kind">
  </xsl:template>
  <xsl:template match="lang">
  </xsl:template>
  <xsl:template match="logo">
  </xsl:template>
  <xsl:template match="member">
  </xsl:template>
  <xsl:template match="n">
  </xsl:template>
  <xsl:template match="nickname">
  </xsl:template>
  <xsl:template match="note">
  </xsl:template>
  <xsl:template match="org">
  </xsl:template>
  <xsl:template match="photo">
  </xsl:template>
  <xsl:template match="prodid">
  </xsl:template>
  <xsl:template match="related">
  </xsl:template>
  <xsl:template match="rev">
  </xsl:template>
  <xsl:template match="role">
  </xsl:template>
  <xsl:template match="gender">
  </xsl:template>
  <xsl:template match="sound">
  </xsl:template>
  <xsl:template match="source">
  </xsl:template>
  <xsl:template match="tel">
  </xsl:template>
  <xsl:template match="title">
  </xsl:template>
  <xsl:template match="tz">
  </xsl:template>
  
  <xsl:template match="uid">
    <xsl:text>UID:</xsl:text>
    <xsl:value-of select="uri/text()" />
    <xsl:text>&#xd;</xsl:text>
  </xsl:template>
  
  <xsl:template match="url">
  </xsl:template>

  <xsl:template match="geo">
  </xsl:template>

  <xsl:template match="tz">
  </xsl:template>

  <xsl:template match="label">
    <xsl:param name="lang" />
    <xsl:param name="domORintl" />
    <xsl:param name="pobox" />
    <xsl:param name="ext" />
    <xsl:param name="street" />
    <xsl:param name="locality" />
    <xsl:param name="region" />
    <xsl:param name="code" />
    <xsl:param name="country" />
    <xsl:text>LABEL</xsl:text>
    <xsl:copy-of select="$lang" />
    <xsl:copy-of select="$domORintl" />
    <xsl:text>:</xsl:text>
    <xsl:choose>
      <xsl:when test="descendant-or-self::node()/*[name() = 'label']//text">
	<!-- replace newlines with =0D=0A= -->
	<xsl:value-of select="descendant-or-self::node()/*[name()='label']//text/text()[string-join(tokenize(.,'&#xd;'), '=0D=0A=')]" />
      </xsl:when>
      <xsl:otherwise>
	<!-- default mailing label -->
	<xsl:copy-of select="$pobox" />
	<xsl:text>=0D=0A=</xsl:text>
	<xsl:copy-of select="$ext" />
	<xsl:text>=0D=0A=</xsl:text>
	<xsl:copy-of select="$street" />
	<xsl:text>=0D=0A=</xsl:text>
	<xsl:copy-of select="$locality" />
	<xsl:text>, </xsl:text>
	<xsl:copy-of select="$region" />
	<xsl:text> </xsl:text>
	<xsl:copy-of select="$code" />
	<xsl:text>=0D=0A=</xsl:text>
	<xsl:copy-of select="$country" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xd;</xsl:text>
  </xsl:template>
  

  <!-- parameters -->
  <xsl:template match="language">
    <xsl:text>;LANGUAGE=</xsl:text>
    <xsl:value-of select="language-tag/text()" />
  </xsl:template>

  <xsl:template match="altid">
    <xsl:value-of select="text/text()" />
  </xsl:template>

  <xsl:template match="type">
    <xsl:text>;</xsl:text>
    <xsl:value-of select="text/text()[upper-case(.)]" />
  </xsl:template>

  <xsl:template match="pobox">
    <xsl:value-of select="text()" />
  </xsl:template>
  <xsl:template match="ext">
    <xsl:value-of select="text()" />
  </xsl:template>
  <xsl:template match="street">
    <xsl:value-of select="text()" />
  </xsl:template>
  <xsl:template match="locality">
    <xsl:value-of select="text()" />
  </xsl:template>
  <xsl:template match="region">
    <xsl:value-of select="text()" />
  </xsl:template>
  <xsl:template match="country">
    <xsl:value-of select="text()" />
  </xsl:template>
  <xsl:template match="code">
    <xsl:value-of select="text()" />
  </xsl:template>
</xsl:stylesheet>
