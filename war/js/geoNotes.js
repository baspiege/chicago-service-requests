///////////////////
// Asynch
///////////////////

var xmlHttpRequest=new XMLHttpRequest();

function sendRequest(url,callback,postData) {
  var req = xmlHttpRequest;
  if (!req) return;
  var method = (postData) ? "POST" : "GET";
  req.open(method,url,true);
  req.setRequestHeader('User-Agent','XMLHTTP/1.0');
  if (postData)
    req.setRequestHeader('Content-type','application/x-www-form-urlencoded');
  req.onreadystatechange = function () {
    if (req.readyState != 4) return;
    if (req.status != 200 && req.status != 304) {
      // alert('HTTP error ' + req.status);
      return;
    }
    if (callback){      
      callback(req);
    }
  }
  if (req.readyState == 4) return;
  req.send(postData);
}

///////////////////
// Data
///////////////////

function getGeoNotesData() {
  // Get position and send request
  var lat=localStorage.getItem("latitude");
  var lon=localStorage.getItem("longitude");
  sendRequest('geoNotesTable.jsp?latitude='+lat+'&longitude='+lon, handleGeoNotesDataRequest);
}

function handleGeoNotesDataRequest(req) {
  var table=document.createElement("table");
  table.setAttribute("id","geoNotes");
  var tr=document.createElement("tr");
  // Distance
  var th1=document.createElement("th");
  tr.appendChild(th1);
  var distanceLink=document.createElement("a");
  distanceLink.setAttribute("href","#");
  distanceLink.setAttribute("onclick","reorderGeoNotesByDistanceAscending();return false;");
  distanceLink.appendChild(document.createTextNode("Distance"));  
  th1.appendChild(distanceLink);
  // Time
  var th2=document.createElement("th");
  tr.appendChild(th2);
  var timeLink=document.createElement("a");
  timeLink.setAttribute("href","#");
  timeLink.setAttribute("onclick","reorderGeoNotesByTimeDescending();return false;");
  timeLink.appendChild(document.createTextNode("Time"));  
  th2.appendChild(timeLink);
  // Agree
  var th3=document.createElement("th");
  tr.appendChild(th3);
  var distanceLink=document.createElement("a");
  distanceLink.setAttribute("href","#");
  distanceLink.setAttribute("onclick","reorderGeoNotesByVoteYesDescending();return false;");
  distanceLink.appendChild(document.createTextNode("Agree"));  
  th3.appendChild(distanceLink);
  // Image
  var th4=document.createElement("th");
  tr.appendChild(th4);
  th4.appendChild(document.createTextNode("Image"));
  // Type
  var th5=document.createElement("th");
  tr.appendChild(th5);
  th5.appendChild(document.createTextNode("Type"));  
  // Note
  var th6=document.createElement("th");
  tr.appendChild(th6);
  th6.appendChild(document.createTextNode("Note"));  
  table.appendChild(tr);  
  // Process request
  var xmlDoc=req.responseXML;
  var geoNotes=xmlDoc.getElementsByTagName("geoNote");
  if (geoNotes.length==0){
    var tr=document.createElement("tr");
    var td=document.createElement("td");
    td.setAttribute("colspan","6");
    td.appendChild(document.createTextNode("No nearby requests."));
    tr.appendChild(td);
    table.appendChild(tr);
    var tableDiv=document.getElementById("geoNotesDiv");
    removeChildrenFromElement(tableDiv);
    // Update tableDiv with new table at end of processing to prevent multiple
    // requests from interfering with each other
    tableDiv.appendChild(table);
  } else {
    // Make HTML for each geoNote
    for (var i=0;i<geoNotes.length;i++) {
      var geoNote=geoNotes[i];
      var tr=document.createElement("tr");
      // Attributes
      var id=geoNote.getAttribute("id")
      tr.setAttribute("id",id);
      tr.setAttribute("lat",geoNote.getAttribute("lat"));
      tr.setAttribute("lon",geoNote.getAttribute("lon"));
      tr.setAttribute("yes",geoNote.getAttribute("yes"));
      tr.setAttribute("time",geoNote.getAttribute("time"));
      // Distance and bearing
      tr.appendChild(document.createElement("td"));
      // Elapse time
      tr.appendChild(document.createElement("td"));
      // Vote
      var vote=document.createElement("td")
      var voteButton=document.createElement("button");
      voteButton.setAttribute("onclick","sendYesVote(this)");
      voteButton.appendChild(document.createTextNode(geoNote.getAttribute("yes")));
      vote.appendChild(voteButton);
      tr.appendChild(vote);
      // Image
      if (geoNote.getAttribute("img")=="true") {
        var imageCell=document.createElement("td")
        var imageLink=document.createElement("a");
        imageLink.setAttribute("href","geoNoteImage.jsp?id="+id);
        var image=document.createElement("img");
        image.setAttribute("src","geoNoteThumbNailImage?id="+id);
        imageLink.appendChild(image);
        imageCell.appendChild(imageLink);
        tr.appendChild(imageCell);
      } else {
        var imageCell=document.createElement("td")
        var imageLink=document.createElement("a");
        imageLink.setAttribute("href","geoNoteImage.jsp?id="+id);
        imageLink.setAttribute("class","add");
        imageLink.appendChild(document.createTextNode("Add"));
        imageCell.appendChild(imageLink);
        tr.appendChild(imageCell);
      }
      // Type
      var type=document.createElement("td");
      var typeLink=document.createElement("a");
      typeLink.setAttribute("href","geoNote.jsp?id="+id);
      typeLink.appendChild(document.createTextNode(geoNote.getAttribute("type")));
      type.appendChild(typeLink);
      tr.appendChild(type);
      // Desc
      var desc=document.createElement("td");
      var descLink=document.createElement("a");
      descLink.setAttribute("href","geoNote.jsp?id="+id);
      var text=geoNote.getAttribute("text");
      if (text=="") {
        text="Add";
        descLink.setAttribute("class","add");
      }
      descLink.appendChild(document.createTextNode(text));
      desc.appendChild(descLink);
      tr.appendChild(desc);
      table.appendChild(tr);
    }
    var tableDiv=document.getElementById("geoNotesDiv");
    removeChildrenFromElement(tableDiv);
    // Update tableDiv with new table at end of processing to prevent multiple
    // requests from interfering with each other
    tableDiv.appendChild(table);
    updateNotesDispay();
  }
}

