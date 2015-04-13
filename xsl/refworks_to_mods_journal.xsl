<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/mods/v3"
    version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <mods>
            <titleInfo>                
                <!--               <title>
                    <xsl:variable name="title-clean">
                        <xsl:call-template name="string-replace-all">
                            <xsl:with-param name="text" select="//reference/t1"/>
                            <xsl:with-param name="replace" select="'&amp;#39;'"/>
                            <xsl:with-param name="by" select="'&amp;apos;'"/>
                            
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$title-clean"/>
                </title>
 
                <subTitle>
                    <xsl:value-of select="//reference/t2"/>
                </subTitle>
 -->
                <xsl:for-each select="//reference/t1">
                    <xsl:call-template name="title">
                        <xsl:with-param name="strTitle" select="."/>
                    </xsl:call-template>
                </xsl:for-each>            
            </titleInfo>
            
            <xsl:for-each select="//reference/a1">
                <name>
                   
                    <xsl:choose>
                        <xsl:when test="contains(text(), ',')">
                            <xsl:attribute name="type">personal</xsl:attribute>
                            <namePart>
                                <xsl:attribute name="type">given</xsl:attribute>
                                <xsl:value-of select="normalize-space(substring-after(text(), ','))"
                                />
                            </namePart>
                            <namePart>
                                <xsl:attribute name="type">family</xsl:attribute>
                                <xsl:value-of
                                    select="normalize-space(substring-before(text(), ','))"/>
                            </namePart>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="type">corporate</xsl:attribute>
                            <namePart>
                                <!--<xsl:attribute name="type">family</xsl:attribute>-->
                                <xsl:value-of select="normalize-space(text())"/>
                            </namePart>
                        </xsl:otherwise>
                    </xsl:choose>
                    <role>
                        <roleTerm>
                            <xsl:attribute name="authority">marcrelator</xsl:attribute>
                            <xsl:attribute name="type">text</xsl:attribute>Author</roleTerm>
                    </role>
                </name>
            </xsl:for-each>
            <xsl:for-each select="//reference/u1">
                <xsl:call-template name="links">
                    <xsl:with-param name="str" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="//reference/u2">
                <xsl:call-template name="links2">
                    <xsl:with-param name="str" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <typeOfResource>text</typeOfResource>
            <genre>
                <xsl:value-of select="//reference/rt"/>
            </genre>
            <identifier>
                <xsl:attribute name="type">refworks</xsl:attribute>
                <xsl:value-of select="//reference/id"/>
            </identifier>
