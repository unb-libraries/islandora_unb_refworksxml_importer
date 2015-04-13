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
                <originInfo>
                    <xsl:if test="//reference/ad/text() [normalize-space(.) ]">
                        <place>
                            <placeTerm>
                                <xsl:attribute name="type">text</xsl:attribute>
                                <xsl:value-of select="//reference/ad"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <xsl:if test="//reference/pp/text() [normalize-space(.) ]">
                        <place>
                            <placeTerm>
                                <xsl:attribute name="type">text</xsl:attribute>
                                <xsl:value-of select="//reference/pp"/>
                            </placeTerm>
                        </place>
                    </xsl:if>
                    <xsl:for-each select="//reference/pb">
                        <publisher>
                            <xsl:value-of select="normalize-space(text())"/>
                        </publisher>
                    </xsl:for-each>
                    <dateIssued>
                        <xsl:attribute name="keyDate">yes</xsl:attribute>
                        <xsl:value-of select="//reference/yr"/>
                    </dateIssued>
                    <xsl:if test="//reference/ed/text() [normalize-space(.) ]">
                        <edition>
                            <xsl:value-of select="//reference/ed"/>
                        </edition>
                    </xsl:if>
                </originInfo>
           <xsl:if test="//reference/sn/text() [normalize-space(.) ]">
               <xsl:for-each select="//reference/sn">
                   <xsl:call-template name="isbn">
                       <xsl:with-param name="strisbn" select="."/>
                   </xsl:call-template>
               </xsl:for-each>
           </xsl:if>
               <!--<xsl:if test="//reference/sn/text() [normalize-space(.) ]">
                    <identifier>
                        <xsl:if test="string-length(//reference/sn) &gt; 10">
                            <xsl:attribute name="type">isbn</xsl:attribute>
                            <xsl:value-of select="//reference/sn"/>
                        </xsl:if>
                    </identifier>
                </xsl:if>-->
            <identifier>
                <xsl:attribute name="type">refworks</xsl:attribute>
                <xsl:value-of select="//reference/id"/>
            </identifier>
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
                    <extent>
                        <xsl:value-of select="//reference/sp"/>
                    </extent>                
                </physicalDescription>
            </xsl:if>
           <xsl:if test="//reference/t2/text() [normalize-space(.) ]">
               <relatedItem type="series">
                   <titleInfo>
                       <title>
                           <xsl:value-of select="//reference/t2"/>
                       </title>
                   </titleInfo>
               </relatedItem>
           </xsl:if>
        </mods>
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
    
    <xsl:template name="isbn">
        <xsl:param name="strisbn"/>
        <xsl:choose>
            <xsl:when test="contains($strisbn,';')">
                <identifier type="isbn">
                    <xsl:value-of select="normalize-space(substring-before($strisbn,';'))"/>
                </identifier>
                <xsl:call-template name="isbn">
                    <xsl:with-param name="strisbn" select="normalize-space(substring-after($strisbn,';'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <identifier type="isbn">
                    <xsl:value-of select="normalize-space($strisbn)"/>
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
