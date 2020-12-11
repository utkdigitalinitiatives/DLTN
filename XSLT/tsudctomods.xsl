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
            <xsl:apply-templates select="dc:identifier"/>
            
            <!-- abstract or thumbnail -->
            <xsl:apply-templates select="dc:description"/>
            
            <!-- creator -->
            <xsl:apply-templates select="dc:creator"/>
            
            <!-- originInfo> -->
            <xsl:apply-templates select="dc:date"/>
            
            <!-- subject(s) -->
            <xsl:apply-templates select="dc:subject"/>
            
            <!-- relatedItem -->
            <xsl:apply-templates select="dc:source"/>
            
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
    
    <!-- identifier / object URL / typeOfResource based off collection -->
    <xsl:template match='dc:identifier'>
        <xsl:choose>
            <xsl:when test="contains(., 'library-digital-collections/')">
                <typeOfResource>still image</typeOfResource>
            </xsl:when>
            <xsl:when test="contains(., 'catalogues/')">
                <typeOfResource>text</typeOfResource>
            </xsl:when>
            <xsl:when test="contains(., 'yearbooks/')">
                <typeOfResource>text</typeOfResource>
            </xsl:when>
            <xsl:when test="matches(., '[0-9]$')">
                <location>
                    <url usage="primary" access="object in context"><xsl:apply-templates/></url>
                </location>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- abstract or thumbnail -->
    <xsl:template match="dc:description">
        <xsl:choose>
            <xsl:when test="starts-with(., 'https://')">
                <location>
                    <url access="preview"><xsl:apply-templates/></url>
                </location>
            </xsl:when>
            <xsl:otherwise>
                <abstract><xsl:apply-templates/></abstract>
            </xsl:otherwise>
        </xsl:choose>
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
        <originInfo><dateCreated><xsl:copy-of select="substring(., 1, string-length(.) -10)"></xsl:copy-of></dateCreated></originInfo>
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