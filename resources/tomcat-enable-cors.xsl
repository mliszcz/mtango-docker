<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform
  xmlns="http://java.sun.com/xml/ns/javaee"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:jee="http://java.sun.com/xml/ns/javaee" version="1.0">

  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="jee:security-constraint[jee:web-resource-collection/jee:web-resource-name = 'Tango RESTful gateway']">
    <!-- Delete -->
  </xsl:template>

  <xsl:template match="jee:filter[jee:filter-class = 'org.tango.web.server.filters.CORSFilter']">
    <!-- Delete -->
  </xsl:template>

  <xsl:template match="jee:filter-mapping[jee:filter-name = 'CORSFilter']">
    <!-- Delete -->
  </xsl:template>

  <xsl:template match="jee:web-app">
    <xsl:copy>

      <xsl:apply-templates select="@* | node()" />

      <filter>
        <filter-name>CorsFilter</filter-name>
        <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>

        <init-param>
          <param-name>cors.allowed.methods</param-name>
          <param-value>GET,HEAD,POST,PUT,DELETE,OPTIONS</param-value>
        </init-param>

        <init-param>
          <param-name>cors.allowed.headers</param-name>
          <param-value>Accept,Accept-Encoding,Accept-Language,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization,Cache-Control,Connection,Content-Type,Host,Origin,Referer,User-Agent,X-Requested-With</param-value>
        </init-param>
      </filter>

      <filter-mapping>
        <filter-name>CorsFilter</filter-name>
        <url-pattern>/rest/*</url-pattern>
      </filter-mapping>

      <security-constraint>
        <web-resource-collection>
          <web-resource-name>Tango RESTful gateway</web-resource-name>
          <url-pattern>/rest/*</url-pattern>
          <http-method>OPTIONS</http-method>
        </web-resource-collection>
      </security-constraint>

      <security-constraint>
        <web-resource-collection>
          <web-resource-name>Tango RESTful gateway</web-resource-name>
          <url-pattern>/rest/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
          <role-name>mtango-rest</role-name>
        </auth-constraint>
      </security-constraint>

    </xsl:copy>
  </xsl:template>

</xsl:transform>
