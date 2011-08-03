<%-- This JSP has the HTML for bulk upload page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="geonotes.data.GeoNoteBulkAdd" %>
<%@ page import="geonotes.utils.RequestUtils" %>
<%@ page import="geonotes.utils.StringUtils" %>
<%
    String action=RequestUtils.getAlphaInput(request,"action","Action",false);
    ResourceBundle bundle = ResourceBundle.getBundle("Text");

    // Process based on action
    if (!StringUtils.isEmpty(action)) {
        if (action.equals(bundle.getString("updateLabel"))) {		

            // Fields
            RequestUtils.getBulkAlphaInput(request,"notes",bundle.getString("noteLabel"),true);
            
            if (!RequestUtils.hasEdits(request)) {
            
                new GeoNoteBulkAdd().execute(request);
            }
        } else {
            RequestUtils.resetAction(request);
            RequestUtils.removeEdits(request);
            %>
            <jsp:forward page="/geoNotes.jsp"/>
            <%
        }
    }
%>
<%@ include file="/WEB-INF/pages/components/noCache.jsp" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<title>Bulk Upload</title>
</head>
<body>
<form method="post" action="bulkUpload.jsp" autocomplete="off">
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>
<p>
<textarea name="notes" rows="30" cols="100">
</textarea>
</p>
<div style="margin-top:30px">
<input type="submit" name="action" value="<%=bundle.getString("cancelLabel")%>"/>
<input style="margin-left:30px" type="submit" name="action" value="<%=bundle.getString("updateLabel")%>"/>
</div>
</form>
</body>
</html>