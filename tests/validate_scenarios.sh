#!/bin/bash

## Add Global Variables
DLTNMODS="testSchemas/DLTN_oai_mods.xsd"
SAMPLEDATA="../Sample_Data"
STYLESHEETS="../XSLT"
TESTFILE="../working_directory/test.xml"
SAXON="java -jar ../working_directory/saxon-8.7.jar"


testJavaInstalled() {
    assertNotNull $(which java)
}

testShunitIntalled() {
    assertNotNull $(which shunit2)
}

testCurlInstalled() {
    assertNotNull $(which curl)
}

# Rhodes and Crossroads to Freedom
testValidityOfSternberg() {
    ${SAXON} ${SAMPLEDATA}/Rhodes/sternberg.xml ${STYLESHEETS}/rhodes_sternberg_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    STERNBERG=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${STERNBERG}" "${TESTFILE} validates"
}

testValidityofFarnsworth() {
    ${SAXON} ${SAMPLEDATA}/Rhodes/Farnsworth.xml ${STYLESHEETS}/rhodes_dspace_xoai_to_mods_farnsworth.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${RESPONSE}" "${TESTFILE} validates"
}

testValidityOfCrossroadsXOAItoMODS() {
    for filename in ${SAMPLEDATA}/Crossroads_xoai_default/*.xml; do
        ${SAXON} ${filename} ${STYLESHEETS}/rhodes_dspace_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
}

# Country Music Hall of Fame Tests
testValidityOfCountryMusicHallofFame() {
    ${SAXON} ${SAMPLEDATA}/Country/countryqdc.xml ${STYLESHEETS}/countryqdctomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${RESPONSE}" "${TESTFILE} validates"
}

testValidityOfCountryMusicHallofFameHatch(){
    curl "https://dpla.lib.utk.edu/repox/OAIHandler?verb=ListRecords&metadataPrefix=oai_qdc&set=cmhf_hatch" 2>&1 2>/dev/null 1>"delete.xml"
    ${SAXON} delete.xml ${STYLESHEETS}/countryqdctomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${RESPONSE}" "${TESTFILE} validates"
}

# TSLA Tests
testValidityOfTSLAqdctoMODS() {
    TSLA="test_data/tsla_qdc.txt"
    DATADIR="../working_directory/tsla_qdc"
    mkdir ${DATADIR}
    cat $TSLA | while read line; do
        curl "https://dpla.lib.utk.edu/repox/OAIHandler?verb=ListRecords&metadataPrefix=oai_qdc&set=$line" 2>&1 2>/dev/null 1>"$DATADIR/$line.xml"
        cat "$DATADIR/$line.xml"
    done
    for filename in ${DATADIR}/*.xml; do
        ${SAXON} ${filename} ${STYLESHEETS}/tslaqdctomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
    rm -rf ${DATADIR}
}

# UTC Tests
testValidityOfUTCQDCtoMODS() {
    UTK="test_data/utc_qdc.txt"
    DATADIR="../working_directory/utc"
    mkdir ${DATADIR}
    cat $UTK | while read line; do
        curl "https://dpla.lib.utk.edu/repox/OAIHandler?verb=ListRecords&metadataPrefix=mods&set=$line" 2>&1 2>/dev/null 1>"$DATADIR/$line.xml"
    done
    for filename in ${DATADIR}/*.xml; do
        TESTFILE="${filename}.test"
        ${SAXON} ${filename} ${STYLESHEETS}/utkmodstomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
    rm -rf ${DATADIR}
}

#UTK Tests
testValidityOfUTKMODStoMODS() {
    UTK="test_data/utk_mods.txt"
    DATADIR="../working_directory/utk"
    mkdir ${DATADIR}
    cat $UTK | while read line; do
        curl "https://dpla.lib.utk.edu/repox/OAIHandler?verb=ListRecords&metadataPrefix=mods&set=$line" 2>&1 2>/dev/null 1>"$DATADIR/$line.xml"
    done
    for filename in ${DATADIR}/*.xml; do
        TESTFILE="${filename}.test"
        ${SAXON} ${filename} ${STYLESHEETS}/utkmodstomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
    rm -rf ${DATADIR}
}

. shunit2