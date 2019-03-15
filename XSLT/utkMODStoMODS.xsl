<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/mods/v3"
    version="2.0" exclude-result-prefixes="mods">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <!-- parsed out top-level elements for ease of tweaking as feedback comes in. 
                as source feed is worked on, this can be simplified -->
    
    <xsl:template match="text()|@*"/>
    <xsl:template match="//mods:mods">
        <mods version="3.5" xmlns="http://www.loc.gov/mods/v3"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="mods:identifier"/>
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:abstract"/>
            <xsl:apply-templates select="mods:name"/> <!-- not handing over unknowns to DLTN, though we do keep in UTK Islandora -->
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:physicalDescription"/>
            <xsl:apply-templates select="mods:note"/>
            <xsl:apply-templates select="mods:subject"/>
            <xsl:apply-templates select="mods:physicalDescription/mods:form" mode="form2genre"/> <!-- DPLA genre is UTK form - UTK form being copied over -->
            <xsl:apply-templates select="mods:genre"/> <!-- copied over as found, also copied below for use as genre -->
            <xsl:apply-templates select="mods:language"/>
            <xsl:apply-templates select="mods:typeOfResource"/>
            <xsl:apply-templates select="mods:relatedItem"/>
            <xsl:apply-templates select="mods:part"/>
            <location>
                <xsl:apply-templates select="mods:location/mods:physicalLocation"/>
                <xsl:apply-templates select="mods:location/mods:url"/>
                <xsl:apply-templates select="mods:location/mods:holdingExternal"/>
            </location>
            <xsl:apply-templates select="mods:recordInfo"/>
            <xsl:apply-templates select="mods:accessCondition"/>
        </mods>
    </xsl:template>
    
    <!-- TEMPLATES WITH CHANGES FOR DLTN -->
    <xsl:template match="mods:name">
        <xsl:if test="normalize-space(lower-case(mods:namePart/text())) != 'unknown'"> <!-- not handing over unknowns to DLTN, though we do keep in UTK Islandora -->
            <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()" copy-namespaces="no"></xsl:copy-of></xsl:copy>
        </xsl:if>
    </xsl:template>

    <!-- templates for new mods:location -->
    <xsl:template match="mods:location/mods:physicalLocation">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="mods:location/mods:url">
        <!-- doesn't work - location is ordered -->
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="mods:location/mods:holdingExternal">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="mods:originInfo">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="mods:dateIssued[@encoding='edtf']">
                    <dateCreated>
                        <xsl:value-of select="mods:dateIssued[@encoding='edtf']"/>
                    </dateCreated>
                </xsl:when>
                <xsl:when test="mods:dateCreated">
                    <xsl:copy-of select="mods:dateCreated" copy-namespaces="no"/>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:physicalDescription/mods:form" mode="form2genre"> <!-- DPLA genre is UTK form - UTK form being copied over -->
        <xsl:choose>
            <xsl:when test="lower-case(.) = 'albums (books)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026690</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>albums (books)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'architectural drawings (visual works)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026690</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>architectural drawings (visual works)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'books'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028051</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>books</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'cartoons (humorous images)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300123430</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>cartoons (humorous images)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'clippings (information artifacts)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026867</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>clippings (information artifacts)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'corporation reports'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300027275</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>corporation reports</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'correspondence'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026877</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>correspondence</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'diagrams'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300015387</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>diagrams</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'drawings (visual works)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300033973</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>drawings (visual works)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'ephemera (general)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028881</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>ephemera (general)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'filmstrips'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028048</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>filmstrips</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'illustrations'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300015578</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>illustrations</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'manuscripts (document genre)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028569</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>manuscripts (document genre)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'maps (documents)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028094</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>maps (documents)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'minutes (administrative records)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300027440</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>minutes (administrative records)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'money'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300037316</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>money</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'moving images'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300263857</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>moving images</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'music'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="authority">local</xsl:attribute>music</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'negatives (photographic)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300127173</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>negatives (photographic)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'objects'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300311889</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>objects</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'oral histories (document genres)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300202595</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>oral histories (document genres)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'paintings (visual works)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300033618</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>paintings (visual works)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'pamphlets'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300220572</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>pamphlets</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'periodicals'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026657</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>periodicals</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'photographs'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300046300</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>photographs</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'postcards'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026816</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>postcards</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'posters'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300027221</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>posters</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'printed ephemera'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300264821</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>printed ephemera</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'prints (visual works)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300041273</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>prints (visual works)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'record covers'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300247936</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>record covers</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'records (documents)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026685</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>records (documents)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'scores'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300026427</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>scores</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'signs (declatory or advertising artifacts)'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300123013</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>signs (declatory or advertising artifacts)</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'sound recordings'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028633</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>sound recordings</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'transparencies'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300127478</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>transparencies</xsl:element>
            </xsl:when>
            <xsl:when test="lower-case(.) = 'video recordings'">
                <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3"><xsl:attribute name="valueURI">http://vocab.getty.edu/aat/300028682</xsl:attribute><xsl:attribute name="authority">aat</xsl:attribute>video recordings</xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- TEMPLATES WITH NO CHANGES CURRENTLY FOR DLTN -->
    
    <xsl:template match="mods:identifier">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:titleInfo">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:typeOfResource">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:genre">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:language">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:physicalDescription">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:abstract">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:note">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:subject">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:relatedItem">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:accessCondition">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:part">
        <xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>
    </xsl:template>
    
    <xsl:template match="mods:recordInfo">
        <!--<xsl:copy copy-namespaces="no"><xsl:copy-of select="node()|@*" copy-namespaces="no"></xsl:copy-of></xsl:copy>-->
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
            <!--<xsl:copy-of select="@*|node()" copy-namespaces="no"/>-->
            <!--<xsl:if test="mods:recordContentSource = ''">-->
                <!--<recordContentSource>-->
                    <!--<xsl:value-of select="'University of Tennessee'"/>-->
                <!--</recordContentSource>-->
            <!--</xsl:if>-->
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mods:recordIdentifier">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:recordContentSource[not(. = '')]">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:recordContentSource[(. = '')]">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="'University of Tennessee'"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:languageOfCataloging">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:languageTerm">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:recordOrigin">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:recordCreationDate">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mods:recordChangeDate">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*|node()" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>