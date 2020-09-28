<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:dltn = "https://github.com/digitallibraryoftennessee"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <!-- output settings -->
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- includes and imports -->
    
    <!-- Types -->
    <xsl:param name="pType">
        <dltn:type string="moving image">Video</dltn:type>
        <dltn:type string="text">Text</dltn:type>
        <dltn:type string="sound recording">Sound</dltn:type>
        <dltn:type string="still image">Still image</dltn:type>
        <dltn:type string="still image">Image</dltn:type>
    </xsl:param>
    
    
    <!-- identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- normalize all the text! -->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <!-- match metadata -->
    <xsl:template match="oai_dc:dc">
        <!-- match the document root and return a MODS record -->
        <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            
            <!-- identifiers -->
            <xsl:apply-templates select='dc:identifier'/>
            
            <!-- title -->
            <titleInfo>
                <xsl:apply-templates select="dc:title"/>
            </titleInfo>
            
            <!-- abstract -->
            <xsl:apply-templates select="dc:description"/>
            
            <!-- Creators & Contributors -->
            <xsl:apply-templates select="dc:creator"/>
            <xsl:apply-templates select="dc:contributor"/>
            
            <!-- form -->
            <xsl:apply-templates select="dc:format"/>
            
            <!-- originInfo> -->
            <xsl:apply-templates select="dc:date"/>
            
            <!-- subject(s) -->
            <xsl:apply-templates select="dc:subject"/>
            
            <!-- typeOfResource -->
            <xsl:apply-templates select="dc:type"/>
            
            <!-- language -->
            <xsl:apply-templates select="dc:language"/>
            
            <!-- recordInfo -->
            <recordInfo>
                <recordContentSource>Memphis Public Library</recordContentSource>
            </recordInfo>
            
            <!-- source or collection title -->
            <xsl:apply-templates select="dc:relation"/>
            
            <!-- accessCondition -->
            <xsl:apply-templates select="dc:rights"/>
            
        </mods>
    </xsl:template>
    
    <!-- identifiers -->
    <xsl:template match='dc:identifier'>
        <xsl:choose>
            <xsl:when test="starts-with(., 'http://')">
                <xsl:variable name="identifier-preview-url" select="replace(., '/cdm/ref', '/utils/getthumbnail')"/>
                <location>
                    <url usage="primary" access="object in context"><xsl:apply-templates/></url>
                    <url access="preview"><xsl:value-of select="$identifier-preview-url"/></url>
                </location>
            </xsl:when>
            <xsl:when test="matches(., '^[0-9]')"/>
            <xsl:when test="starts-with(., '[')"/>
            <xsl:otherwise>
                <identifier><xsl:apply-templates/></identifier>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- title -->
    <xsl:template match="dc:title">
        <title><xsl:apply-templates/></title>
    </xsl:template>
    
    <!-- abstract -->
    <xsl:template match="dc:description">
        <abstract><xsl:apply-templates/></abstract>
    </xsl:template>
    
    <!-- Creators & Contributors -->
    <xsl:template match="dc:creator">
        <name>
            <namePart><xsl:apply-templates/></namePart>
            <role>
                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
            </role>
        </name>
    </xsl:template>
    <xsl:template match="dc:contributor">
        <xsl:choose>
            <xsl:when test="starts-with(., 'Gift of')">
                <xsl:variable name="contributor-only" select="replace(., 'Gift of ', '')"/>
                <name>
                    <namePart><xsl:value-of select="$contributor-only"/></namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                    </role>
                </name>    
            </xsl:when>
            <xsl:when test="starts-with(., 'Donated by')">
                <xsl:variable name="contributor-only-2" select="replace(., 'Donated by ', '')"/>
                <name>
                    <namePart><xsl:value-of select="$contributor-only-2"/></namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                    </role>
                </name>    
            </xsl:when>
            <xsl:otherwise>
                <name>
                    <namePart><xsl:apply-templates/></namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                    </role>
                </name>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- form -->
    <xsl:template match="dc:format">
        <physicalDescription><form><xsl:apply-templates/></form></physicalDescription>
    </xsl:template>
    
    <!-- originInfo> -->
    <xsl:template match="dc:date">
        <originInfo><dateCreated><xsl:apply-templates/></dateCreated></originInfo>
    </xsl:template>
    
    <!-- subject(s) -->
    <!-- for subjects, whether they contains a ';' or not -->
    <xsl:template match="dc:subject">
        <xsl:variable name="subj-tokens" select="tokenize(., '; ')"/>
        <xsl:for-each select="$subj-tokens">
            <xsl:choose>
                 <xsl:when test="ends-with(., ';')">
                    <subject>
                        <topic>
                            <xsl:value-of select="substring(., 1, string-length(.) -1)"/>
                        </topic>
                    </subject>
                 </xsl:when>
                <xsl:otherwise>
                    <subject>
                        <topic><xsl:value-of select="normalize-space(.)"/></topic>
                    </subject>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <!-- typeOfResource -->
    <xsl:template match='dc:type'>
        <xsl:variable name="rtype" select="."/>
        <xsl:choose>
            <xsl:when test="$rtype=$pType/dltn:type">
                <typeOfResource>
                    <xsl:value-of select="$pType/dltn:type[. = $rtype]/@string"/>
                </typeOfResource>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- language -->
    <xsl:template match='dc:language'>
        <xsl:variable name="language-term" select="tokenize(., ';|,')"/>
        <xsl:for-each select="$language-term">
            <language>
                <languageTerm><xsl:value-of select="normalize-space(.)"/></languageTerm>
            </language>
        </xsl:for-each>
    </xsl:template>
    
    <!-- source or collection title -->
    <xsl:template match='dc:relation'>
    <relatedItem type="host" displayLabel="Project">
        <titleInfo>
            <title><xsl:apply-templates/></title>
        </titleInfo>
    </relatedItem>
    </xsl:template>
    
    <!-- accessCondition -->
    <xsl:template match="dc:rights">
        <accessCondition type="local rights statement"><xsl:apply-templates/></accessCondition>
    </xsl:template>

</xsl:stylesheet>