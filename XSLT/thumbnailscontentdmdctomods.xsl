<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    <!-- OAI-DC to MODS ContentDM Transformations for Thumbnail URL additions. Includes only the following template:
        dc:identifier mode="locationurl"
    -->
    <xsl:variable name="catalogs" select="collection('catalogs/')"/>
    
    <xsl:template match="dc:identifier" mode="locationurl">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'http') and contains($idvalue, 'contentdm')"> 
            <!-- CONTENTdm puts the URI in an <identifier> field in the OAI record -->
            <!-- process identifier into CONTENTdm 6.5 thumbnail urls --> 
            <xsl:variable name="contentdmroot" select="substring-before($idvalue,'/cdm/ref/')"/>
            <xsl:variable name="recordinfo" select="substring-after($idvalue,'/cdm/ref/collection/')"/>
            <xsl:variable name="alias" select="substring-before($recordinfo,'/id/')"/>
            <xsl:variable name="pointer" select="substring-after($recordinfo,'/id/')"/>
            <url access="preview"><xsl:value-of select="concat($contentdmroot,'/utils/getthumbnail/collection/',$alias,'/id/',$pointer)"/></url> 
            <!--CONTENTdm thumbnail url-->
            <xsl:variable name="iiif-manifest" select="concat(replace(replace(., 'cdm/ref/collection', 'iiif/info'), '/id', ''), '/manifest.json')"/>
            <xsl:if test="normalize-space(.) = $catalogs//@id">
                <url note="iiif-manifest"><xsl:value-of select="$iiif-manifest"/></url>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>