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
<style>
a:link, a:visited {color:DarkBlue;}
th {background-color: WhiteSmoke;}
table {border-collapse:collapse;margin-top:1em;}
table,th,td { padding: 3px; border: 1px solid black; word-wrap:break-word; }
a.add:link {text-decoration:none; color:#909090; font-size:small;}
a.add:visited {text-decoration:none; color:#909090; font-size:small;}
</style>
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
<input type="submit" style="display:none" id="addButtonEnabled" name="action" onclick="this.style.display='none';document.getElementById('addButtonDisabled').style.display='inline';clearAddPositionFromLocalStorage();window.location='geoNoteAdjustLocation.jsp';" value="<%=bundle.getString("addNewRequestLabel")%>"/>
</div>
<%-- Data --%>
<div style="margin-top:1.5em" id="geoNotesDiv">
<p> <%=bundle.getString("waitingForDataLabel")%> </p>
</div>
<script type="text/javascript" src="/js/geoNotes.js" />
</script>
</body>
</html>