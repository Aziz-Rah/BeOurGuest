<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>B.arguest.</title>
</head>

<body onload="setDynamicBackground()">
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">B.arguest.</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="${pageContext.request.contextPath}/discover.jsp">Discover.</a></li>
      <li><a href="${pageContext.request.contextPath}/fightme.jsp">Music and fights.</a></li>
      <li><a href="${pageContext.request.contextPath}/updateus.jsp">Keep us updated.</a></li>
      <li><a href="${pageContext.request.contextPath}/query.jsp">Custom queries.</a></li>
      <li><a href="${pageContext.request.contextPath}/writeup.jsp">For the grader.</a></li>
    </ul>
  </div>
</nav>

<div class="container">
<div class="col" id="rcorners" style="padding:15px">
<h1>Put our service to the test.</h1>
Tie your napkin 'round your neck, cherie, and we'll provide the rest.<br><br>

<table class="table table-striped">
  <thead>
    <tr>
      <th>Page</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Discover.</td>
      <td>Suggests bars for you based on preferences.<br> Uses basic queries.</td>
    </tr>
    <tr>
      <td>Music and fights.</td>
      <td>Learn something interesting about bar fights.<br>
          Uses more "interestng" queries to view probabalistic patterns.<br></td>
    </tr>
    <tr>
      <td>Keep us updated.</td>
      <td>Let us know if a bar sells something new.<br>
        Tests constraints and triggers by attempting update.<br></td>
    </tr>
    <tr>
      <td>Custom queries.</td>
      <td>Perform custom queries.</td>
    </tr>
    <tr>
      <td>For the graders.</td>
      <td>A write up for the project.</td>
    </tr>
  </tbody>
</table>

</div></body>

<link rel="stylesheet" href="styles.css">

<!-- BOOTSTRAP -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- BOOTSTRAP SELECT -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/css/bootstrap-select.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/js/bootstrap-select.min.js"></script>

<!-- MAKE IT PRETTY I GUESS -->
<script type="text/javascript">
	var myCanvas = document.createElement("canvas");

	myCanvas.width=100;
	myCanvas.height=100;

	var ctx = myCanvas.getContext("2d");
	ctx.clearRect(0,0,100,100);
	var grayPalette = ["#f2f2f2","#f7f7f7","#e8e8e8","#e2e2e2","#eeeeee"];

	for (i=0;i<10;i++){
	 for(j=0;j<10;j++){
	  ctx.beginPath();
	  ctx.rect(0+10*j,0+10*i,10,10);

	  var randomColorIndex = 
	    Math.round(Math.random() * (grayPalette.length-1));
	  ctx.fillStyle = grayPalette[randomColorIndex];

	  ctx.fill();

	  ctx.strokeStyle = "#ffffff";
	  ctx.stroke();

	  ctx.closePath();
	 }
	}

	function setDynamicBackground(){
	  var imageDataURL = myCanvas.toDataURL();

	  document.body.style.background = 
	   "transparent url('"+imageDataURL+"') repeat";
	}
</script>
</html>