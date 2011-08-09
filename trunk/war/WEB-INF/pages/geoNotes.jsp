<%-- This JSP has the HTML for Geo Notes page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
%>
<%@ include file="/WEB-INF/pages/components/noCache.jsp" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<title><%=bundle.getString("geoNotesLabel")%></title>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script> 
<script type="text/javascript">
var waitingForCoordinatesMessage="<%=bundle.getString("waitingForCoordinatesMessage")%>";
var locationNotAvailableMessage="<%=bundle.getString("locationNotAvailableMessage")%>";
var locationNotFoundMessage="<%=bundle.getString("locationNotFoundMessage")%>";
function clearAddPositionFromLocalStorage() {
  localStorage.removeItem("add-latitude");
  localStorage.removeItem("add-longitude");
}
</script>
</head>
<body onload="getCoordinates();">
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>
<%-- Location --%>
<div><span id="geoStatus"></span><a style="margin-left:1em" href="location.jsp"><%=bundle.getString("changeLocationLabel")%></a></div>
<div style="margin-top:1.5em">
<%-- Add Button --%>
<input type="submit" style="display:inline" id="addButtonDisabled" disabled="disabled" value="<%=bundle.getString("addNewRequestLabel")%>"/>
<input type="submit" style="display:none" id="addButtonEnabled" name="action" onclick="this.style.display='none';document.getElementById('addButtonDisabled').style.display='inline';clearAddPositionFromLocalStorage();window.location='geoNoteAddLocation.jsp';" value="<%=bundle.getString("addNewRequestLabel")%>"/>
</div>
<%-- Data --%>
<div style="margin-top:1.5em" id="geoNotesDiv">
<p> <%=bundle.getString("waitingForDataLabel")%> </p>
</div>
<script type="text/javascript" src="/js/geoNotes.js" />
</script>
</body>
</html>