<!--            <identifier>
               <xsl:for-each select="//reference/do">
                <xsl:attribute name="type">doi</xsl:attribute>
                    <xsl:text>http://dx.doi.org/</xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(string(.),'DOI:')">
                            <xsl:value-of select="translate(string(.), 'DOI:', '')" />
                        </xsl:when>
                        <xsl:when test="contains(string(.),'doi')">
                            <xsl:value-of select="translate(string(.), 'doi:', '')" />
                        </xsl:when>
                        <xsl:when test="contains(string(.),'[doi]')">
                            <xsl:value-of select="translate(string(.), '[doi]', '')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="." />	
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                </identifier> -->
           <!-- HANDLING DOIs in the drush script as there is a lot of logic <xsl:if test="//reference/do/text() [normalize-space(.) ]">
                <xsl:for-each select="//reference/do">
                    <xsl:call-template name="doi">
                        <xsl:with-param name="strdoi" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>-->
            <relatedItem>
                <xsl:attribute name="type">host</xsl:attribute>
                <xsl:if test="//reference/t2/text() [normalize-space(.) ]">
                    <titleInfo>
                        <title>
                            <xsl:variable name="title-clean2">
                                <xsl:call-template name="string-replace-all">
                                    <xsl:with-param name="text" select="//reference/t2"/>
                                    <xsl:with-param name="replace" select="'&amp;#39;'"/>
                                    <xsl:with-param name="by" select="'&amp;apos;'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="$title-clean2"/>
                        </title> 
                    </titleInfo>
                </xsl:if>
                <xsl:if test="//reference/jf/text() [normalize-space(.) ]">
                    <titleInfo>
                        <title>
                            <xsl:value-of select="//reference/jf"/>
                        </title>
                    </titleInfo>
                </xsl:if>
                
                <xsl:if test="//reference/jo/text() [normalize-space(.) ]">
                    <titleInfo>
                        <xsl:attribute name="type">abbreviated</xsl:attribute>
                        <title>
                            <xsl:value-of select="//reference/jo"/>
                        </title>
                    </titleInfo>
                </xsl:if>
                <xsl:if test="//reference/ad/text() [normalize-space(.) ]">
                    <note>
                        <xsl:value-of select="//reference/ad"/>
                    </note>
                </xsl:if>
                <xsl:if test="//reference/pp/text() [normalize-space(.) ]">
                    <note>                           
                        <xsl:value-of select="//reference/pp"/>
                    </note>
                </xsl:if>
                <xsl:for-each select="//reference/pb">
                    <note>
                        <xsl:value-of select="normalize-space(text())"/>
                    </note>
                </xsl:for-each>
                <originInfo>                  
                    <dateIssued>
                        <xsl:attribute name="keyDate">yes</xsl:attribute>
                        <xsl:value-of select="//reference/yr"/>
                    </dateIssued>
                    <dateOther>
                        <xsl:value-of select="//reference/fd"/>
                    </dateOther>
                </originInfo>
                <part>
                    <date>
                        <xsl:value-of select="//reference/yr"/>
                    </date>
                    <detail>
                        <xsl:attribute name="type">volume</xsl:attribute>
                        <number>
                            <xsl:value-of select="//reference/vo"/>
                        </number>
                    </detail>
                    <detail>
                        <xsl:attribute name="type">issue</xsl:attribute>
                        <number>
                            <xsl:value-of select="//reference/is"/>
                        </number>
                    </detail>
                    <extent>
                        <xsl:attribute name="unit">page</xsl:attribute>
                        <start>
                            <xsl:value-of select="//reference/sp"/>
                        </start>
                        <end>
                            <xsl:value-of select="//reference/op"/>
                        </end>
                    </extent>
                </part>
                <xsl:if test="//reference/sn/text() [normalize-space(.) ]">
                        <xsl:for-each select="//reference/sn">
                            <xsl:call-template name="issn">
                                <xsl:with-param name="strissn" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                </xsl:if>
            </relatedItem>
            <subject authority="local">
                <xsl:for-each select="//reference/k1">
                    <topic>
                        <xsl:value-of select="normalize-space(text())"/>
                    </topic>
                </xsl:for-each>
            </subject>
            <abstract>
                <xsl:variable name="abstract-clean">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="//reference/ab"/>
                        <xsl:with-param name="replace" select="'&amp;#39;'"/>
                        <xsl:with-param name="by" select="'&amp;apos;'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$abstract-clean"/>
            </abstract>
            <xsl:if test="//reference/no/text() [normalize-space(.) ]">
                <note>
                    <xsl:value-of select="//reference/no"/>
                </note>
            </xsl:if>
            <note>Source type: <xsl:value-of select="//reference/sr"/></note>
            <xsl:if test="//reference/lk/text() [normalize-space(.) ]">
                <note>
                    <xsl:value-of select="//reference/lk"/>
                </note>
            </xsl:if>
            <location>
                <url>
                    <xsl:value-of select="//reference/ul"/>
                </url>
            </location>
            <xsl:choose>
                <xsl:when test="//reference/ol/text()='Unknown(0)'"></xsl:when>
                <xsl:otherwise>
                    <language>
                        <languageTerm>
                            <xsl:attribute name="type">code</xsl:attribute>
                            <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                            <xsl:value-of select="//reference/ol"/>
                        </languageTerm>
                    </language>                    
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="//reference/usage/text() [normalize-space(.) ]">
                <accessCondition type="use and reproduction">
                    <xsl:value-of select="//reference/usage"/>
                </accessCondition>
            </xsl:if>
            <xsl:if test="//reference/status/text() [normalize-space(.) ]">
                <physicalDescription>
                    <form authority="local">
                        <xsl:value-of select="//reference/status"/>
                    </form>
                </physicalDescription>
            </xsl:if>
        </mods>
    </xsl:template>
    
    <xsl:template name="issn">
        <xsl:param name="strissn"/>
        <xsl:choose>
            <xsl:when test="contains($strissn,';')">
                <identifier type="issn">
                    <xsl:value-of select="normalize-space(substring-before($strissn,';'))"/>
                </identifier>
                <xsl:call-template name="issn">
                    <xsl:with-param name="strissn" select="normalize-space(substring-after($strissn,';'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <identifier type="issn">
                    <xsl:value-of select="normalize-space($strissn)"/>
                </identifier>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="doi">
        <xsl:param name="strdoi"/>
        <xsl:choose>
            <xsl:when test="contains($strdoi,';')">
                <identifier type="doi">
                    <xsl:value-of select="normalize-space(substring-before($strdoi,';'))"/>
                </identifier>
                <identifier type="doi">
                    <xsl:value-of select="normalize-space(substring-after($strdoi,';'))"/>
                </identifier>
            </xsl:when>
            <xsl:otherwise>
                <identifier type="doi">
                    <xsl:value-of select="normalize-space($strdoi)"/>
                </identifier>
            </xsl:otherwise>
        </xsl:choose>
 <!--       <xsl:choose>
            <xsl:when test="contains($strdoi,';')">                
                     <xsl:value-of select="normalize-space(substring-before($strdoi,';'))"/>
                <xsl:for-each select="contains($strdoi, 'doi')">
                    <identifier type="doi">
                        <xsl:value-of select="normalize-space(.)"/>
                </identifier>
                </xsl:for-each>                
            </xsl:when>
            <xsl:when test="contains($strdoi,';')">                
                <xsl:value-of select="normalize-space(substring-before($strdoi,';'))"/>
                <xsl:for-each select="contains($strdoi, 'pii')">
                    <identifier type="pii">
                        <xsl:value-of select="normalize-space(.)"/>
                    </identifier>
                </xsl:for-each>                
            </xsl:when>
            <xsl:when test="contains($strdoi,';')">                
                <xsl:value-of select="normalize-space(substring-after($strdoi,';'))"/>
                <xsl:for-each select="contains($strdoi, 'doi')">
                    <identifier type="doi">
                        <xsl:value-of select="normalize-space(.)"/>
                    </identifier>
                </xsl:for-each>                
            </xsl:when>
            <xsl:when test="contains($strdoi,';')">                
                <xsl:value-of select="normalize-space(substring-after($strdoi,';'))"/>
                <xsl:for-each select="contains($strdoi, 'pii')">
                    <identifier type="pii">
                        <xsl:value-of select="normalize-space(.)"/>
                    </identifier>
                </xsl:for-each>                
            </xsl:when>
            <xsl:otherwise>
                <identifier type="doi">
                    <xsl:value-of select="normalize-space($strdoi)"/>
                </identifier>
            </xsl:otherwise>
        </xsl:choose>
         -->
    </xsl:template>
    
    <xsl:template name="title">
        <xsl:param name="strTitle"/>
        <xsl:choose>
            <xsl:when test="contains($strTitle,':')">
                <title>
                    <xsl:value-of select="normalize-space(substring-before($strTitle,':'))"/>
                </title>
                <subTitle>
                    <xsl:value-of select="normalize-space(substring-after($strTitle,':'))"/>
                </subTitle>
            </xsl:when>
            <xsl:otherwise>
                <title>
                    <xsl:value-of select="normalize-space($strTitle)"/>
                </title>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="links">
        <xsl:param name="str"/>
        <xsl:choose>
            <xsl:when test="contains($str,';')">
                <identifier type="u1">
                    <xsl:value-of select="normalize-space(substring-before($str,';'))"/>
                </identifier>
                <xsl:call-template name="links">
                    <xsl:with-param name="str" select="normalize-space(substring-after($str,';'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <identifier type="u1">
                    <xsl:value-of select="normalize-space($str)"/>
                </identifier>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="links2">
        <xsl:param name="str"/>
        <xsl:choose>
            <xsl:when test="contains($str,';')">
                <identifier type="u2">
                    <xsl:value-of select="normalize-space(substring-before($str,';'))"/>
                </identifier>
                <xsl:call-template name="links">
                    <xsl:with-param name="str" select="normalize-space(substring-after($str,';'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <identifier type="u2">
                    <xsl:value-of select="normalize-space($str)"/>
                </identifier>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