///////////////////
// Votes
///////////////////

function sendYesVote(elem) {
  var tr=elem.parentNode.parentNode;
  var yes=parseInt(tr.getAttribute("yes"));
  var id=parseInt(tr.getAttribute("id"));
  tr.setAttribute("yes",yes+1);
  elem.innerHTML=yes+1;
  sendRequest('vote.jsp?vote=yes&id='+id);
}

///////////////////
// Coordinates
///////////////////

var geocoder = new google.maps.Geocoder();
 
function geocodePosition(pos) {
  geocoder.geocode({
    latLng: pos
  }, function(responses) {
    if (responses && responses.length > 0) {
      updateGeoStatus(responses[0].formatted_address);
    } else {
      updateGeoStatus('Cannot determine address at this location.');
    }
  });
}  

function getCoordinates() {
  var useGeoLocation=localStorage.getItem("useGeoLocation");
  if (useGeoLocation==null || useGeoLocation=="true") {
    updateGeoStatus(waitingForCoordinatesMessage);
    var geolocation = navigator.geolocation;
    if (geolocation) {
      var parameters={enableHighAccuracy:true, maximumAge:20000, timeout:20000};
      geolocation.watchPosition(setPosition,displayError,parameters);
    } else {
      updateGeoStatus(locationNotAvailableMessage);
    }
  } else {      
    var latLng = new google.maps.LatLng(localStorage.getItem("latitude"), localStorage.getItem("longitude"));
    geocodePosition(latLng);
    getGeoNotesData();
    // Update buttons
    document.getElementById("addButtonDisabled").style.display='none';
    document.getElementById('addButtonEnabled').style.display='inline';
  }
}

