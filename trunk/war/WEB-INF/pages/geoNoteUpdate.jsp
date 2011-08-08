<%-- This JSP has the HTML for Geo Note page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="geonotes.data.GeoNoteDelete" %>
<%@ page import="geonotes.data.GeoNoteGetSingle" %>
<%@ page import="geonotes.data.GeoNoteUpdate" %>
<%@ page import="geonotes.data.model.GeoNote" %>
<%@ page import="geonotes.utils.HtmlUtils" %>
<%@ page import="geonotes.utils.RequestUtils" %>
<%@ page import="geonotes.utils.StringUtils" %>
<%
    String action=RequestUtils.getAlphaInput(request,"action","Action",false);
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
    Long geoNoteId=RequestUtils.getNumericInput(request,"id","id",true);

    GeoNote geoNote=null;
    if (geoNoteId!=null) {
        new GeoNoteGetSingle().execute(request);
        // If note is null, forward to main page
        geoNote=(GeoNote)request.getAttribute("geoNote");
        if (geoNote==null) {
            RequestUtils.resetAction(request);
            RequestUtils.removeEdits(request);
            %>
            <jsp:forward page="/geoNotes.jsp"/>
            <%
        } else {
            request.setAttribute("type", geoNote.type);
        }
    } else {
        RequestUtils.resetAction(request);
        RequestUtils.removeEdits(request);
        %>
        <jsp:forward page="/geoNotes.jsp"/>
        <%
    }

    // Process based on action
    if (!StringUtils.isEmpty(action)) {
        if (action.equals(bundle.getString("updateLabel"))) {		
            // Fields
            RequestUtils.getAlphaInput(request,"note",bundle.getString("noteLabel"),false);
            RequestUtils.getNumericInput(request,"type",bundle.getString("typeLabel"),true);		
            if (!RequestUtils.hasEdits(request)) {
                new GeoNoteUpdate().execute(request);
            }
            if (!RequestUtils.hasEdits(request)) {
                %>
                <jsp:forward page="/geoNotes.jsp"/>
                <%
            }
        } else if (action.equals(bundle.getString("deleteLabel"))) {		
            if (!RequestUtils.hasEdits(request)) {
                new GeoNoteDelete().execute(request);
            }
            if (!RequestUtils.hasEdits(request)) {
                %>
                <jsp:forward page="/geoNotes.jsp"/>
                <%
            }
        } else {
            RequestUtils.resetAction(request);
            RequestUtils.removeEdits(request);
            %>
            <jsp:forward page="/geoNotes.jsp"/>
            <%
        }
    }

    SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy MMM dd HH:mm zzz");
%>
<%@ include file="/WEB-INF/pages/components/noCache.jsp" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<title><%=bundle.getString("geoNoteLabel")%></title>
</head>
<body>
<form id="geoNote" method="post" action="geoNoteUpdate.jsp" autocomplete="off">
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>
<table>
<tr><td><%=bundle.getString("typeLabel")%>:</td><td><jsp:include page="/WEB-INF/pages/components/selectType.jsp"/></td></tr>
<tr><td><%=bundle.getString("noteLabel")%>:</td><td><input type="text" name="note" value="<%=HtmlUtils.escapeChars(geoNote.note)%>" id="note" title="<%=bundle.getString("noteLabel")%>" maxlength="500"/></td></tr>
<tr><td><%=bundle.getString("lastUpdatedLabel")%>:</td><td><%=dateFormat.format(geoNote.lastUpdateTime)%></td></tr>
</table>
<div style="margin-top:30px">
<input type="hidden" name="id" value="<%=new Long(geoNote.getKey().getId()).toString()%>"/>
<%-- Cancel, no need to disable when clicked --%>
<input type="submit" name="action" value="<%=bundle.getString("cancelLabel")%>"/>
<%-- Update --%>
<input style="margin-left:30px" type="submit" name="action" value="<%=bundle.getString("updateLabel")%>"/>
<%-- Delete --%>
<input style="margin-left:30px" type="submit" name="action" value="<%=bundle.getString("deleteLabel")%>"/>
</div>
</form>
</body>
</html>