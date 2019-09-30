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
    <xsl:template match="lyncode:metadata">
        <!-- match the document root and return a MODS record -->
        <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            
            <!-- identifiers -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="identifier"]/element[@name="other"]/element[@name="none"]/field[@name="value"]'/>
            
            <!-- title-->
            <xsl:apply-templates select="element[@name = 'dc']/element[@name = 'title']/element/field"/>
            
            <!-- alternative title -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="title"]/element[@name="alternative"]/element[@name="en_US"]/field'/>
            
            <!-- abstract -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="description"]/element[@name="abstract"]/element[@name="en_US"]/field[@name="value"]'/>
            
            <!-- urls -->
                <location>
                <xsl:apply-templates select='element[@name = "dc"]/element[@name = "identifier"]/element[@name = "uri"]/element[@name = "none"]/field[@name = "value"]'/>
                <xsl:apply-templates select='element[@name="bundles"]/element[@name="bundle"][field[@name="name"][text()="THUMBNAIL"]]/element[@name="bitstreams"]/element[@name="bitstream"][1]/field[@name="url"]'/>
                </location>
            
            <!-- Contributors -->
            <xsl:apply-templates select='element[@name = "dc"]/element[@name="contributor"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <!-- Creators -->
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "editor"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "artist"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "author"]/element[@name = "none"]/field[@name = "value"]'/>
            
            <!-- originInfo -->
            <originInfo>
                <xsl:apply-templates
                    select='element[@name = "dc"]/element[@name = "date"]/element[@name = "issued"]/element[@name = "none"]/field[@name = "value"]'/>
                <xsl:apply-templates select='element[@name = "dc"]/element[@name = "publisher"]/element[@name = "none"]/field[@name = "value"]'/>
                <xsl:apply-templates select='element[@name="dc"]/element[@name="date"]/element[@name="accessioned"]/element[@name="none"]/field[@name="value"]'/>
            </originInfo>
            
            <!-- form -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="format"]/element[@name="medium"]/element[@name="none"]/field[@name="value"]'/>
            
            <!-- subjects -->
            <xsl:apply-templates select='element[@name = "dc"]/element[@name = "subject"]/element[@name = "none"]/field[@name = "value"]'/>
            <xsl:apply-templates select='element[@name = "dc"]/element[@name = "subject"]/element[@name = "en_US"]/field[@name = "value"]'/>
            
            <!-- typeOfResource -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="type"]/element/field[@name="value"]'/>
            
            <!-- language -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="language"]/element[@name="none"]/field[@name="value"]'/>
            
            <!-- recordInfo -->
            <recordInfo>
                <recordContentSource valueURI="http://id.loc.gov/authorities/names/n88258779">Rhodes College</recordContentSource>
                <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </languageOfCataloging>
