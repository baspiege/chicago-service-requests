<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.ResourceBundle" %>
<% ResourceBundle bundle = ResourceBundle.getBundle("Text"); %>
<div style="clear:both;padding-top:1em">
<p style="font-size:small;"><%= bundle.getString("copyrightLabel")%> <%= Calendar.getInstance().get(Calendar.YEAR) %> Brian Spiegel</p>
</div>