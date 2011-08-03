<?xml version="1.0" encoding="UTF-8"?>
<%-- This JSP has the HTML for Geo Notes table. --%>
<%@page pageEncoding="UTF-8" contentType="text/xml; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="geonotes.data.GeoNoteGetAll" %>
<%@ page import="geonotes.data.model.GeoNote" %>
<%@ page import="geonotes.utils.HtmlUtils" %>
<%@ page import="geonotes.utils.RequestUtils" %>
<%
    String action=RequestUtils.getAlphaInput(request,"action","Action",false);
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
    RequestUtils.getNumericInputAsDouble(request,"latitude",bundle.getString("latitudeLabel"),true);
    RequestUtils.getNumericInputAsDouble(request,"longitude",bundle.getString("longitudeLabel"),true);		
%>
<geoNotes>
<%@ include file="/WEB-INF/pages/components/noCache.jsp" %>
<%
    new GeoNoteGetAll().execute(request);
    List<GeoNote> geoNotes=(List<GeoNote>)request.getAttribute("geoNotes");
    if (geoNotes!=null && geoNotes.size()>0) {
        for (GeoNote geoNote:geoNotes) {

            long geoId=geoNote.getKey().getId();
        
            // Add attributes
            out.write("<geoNote");
            out.write(" id=\"" + geoId + "\"");            
            out.write(" lat=\"" + geoNote.latitude + "\"");
            out.write(" lon=\"" + geoNote.longitude + "\"");
            out.write(" yes=\"" + geoNote.yes + "\""); 
            out.write(" text=\"" + HtmlUtils.escapeChars(geoNote.note) + "\"");
            
            // Thumbnail
            if (geoNote.imageThumbnail!=null) {
                out.write(" img=\"true\"");
            } else {
                out.write(" img=\"false\"");
            }
            
            out.write(" time=\"" + geoNote.lastUpdateTime.getTime()/1000 + "\"/>");
        }
    }
%>
</geoNotes>