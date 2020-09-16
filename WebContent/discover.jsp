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
      <li><a class="active" href="#">Discover.</a></li>
      <li><a href="${pageContext.request.contextPath}/fightme.jsp">Music and fights.</a></li>
      <li><a href="${pageContext.request.contextPath}/updateus.jsp">Keep us updated.</a></li>
      <li><a href="${pageContext.request.contextPath}/query.jsp">Custom queries.</a></li>
      <li><a href="${pageContext.request.contextPath}/writeup.jsp">For the grader.</a></li>
    </ul>
  </div>
</nav>

<div class="container">
<div class="col" id="rcorners" style="padding:15px">
<h2>Put our service to the test.</h2>
Tie your napkin 'round your neck, cherie, and we'll provide the rest.

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

<br>									  

 <!-- Show html form to i) display something, ii) choose an action via a 
  | radio button -->
<!-- forms are used to collect user input 
	The default method when submitting form data is GET.
	However, when GET is used, the submitted form data will be visible in the page address field-->
<form method="post" action="show.jsp">
    <!-- note the show.jsp will be invoked when the choice is made -->
	<!-- The next lines give HTML for radio buttons being displayed
  <input type="radio" name="command" value="beers"/>Let's have a beer!
  <br>
  <input type="radio" name="command" value="bars"/>Let's go to a bar!
    when the radio for bars is chosen, then 'command' will have value 
     | 'bars', in the show.jsp file, when you access request.parameters -->

 	<!-- LOCATION CHECKBOX -->
    <div class="checkbox">
    <label><input type="checkbox" name="wantslocation" value="true" data-toggle="collapse" data-target="#location">Location</label>
      <div id="location" class="collapse">

      	<p></p>

        <div class="form-group">
          <!-- ZIPCODE -->
          <label for="zipcode">Zipcode:</label>
          <input type="text" class="form-control" name="zipcode">

         <p></p>

          <!-- MAX DISTANCE SLIDER -->
          <div id="slidecontainer">
          	<label for="zipcode">Maximum distance: <span id="distanceOutput"></span> miles</p></label>
              <input type="range" min="1" max="100" value="50" name="maxDistance" class="slider" id="distance">
  		    </div>
          <script>
            var sliderDistance = document.getElementById("distance");
            var outputDistance = document.getElementById("distanceOutput");
            outputDistance.innerHTML = sliderDistance.value;

            sliderDistance.oninput = function() {
              outputDistance.innerHTML = this.value;
            }
          </script>
          <br>
        </div>
   	  </div>
    </div>



    <!-- PRICE RANGE CHECKBOX -->
    <div class="checkbox">
      <label><input type="checkbox" name="wantsprice" value="true" data-toggle="collapse" data-target="#price-range">Price Range</label>
      <div id="price-range" class="collapse">

        <br>

        <!-- MAX PRICE SLIDER -->
        <div id="slidecontainer">
          <label for="price-range">Max drink prices in USD: $<span id="priceOutput"></span></p></label>
            <input type="range" min="1" max="100" value="50" class="slider" name="maxPrice" id="price">
        </div>
        
        <script>
          var sliderPrice = document.getElementById("price");
          var outputPrice = document.getElementById("priceOutput");
          outputPrice.innerHTML = sliderPrice.value;

          sliderPrice.oninput = function() {
            outputPrice.innerHTML = this.value;
          }
        </script>
        <br>
   	  </div>
    </div>




    <!-- MUSIC CHECKBOX -->
    <div class="checkbox">
      <label><input type="checkbox" name="wantsmusic" value="true" data-toggle="collapse" data-target="#music">Music</label>

      <div id="music" class="collapse">

        <br>Genres?
        <p><select class="selectpicker" multiple="multiple" data-live-search="true" name="genres">  

	        <!-- POPULATE GENRE DROPDOWN FROM DATABASE -->
	        <% 
	      		String QueryString = "SELECT distinct genre from music;";
				rs = statement.executeQuery(QueryString);
	        	while (rs.next()) {
	        %>	
	        		<option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>
			<% } %>
	
        </select></p>

        Artists?
       	<p><select class="selectpicker" multiple data-live-search="true" name="artists">  

	        <!-- POPULATE ARTIST DROPDOWN FROM DATABASE -->
	        <% 
	      		QueryString = "SELECT distinct artist from music;";
				rs = statement.executeQuery(QueryString);
	        	while (rs.next()) {
	        %>	
	        		<option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>
			<% } %>
	
        </select></p><br>
      </div>
    </div>

    <!-- DRINKS CHECKBOX -->
    <div class="checkbox">
      <label><input type="checkbox" name="wantsdrinks" value="true" data-toggle="collapse" data-target="#drinks">Drinks Available</label>

      <div id="drinks" class="collapse">

        <br>
        Brands:
        <p><select class="selectpicker" multiple data-live-search="true" name="drinkshere">  

	        <!-- POPULATE BOOZE BRANDS FROM DATABASE -->
	        <% 
	      		QueryString = "SELECT brand from booze;";
				rs = statement.executeQuery(QueryString);
	        	while(rs.next()) {
	        %>	
	        		<option value="<%=rs.getString(1)%>"><%=rs.getString(1)%></option>
			<% } %>
	
        </select></p><br>
      </div>
    </div>

  <br>

  <!-- SUBMIT -->
  <input class="btn" type="submit" value="Next"/>
</form>
<br>
</div>

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