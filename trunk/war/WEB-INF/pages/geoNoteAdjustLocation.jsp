<%-- This JSP has the HTML for location page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<%
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
%>
<title><%=bundle.getString("adjustLocationLabel")%></title>
<style>
input:disabled {background:#dddddd;}
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script> 
<script type="text/javascript">

function setFieldsFromLocalStorage() {
//  document.getElementById("latitude").value=localStorage.getItem("latitude");
//  document.getElementById("longitude").value=localStorage.getItem("longitude");
}

// If can be parsed, return float.  Else, return 0.
function checkFloat(value) {
  var returnValue=parseFloat(value);
  if (isNaN(returnValue)){
    returnValue=0;
  }
  return returnValue;
}

</script>
</head>
<body onload="setFieldsFromLocalStorage()">
<table>
  <tr><td><%=bundle.getString("positionLabel")%>:</td><td><span id="info"></span></td></tr>
  <tr><td><%=bundle.getString("addressLabel")%>:</td><td><span id="address"></span></td></tr>
</table>
<div style="margin-top:1em;margin-bottom:1em;">
<%-- Cancel --%>
<input type="submit" name="action" value="<%=bundle.getString("cancelLabel")%>" onclick="window.location='geoNotes.jsp';return false;"/>
<%-- Update --%>
<input type="submit" name="action" style="margin-left:30px" onclick="window.location='geoNoteAdd.jsp'" value="<%=bundle.getString("nextLabel")%>"/>
</div>

<script type="text/javascript"> 
var geocoder = new google.maps.Geocoder();
 
function geocodePosition(pos) {
  geocoder.geocode({
    latLng: pos
  }, function(responses) {
    if (responses && responses.length > 0) {
      updateMarkerAddress(responses[0].formatted_address);
    } else {
      updateMarkerAddress('Cannot determine address at this location.');
    }
  });
}
 
function updateMarkerPosition(latLng) {
  document.getElementById('info').innerHTML = [
    latLng.lat(),
    latLng.lng()
  ].join(', ');
}
 
function updateMarkerAddress(str) {
  document.getElementById('address').innerHTML = str;
}
 
function initialize() {
  var lat=localStorage.getItem("latitude");
  var lon=localStorage.getItem("longitude");
  
  localStorage.setItem("add-latitude",lat);
  localStorage.setItem("add-longitude",lon);
  
  var latLng = new google.maps.LatLng(lat, lon);
  var map = new google.maps.Map(document.getElementById('mapCanvas'), {
    zoom: 16,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.HYBRID 
  }); 
  var marker = new google.maps.Marker({
    position: latLng,
    title: 'Location',
    map: map,
    draggable: true
  });
  
  // Update current position info.
  updateMarkerPosition(latLng);
  geocodePosition(latLng);
  
  // Add dragging event listeners.
  google.maps.event.addListener(marker, 'dragstart', function() {
    updateMarkerAddress('');
  });
  
  google.maps.event.addListener(marker, 'drag', function() {
    updateMarkerPosition(marker.getPosition());
  });
  
  google.maps.event.addListener(marker, 'dragend', function() {
    geocodePosition(marker.getPosition());
    // map.setCenter(marker.getPosition())
    localStorage.setItem("latitude",marker.getPosition().lat());
    localStorage.setItem("longitude",marker.getPosition().lng());
    localStorage.setItem("add-latitude",marker.getPosition().lat());
    localStorage.setItem("add-longitude",marker.getPosition().lng());
  });
}
 
// Onload handler to fire off the app.
google.maps.event.addDomListener(window, 'load', initialize);
</script> 
<body> 
<style> 
#mapCanvas {
  width: 300px;
  height: 300px;
  float: left;
}
#infoPanel {
  float: left;
  margin-left: 10px;
}
#infoPanel div {
  margin-bottom: 5px;
}
</style>   
<div id="mapCanvas"></div>  
</body> 
</html> 