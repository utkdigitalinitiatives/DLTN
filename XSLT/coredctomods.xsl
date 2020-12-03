<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <!-- OAI-DC to MODS Core Transformations. Includes the following templates:
        dc:date
        dc:description
        dc:identifier
        dc:identifier mode=URL
        dc:language
        dc:rights
        dc:title[1]
        dc:title[position()>1]
    -->

    <!-- variables and parameters-->
    <xsl:param name="pRights">
        <rs uri="http://rightsstatements.org/vocab/InC/1.0/" string="In Copyright">in copyright</rs>
        <rs uri="http://rightsstatements.org/vocab/InC-OW-EU/1.0/" string="In Copyright - EU Orphan Work">in copyright - eu orphan work</rs>
        <rs uri="http://rightsstatements.org/vocab/InC-EDU/1.0/" string="In Copyright - Educational Use Permitted">in copyright - educational use permitted</rs>
        <rs uri="http://rightsstatements.org/vocab/InC-NC/1.0/" string="In Copyright - Non-Commercial Use Permitted">in copyright - non-commercial use permitted</rs>
        <rs uri="http://rightsstatements.org/vocab/InC-RUU/1.0/" string="In Copyright - Rights-holder(s) Unlocatable or Unidentifiable">in copyright - rights-holder(s) unlocatable or unidentifiable</rs>
        <rs uri="http://rightsstatements.org/vocab/NoC-CR/1.0/" string="No Copyright - Contractual Restrictions">no copyright - contractual restrictions</rs>
        <rs uri="http://rightsstatements.org/vocab/NoC-NC/1.0/" string="No Copyright - Non-Commercial Use Only">no copyright - non-commercial use only</rs>
        <rs uri="http://rightsstatements.org/vocab/NoC-OKLR/1.0/" string="No Copyright - Other Known Legal Restrictions">no copyright - other known legal restrictions</rs>
        <rs uri="http://rightsstatements.org/vocab/NoC-US/1.0/" string="No Copyright - United States">no copyright - united states</rs>
        <rs uri="http://rightsstatements.org/vocab/CNE/1.0/" string="Copyright Not Evaluated">copyright not evaluated</rs>
        <rs uri="http://rightsstatements.org/vocab/UND/1.0/" string="Copyright Undetermined">copyright undetermined</rs>
        <rs uri="http://rightsstatements.org/vocab/NKC/1.0/" string="No Known Copyright">no known copyright</rs>
    </xsl:param>

    <xsl:variable name="vRightsString" select="normalize-space(string-join(//dc:rights, ' '))"/>
    <xsl:variable name="vRightsCount" select="count(//dc:rights)"/>

    <xsl:template match="dc:date">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                <!-- Record Creation Timestamps in DC record - ignored -->
                    <xsl:when test="starts-with(normalize-space(lower-case(.)), 'ap') or starts-with(normalize-space(lower-case(.)), 'mt') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}T.')">
                        <!-- do nothing -->
                    </xsl:when>
                <!-- Text Terms -->
                    <xsl:when test="normalize-space(lower-case(.))='pre civil war' or normalize-space(lower-case(.))='pre-civil war' or normalize-space(lower-case(.))='antebellum'">
                        <dateCreated encoding="edtf" keyDate="yes">unknown/1861</dateCreated>
                    </xsl:when>
                    <xsl:when test="normalize-space(lower-case(.))='postwar' or normalize-space(lower-case(.))='post-civil war' or normalize-space(lower-case(.))='postbellum'">
                        <dateCreated encoding="edtf" keyDate="yes">1865/unknown</dateCreated>
                    </xsl:when>
                  <!-- DIRECT EDTF MATCHES -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}?$') or matches(normalize-space(.), '^\d{4}-\d{2}?$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}?$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="normalize-space(lower-case(.))='unknown' or normalize-space(lower-case(.))='uknown' or contains(lower-case(.), 'undated') or contains(lower-case(.), 'n.d.')">
                        <dateCreated encoding="edtf" keyDate="yes">uuuu</dateCreated>
                    </xsl:when>
                    <xsl:when test="starts-with(., 'year unknown')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(lower-case(.), 'year unknown', 'uuuu')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="starts-with(lower-case(.), 'xxxx')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(lower-case(.), 'xxxx', 'uuuu')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="ends-with(., 'unknown day')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(lower-case(.), 'unknown day', 'uu')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat('uuuu-', normalize-space(.))"/> </dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/> </dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/> </dateCreated>
                    </xsl:when>
                  <!-- DATE RANGES -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2} to \d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' to ', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}s$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(replace(normalize-space(.), 's', ''), '/'), replace(normalize-space(.), '0s', '9'))"/></dateCreated>
                    </xsl:when>
              <!-- Match YYYY Month DD formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} january \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' january ', '-01-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} january \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' january ', '-01-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} jan. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' jan. ', '-01-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} jan \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' jan ', '-01-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} february \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' february ', '-02-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} february \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' february ', '-02-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} feb. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' feb. ', '-02-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} feb \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' feb ', '-02-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} march \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' march ', '-03-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} march \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' march ', '-03-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} mar. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' mar. ', '-03-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} mar \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' mar ', '-03-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} april \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' april ', '-04-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} april \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' april ', '-04-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} apr. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' apr. ', '-04-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} apr \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' apr ', '-04-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} may \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' may ', '-05-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} may \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' may ', '-05-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} june \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' june ', '-06-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} june \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' june ', '-06-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} july \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' july ', '-07-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} july \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' july ', '-07-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} august \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' august ', '-08-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} august \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' august ', '-08-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} aug. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' aug. ', '-08-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} aug \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' aug ', '-08-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} september \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' september ', '-09-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} september \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' september ', '-09-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} sept. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' sept. ', '-09-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} sept \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' sept ', '-09-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} october \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' october ', '-10-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} october \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' october ', '-10-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} oct. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' oct. ', '-10-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} oct \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' oct ', '-10-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} november \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' november ', '-11-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} november \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' november ', '-11-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} nov. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' nov. ', '-11-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} nov \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' nov ', '-11-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} december \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' december ', '-12-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} december \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' december ', '-12-0')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} dec. \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' dec. ', '-12-')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} dec \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' dec ', '-12-0')"/></dateCreated>
                    </xsl:when>
                    <!-- Match YYYY Month formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} january$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' january', '-01')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} february$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' february', '-02')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} march$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' march', '-03')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} april$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' april', '-04')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} may$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' may', '-05')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} june$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' june', '-06')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} july$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' july', '-07')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} august$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' august', '-08')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} september$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' september', '-09')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} october$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' october', '-10')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} november$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' november', '-11')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} december$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)),' december', '-12')"/></dateCreated>
                    </xsl:when>
                <!-- Match Month YYYY formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^january \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-01')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^february \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-02')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^march \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-03')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^april \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-04')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^may \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-05')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^june \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-06')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^july \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-07')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^august \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-08')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^september \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-09')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^october \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-10')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^november \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-11')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^december \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-12')"/></dateCreated>
                    </xsl:when>
                  <!-- Match Month DD, YYYY formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^january \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'january ', '-01-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^january \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'january ', '-01-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^february \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'february ', '-02-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^february \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'february ', '-02-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^march \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'march ', '-03-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^march \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'march ', '-03-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^april \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'april ', '-04-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^april \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'april ', '-04-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^may \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'may ', '-05-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^may \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'may ', '-05-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^june \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'june ', '-06-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^june \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'june ', '-06-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^july \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'july ', '-07-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^july \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'july ', '-07-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^august \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'august ', '-08-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^august \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'august ', '-08-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^september \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'september ', '-09-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^september \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'september ', '-09-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^october \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'october ', '-10-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^october \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'october ', '-10-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^november \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'november ', '-11-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^november \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'november ', '-11-'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^december \d{1}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'december ', '-12-0'))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^december \d{2}, \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ', ')), replace(replace(substring-before(normalize-space(lower-case(.)), ','), ',', ''), 'december ', '-12-'))"/></dateCreated>
                    </xsl:when>
                  <!-- INFERRED -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '\[')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}-\d{2}-\d{2}\]$') or matches(normalize-space(.), '^\[\d{4}-\d{2}\]$') or matches(normalize-space(.), '^\[\d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="translate(normalize-space(.), '\[\]', '')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}\]\?$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(translate(normalize-space(.), '\[\]', ''), '?')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(translate(normalize-space(.), '\[\]', ''), '?')"/></dateCreated>
                            </xsl:when>
                          <!-- Match [Month YYYY] formatting -->
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[january \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-01')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[february \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-02')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[march \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-03')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[april \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-04')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[may \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-05')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[june \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-06')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[july \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-07')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[august \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-08')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[september \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-09')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[october \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-10')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[november \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-11')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[december \d{4}\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-12')"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated ><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- REVISIONS -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4} \(.+revis.+\)$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="substring-before(normalize-space(.), ' \(')"/></dateCreated>
                    </xsl:when>
                  <!-- QUESTIONABLE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '?')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\?{4}-\d{2}-\?{2}$') or matches(normalize-space(.), '^\?{4}-\d{2}$') or matches(normalize-space(.), '^\?{4}-\d{2}-\d{2}$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '\?', 'u')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2} (\?)$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' (\?)', '')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\?{4}-\d{2}-\?{2} \[.+\]$') or matches(normalize-space(.), '^\d{2}\?{2}-\d{2}-\?{2} \[.+\]$') or matches(normalize-space(.), '^\?{4}-\d{2} \[.+\]$') or matches(normalize-space(.), '^\?{4}-\d{2}-\d{2} \[.+\]$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="substring-before(replace(normalize-space(.), '\?', 'u'), '[')"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                  <!-- APPROXIMATE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'circa') or contains(normalize-space(lower-case(.)), 'c.') or contains(normalize-space(lower-case(.)), 'ca.')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}$') or matches(normalize-space(.), '^c. \d{4}-\d{2}$') or matches(normalize-space(.), '^c. \d{4}-\d{2}-\d{2}$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}-\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),1, 4),'/'), substring(., 6, 8)), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^ca. \d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c.\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c.', ''), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}s$')">
                                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(concat(replace(replace(normalize-space(.), 'c. ', ''), 's', ''), '~'), '/'), concat(replace(replace(normalize-space(.), 'c. ', ''), '0s', '9'), '~'))"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="approximate"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:description[1]"> <!-- second abstract skipped bc bad OCR texts - need to review further -->
        <xsl:if test="normalize-space(.)!=''">
            <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier">
        <xsl:if test="normalize-space(.)!='' and not(starts-with(., 'http://'))  and not(contains(lower-case(.), 'box')) and not(contains(lower-case(.), 'folder')) and not(contains(lower-case(.), 'drawer'))">
            <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="URL">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:if test="starts-with(., 'http://')">
                <url usage="primary" access="object in context"><xsl:value-of select="normalize-space(.)"/></url>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:for-each select="tokenize(normalize-space(.), ' and ')">
                <xsl:for-each select="tokenize(normalize-space(.), ' &amp; ')">
                    <xsl:if test="normalize-space(.)!='' and not(contains(lower-case(.), 'box 3')) and not(contains(lower-case(.), 'europe - 1974')) and not(matches(., 'language')) and not(contains(., 'closed stacks')) and not(contains(., 'baptist'))">
                        <language>
                            <xsl:choose>
                                <xsl:when test="normalize-space(lower-case(.))='en' or starts-with(normalize-space(lower-case(.)), 'eng') or contains(normalize-space(lower-case(.)), 'enlish')">
                                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                                </xsl:when>
                                <xsl:when test="normalize-space(lower-case(.))='deu' or contains(normalize-space(lower-case(.)), 'dutch') or starts-with(normalize-space(lower-case(.)), 'dut')">
                                    <languageTerm type="code" authority="iso639-2b">dut</languageTerm>
                                </xsl:when>
                                <xsl:when test="starts-with(normalize-space(lower-case(.)), 'fre')">
                                    <languageTerm type="code" authority="iso639-2b">fre</languageTerm>
                                </xsl:when>
                                <xsl:when test="starts-with(normalize-space(lower-case(.)),'german') or starts-with(normalize-space(lower-case(.)), 'ger')">
                                    <languageTerm type="code" authority="iso639-2b">deu</languageTerm>
                                </xsl:when>
                                <xsl:when test="normalize-space(lower-case(.))='italian'">
                                    <languageTerm type="code" authority="iso639-2b">ita</languageTerm>
                                </xsl:when>
                                <xsl:when test="normalize-space(lower-case(.))='spanish'">
                                    <languageTerm type="code" authority="iso639-2b">spa</languageTerm>
                                </xsl:when>
                                <xsl:when test="normalize-space(lower-case(.))='n/a'">
                                    <languageTerm type="code" authority="iso639-2b">zxx</languageTerm>
                                </xsl:when>
                            </xsl:choose>
                        </language>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:rights[1]">
        <xsl:variable name="vText"
                      select="if (contains(normalize-space(.), 'http://'))
                              then (normalize-space(.))
                              else (lower-case(normalize-space(.)))"/>
        <xsl:choose>
            <xsl:when test="$vRightsCount > 1">
                <accessCondition type="local rights statement"><xsl:value-of select="$vRightsString"/></accessCondition>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$vText = $pRights/rs/@uri">
                        <accessCondition type="use and reproduction" xlink:href="{$vText}">
                            <xsl:value-of select="$pRights/rs[@uri = $vText]/@string"/>
                        </accessCondition>
                    </xsl:when>
                    <xsl:when test="$vText = $pRights/rs">
                        <accessCondition type="use and reproduction" xlink:href="{$pRights/r[. = $vText]/@uri}">
                            <xsl:value-of select="$pRights/rs[. = $vText]/@string"/>
                        </accessCondition>
                    </xsl:when>
                    <!-- keep public domain test but map to no copyright - united states -->
                    <xsl:when test="contains($vText, 'public domain')">
                        <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/NoC-US/1.0/">No Copyright - United States</accessCondition>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="$vText != ''">
                            <accessCondition type="local rights statement"><xsl:value-of select="normalize-space(.)"/></accessCondition>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:title">
        <xsl:if test="normalize-space(.)!='' and position()=1">
            <titleInfo>
                <title><xsl:value-of select="normalize-space(.)"/></title>
            </titleInfo>
        </xsl:if>
        <xsl:if test="normalize-space(.)!='' and position()>1">
            <titleInfo>
                <title type="alternative"><xsl:value-of select="normalize-space(.)"/></title>
            </titleInfo>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>