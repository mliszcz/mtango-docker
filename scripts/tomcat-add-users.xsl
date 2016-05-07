<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform
  xmlns="http://tomcat.apache.org/xml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tomcat="http://tomcat.apache.org/xml" version="1.0">

  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tomcat:tomcat-users">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
      <role rolename="mtango-rest"/>
      <role rolename="mtango-admin"/>
      <role rolename="mtango-groovy"/>
      <user username="${{rest.user}}" password="${{rest.password}}" roles="mtango-rest"/>
      <user username="${{groovy.user}}" password="${{groovy.password}}" roles="mtango-groovy"/>
      <user username="${{admin.user}}" password="${{admin.password}}" roles="mtango-admin,mtango-rest,mtango-groovy"/>
    </xsl:copy>
  </xsl:template>

</xsl:transform>
