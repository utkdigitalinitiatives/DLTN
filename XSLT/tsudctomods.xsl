<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <!-- output settings -->
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
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
            <!-- title -->
            <xsl:apply-templates select="dc:title"/>
            <!-- identifier -->
            <xsl:apply-templates select="dc:identifier[contains(., 'viewcontent.cgi')]"/>
            <!-- abstract -->
            <xsl:apply-templates select="dc:description[not(starts-with(., 'http'))]"/>
            <!-- creator -->
            <xsl:apply-templates select="dc:creator"/>
            <!-- originInfo> -->
            <xsl:apply-templates select="dc:date"/>
            <!-- subject(s) -->
            <xsl:apply-templates select="dc:subject"/>
            <!-- relatedItem -->
            <xsl:apply-templates select="dc:source"/>
            <!-- location -->
            <location>
                <xsl:apply-templates select="dc:identifier[matches(., '[0-9]$')]"/>
                <xsl:apply-templates select="dc:description[(ends-with(., 'jpg'))]"/>        
            </location>
            <!-- publisher or recordContentSource -->
            <recordInfo><recordContentSource>Tennessee State University</recordContentSource></recordInfo>
            <!-- rights or accessCondition -->
            <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/CNE/1.0/">Copyright Not Evaluated</accessCondition>
        </mods>
        
    </xsl:template>
    <!-- title -->
    <xsl:template match="dc:title">
        <titleInfo><title><xsl:apply-templates/></title></titleInfo>
    </xsl:template>
    <!-- Object in context -->
    <xsl:template match="dc:identifier[matches(., '[0-9]$')]">
        <url usage="primary" access="object in context"><xsl:apply-templates/></url>
    </xsl:template>
    
    <!-- abstract or thumbnail -->
    <xsl:template match="dc:description[not(starts-with(., 'http'))]">
        <abstract><xsl:apply-templates/></abstract>
    </xsl:template>
    
    <!-- thumbnail -->
    <xsl:template match="dc:description[ends-with(., 'jpg')]">
        <url access="preview"><xsl:apply-templates/></url>
    </xsl:template>
    
    <!-- other identifier -->
    <xsl:template match="dc:identifier[contains(., 'viewcontent.cgi')]">
        <identifier><xsl:apply-templates/></identifier>
    </xsl:template>
    
    <!-- creator -->
    <xsl:template match="dc:creator">
        <name>
            <namePart><xsl:apply-templates/></namePart>
            <role>
                <roleTerm authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
            </role>
        </name>
    </xsl:template>
    
    <!-- originInfo -->
    <xsl:template match="dc:date">
        <xsl:choose>
            <xsl:when test="starts-with(., '19')">
                <originInfo><dateCreated>
                    <xsl:copy-of select="substring(., 1, string-length(.) -10)"></xsl:copy-of>
                </dateCreated></originInfo>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- subject(s) -->
    <!-- for subjects, whether they contain a ';' or not -->
    <xsl:template match="dc:subject">
        <xsl:variable name="subj-tokens" select="tokenize(., ';')"/>
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
    
    <!-- relatedItem -->
    <xsl:template match="dc:source">
        <xsl:choose>
            <xsl:when test="contains(., 'Digital Collections')">
                <typeOfResource>still image</typeOfResource>
            </xsl:when>
            <xsl:when test="contains(., 'Catalogues')">
                <typeOfResource>text</typeOfResource>
            </xsl:when>
            <xsl:when test="contains(., 'Yearbooks')">
                <typeOfResource>text</typeOfResource>
            </xsl:when>
        </xsl:choose>
        <relatedItem displayLabel="Collection" type="host">
            <titleInfo>
                <title><xsl:value-of select="normalize-space(.)"/></title>
            </titleInfo>
        </relatedItem>
    </xsl:template>
    
    <!-- recordContentSource -->
    <xsl:template match="dc:publisher">
        <recordInfo><recordContentSource><xsl:apply-templates/></recordContentSource></recordInfo>
    </xsl:template>
</xsl:stylesheet>