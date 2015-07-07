<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.loc.gov/MARC21/slim">
    <!-- This defines default value; can input a value to the stylesheet -->
    <xsl:param name="pRecords" select="25"/>
    <!-- Directory to write the new files; can input a value to the stylesheet -->
    <xsl:param name="pDestination"/> 
    <!-- Get the filename -->
    <xsl:variable name="filename" select="tokenize(base-uri(.), '/')[last()]"/>
    <!-- Remove the file extension -->
    <xsl:variable name="filenamebase" select="substring-before($filename, '.xml')"/>
    <xsl:template match="collection">
        <xsl:for-each-group select="record"
            group-adjacent="(position()-1) idiv $pRecords">
            <xsl:variable name="startindex" select="current-grouping-key() * $pRecords"/>
            <!-- This gives wrong endindex on final group if there are not $pRecords in
                the group.
                <xsl:variable name="endindex" select="($startindex + $pRecords) - 1"/> -->
            <xsl:variable name="endindex" select="$startindex + count(current-group()) -1"/> 
            <!-- Name the new file using the orginal file name and range of record indices -->
            <xsl:result-document  href="{$pDestination}{$filenamebase}.{$startindex}-{$endindex}.xml">
                <collection xmlns="http://www.loc.gov/MARC21/slim">
                    <xsl:copy-of select="current-group()"/>
                </collection>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>