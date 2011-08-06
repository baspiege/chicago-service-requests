<%-- This JSP has the HTML for location page. --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ include file="/WEB-INF/pages/components/docType.jsp" %>
<%
    ResourceBundle bundle = ResourceBundle.getBundle("Text");
%>
<title><%=bundle.getString("changeLocationLabel")%></title>
<style>
input:disabled {background:#dddddd;}
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script> 
<script type="text/javascript">//<![CDATA[

function setFieldsFromLocalStorage() {
//  document.getElementById("latitude").value=localStorage.getItem("latitude");
//  document.getElementById("longitude").value=localStorage.getItem("longitude");
//  document.getElementById("accuracy").value=localStorage.getItem("accuracy");

  var useGeoLocation=localStorage.getItem("useGeoLocation");
  if (useGeoLocation==null || useGeoLocation=="true") {
    disableInputs(true);
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

    // Latitude
    /*
    var latitude=document.getElementById("latitude").value;
    localStorage.setItem("latitude",checkFloat(latitude));

    // Longitude
    var longitude=document.getElementById("longitude").value;
    localStorage.setItem("longitude",checkFloat(longitude));

    // Accuracy
    var accuracy=document.getElementById("accuracy").value;
    localStorage.setItem("accuracy",checkFloat(accuracy));
    */
  }
}

// If can be parsed, return float.  Else, return 0.
function checkFloat(value) {
  var returnValue=parseFloat(value);
  if (isNaN(returnValue)){
    returnValue=0;
  }
  return returnValue;
}

function disableInputs(disabled) {
//  document.getElementById("latitude").disabled=disabled;
//  document.getElementById("longitude").disabled=disabled;
//  document.getElementById("accuracy").disabled=disabled;
}

//]]></script>
</head>
<body onload="setFieldsFromLocalStorage()">
<p>
  <input type="radio" name="location" id="useGeoLocation" value="useGeoLocation" onclick="disableInputs(true);"/><label for="useGeoLocation"><%=bundle.getString("currentLocationLabel")%></label>
  <input type="radio" name="location" id="useOverride" value="useOverride" onclick="disableInputs(false);"/><label for="useOverride"><%=bundle.getString("locationBelowLabel")%></label>
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
 
function updateMarkerStatus(str) {
  //document.getElementById('markerStatus').innerHTML = str;
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
  var latLng = new google.maps.LatLng(lat, lon);
  var map = new google.maps.Map(document.getElementById('mapCanvas'), {
    zoom: 18,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.HYBRID 
  }); 
  var marker = new google.maps.Marker({
    position: latLng,
    title: 'Point A',
    map: map,
    draggable: true
  });
  
  // Update current position info.
  updateMarkerPosition(latLng);
  geocodePosition(latLng);
  
  // Add dragging event listeners.
  google.maps.event.addListener(marker, 'dragstart', function() {
    updateMarkerAddress('Dragging...');
  });
  
  google.maps.event.addListener(marker, 'drag', function() {
    updateMarkerStatus('Dragging...');
    updateMarkerPosition(marker.getPosition());
  });
  
  google.maps.event.addListener(marker, 'dragend', function() {
  
    updateMarkerStatus('Drag ended');
    geocodePosition(marker.getPosition());
    //alert(marker.getPosition().lat());
    
    localStorage.setItem("latitude",checkFloat(marker.getPosition().lat()));
    localStorage.setItem("longitude",checkFloat(marker.getPosition().lng()));
    
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