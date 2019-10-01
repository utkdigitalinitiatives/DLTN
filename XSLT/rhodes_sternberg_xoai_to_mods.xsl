<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lyncode="http://www.lyncode.com/xoai"
    xmlns:dltn = "https://github.com/digitallibraryoftennessee"
    xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.lyncode.com/xoai" version="2.0">
    
    <!-- output settings -->
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Types -->
    <xsl:param name="pType">
        <dltn:type string="moving image">Video</dltn:type>
        <dltn:type string="text">Text</dltn:type>
        <dltn:type string="sound recording">Sound</dltn:type>
        <dltn:type string="still image">Still image</dltn:type>
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
    <xsl:template match="lyncode:metadata">
        <!-- match the document root and return a MODS record -->
        <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            
            <!-- title-->
            <xsl:apply-templates select="element[@name = 'dc']/element[@name = 'title']/element/field"/>
            
            <!-- rights-->
            <xsl:choose>
                <xsl:when test="element[@name = 'dc']/element[@name = 'rights']/element/field">
                    <xsl:apply-templates select="element[@name = 'dc']/element[@name = 'rights']/element/field"/>                   
                </xsl:when>
                <xsl:otherwise>
                    <accessCondition type="local rights statement">All rights reserved. The accompanying
                        digital object and its associated documentation are provided for online research and
                        access purposes. Permission to use, copy, modify, distribute and present this
                        digital object and the accompanying documentation, without fee, and without written
                        agreement, is hereby granted for educational, non-commercial purposes only. The
                        Rhodes College Archives reserves the right to decide what constitutes educational
                        and commercial use; commercial users may be charged a nominal fee to be determined
                        by current, commercial rates for use of special materials. In all instances of use,
                        acknowledgement must begiven to Rhodes College Archives and Special Collection,
                        Memphis, TN. For information regarding permission to use this image, please email
                        the Archives at archives@rhodes.edu or call 901-843-3334.</accessCondition>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- urls -->
            <location>
                <xsl:apply-templates select='element[@name = "dc"]/element[@name = "identifier"]/element[@name = "uri"]/element[@name = "none"]/field[@name = "value"]'/>
                <xsl:apply-templates select='element[@name="bundles"]/element[@name="bundle"][field[@name="name"][text()="THUMBNAIL"]]/element[@name="bitstreams"]/element[@name="bitstream"][1]/field[@name="url"]'/>
            </location>
            
            <!-- Creators -->
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "editor"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "artist"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "author"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <!-- OriginInfo -->
            <originInfo>
                <xsl:apply-templates
                    select='element[@name = "dc"]/element[@name = "date"]/element[@name = "issued"]/element[@name = "none"]/field[@name = "value"]'
                />
                <xsl:apply-templates select='element[@name = "dc"]/element[@name = "publisher"]/element[@name = "en_US"]/field[@name = "value"]'/>
                <xsl:apply-templates select='element[@name="dc"]/element[@name="date"]/element[@name="accessioned"]/element[@name="none"]/field[@name="value"]'/>
            </originInfo>
            
            <!-- recordInfo -->
            <recordInfo>
                <recordContentSource valueURI="http://id.loc.gov/authorities/names/n88258779">Rhodes College</recordContentSource>
                <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from an XOAI record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/digitallibraryoftennessee/DLTN_XSLT. Metadata originally created in an XOAI record in DSPACE (data dictionary available: https://dltn-technical-docs.readthedocs.io/en/latest/mappings/rhodes.html#mapping-tables).</recordOrigin>
</recordInfo>
            
            <!-- typeOfResource -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="type"]/element/field[@name="value"]'/>
            
            <!-- identifiers -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="identifier"]/element[@name="rhodes"]/element[@name="none"]/field[@name="value"]'/>
            
            <!-- Subjects -->
            <xsl:apply-templates select='element[@name = "dc"]/element[@name = "subject"]/element/field[@name = "value"]'/>
            
            <!-- abstract -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="description"]/element[@name="abstract"]/element[@name="en_US"]/field[@name="value"]'/>
            
            <!-- streaming video -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="relation"]/element[@name="uri"]/element[@name="none"]/field[@name="value"]'/>
            
            <!-- forms -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="format"]/element[@name="medium"]/element[@name="en_US"]/field[@name="value"]'/>
        </mods>
    </xsl:template>
    
    <!-- title -->
    <xsl:template match="element[@name = 'dc']/element[@name = 'title']/element/field">
        <titleInfo>
            <title>
                <xsl:apply-templates/>
            </title>
        </titleInfo>
    </xsl:template>
    
    <!-- Thumbnail -->
    <xsl:template match='element[@name="bundles"]/element[@name="bundle"][field[@name="name"][text()="THUMBNAIL"]]/element[@name="bitstreams"]/element[@name="bitstream"][1]/field[@name="url"]'>
        <xsl:variable name="thumbnail-link" select="./text()"/>
        <xsl:choose>
            <xsl:when test="starts-with($thumbnail-link, 'http://dam-2013.rhodes.edu:8080/xmlui')">
                <xsl:variable name="new-thumbnail" select="replace($thumbnail-link, 'http://dam-2013.rhodes.edu:8080/xmlui', 'http://dlynx.rhodes.edu:8080/jspui')"/>
                <url access="preview"><xsl:value-of select="$new-thumbnail"/></url>
            </xsl:when>
            <xsl:otherwise>
                <url access="preview"><xsl:value-of select="$thumbnail-link"/></url>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Handle -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "identifier"]/element[@name = "uri"]/element[@name = "none"]/field[@name = "value"]'>
        <url access="object in context" usage="primary display">
            <xsl:apply-templates/>
        </url>
    </xsl:template>
    
    <!-- Contributors -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "none"]/field[@name = "value"]'>
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm>Contributor</roleTerm>
            </role>
        </name>
    </xsl:template>
    
    <!-- Creators -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "editor"]/element[@name = "none"]/field[@name = "value"]'>
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm>Creator</roleTerm>
            </role>
        </name>
    </xsl:template>
    
    <xsl:template
        match='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "artist"]/element[@name = "none"]/field[@name = "value"]'>
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm>Creator</roleTerm>
            </role>
        </name>
    </xsl:template>
    
    <xsl:template
        match='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "author"]/element[@name = "none"]/field[@name = "value"]'>
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm>Creator</roleTerm>
            </role>
        </name>
    </xsl:template>
    
    <!-- Date Created -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "date"]/element[@name = "issued"]/element[@name = "none"]/field[@name = "value"]'>
        <dateCreated>
            <xsl:apply-templates/>
        </dateCreated>
    </xsl:template>
    
    <!-- typeOfResource -->
    <xsl:template match='element[@name="dc"]/element[@name="type"]/element/field[@name="value"]'>
        <xsl:variable name="rtype" select="."/>
        <xsl:choose>
            <xsl:when test="$rtype=$pType/dltn:type">
                <typeOfResource>
                    <xsl:value-of select="$pType/dltn:type[. = $rtype]/@string"/>
                </typeOfResource>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- identifiers -->
    <xsl:template match='element[@name="dc"]/element[@name="identifier"]/element[@name="rhodes"]/element[@name="none"]/field[@name="value"]'>
        <identifier type="local"><xsl:apply-templates/></identifier>
    </xsl:template>
    
    <!-- Subjects -->
    <xsl:template match='element[@name = "dc"]/element[@name = "subject"]/element/field[@name = "value"]'>
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
    </xsl:template>
    
    <!-- Publisher -->
    <xsl:template match='element[@name = "dc"]/element[@name = "publisher"]/element[@name = "en_US"]/field[@name = "value"]'>
        <xsl:choose>
            <xsl:when test=".!='Rhodes College'">
                <publisher><xsl:apply-templates/></publisher>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Abstract -->
    <xsl:template match='element[@name="dc"]/element[@name="description"]/element[@name="abstract"]/element[@name="en_US"]/field[@name="value"]'>
        <xsl:if test=".!='UPDATE THIS INFORMATION'">
            <abstract><xsl:apply-templates/></abstract>
        </xsl:if>
    </xsl:template>
    
    <!-- Streaming Resource -->
    <xsl:template match='element[@name="dc"]/element[@name="relation"]/element[@name="uri"]/element[@name="none"]/field[@name="value"]'>
        <xsl:choose>
            <xsl:when test="contains(., 'vimeo.com')">
                <relatedItem displayLabel="streaming resource">
                    <location>
                        <url>
                            <xsl:apply-templates/>
                        </url>
                    </location>
                </relatedItem>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Date Other -->
    <xsl:template match='element[@name="dc"]/element[@name="date"]/element[@name="accessioned"]/element[@name="none"]/field[@name="value"]'>
        <dateOther>
            <xsl:apply-templates/>
        </dateOther>
    </xsl:template>
    
    <!-- Rights -->
    <xsl:template match="element[@name = 'dc']/element[@name = 'rights']/element/field">
        <accessCondition type="local rights statement">
            <xsl:apply-templates/>
        </accessCondition>
    </xsl:template>
    
    <!-- Form -->
    <xsl:template match='element[@name="dc"]/element[@name="format"]/element[@name="medium"]/element[@name="en_US"]/field[@name="value"]'>
        <physicalDescription>
            <form>
                <xsl:apply-templates/>
            </form>
        </physicalDescription>
    </xsl:template>
</xsl:stylesheet>
