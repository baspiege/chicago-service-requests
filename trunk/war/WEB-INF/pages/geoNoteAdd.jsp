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

    String note="";
    String type="";
    
    // Process based on action
    if (!RequestUtils.isForwarded(request) && !StringUtils.isEmpty(action)) {
        if (action.equals(bundle.getString("addLabel"))) {		
            // Get fields
            note=RequestUtils.getAlphaInput(request,"note",bundle.getString("noteLabel"),false);
            RequestUtils.getNumericInputAsDouble(request,"latitude",bundle.getString("latitudeLabel"),true);
            RequestUtils.getNumericInputAsDouble(request,"longitude",bundle.getString("longitudeLabel"),true);		
            RequestUtils.getNumericInput(request,"type",bundle.getString("typeLabel"),true);		
            if (!RequestUtils.hasEdits(request)) {
                new GeoNoteAdd().execute(request);
                RequestUtils.resetAction(request);
                %>
                <jsp:forward page="/geoNotes.jsp"/>
                <%
            }
        }
    }
%>
<%@ include file="/WEB-INF/pages/components/noCache.jsp" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<title><%=bundle.getString("geoNotesLabel")%></title>
<script type="text/javascript">
function setFieldsFromLocalStorage() {
  document.getElementById("latitude").value=localStorage.getItem("add-latitude");
  document.getElementById("longitude").value=localStorage.getItem("add-longitude");
}
function clearAddPositionFromLocalStorage() {
  localStorage.removeItem("add-latitude");
  localStorage.removeItem("add-longitude");
}
</script>
</head>
<body onload="setFieldsFromLocalStorage();">
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>
<%-- Fields --%>
<form id="geoNote" method="post" action="geoNoteAdd.jsp" autocomplete="off">
<table>
<tr><td>Type:</td><td>
<jsp:include page="/WEB-INF/pages/components/selectType.jsp"/>
</td></tr>
<tr><td><%=bundle.getString("noteLabel")%>:</td><td><input type="text" name="note" value="<%=note%>" id="note" title="<%=bundle.getString("noteLabel")%>" maxlength="500"/></td></tr>
</table>
<p>
<%-- Back --%>
<input type="submit" name="action" value="<%=bundle.getString("backLabel")%>" onclick="window.location='geoNoteAdjustLocation.jsp';return false;"/>
<%-- Cancel --%>
<input style="margin-left:30px;" type="submit" name="action" value="<%=bundle.getString("cancelLabel")%>" onclick="clearAddPositionFromLocalStorage();window.location='geoNotes.jsp';return false;"/>
<%-- Add --%>
<input id="latitude" type="hidden" name="latitude" value="" />
<input id="longitude" type="hidden" name="longitude" value="" />
<input type="submit" style="margin-left:30px;display:none" id="addButtonDisabled" disabled="disabled" value="<%=bundle.getString("addLabel")%>"/>
<input type="submit" style="margin-left:30px;display:inline" id="addButtonEnabled" name="action" onclick="setCoorindatesFormFields();this.style.display='none';document.getElementById('addButtonDisabled').style.display='inline';" value="<%=bundle.getString("addLabel")%>"/>
</p>
</form>
</body>
</html>