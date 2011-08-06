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
            
            // Set from local storage
            
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
</head>
<body>
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>

<%-- Add Note --%>

<form id="geoNote" method="get" action="geoNoteAdd.jsp" autocomplete="off">
<table>
<tr><td>Type:</td><td>
<select>
<option>Graffiti</option>
<option>Street Light Out</option>
</select>
</td></tr>
<tr><td>Description:</td><td><input type="text" name="note" value="" id="note" title="<%=bundle.getString("noteLabel")%>" maxlength="500"/></td></tr>
</table>
<%-- Add --%>
</p>
<p>
<%-- Cancel --%>
<input type="submit" name="action" value="<%=bundle.getString("cancelLabel")%>" onclick="window.location='geoNoteAdjustLocation.jsp';return false;"/>
<input type="submit" style="margin-left:30px;display:none" id="addButtonDisabled" disabled="disabled" value="<%=bundle.getString("addLabel")%>"/>
<input type="submit" style="margin-left:30px;display:inline" id="addButtonEnabled" name="action" onclick="setCoorindatesFormFields();this.style.display='none';document.getElementById('addButtonDisabled').style.display='inline';" value="<%=bundle.getString("addLabel")%>"/>
</p>
</form>


</body>
</html>