// Set global variables holding the position
function setPosition(position){
  var display="N/A";
  if (position){
    // Set global variables
    localStorage.setItem("latitude", position.coords.latitude);
    localStorage.setItem("longitude", position.coords.longitude);
    // Display accuracy
    display="";//accuracyLabel + ": " + position.coords.accuracy + "m";
    // Update buttons
    document.getElementById("addButtonDisabled").style.display='none';
    document.getElementById('addButtonEnabled').style.display='inline';
    getGeoNotesData();
    
    var latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    geocodePosition(latLng);
  }
  updateGeoStatus(display);
}

function setCoorindatesFormFields(){
    document.getElementById("latitude").value=localStorage.getItem("latitude");
    document.getElementById("longitude").value=localStorage.getItem("longitude");
}

if (typeof(Number.prototype.toRad) === "undefined") {
  Number.prototype.toRad = function() {
    return this * Math.PI / 180;
  }
}

// Converts radians to numeric (signed) degrees
if (typeof(Number.prototype.toDeg) === "undefined") {
  Number.prototype.toDeg = function() {
    return this * 180 / Math.PI;
  }
}

function calculateDistance(lat1, lon1, lat2, lon2) {
  var R = 6371; // km
  var dLat = (lat2-lat1).toRad();
  var dLon = (lon2-lon1).toRad();
  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) *
          Math.sin(dLon/2) * Math.sin(dLon/2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  var d = R * c;
  return d;
}

function calculateBearing(lat1, lon1, lat2, lon2) {
  var dLon=(lon2-lon1).toRad();
  var lat1r=lat1.toRad();
  var lat2r=lat2.toRad();
  var y = Math.sin(dLon) * Math.cos(lat2r);
  var x = Math.cos(lat1r)*Math.sin(lat2r) -
          Math.sin(lat1r)*Math.cos(lat2r)*Math.cos(dLon);
  var bearing = Math.atan2(y, x).toDeg();
  return (bearing+360)%360;
}

///////////////////
// Sorting
///////////////////

function reorderGeoNotes(sortFunction) {
  var geoNotes=document.getElementById("geoNotes");
  var notes=geoNotes.getElementsByTagName("tr");
  var notesTemp=new Array();
  for (var i=1; i<notes.length; i++) {
    notesTemp.push(notes[i]);
  }
  notesTemp.sort(sortFunction);
  for (var i=0; i<notesTemp.length; i++) {
    geoNotes.appendChild(notesTemp[i]);
  }
}

function sortByDistanceAscending(note1,note2) {
  var distance1=parseFloat(note1.getAttribute("distance"));
  var distance2=parseFloat(note2.getAttribute("distance"));
  if (distance2>distance1) {
      return -1;
  } else if (distance1>distance2) {
      return 1;
  } else {
      return 0;
  }
}

function sortByTimeDescending(note1,note2) {
  var time1=parseFloat(note1.getAttribute("time"));
  var time2=parseFloat(note2.getAttribute("time"));
  if (time1>time2) {
      return -1;
  } else if (time2>time1) {
      return 1;
  } else {
      return 0;
  }
}

function sortByVoteYesDescending(note1,note2) {
  var vote1=parseInt(note1.getAttribute("yes"));
  var vote2=parseInt(note2.getAttribute("yes"));
  if (vote1>vote2) {
      return -1;
  } else if (vote2>vote1) {
      return 1;
  } else {
      return 0;
  }
}

function reorderGeoNotesByTimeDescending() {
  localStorage.setItem("sortBy","time");
  reorderGeoNotes(sortByTimeDescending);
}

