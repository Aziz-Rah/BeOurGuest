<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update us. | B.arguest.</title>
</head>

<!-- CONNECT TO DB -->
<%
	try {
		String connectionURL = "jdbc:mysql://cs336projecy.cmpiv3as1lzd.us-east-1.rds.amazonaws.com/barguest";

		Connection connection = null;
		Statement statement = null;
		ResultSet rs = null;

		
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		connection = DriverManager.getConnection(connectionURL, "master", "adminadmin");
		statement = connection.createStatement();
%>

<body onload="setDynamicBackground()">

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">B.arguest.</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="${pageContext.request.contextPath}/discover.jsp">Discover.</a></li>
      <li><a href="${pageContext.request.contextPath}/fightme.jsp">Music and fights.</a></li>
      <li><a class="active" href="#">Keep us updated.</a></li>
      <li><a href="${pageContext.request.contextPath}/query.jsp">Custom queries.</a></li>
      <li><a href="${pageContext.request.contextPath}/writeup.jsp">For the grader.</a></li>
    </ul>
  </div>
</nav>
<br>

<div class="container">
<div class="col" id="rcorners" style="padding:15px">
<h2>Suggest additions to our information.</h2><br>

<!-- UPDATE TO BARS -->
<button class="btn" data-toggle="collapse" data-target="#awholenewbar">I've found a new bar!</button>
<div id="awholenewbar" class="collapse">It's not done yet sorry LOL. Try the other button.<br></div><br><br>

<!-- UPDATE TO SELLS -->
<button class="btn" data-toggle="collapse" data-target="#anewfantastictypeofbooze">This (existing) bar sells something new.</button>
<div id="anewfantastictypeofbooze" class="collapse">
<form method="post" action="${pageContext.request.contextPath}/newBooze.jsp">
	Bar
	<p><select class="selectpicker" data-live-search="true" name="newBarName">  
		<!-- POPULATE GENRE DROPDOWN FROM DATABASE -->
        <% 
      		String QueryString = "SELECT barname from bars;";
			rs = statement.executeQuery(QueryString);
        	while (rs.next()) {
        %>	
        		<option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>
		<% } %>
	</select></p>

	<div class="form-group">
		<label for="newBoozeName">Brand</label>
		<input type="text" class="form-control" name="newBoozeName" id="newBoozeName">
	</div>
	<div class="form-group">
		<label for="newBoozeName">Type</label>
		<input type="text" class="form-control" name="newBoozeType" id="newBoozeType">
	</div>
	<div class="form-group">
		<label for="newBoozePrice">Price</label>
		<input type="number" class="form-control" min="0" name="newBoozePrice">
	</div>

	<br><input class="btn" type="submit" value="submit">
</form></div><br>


</div></div>
</body>

<!-- CLOSE CONNECTIONS -->
<%
	rs.close();
	statement.close();
	connection.close();
	} catch (Exception ex) {
		out.println("Unable to connect to database.");
	}
%>

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