<recordOrigin>Record has been transformed into MODS 3.5 from an XOAI record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/digitallibraryoftennessee/DLTN_XSLT. Metadata originally created in an XOAI record in DSPACE (data dictionary available: https://dltn-technical-docs.readthedocs.io/en/latest/mappings/crossroads.html#mapping-tables).</recordOrigin>
</recordInfo>
            
            <!-- relatedItem -->
            <xsl:choose>
                <xsl:when test='element[@name="dc"]/element[@name="relation"]/element[@name="ispartof"]/element[@name="none"]/field[@name="value"]'>
                    <xsl:apply-templates select='element[@name="dc"]/element[@name="relation"]/element[@name="ispartof"]/element[@name="none"]/field[@name="value"]'/>
                </xsl:when>
            </xsl:choose>
       
            <!-- rights-->
            <xsl:choose>
                <xsl:when test="element[@name = 'dc']/element[@name = 'rights']/element/field">
                    <xsl:apply-templates select="element[@name = 'dc']/element[@name = 'rights']/element/field"/>                   
                </xsl:when>
                <xsl:otherwise>
                    <accessCondition type="local rights statement">Rhodes College owns the rights to the digital objects in this collection. Objects are made available for educational use only and may not be used for any non-educational or commercial purpose. Approved educational uses include private research and scholarship, teaching, and student projects. For additional information please contact archives@rhodes.edu. Fees may apply</accessCondition>
                </xsl:otherwise>
            </xsl:choose>
        </mods>
    </xsl:template>
    
    <!-- identifiers -->
    <xsl:template match='element[@name="dc"]/element[@name="identifier"]/element[@name="other"]/element[@name="none"]/field[@name="value"]'>
        <identifier type="local"><xsl:apply-templates/></identifier>
    </xsl:template>
    
    <!-- title -->
    <xsl:template match="element[@name = 'dc']/element[@name = 'title']/element/field">
        <titleInfo>
            <title>
                <xsl:apply-templates/>
            </title>
        </titleInfo>
    </xsl:template>
    
    <!-- alternative title -->
    <xsl:template match='element[@name="dc"]/element[@name="title"]/element[@name="alternative"]/element[@name="en_US"]/field'>
        <titleInfo type="alternative">
            <title>
                <xsl:apply-templates/>
            </title>
        </titleInfo>
    </xsl:template>
    
    <!-- Abstract -->
    <xsl:template match='element[@name="dc"]/element[@name="description"]/element[@name="abstract"]/element[@name="en_US"]/field[@name="value"]'>
        <abstract><xsl:apply-templates/></abstract>
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
    
    <!-- Creator -->
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
    
    <!-- Contributor -->
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
    
    <!-- publisher -->
    <xsl:template match='element[@name = "dc"]/element[@name = "publisher"]/element[@name = "none"]/field[@name = "value"]'>
        <xsl:choose>
            <xsl:when test=".!='Memphis, Tenn. : Archives and Special Collections, Rhodes College'">
                <publisher><xsl:apply-templates/></publisher>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- dateCreated -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "date"]/element[@name = "issued"]/element[@name = "none"]/field[@name = "value"]'>
        <dateCreated>
            <xsl:apply-templates/>
        </dateCreated>
    </xsl:template>
    
    <!-- dateIssued -->
    <xsl:template match='element[@name="dc"]/element[@name="date"]/element[@name="accessioned"]/element[@name="none"]/field[@name="value"]'>
        <dateOther>
            <xsl:apply-templates/>
        </dateOther>
    </xsl:template>
    
    <!-- dateOther -->
    <xsl:template match='element[@name="dc"]/element[@name="date"]/element[@name="accessioned"]/element[@name="none"]/field[@name="value"]'>
        <dateOther>
            <xsl:apply-templates/>
        </dateOther>
    </xsl:template>
    
    <!-- form -->
    <xsl:template match='element[@name="dc"]/element[@name="format"]/element[@name="medium"]/element[@name="none"]/field[@name="value"]'>
        <xsl:choose>
            <xsl:when test=".='Engraving, hxw'">
                <physicalDescription>
                    <form>Engraving</form>
                </physicalDescription>
            </xsl:when>
            <xsl:otherwise>
                <physicalDescription>
                    <form>
                        <xsl:apply-templates/>
                    </form>
                </physicalDescription>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- subject -->
    <xsl:template match='element[@name = "dc"]/element[@name = "subject"]/element[@name = "none"]/field[@name = "value"]'>
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
    </xsl:template>
    
    <!-- subject -->
    <xsl:template match='element[@name = "dc"]/element[@name = "subject"]/element[@name = "en_US"]/field[@name = "value"]'>
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
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
    
    <!-- language -->
    <xsl:template match='element[@name="dc"]/element[@name="language"]/element[@name="none"]/field[@name="value"]'>
        <language>
            <languageTerm>
                <xsl:apply-templates/>
            </languageTerm>
        </language>
    </xsl:template>
    
    <!-- relatedItem -->
    <xsl:template match='element[@name="dc"]/element[@name="relation"]/element[@name="ispartof"]/element[@name="none"]/field[@name="value"]'>
        <relatedItem displayLabel="Project">
            <titleInfo>
                <title><xsl:apply-templates/></title>
            </titleInfo>
        </relatedItem>
        
    </xsl:template>
    
    <!-- rights -->
    <xsl:template match="element[@name = 'dc']/element[@name = 'rights']/element/field">
        <accessCondition type="local rights statement">
            <xsl:apply-templates/>
        </accessCondition>
    </xsl:template>
</xsl:stylesheet>
