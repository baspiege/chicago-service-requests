<%-- This JSP has the HTML for Geo Notes page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="geonotes.data.GeoNoteAdd" %>
<%@ page import="geonotes.utils.RequestUtils" %>
<%@ page import="geonotes.utils.StringUtils" %>
<%
    String action=RequestUtils.getAlphaInput(request,"action","Action",false);
    ResourceBundle bundle = ResourceBundle.getBundle("Text");

    // Process based on action
    if (!RequestUtils.isForwarded(request) && !StringUtils.isEmpty(action)) {
        if (action.equals(bundle.getString("addLabel"))) {		

            // Get fields
            RequestUtils.getAlphaInput(request,"note",bundle.getString("noteLabel"),true);
            RequestUtils.getNumericInputAsDouble(request,"latitude",bundle.getString("latitudeLabel"),true);
            RequestUtils.getNumericInputAsDouble(request,"longitude",bundle.getString("longitudeLabel"),true);		
            RequestUtils.getNumericInputAsDouble(request,"accuracy",bundle.getString("accuracyLabel"),true);		

            if (!RequestUtils.hasEdits(request)) {
                new GeoNoteAdd().execute(request);
            }
        }
    }
%>
<%@ include file="/WEB-INF/pages/components/noCache.jsp" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<title><%=bundle.getString("geoNotesLabel")%></title>
<style>
a:link, a:visited {color:DarkBlue;}
th {background-color: WhiteSmoke;}
table {border-collapse:collapse;margin-top:1em;}
table,th,td { padding: 3px; border: 1px solid black; word-wrap:break-word; }
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script> 
<script type="text/javascript">//<![CDATA[
var waitingForCoordinatesMessage="<%=bundle.getString("waitingForCoordinatesMessage")%>";
var locationNotAvailableMessage="<%=bundle.getString("locationNotAvailableMessage")%>";
var locationNotFoundMessage="<%=bundle.getString("locationNotFoundMessage")%>";
var accuracyLabel="<%=bundle.getString("accuracyLabel")%>";
//]]></script>
</head>
<body onload="getCoordinates();">
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>

<%-- Location --%>
<div><span id="geoStatus"></span><a style="margin-left:1em" href="location.jsp"><%=bundle.getString("changeLocationLabel")%></a></div>
<%-- Add Note --%>

<div style="margin-top:1.5em">
<form id="geoNote" method="get" action="geoNoteAdjustLocation.jsp" autocomplete="off">
<%-- Add --%>
<input type="submit" style="display:inline" id="addButtonDisabled" disabled="disabled" value="<%=bundle.getString("addLabel")%>"/>
<input type="submit" style="display:none" id="addButtonEnabled" name="action" onclick="setCoorindatesFormFields();this.style.display='none';document.getElementById('addButtonDisabled').style.display='inline';" value="<%=bundle.getString("addLabel")%>"/>
</form>
</div>



<div style="margin-top:1.5em" id="geoNotesDiv">
<p> Waiting for data... </p>
</div>
<script type="text/javascript" src="/js/geoNotes.js" />
</script>
</body>
</html>