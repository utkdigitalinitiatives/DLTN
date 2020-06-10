<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.og/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:functx="http://www.functx.com"
                xmlns="http://www.loc.gov/mods/v3"
                exclude-result-prefixes="#all"
                version="2.0">
  <!-- output settings -->
  <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Add Manifest Catalog -->
  <xsl:variable name="catalog" select="document('catalogs/cmhf_catalog.xml')"/>

  <!-- includes and imports -->
    
  <!--
    Collection/Set = Country Music Hall of Fame and Museum (CHMF)
  -->
  
  <!-- identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- normalize all the text! -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- match oai_qdc:qualifieddc -->
  <xsl:template match="oai_qdc:qualifieddc">
    <!-- match the document root and return a MODS record -->
    <mods xmlns="http://www.loc.gov/mods/v3" version="3.5" 
          xmlns:xlink="http://www.w3.org/1999/xlink"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
      <!-- title -->
      <xsl:apply-templates select="dc:title"/>
      <!-- accessRights -->
      <xsl:choose>
        <xsl:when test="dcterms:accessRights">
          <xsl:apply-templates select="dcterms:accessRights"/>
        </xsl:when>
        <xsl:when test="dc:rights">
          <xsl:apply-templates select="dc:rights"/>
        </xsl:when>
        <xsl:otherwise>
          <accessCondition type="local rights statement">
            This digital image is the property of the Country Music Hall of Fame® and Museum and is protected by U.S. and international copyright laws. The image may not be downloaded, reproduced, or distributed without permission. To inquire about use permissions and obtain a high-quality version of this file, contact print@countrymusichalloffame.org. Please cite image information in email.
          </accessCondition>
        </xsl:otherwise>
      </xsl:choose>
      <!-- description -->
      <xsl:apply-templates select="dc:description"/>
      <!-- subject(s) -->
      <xsl:apply-templates select="dc:subject"/>
      <!-- creator(s) -->
      <xsl:apply-templates select="dc:creator"/>
      <!-- identifier(s) that are not URLs -->
      <xsl:apply-templates select="dc:identifier[not(starts-with(., 'http://'))]"/>
      <!-- location: physicalLocation and URLs -->
      <location>
        <!-- identifier beginning with 'http://' -->
        <xsl:apply-templates select="dc:identifier[starts-with(., 'http://')]"/>
      </location>
        <!-- format(s) -->
        <xsl:apply-templates select="dc:format"/>
      <!-- recordInfo -->
      <xsl:call-template name="record-info"/>
    </mods>
  </xsl:template>
  
  <!-- title -->
  <xsl:template match="dc:title">
    <titleInfo>
      <title><xsl:apply-templates/></title>
    </titleInfo>
  </xsl:template>
  
  <!-- accessRights -->
  <xsl:template match="dcterms:accessRights">
    <accessCondition type='local rights statement'><xsl:apply-templates/></accessCondition>
  </xsl:template>

  <xsl:template match="dc:rights">
    <accessCondition type='local rights statement'><xsl:apply-templates/></accessCondition>
  </xsl:template>
  
  <!-- description -->
  <xsl:template match="dc:description">
   <abstract><xsl:apply-templates/></abstract> 
  </xsl:template>
  
  <!-- subject(s) -->
  <xsl:template match="dc:subject[contains(., ';')]">
    <xsl:variable name="subj-tokens" select="tokenize(.,';')"/>
    <xsl:for-each select="$subj-tokens">
      <xsl:if test=". != ''">
        <subject>
          <topic><xsl:value-of select="normalize-space(.)"/></topic>
      </subject>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- a template to match subjects that do *not* end with a trailing ';' -->
  <xsl:template match="dc:subject[not(contains(., ';'))]">
    <subject>
      <topic><xsl:apply-templates/></topic>
    </subject>
  </xsl:template>

  <!-- creator(s) -->
  <xsl:template match="dc:creator">
    <xsl:variable name="creator-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$creator-tokens">
      <name>
        <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
        <role>
          <roleTerm type="text" valueURI="http://id.loc.gov/vocabular/relators/cre">Creator</roleTerm>
        </role>
      </name>
    </xsl:for-each>
  </xsl:template>
  
  <!-- identifier(s) -->
  <!-- identifier - location processing -->
  <xsl:template match="dc:identifier[starts-with(., 'http://')]">
    <xsl:variable name="identifier-preview-url" select="replace(., '/cdm/ref', '/utils/getthumbnail')"/>
    <xsl:variable name="iiif-manifest" select="concat(replace(replace(., 'cdm/ref/collection', 'iiif/info'), '/id', ''), '/manifest.json')"/>
    <url usage="primary" access="object in context"><xsl:apply-templates/></url>
    <url access="preview"><xsl:value-of select="$identifier-preview-url"/></url>
    <xsl:if test="normalize-space(.) = $catalog//@id">
      <url note="iiif-manifest"><xsl:value-of select="$iiif-manifest"/></url>
    </xsl:if>
  </xsl:template>
  
  <!-- a template to match identifiers that do *not* start with 'http://' -->
  <xsl:template match="dc:identifier[not(starts-with(., 'http://'))]">
    <identifier type="local"><xsl:apply-templates/></identifier>
  </xsl:template>
  
  <!-- format(s) -->
  <xsl:template match="dc:format">
    <physicalDescription>
      <form>
        <xsl:apply-templates/>
      </form>
    </physicalDescription>
  </xsl:template>
  
  <!-- record-info template -->
  <xsl:template name="record-info">
    <recordInfo>
      <!-- not sure about the values for some of these elements; maybe we don't want them at all? -->
      <recordContentSource>Country Music Hall of Fame and Museum</recordContentSource>
      <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
      <languageOfCataloging>
        <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
      </languageOfCataloging>
      <recordOrigin>Record has been transformed into MODS v3.5 from a Qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America.</recordOrigin>
    </recordInfo>
  </xsl:template>
  
  <!-- functions -->
  <!-- pulled from the functx stylesheet due to compliation errors with Saxon 8.7 -->
  <xsl:function name="functx:substring-before-last">
    <xsl:param name="arg"/> 
    <xsl:param name="delim"/> 
    
    <xsl:sequence select="if (matches($arg, functx:escape-for-regex($delim)))
                          then replace($arg, concat('^(.*)', functx:escape-for-regex($delim),'.*'), '$1')
                          else ''"/>
    
  </xsl:function>
  
  <xsl:function name="functx:escape-for-regex">
    <xsl:param name="arg"/> 
    
    <xsl:sequence select="replace($arg, '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>
  </xsl:function>
</xsl:stylesheet>

