<%-- This JSP has the HTML for Geo Notes page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%> 
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="geonotes.data.GeoNoteDelete" %>
<%@ page import="geonotes.data.GeoNoteGetSingle" %>
<%@ page import="geonotes.data.GeoNoteImageRemove" %>
<%@ page import="geonotes.data.GeoNoteImageUpdate" %>
<%@ page import="geonotes.data.GeoNoteUpdate" %>
<%@ page import="geonotes.data.model.GeoNote" %>
<%@ page import="geonotes.utils.HtmlUtils" %>
<%@ page import="geonotes.utils.RequestUtils" %>
<%@ page import="geonotes.utils.StringUtils" %>
<%@ page import="org.apache.commons.fileupload.FileItemStream" %>
<%@ page import="org.apache.commons.fileupload.FileItemIterator" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="com.google.appengine.api.datastore.Blob" %>
<%@ page import="com.google.appengine.api.images.Image" %>
<%@ page import="com.google.appengine.api.images.ImagesService" %>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory" %>
<%@ page import="com.google.appengine.api.images.Transform" %>

<%
    String action=RequestUtils.getAlphaInput(request,"action","Action",false);
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
    Long geoNoteId=RequestUtils.getNumericInput(request,"id","id",true);
    
    GeoNote geoNote=null;
    if (geoNoteId!=null)
    {
        new GeoNoteGetSingle().execute(request);

        // If note is null, forward to main page
        geoNote=(GeoNote)request.getAttribute("geoNote");
        if (geoNote==null)
        {
            RequestUtils.resetAction(request);
            RequestUtils.removeEdits(request);
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

    // Process based on action
    if (!StringUtils.isEmpty(action)) {
        if (action.equals(bundle.getString("updateLabel"))) {		

            // Fields
            RequestUtils.getAlphaInput(request,"note",bundle.getString("noteLabel"),true);
            RequestUtils.getNumericInputAsDouble(request,"latitude",bundle.getString("latitudeLabel"),true);
            RequestUtils.getNumericInputAsDouble(request,"longitude",bundle.getString("longitudeLabel"),true);		
            RequestUtils.getNumericInputAsDouble(request,"accuracy",bundle.getString("accuracyLabel"),true);		

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
        } else if (action.equals("Upload") && ServletFileUpload.isMultipartContent(request)) {		

            ServletFileUpload upload = new ServletFileUpload(); 
            
            FileItemIterator iter = upload.getItemIterator(request);
            FileItemStream imageItem = iter.next();
            InputStream imgStream = imageItem.openStream();

            // Get stream
            int len;
            byte[] buffer = new byte[8192];
            ByteArrayOutputStream baos=new ByteArrayOutputStream();
            while ((len = imgStream.read(buffer, 0, buffer.length)) != -1) {
                baos.write(buffer, 0, len);
            }
            
            if (baos.size()>0){
            
                // Detail
                byte[] oldImageData=baos.toByteArray();
                ImagesService imagesService = ImagesServiceFactory.getImagesService();
                Image oldImage = ImagesServiceFactory.makeImage(oldImageData);
                int newPercent1=70000/oldImage.getHeight();
                Transform resize = ImagesServiceFactory.makeResize(700, (oldImage.getWidth() * newPercent1)/100);
                Image newImage = imagesService.applyTransform(resize, oldImage);
                byte[] newImageData = newImage.getImageData();
                Blob imageBlob=new Blob(newImageData);
                request.setAttribute("image",imageBlob);
                
                // Thumbnail
                byte[] oldImageDataThumbnail=baos.toByteArray();
                Image oldImageThumbnail = ImagesServiceFactory.makeImage(oldImageDataThumbnail);
                int newPercent=10000/oldImageThumbnail.getHeight();
                Transform resizeThumbnail = ImagesServiceFactory.makeResize(100, (oldImageThumbnail.getWidth() * newPercent)/100);
                Image newImageThumbnail = imagesService.applyTransform(resizeThumbnail, oldImageThumbnail);
                byte[] newImageDataThumbnail = newImageThumbnail.getImageData();
                Blob imageBlobThumbnail=new Blob(newImageDataThumbnail);
                request.setAttribute("imageThumbnail",imageBlobThumbnail);
                
                if (!RequestUtils.hasEdits(request)) {
                   new GeoNoteImageUpdate().execute(request);
                }
                
                new GeoNoteGetSingle().execute(request);
                geoNote=(GeoNote)request.getAttribute("geoNote");
            }
        } else if (action.equals(bundle.getString("removeLabel"))) {		
            // Remove an image
            if (!RequestUtils.hasEdits(request)) {
                new GeoNoteImageRemove().execute(request);
                new GeoNoteGetSingle().execute(request);
                geoNote=(GeoNote)request.getAttribute("geoNote");
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
<style>
form {margin: 0px 0px 0px 0px; display: inline;}
</style>
</head>
<body>
<form id="geoNote" method="post" action="geoNote.jsp" autocomplete="off">
<jsp:include page="/WEB-INF/pages/components/edits.jsp"/>
<table>
<tr><td><%=bundle.getString("latitudeLabel")%>:</td><td><input type="text" name="latitude" id="latitude" value="<%=geoNote.latitude%>" title="<%=bundle.getString("latitudeLabel")%>"/></td></tr>
<tr><td><%=bundle.getString("longitudeLabel")%>:</td><td><input type="text" name="longitude" id="longitude" value="<%=geoNote.longitude%>" title="<%=bundle.getString("longitudeLabel")%>"/></td></tr>
<tr><td><%=bundle.getString("accuracyLabel")%> (m):</td><td><input type="text" name="accuracy" id="accuracy" value="<%=geoNote.accuracy%>" title="<%=bundle.getString("accuracyLabel")%>"/></td></tr>
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