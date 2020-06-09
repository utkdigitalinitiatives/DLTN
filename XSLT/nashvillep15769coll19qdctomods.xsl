<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns="http://www.loc.gov/mods/v3"
                xpath-default-namespace="http://worldcat.org/xmlschema/qdc-1.0/"
                exclude-result-prefixes="xs xsi oai oai_qdc dcterms dc"
                version="2.0">

  <!-- output settings -->
  <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- includes and imports -->

  <!--
    Collection/Set = UT Chattanooga's sets as Qualified Dublin Core => MODS
  -->

  <!-- variables and parameters -->
  <!--
    dc:language processing parameter: there are multiple language values in the
    QDC.
  -->
  <xsl:variable name="catalog" select="document('catalogs/nashville_catalog.xml')"/>
  <xsl:param name="pLang">
    <l string="eng">english</l>
    <l string="eng">en</l>
    <l string="eng">eng</l>
    <l string="deu">german</l>
    <l string="spa">spanish</l>
    <l string="zxx">zxx</l>
    <l string="zxx">no linguistic content.</l>
  </xsl:param>


  <!-- identity tranform -->
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
    <!-- document-level variables -->
    <!-- match the document root and return a MODS record -->
    <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
      <!-- title -->
      <titleInfo>
        <xsl:apply-templates select="dc:title"/>
        <xsl:apply-templates select="dcterms:alternative"/>
      </titleInfo>
      <!-- description -->
      <xsl:apply-templates select="dc:description"/>
      <!-- creator(s) -->
      <xsl:apply-templates select="dc:creator"/>
      <!-- contributor(s) -->
      <xsl:apply-templates select="dc:contributor"/>
      <!-- rightsHolder(s) -->
      <xsl:apply-templates select="dcterms:rightsHolder"/>
      <!-- subject(s) -->
      <xsl:apply-templates select="dc:subject"/>
      <xsl:apply-templates select="dcterms:spatial"/>
      <!-- language(s) -->
      <xsl:apply-templates select="dc:language"/>
      <!-- identifier(s) that are not URLs -->
      <xsl:apply-templates select="dc:identifier[not(starts-with(normalize-space(.), 'http://'))]"/>
      <!-- originInfo -->
      <originInfo>
        <!-- publisher -->
        <xsl:apply-templates select="dc:publisher"/>
        <!-- dcterms:created -->
        <xsl:apply-templates select="dcterms:created"/>
        <!-- dcterms:modified -->
        <xsl:apply-templates select="dcterms:modified"/>
      </originInfo>
      <!-- accessCondition -->
      <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/InC/1.0/">In Copyright</accessCondition>
      <!-- location: physicalLocation and URLs -->
      <location>
        <xsl:apply-templates select="dc:identifier[starts-with(normalize-space(.), 'http://')]"/>
      </location>
      <!-- physicalDescription -->
      <physicalDescription>
        <!-- formats -->
        <xsl:apply-templates select="dc:format"/>
        <!-- dcterms:extent -->
        <xsl:apply-templates select="dcterms:extent"/>
        <!-- type(s) that start with a lower-case letter -->
        <xsl:apply-templates select="dc:type"/>
      </physicalDescription>
      <recordInfo>
        <recordContentSource>Nashville Public Library</recordContentSource>
        <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
        <languageOfCataloging>
          <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
        </languageOfCataloging>
        <recordOrigin>Record has been transformed into MODS 3.5 from a Qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/digitallibraryoftennessee/DLTN_XSLT. Metadata originally created in a locally modified version of Qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA).</recordOrigin>
      </recordInfo>
    </mods>
  </xsl:template>

  <!-- title -->
  <xsl:template match="dc:title">
    <title><xsl:apply-templates/></title>
  </xsl:template>

  <!-- alternative title(s) -->
  <xsl:template match="dcterms:alternative">
    <title type="alternative"><xsl:apply-templates/></title>
  </xsl:template>

  <!-- description -->
  <xsl:template match="dc:description">
    <abstract><xsl:apply-templates/></abstract>
  </xsl:template>

  <!-- creator(s) -->
  <xsl:template match="dc:creator">
    <xsl:variable name="creator-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$creator-tokens">
      <name>
        <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
        <role>
          <roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
        </role>
      </name>
    </xsl:for-each>
  </xsl:template>

  <!-- contributor(s) -->
  <xsl:template match="dc:contributor">
    <xsl:variable name="contributor-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$contributor-tokens">
      <name>
        <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
        <role>
          <roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
        </role>
      </name>
    </xsl:for-each>
  </xsl:template>

  <!-- rightsHolder(s) -->
  <xsl:template match="dcterms:rightsHolder">
    <xsl:variable name="rh-tokens" select="tokenize(., ';')"/>
    <name>
      <namePart><xsl:value-of select="$rh-tokens"/></namePart>
      <role>
        <roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators/cph">Copyright holder</roleTerm>
      </role>
    </name>
  </xsl:template>
  
  <!-- subject(s) -->
  <!-- for subjects, whether they contains a ';' or not -->
  <xsl:template match="dc:subject">
    <xsl:variable name="subj-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$subj-tokens">
      <subject>
        <topic><xsl:value-of select="normalize-space(.)"/></topic>
      </subject>
    </xsl:for-each>
  </xsl:template>

  <!-- spatial to subject/geographic -->
  <xsl:template match="dcterms:spatial">
    <xsl:variable name="spatial-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$spatial-tokens">
      <subject>
        <geographic><xsl:value-of select="normalize-space(.)"/></geographic>
      </subject>
    </xsl:for-each>
  </xsl:template>

  <!-- language(s) -->
  <!--
    There are multiple dc:language elements; e.g.
      <dc:language>Spanish</dc:language>
      <dc:language>spa</dc:language>
      or
      <dc:language>English; German</dc:language>
      <dc:language>eng; deu</dc:language>
    The list of languages (pLang, above) is exhaustive for the current set of
    records. The following template matches the first dc:language element, tokenizes
    the value(s), and then does some comparisons vs the values in pLang.

  -->
  <xsl:template match="dc:language[1]">
    <xsl:variable name="lang-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$lang-tokens">
      <xsl:variable name="ltln" select="lower-case(normalize-space(.))"/>
      <xsl:choose>
        <xsl:when test="$ltln = $pLang/l">
          <languageTerm type="code" authority="iso639-2b">
            <xsl:value-of select="$pLang/l[. = $ltln]/@string"/>
          </languageTerm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- publisher -->
  <xsl:template match="dc:publisher">
    <publisher><xsl:apply-templates/></publisher>
  </xsl:template>

  <!-- dcterms:created -->
  <xsl:template match="dcterms:created">
    <xsl:variable name="date-tokens"
                  select="if (contains(., ','))
                          then (tokenize(., ','))
                          else if (contains(., ';'))
                            then (tokenize(., ';'))
                            else (.)"/>
    <dateCreated encoding="edtf" point="start"><xsl:value-of select="$date-tokens[1]"/></dateCreated>
    <xsl:if test="count($date-tokens) > 1">
      <dateCreated encoding="edtf" point="end">
        <xsl:value-of select="normalize-space($date-tokens[position() = last()])"/>
      </dateCreated>
    </xsl:if>
  </xsl:template>
  
  <!-- dcterms:modified -->
  <xsl:template match="dcterms:modified">
    <dateModified><xsl:apply-templates/></dateModified>
  </xsl:template>

  <!-- identifier(s) -->
  <!-- identifier - location processing -->
  <xsl:template match="dc:identifier[starts-with(normalize-space(.), 'http://')]">
    <xsl:variable name="identifier-preview-url" select="replace(., '/cdm/ref', '/utils/getthumbnail')"/>
    <xsl:variable name="iiif-manifest" select="concat(replace(replace(., 'cdm/ref/collection', 'digital/iiif'), '/id', ''), '/manifest.json')"/>
    <url usage="primary" access="object in context"><xsl:apply-templates/></url>
    <url access="preview"><xsl:value-of select="$identifier-preview-url"/></url>
    <xsl:if test="normalize-space(.) = $catalog//@id">
      <url note="iiif-manifest"><xsl:value-of select="$iiif-manifest"/></url>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dc:identifier[not(starts-with(normalize-space(.), 'http://'))]">
    <identifier type="local"><xsl:apply-templates/></identifier>
  </xsl:template>

  <!-- type(s) starting with lower-case letters -->
  <xsl:template match="dc:type">
    <xsl:variable name="lc-type-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$lc-type-tokens">
      <form><xsl:value-of select="normalize-space(.)"/></form>
    </xsl:for-each>
  </xsl:template>

  <!-- source -->
  <xsl:template match="dc:source">
    <title><xsl:apply-templates/></title>
  </xsl:template>

  <!-- dcterms:isPartOf -->
  <xsl:template match="dcterms:isPartOf">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <!-- format(s) and dcterms:extent(s) -->
  <!--
    For formats that contain something that resembles an xs:time, serialize
    an <extent>.
  -->
  <xsl:template match="dc:format[matches(., '\d{2}:\d{2}:\d{2}')]">
    <extent><xsl:value-of select="."/></extent>
  </xsl:template>

  <!--
    For dcterms:extents that contains something that resembles the following:
    * an xs:time
    * a count of leaves
    * a measurement of dimensions or length
    This is union of elements that don't start with things that look like an internetMediaType.
  -->
  <xsl:template match="dcterms:extent[not(starts-with(., 'image'))] | dcterms:extent[not(starts-with(., 'video'))]">
    <xsl:variable name="extent-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$extent-tokens">
      <extent><xsl:value-of select="normalize-space(.)"/></extent>
    </xsl:for-each>
  </xsl:template>

  <!-- for formats that may contain multiple values separated by ';' -->
  <xsl:template match="dc:format[not(matches(., '\d{2}:\d{2}:\d{2}'))]">
    <xsl:variable name="format-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$format-tokens">
      <internetMediaType><xsl:value-of select="normalize-space(.)"/></internetMediaType>
    </xsl:for-each>
  </xsl:template>

  <!-- for dcterms:extents that start with something resembling an internetMediaType -->
  <xsl:template match="dcterms:extent[starts-with(., 'image')] | dcterms:extent[starts-with(., 'video')]">
    <xsl:variable name="format-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$format-tokens">
      <internetMediaType><xsl:value-of select="normalize-space(.)"/></internetMediaType>
    </xsl:for-each>
  </xsl:template>
  
  <!-- match -->

  <!-- ignored elements -->
  <xsl:template match="dc:rights | dcterms:license"/>
  <xsl:template match="dc:language[position() > 1]"/>
</xsl:stylesheet>