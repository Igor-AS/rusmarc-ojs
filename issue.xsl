<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
    xmlns:marc="http://www.loc.gov/MARC21/slim" 
    exclude-result-prefixes="marc"
    xmlns="http://pkp.sfu.ca" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:param name="abbrev_locale_ru">СТ</xsl:param>
  <xsl:template match="/">
    <issue xmlns="http://pkp.sfu.ca" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" published="1" xsi:schemaLocation="http://pkp.sfu.ca native.xsd">
      <xsl:apply-templates/>
    </issue>
  </xsl:template>
  <xsl:template match="marc:collection">
    <id type="internal" advice="ignore">1</id>
    <xsl:if test="substring(marc:record/marc:leader,8,1)='s' or substring(marc:record/marc:leader,8,1)='m'">
      <xsl:if test="contains(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], 'Т. ')">
        <issue_identification>
          <volume>
            <xsl:value-of select="substring-before(substring-after(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], 'Т. '), ',')"/>
          </volume>
          <xsl:choose>
            <xsl:when test="contains(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], ':')">
              <number>
                <xsl:value-of select="substring-before(substring-after(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], '№ '), ' : ')"/>
              </number>
            </xsl:when>
            <xsl:otherwise>
              <number>
                <xsl:value-of select="substring-after(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], '№ ')"/>
              </number>
            </xsl:otherwise>
          </xsl:choose>
          <year>
            <xsl:value-of select="normalize-space(marc:record/marc:datafield[@tag=210]/marc:subfield[@code='d'])"/>
          </year>
          <xsl:if test="contains(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], ':')">
            <title locale="ru_RU">
              <xsl:value-of select="substring-after(marc:record/marc:datafield[@tag=200]/marc:subfield[@code='a'], ': ')"/>
            </title>
          </xsl:if>
        </issue_identification>
      </xsl:if>
    </xsl:if>
    <xsl:if test="marc:record/marc:datafield[@tag=801]/marc:subfield[@code='c']">
      <date_published>
        <xsl:value-of select="substring(marc:record/marc:datafield[@tag=801]/marc:subfield[@code='c'],1,4)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring(marc:record/marc:datafield[@tag=801]/marc:subfield[@code='c'],5,2)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring(marc:record/marc:datafield[@tag=801]/marc:subfield[@code='c'],7,2)"/>
      </date_published>
    </xsl:if>
    <last_modified>2019-05-15</last_modified>
    <sections>
      <section ref="{$abbrev_locale_ru}" seq="1">
        <id type="internal" advice="ignore">1</id>
        <!-- abbrev locale="en_US">ART</abbrev -->
        <abbrev locale="en_US">AR</abbrev>
        <abbrev locale="ru_RU">
          <xsl:value-of select="$abbrev_locale_ru"/>
        </abbrev>
        <title locale="en_US">Articles</title>
        <title locale="ru_RU">Статьи</title>
      </section>
    </sections>
    <issue_galleys/>
    <articles>
      <xsl:apply-templates select="marc:record"/>
    </articles>
  </xsl:template>
  <xsl:template match="marc:record">
    <xsl:if test="substring(marc:leader,8,1)='a'">
      <xsl:variable name="locale1">
        <xsl:choose>
          <xsl:when test="contains(marc:datafield[@tag=101]/marc:subfield[@code='a'], 'rus')">
            <xsl:text>ru_RU</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>en_US</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="locale2">
        <xsl:choose>
          <xsl:when test="contains(marc:datafield[@tag=101]/marc:subfield[@code='a'], 'rus')">
            <xsl:text>en_US</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>ru_RU</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="count">
        <xsl:value-of select="count(preceding-sibling::*)"/>
      </xsl:variable>
      <xsl:variable name="date_published">
        <xsl:value-of select="substring(marc:datafield[@tag=801]/marc:subfield[@code='c'],1,4)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring(marc:datafield[@tag=801]/marc:subfield[@code='c'],5,2)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring(marc:datafield[@tag=801]/marc:subfield[@code='c'],7,2)"/>
      </xsl:variable>
      <article locale="{$locale1}" stage="production" date_published="{$date_published}" section_ref="{$abbrev_locale_ru}" seq="{$count}">
        <id type="internal" advice="ignore">
          <xsl:value-of select="count(preceding-sibling::*)"/>
        </id>
        <xsl:if test="contains(marc:datafield[@tag=856]/marc:subfield[@code='u'], 'doi.org/')">
          <id type="doi" advice="update">
            <xsl:value-of select="substring-after(marc:datafield[@tag=856]/marc:subfield[@code='u'], 'doi.org/')"/>
          </id>
        </xsl:if>
        <xsl:if test="marc:datafield[@tag=200]">
          <title locale="{$locale1}">
            <xsl:value-of select="normalize-space(marc:datafield[@tag=200]/marc:subfield[@code='a'])"/>
          </title>
        </xsl:if>
        <xsl:if test="marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='200']/following-sibling::marc:subfield[@code='a']">
          <title locale="{$locale2}">
            <xsl:value-of select="marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='200']/following-sibling::marc:subfield[@code='a']"/>
          </title>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=200]/marc:subfield[@code='h']|marc:datafield[@tag=200]/marc:subfield[@code='h']">
          <subtitle locale="{$locale1}">
            <xsl:choose>
              <xsl:when test="marc:datafield[@tag=200]/marc:subfield[@code='e']">
                <xsl:value-of select="normalize-space(normalize-space(marc:datafield[@tag=200]/marc:subfield[@code='e']))"/>
              </xsl:when>
              <xsl:when test="marc:datafield[@tag=200]/marc:subfield[@code='h']">
                <xsl:value-of select="normalize-space(marc:datafield[@tag=200]/marc:subfield[@code='h'])"/>
                <xsl:if test="marc:datafield[@tag=200]/marc:subfield[@code='i']">
                  <xsl:text>. </xsl:text>
                  <xsl:value-of select="normalize-space(marc:datafield[@tag=200]/marc:subfield[@code='i'])"/>
                </xsl:if>
              </xsl:when>
            </xsl:choose>
          </subtitle>
        </xsl:if>

        <xsl:if test="marc:datafield[@tag=330]">
          <abstract locale="{$locale1}">
            <xsl:for-each select="marc:datafield[@tag=330]">
              <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
              <xsl:if test="position()!=last()">
                <xsl:text>&#xA0;</xsl:text>
              </xsl:if>
            </xsl:for-each>
          </abstract>
        </xsl:if>
        <xsl:if test="marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='330']">
          <abstract locale="{$locale2}">
            <xsl:for-each select="marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='330']">
              <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='a'])"/>
              <xsl:if test="position()!=last()">
                <xsl:text>&#xA0;</xsl:text>
              </xsl:if>
            </xsl:for-each>
          </abstract>
        </xsl:if>
        <!-- licenseUrl>http://creativecommons.org/licenses/by-nc-nd/4.0/</licenseUrl -->
        <copyrightHolder locale="en_US">Tomsk Polytechnic University</copyrightHolder>
        <copyrightHolder locale="ru_RU">Томский политехнический униерситет</copyrightHolder>
        <copyrightYear>
          <xsl:value-of select="normalize-space(marc:datafield[@tag=463]/marc:subfield[@code='1' and substring(.,1,3)='210']/following-sibling::marc:subfield[@code='d'])"/>
        </copyrightYear>
        <xsl:if test="not(contains(marc:datafield[@tag=610]/marc:subfield[@code='a'] ='' or marc:datafield[@tag=610]/marc:subfield[@code='a'], 'электронный ресурс') or contains(marc:datafield[@tag=610]/marc:subfield[@code='a'], 'труды учёных ТПУ') or contains(marc:datafield[@tag=610]/marc:subfield[@code='a'], 'труды ученых ТПУ')) or marc:datafield[@tag=606]">
          <keywords locale="{$locale1}">
            <xsl:for-each select="marc:datafield[@tag=606]">
              <xsl:if test="marc:subfield[@code='a'] !=''">
                <keyword>
                  <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
                  <xsl:if test="marc:subfield[@code='x'] !=''">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(marc:subfield[@code='x'])"/>
                  </xsl:if>
                  <xsl:if test="marc:subfield[@code='y'] !=''">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(marc:subfield[@code='y'])"/>
                  </xsl:if>
                  <xsl:if test="marc:subfield[@code='z'] !=''">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(marc:subfield[@code='z'])"/>
                  </xsl:if>
                  <xsl:if test="marc:subfield[@code='j'] !=''">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(marc:subfield[@code='j'])"/>
                  </xsl:if>
                </keyword>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="marc:datafield[@tag=610]">
              <xsl:if test="not(marc:subfield[@code='a'] ='' or contains(marc:subfield[@code='a'], 'электронный ресурс') or contains(marc:subfield[@code='a'], 'труды учёных ТПУ') or contains(marc:subfield[@code='a'], 'труды ученых ТПУ'))">
                <keyword>
                  <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
                </keyword>
              </xsl:if>
            </xsl:for-each>
          </keywords>
        </xsl:if>
        <xsl:if test="marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='610']">
          <keywords locale="{$locale2}">
            <xsl:for-each select="marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='610']">
              <keyword>
                <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='a'])"/>
              </keyword>
            </xsl:for-each>
          </keywords>
        </xsl:if>
        <authors>
          <xsl:if test="not(marc:datafield[@tag=700]|marc:datafield[@tag=701]|marc:datafield[@tag=702])">
            <author include_in_browse="false" user_group_ref="Author">
              <givenname locale="{$locale1}">&#xA0;</givenname>
              <familyname locale="{$locale1}">&#xA0;</familyname>
              <country>RU</country>
              <email>no_email@tpu.ru</email>
            </author>
          </xsl:if>
          <xsl:for-each select="marc:datafield[@tag=700]|marc:datafield[@tag=701]|marc:datafield[@tag=702]">
            <author include_in_browse="true" user_group_ref="Author">
              <xsl:variable name="pos">
                <xsl:value-of select="position()"/>
              </xsl:variable>
              <!-- position><xsl:value-of select="$pos"/></position -->
              <givenname locale="{$locale1}">
                <xsl:choose>
                  <xsl:when test="marc:subfield[@code='g']">
                    <xsl:value-of select="normalize-space(marc:subfield[@code='g'])"/>
                  </xsl:when>
                  <xsl:when test="marc:subfield[@code='b']">
                    <xsl:value-of select="normalize-space(marc:subfield[@code='b'])"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>&#xA0;</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </givenname>
              <xsl:for-each select="../marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='700']|../marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='701']|../marc:datafield[@tag=453]/marc:subfield[@code='1' and substring(.,1,3)='702']">
                <xsl:if test="position()=$pos">
                  <givenname locale="{$locale2}">
                    <xsl:choose>
                      <xsl:when test="following-sibling::marc:subfield[@code='g']">
                        <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='g'])"/>
                      </xsl:when>
                      <xsl:when test="following-sibling::marc:subfield[@code='b']">
                        <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='b'])"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>&#xA0;</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </givenname>
                  <familyname locale="{$locale2}">
                    <xsl:value-of select="normalize-space(following-sibling::marc:subfield[@code='a'])"/>
                  </familyname>
                </xsl:if>
              </xsl:for-each>
              <familyname locale="{$locale1}">
                <xsl:choose>
                  <xsl:when test="marc:subfield[@code='a']">
                    <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>&#xA0;</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </familyname>
              <xsl:if test="marc:subfield[@code='p']">
                <affiliation locale="{$locale1}">
                  <xsl:value-of select="normalize-space(marc:subfield[@code='p'])"/>
                </affiliation>
              </xsl:if>
              <country>RU</country>
              <email>no_email@tpu.ru</email>
            </author>
          </xsl:for-each>
        </authors>
        <xsl:for-each select="marc:datafield[@tag=856]/marc:subfield[@code='u']">
          <article_galley approved="false">
            <id type="internal" advice="ignore">1</id>
            <name>
              <xsl:value-of select="substring-after(., '/1/')"/>
            </name>
            <seq>0</seq>
            <xsl:variable name="href">
              <xsl:value-of select="."/>
            </xsl:variable>
            <remote src="{$href}"/>
          </article_galley>
        </xsl:for-each>
        <xsl:if test="contains(marc:datafield[@tag=463]/marc:subfield[@code='1' and substring(.,1,3)='200']/following-sibling::marc:subfield[@code='v'], '[')">
          <xsl:if test="substring-before(substring-after(marc:datafield[@tag=463]/marc:subfield[@code='1' and substring(.,1,3)='200']/following-sibling::marc:subfield[@code='v'], '[С. '), '-')">
            <pages>
              <xsl:value-of select="substring-before(substring-after(marc:datafield[@tag=463]/marc:subfield[@code='1' and substring(.,1,3)='200']/following-sibling::marc:subfield[@code='v'], '[С. '), ']')"/>
            </pages>
          </xsl:if>
        </xsl:if>
      </article>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
