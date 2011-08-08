<%-- This JSP creates the select options for type. --%>
<%@ page language="java"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="geonotes.utils.HtmlUtils" %>
<%
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
%>
<select id='type' name='type' title='<%=bundle.getString("typeLabel")%>'>
<%
    Long typeSelected=(Long)request.getAttribute("type");
    int count=0;
    while(true) {
        String value="";
        String key="type_" + count;
        if (bundle.containsKey(key)) {
            value=bundle.getString(key);
        } else {
            break;
        }
        out.write("<option");
        // Selected
        if (typeSelected!=null && typeSelected.intValue()==count)
        {
            out.write(" selected=\"true\"");
        }
        out.write(" value=\"" + count + "\">");
        out.write( HtmlUtils.escapeChars(value) );
        out.write("</option>");
        count++;
    }
%>
</select>