<%-- This JSP has the HTML for location page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<%
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
%>
<title><%=bundle.getString("instructionsLabel")%></title>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
<ul>
<li> Create note. </li>
<li> Add picture. </li>
<li> Call 311 to submit request with city.</li>
<li> Inform operator that picture, location, and notes are on this site.  Give URL and Id. </li>
</ul>
<jsp:include page="/WEB-INF/pages/components/footer.jsp"/>
</body>
</html>