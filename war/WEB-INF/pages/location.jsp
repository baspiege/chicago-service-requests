<%-- This JSP has the HTML for location page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<%
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
%>
<title><%=bundle.getString("changeLocationLabel")%></title>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
function setFieldsFromLocalStorage() {
  var useGeoLocation=localStorage.getItem("useGeoLocation");
  if (useGeoLocation==null || useGeoLocation=="true") {
    document.getElementById("useGeoLocation").checked="checked";
  } else {
    document.getElementById("useOverride").checked="checked";
  }
}
function setFieldsIntoLocalStorage() {
  if (document.getElementById("useGeoLocation").checked) {
    localStorage.setItem("useGeoLocation","true");
  } else {
    localStorage.setItem("useGeoLocation","false");
    localStorage.setItem("latitude",localStorage.getItem("change-latitude"));
    localStorage.setItem("longitude",localStorage.getItem("change-longitude"));
  }
}
</script>
</head>
<body onload="setFieldsFromLocalStorage()">
<p>
  <input type="radio" name="location" id="useGeoLocation" value="useGeoLocation"/><label for="useGeoLocation"><%=bundle.getString("currentLocationLabel")%></label>
  <input type="radio" name="location" id="useOverride" value="useOverride"/><label for="useOverride"><%=bundle.getString("locationBelowLabel")%></label>
</p>
<table>
  <tr><td><%=bundle.getString("positionLabel")%>:</td><td><span id="info"></span></td></tr>
  <tr><td><%=bundle.getString("addressLabel")%>:</td><td><span id="address"></span></td></tr>
</table>
<div style="margin-top:1em;margin-bottom:1em;">
<%-- Cancel --%>
<input type="submit" name="action" value="<%=bundle.getString("cancelLabel")%>" onclick="window.location='geoNotes.jsp';return false;"/>
<%-- Update --%>
<input type="submit" name="action" style="margin-left:30px" onclick="setFieldsIntoLocalStorage();window.location='geoNotes.jsp';return false;" value="<%=bundle.getString("updateLabel")%>"/>
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
  // Temp variables
  localStorage.setItem("change-latitude",lat);
  localStorage.setItem("change-longitude",lon);
  var latLng = new google.maps.LatLng(lat, lon);
  var map = new google.maps.Map(document.getElementById('mapCanvas'), {
    zoom: 18,
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
    localStorage.setItem("change-latitude",marker.getPosition().lat());
    localStorage.setItem("change-longitude",marker.getPosition().lng());
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