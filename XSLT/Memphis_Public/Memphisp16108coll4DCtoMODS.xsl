<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="MemphisPublicDCtoMODS.xsl"/>
    <xsl:include href="../coreDCtoMODS.xsl"/>
    <xsl:include href="../!thumbnails/ContentDMthumbnailDCtoMODS.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:contributor" /> <!-- name/role -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:contributor" mode="publisher"/> <!-- publisher parsed from contributor -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier|dc:source">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                    <xsl:apply-templates select="dc:identifier" mode="shelfLocator"/> <!-- shelf locator parsed from identifier -->
                    <xsl:apply-templates select="dc:source" mode="repository"/><!-- physicalLocation-->
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic, temporal subject info -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Saul Brown Photograph Collection</title>
                </titleInfo>
                <abstract>Saul Brown was born in 1910 in New York to Russian immigrants. As a young adult, Brown attended Tech High School in Memphis and graduated from the Memphis Academy of Fine Arts with a degree in Fine Art. Brown served in the Air Force during World War II. After graduation, he found work with Loew's Theaters, where he created publicity displays. Brown worked as a staff photographer for the Memphis Press-Scimitar for twenty years, retiring in April of 1980 as the newspaper's chief photographer. After retirement, Brown continued taking publicity photographs for various Memphis theaters as well as images of public figures, personal friends, and Memphis and its residents. He received the Freedom Foundation Award in 1972. In 1986, Brown donated $5,000 to Memphis State University to establish the Saul Brown/Memphis Press Scimitar Award, awarded to students in news journalism and news photography beginning in the 1987-1988 academic year. In 1987, due to his financial support of the school's academic fund, Brown was granted membership in the school's Presidents Club. Saul Brown passed away in Memphis on March 13, 1992 at the home of Myron Taylor, the brother of Mildred, his late wife.</abstract>
                <location>
                    <url>http://cdm16108.contentdm.oclc.org/cdm/landingpage/collection/p16108coll4</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordInfo"/>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:coverage"> <!-- Subject headings/Geographic Names present, but uniquely formulated - can't currently parse -->
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}s$') or matches(normalize-space(.), '^\d{4}s to \d{4}s$')">
                        <subject>
                            <temporal><xsl:value-of select="."/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(lower-case(.), 'original order')">
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <topic><xsl:value-of select="normalize-space(replace(., ' - ', '--'))"/></topic>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:for-each select="tokenize(., ',')">
                <xsl:if test="normalize-space(.)!=''">
                    <xsl:choose>
                        <xsl:when test="matches(., '\d+.+')">
                            <extent><xsl:value-of select="normalize-space(.)"/></extent>
                        </xsl:when>
                        <xsl:when test="contains(., 'mounted')">
                            <note><xsl:value-of select="normalize-space(.)"/></note>
                        </xsl:when>
                        <xsl:otherwise>
                            <form><xsl:value-of select="normalize-space(.)"/></form>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>