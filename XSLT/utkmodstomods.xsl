<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.loc.gov/mods/v3" version="2.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
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

    <!-- Good roleTerms to DC Garbage -->
    <xsl:param name="pRole">
        <l string="Creator">Creator</l>
        <l string="Creator">Author</l>
        <l string="Creator">Photographer</l>
        <l string="Creator">Illustrator</l>
        <l string="Creator">Interviewee</l>
        <l string="Creator">Composer</l>
        <l string="Creator">Performer</l>
        <l string="Creator">Lyricist</l>
        <l string="Creator">Artist</l>
        <l string="Creator">Lithographer</l>
        <l string="Creator">Cartographer</l>
        <l string="Creator">Engraver</l>
        <l string="Creator">Designer</l>
        <l string="Creator">Architect</l>
        <l string="Contributor">Editor</l>
        <l string="Contributor">Copyright holder</l>
        <l string="Contributor">Contributor</l>
        <l string="Contributor">Production company</l>
        <l string="Contributor">Stage director</l>
        <l string="Contributor">Musical director</l>
        <l string="Contributor">Arranger</l>
        <l string="Contributor">Issuing body</l>
        <l string="Contributor">Interviewer</l>
        <l string="Contributor">Attributed name</l>
        <l string="Contributor">Standards body</l>
        <l string="Contributor">Other</l>
        <l string="Contributor">Donor</l>
        <l string="Contributor">Client</l>
        <l string="Contributor">Contractor</l>
        <l string="Contributor">Former owner</l>
        <l string="Contributor">Originator</l>
        <l string="Contributor">Owner</l>
        <l string="Contributor">Printer</l>
        <l string="Contributor">Publisher</l>
        <l string="Contributor">Compiler</l>
        <l string="Contributor">Honoree</l>
        <l string="Contributor">Printer of plates</l>
        <l string="Contributor">Distributor</l>
        <l string="Contributor">Correspondent</l>
        <l string="Contributor">Witness</l>
    </xsl:param>

    <!-- DPLA Genres -->
    <xsl:param name="pForm">
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026690">albums (books)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300034787">architectural drawings (visual
            works)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028051">books</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300123430">cartoons (humorous images)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026867">clippings (information
            artifacts)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300027275">corporation reports</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026877">correspondence</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300015387">diagrams</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300033973">drawings (visual works)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028881">ephemera (general)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028048">filmstrips</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300015578">illustrations</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028569">manuscripts (document
            genre)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028094">maps (documents)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300027440">minutes (administrative
            records)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300037316">money</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300263857">moving images</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300127173">negatives (photographic)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300311889">objects</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300202595">oral histories (document
            genres)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300033618">paintings (visual works)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300220572">pamphlets</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026657">periodicals</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300046300">photographs</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026816">postcards</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300027221">posters</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300264821">printed ephemera</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300041273">prints (visual works)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300247936">record covers</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026685">records (documents)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300026427">scores</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300123013">signs (declatory or advertising
            artifacts)</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028633">sound recordings</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300127478">trasnparencies</f>
        <f authority="aat" uri="http://vocab.getty.edu/aat/300028682">video recordings</f>
    </xsl:param>

    <!-- Drop Unknown Names -->
    <xsl:template match="name[namePart[matches(lower-case(text()), 'unknown')]]"/>

    <!-- Apply Creators and Contributors -->
    <xsl:template match="name[namePart[not(matches(lower-case(text()), 'unknown'))]]">
        <xsl:variable name="vRole" select="normalize-space(role[1]/roleTerm[1])"/>
        <xsl:if test="$vRole=$pRole/l">
            <name>
                <namePart>
                    <xsl:value-of select="namePart"/>
                </namePart>
                <role>
                    <roleTerm>
                        <xsl:value-of select="$pRole/l[matches(text(), $vRole)]/@string"/>
                    </roleTerm>
                </role>
            </name>
        </xsl:if>
    </xsl:template>


    <!-- Convert form to genre if AAT -->
    <xsl:template match="physicalDescription">
        <xsl:variable name="vForm" select="form[1]"/>
        <xsl:if test="$vForm=$pForm/f">
            <genre authority="{$pForm/f[matches(text(), $vForm)]/@authority}" valueURI="{$pForm/f[matches(text(), $vForm)]/@uri}">
                <xsl:value-of select="$pForm/f[matches(text(), $vForm)]/text()"/>
            </genre>
            <physicalDescription>
                <form>
                    <xsl:value-of select="$pForm/f[matches(text(), $vForm)]/text()"/>
                </form>
            </physicalDescription>
        </xsl:if>
    </xsl:template>

    <xsl:template match="originInfo[dateCreated[@encoding = 'edtf']] | originInfo[dateIssued[@encoding = 'edtf']] | originInfo[publisher]">
        <originInfo>
            <xsl:apply-templates select="dateCreated[@encoding = 'edtf']"/>
            <xsl:apply-templates select="dateIssued[@encoding = 'edtf']"/>
            <xsl:apply-templates select="publisher"/>
        </originInfo>
    </xsl:template>

    <xsl:template match="originInfo"/>

    <xsl:template match="dateCreated[@encoding = 'edtf']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="dateIssued[@encoding = 'edtf']">
        <dateCreated encoding="edtf">
            <xsl:value-of select="normalize-space(.)"/>
        </dateCreated>
    </xsl:template>

    <xsl:template match="publisher">
        <publisher>
            <xsl:value-of select="normalize-space(.)"/>
        </publisher>
    </xsl:template>

    <!-- ignore preceding or following sibling titleInfos when titleInfo[@supplied] is present -->
    <xsl:template match="titleInfo[preceding-sibling::titleInfo[@supplied] or following-sibling::titleInfo[@supplied]]"/>

    <xsl:template match="titleInfo[@supplied='yes']">
        <titleInfo>
            <title><xsl:value-of select="normalize-space(.)"/></title>
        </titleInfo>
    </xsl:template>

    <!-- This is a temporary rule to move local accessConditions to abstract and replace all text since it currently has non-UTF8 characters -->
    <xsl:template match="accessCondition[@type='local']">
        <abstract>
            Permission granted for reproduction for use in research and teaching, provided proper attribution of source. Credit line should read: [description of item, including photographic number], 'Courtesy of McClung Museum of Natural History and Culture, The University of Tennessee.' For all other uses consult https://mcclungmuseum.utk.edu/research/image-services/rights-reproductions/ or call 865-974-2144.
        </abstract>
    </xsl:template>
    
    <xsl:template match="note[@displayLabel='instrumentation']">
        <abstract>
                <xsl:value-of select="normalize-space(.)"/>
        </abstract>
    </xsl:template>

    <!-- 
        keep the identifier(s), except for identifier w/
        'http://', and add the url elements to the pre-existing
        high level location (not the location under
        relatedItem.
    -->
    <xsl:template match="location[not(parent::relatedItem)]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <!--
                constructing elements to avoid copied namespaces.
                also, i'm a bit lazy.
            -->
            <xsl:if test="not(url[@access='object in context'])">
                <xsl:element name="url">
                    <xsl:attribute name="access">
                        <xsl:value-of select="'object in context'"/>
                    </xsl:attribute>
                    <xsl:attribute name="usage">
                        <xsl:value-of select="'primary display'"/>
                    </xsl:attribute>
                    <xsl:value-of select="following::identifier[starts-with(.,'https://')]"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="not(url[@access='preview'])">
                <xsl:element name="url">
                    <xsl:attribute name="access">
                        <xsl:value-of select="'preview'"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat(following-sibling::identifier[starts-with(.,'https://')],'/datastream/TN/view')"/>
                </xsl:element>
            </xsl:if>

        </xsl:copy>
    </xsl:template>

    <!-- 
        drop the identifier with the 'http://...'... or 
        really, replace that unneeded identifier with a location
        element that suits our purposes.
        
        there's a test to make sure that we don't add a second
        location if there's already one.
    -->
    <xsl:template match="/mods/identifier[starts-with(.,'https://')]">
        <xsl:choose>
            <!-- do we already have a top-level location? -->
            <xsl:when test="/mods/location"/>
            <!-- if we don't, then this test runs -->
            <xsl:when test="not(/mods/location)">
                <xsl:element name="location">
                    <xsl:element name="url">
                        <xsl:attribute name="access">
                            <xsl:value-of select="'object in context'"/>
                        </xsl:attribute>
                        <xsl:attribute name="usage">
                            <xsl:value-of select="'primary display'"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:element name="url">
                        <xsl:attribute name="access">
                            <xsl:value-of select="'preview'"/>
                        </xsl:attribute>
                        <xsl:value-of select="concat(.,'/datastream/TN/view')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- 
        this template corrects an apparent problem some of the MODS exports.
        there is an identifier element in relatedItem - it shouldn't be there
        and this template drops it from the identity transform.
        
        note: the problem element is 'identifer'. :)
    -->
    <xsl:template match="/mods/relatedItem/identifer[@type='uri']"/>

    <!-- 
        fixing recordContentSource for DPLA. 
        
        matches on recordContentSource, but only when there's a preceding relatedItem, with a @host and @Project, 
        with a title descendent element containing Volunteer Voices. 
        
        this *can* be run against other MODS files without ill effects.
    -->
    <xsl:template match="/mods/recordInfo/recordContentSource[preceding::relatedItem[@type='host'][@displayLabel='Project']/titleInfo/title[contains(.,'Volunteer Voices')]]">
        <xsl:copy>
            <xsl:apply-templates select="/mods/location/physicalLocation/text()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