function reorderGeoNotesByDistanceAscending() {
  localStorage.setItem("sortBy","distance");
  reorderGeoNotes(sortByDistanceAscending);
}

function reorderGeoNotesByVoteYesDescending() {
  localStorage.setItem("sortBy","voteYes");
  reorderGeoNotes(sortByVoteYesDescending);
}

///////////////////
// Display
///////////////////

function removeChildrenFromElement(element) {
  if (element.hasChildNodes()) {
    while (element.childNodes.length>0) {
      element.removeChild(element.firstChild);
    }
  }
}

function updateNotesDispay() {
  // Current location
  var latitude=parseFloat(localStorage.getItem("latitude"));
  var longitude=parseFloat(localStorage.getItem("longitude"));
  var currentSeconds=new Date().getTime()/1000;
  // For each note
  var geoNotes=document.getElementById("geoNotes");
  var notes=geoNotes.getElementsByTagName("tr");
  for (var i=1; i<notes.length; i++) {
    var note=notes[i];
    var noteLat=parseFloat(note.getAttribute("lat"));
    var noteLon=parseFloat(note.getAttribute("lon"));
    var display="";
    // Distance
    var distance=calculateDistance(latitude, longitude, noteLat, noteLon);
    // Save for ordering
    note.setAttribute("distance",distance);
    // Add distance to display
    if (distance<1){
      display=Math.round(distance*1000)+"m";
    } else {
      display=Math.round(distance*10)/10 +"km";
    }
    // Bearing
    var bearingDegrees=calculateBearing(latitude, longitude, noteLat, noteLon);
    display+=" " + getCardinalDirection(bearingDegrees);
    display="<a href='geoNoteUpdateLocation.jsp?id=" + note.getAttribute("id") + "'>"+display+"</a>";
    // Update direction display
    note.getElementsByTagName("td")[0].innerHTML=display;
    // Update time display
    note.getElementsByTagName("td")[1].innerHTML=getElapsedTime(parseInt(note.getAttribute("time")),currentSeconds);
  }
  // Sort
  var sortBy=localStorage.getItem("sortBy");
  if (sortBy==null || sortBy=="distance") {
    reorderGeoNotesByDistanceAscending();
  } else if (sortBy=="time") {
    reorderGeoNotesByTimeDescending();
  } else if (sortBy=="voteYes") {
    reorderGeoNotesByVoteYesDescending();
  }
}

function getCardinalDirection(degrees) {
  var value;
  if (degrees>=22.5 && degrees<=67.5){
    value="NE";
  } else if (degrees>67.5 && degrees<112.5) {
    value="E";
  } else if (degrees>=112.5 && degrees<=157.5) {
    value="SE";
  } else if (degrees>157.5 && degrees<202.5) {
    value="S";
  } else if (degrees>=202.5 && degrees<=247.5) {
    value="SW";
  } else if (degrees>247.5 && degrees<292.5) {
    value="W";
  } else if (degrees>=292.5 && degrees<=337.5) {
    value="NW";
  } else {
    value="N";
  }
  return value;
}

function getElapsedTime(oldSeconds,newSeconds){
  var display="";
  var seconds=newSeconds-oldSeconds;
  if (seconds<60){
    display=Math.round(seconds)+" sec";
  } else {
    var minutes=seconds/60;
    if (minutes<60) {
      display=Math.round(minutes)+" min";
    } else {
      var hours=minutes/60;
      if (hours<24) {
        display=Math.round(hours)+" hr";
      } else {
        var days=hours/24;
        display=Math.round(days)+" day";
      }
    }
  }
  return display;
}

function displayError(error){
  updateGeoStatus(locationNotFoundMessage + ": (" + error.code + ") " + error.message);
}

function updateGeoStatus(text) {
  document.getElementById("geoStatus").innerHTML=text;
}