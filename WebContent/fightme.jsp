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
      <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">B.arguest.</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="${pageContext.request.contextPath}/discover.jsp"">Discover.</a></li>
      <li><a class="active" href="#">Music and fights.</a></li>
      <li><a href="${pageContext.request.contextPath}/updateus.jsp">Keep us updated.</a></li>
      <li><a href="${pageContext.request.contextPath}/query.jsp">Custom queries.</a></li>
      <li><a href="${pageContext.request.contextPath}/writeup.jsp">For the grader.</a></li>
    </ul>
  </div>
</nav>

<div class="container">
<div class="col" id="rcorners" style="padding:15px">
<h2>Life is so unnerving.</h2>
For the observed and the observing.

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
								   
  <!-- BY GENRE -->
<form method="post" action="fightsgenres.jsp">
  <br>See fights when a certain genre is playing?
  <p><select class="selectpicker" multiple="multiple" data-live-search="true" name="genres">  

  <% 
    String QueryString = "SELECT distinct genre from music;";
    rs = statement.executeQuery(QueryString);
    while (rs.next()) {
  %>	
      <option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>
  <% } %>

  </select></p>
  <input class="btn" type="submit" value="Next"/>
</form><br><br>

<!-- BY ARTIST -->
<form method="post" action="fightsartists.jsp">
  See fights when a certain artist is playing?
  <p><select class="selectpicker" multiple data-live-search="true" name="artists">  

  
  <% 
    QueryString = "SELECT distinct artist from music;";
    rs = statement.executeQuery(QueryString);
    while (rs.next()) {
  %>	
      <option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>
  <% } %>

  </select></p>
  <input class="btn" type="submit" value="Next"/>
</form><br><br>

<!-- BY SONG -->
<form method="post" action="fightssongs.jsp">
  See fights when a certain song is playing?
  <p><select class="selectpicker" multiple data-live-search="true" name="songs">  
  
  <% 
    QueryString = "SELECT title, artist from music;";
    rs = statement.executeQuery(QueryString);
    while (rs.next()) {
  %>  
      <option value="<%=rs.getString(1)%>">"<%=rs.getString(1)%>," by <%=rs.getString(2)%></option>
  <% } %>

  </select></p>
  <input class="btn" type="submit" value="Next"/>
</form></div>

<!-- CLOSE CONNECTIONS -->
<%
	rs.close();
	statement.close();
	connection.close();
	} catch (Exception e) {
		out.println(e);
	}
%>

</body>
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