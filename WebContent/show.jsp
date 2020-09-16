<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Soup du jour | B.arguest.</title>
</head>

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

<body onload="setDynamicBackground()">
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp"">B.arguest.</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a class="active" href="#">Discover.</a></li>
      <li><a href="${pageContext.request.contextPath}/fightme.jsp">Stay safe.</a></li>
      <li><a href="${pageContext.request.contextPath}/updateus.jsp">Keep us updated.</a></li>
      <li><a href="${pageContext.request.contextPath}/query.jsp">Custom queries.</a></li>
      <li><a href="${pageContext.request.contextPath}/writeup.jsp">For the grader.</a></li>
    </ul>
  </div>
</nav>

<div class="container">
<div class="col" id="rcorners" style="padding:15px">
<h2>Our suggestions.</h2>
Based on your preferences, we think you'd like to be their guest.
<br><br>

	<% 
		try {
			String connectionURL = "jdbc:mysql://cs336projecy.cmpiv3as1lzd.us-east-1.rds.amazonaws.com/barguest";

			Connection connection = null;
			Statement statement = null;
			ResultSet rs = null;
			String queryStr = null;
			String mainQuery = "select * from bars where ";

			
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			connection = DriverManager.getConnection(connectionURL, "master", "adminadmin");
			statement = connection.createStatement();

			//GRABS VALUES FROM CHECKBOX
			boolean cares_about_location = "true".equals(request.getParameter("wantslocation"));
			boolean cares_about_music = "true".equals(request.getParameter("wantsmusic"));
			boolean cares_about_price = "true".equals(request.getParameter("wantsprice"));
			boolean cares_about_brand = "true".equals(request.getParameter("wantsdrinks"));
			int factorCount = 0;

			if(cares_about_location)
				factorCount += 1;
			if(cares_about_music)
				factorCount += 1;
			if(cares_about_price)
				factorCount += 1;
			if(cares_about_brand)
				factorCount += 1;
			if(factorCount == 0) {
				out.print("No preferenes selected."); %>

				<form action="discover.jsp" method="get">
				<button type="submit">Try again?</button>
				<% return;
			}
		

			String barsInDistance = "(";
			boolean checkDistance = false;
		
			
			
			if(cares_about_location) {
				checkDistance = true;
				int maxMiles = Integer.parseInt(request.getParameter("maxDistance"));
				
				String zipcode = request.getParameter("zipcode");
				queryStr = "select latitude, longitude from coordinates where zipcode = "+"'"+zipcode+"'";
				ResultSet resultZ = statement.executeQuery(queryStr);
				resultZ.next();

				double lat1 = resultZ.getDouble("latitude");
				double lon1 = resultZ.getDouble("longitude");
				
				queryStr = "select barname, latitude, longitude from bars";
				ResultSet resultL = statement.executeQuery(queryStr);
				int i = 0;
				while(resultL.next()){
					
					double lat2 = resultL.getDouble("latitude");
					double lon2 = resultL.getDouble("longitude");
					double R = 6371e3; // metres
					double x1 = Math.toRadians(lat1);
					double x2 = Math.toRadians(lat2);
					double deltaX = Math.toRadians(lat2-lat1);
					double deltaY = Math.toRadians(lon2-lon1);

					double a = Math.sin(deltaX/2) * Math.sin(deltaX/2) +
					        Math.cos(x1) * Math.cos(x2) *
					        Math.sin(deltaY/2) * Math.sin(deltaY/2);
					double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

					double d = R * c;
					double miles = 0.0000621371 * d;

					if (miles <= maxMiles) {
						barsInDistance += "'" + resultL.getString("barname") + "',";
						i++;
					}	
				}		
				barsInDistance += "null)";

				//ADD LOCATION FACTOR TO MAIN QUERY
				mainQuery += "barname in " + barsInDistance;
				factorCount -= 1;
				if(factorCount > 0)
					mainQuery += " and ";

				resultZ.close();

				/*String location = request.getParameter("location");
				queryStr = "select barname from bars where city = " +"'"+location+"'";
				resultL = statement.executeQuery(queryStr);*/
			}


			if(cares_about_music) {
				String[] genre = request.getParameterValues("genres");
				String[] artist = request.getParameterValues("artists");
				if(genre == null && artist == null) {
					out.print("Music selected, but no genres or artists were selected.\n" +
								"Get out of my castle.");
					return;
				}

				String genreList = "(";
				String artistList = "(";
				String barsValidMusic = "(";

				//GENERATE LISTS OF GENRES AND ARTISTS FOR SQL QUERY USE
				if(genre != null) {
					for(int i = 0; i < genre.length; i++){
						genreList += "'" + genre[i] + "'";
						if(i+1 < genre.length)
							genreList += ",";
						else
						genreList += ")";
					}
				}

				if(artist != null) {
					for(int i = 0; i < artist.length; i++){
						artistList += "'" + artist[i] + "'";
						if(i+1 < artist.length)
							artistList += ",";
						else
						artistList += ")";
					}
				}
				
				//CONSTRUCT QUERY TO RETRIEVE VIABLE BARS	
				queryStr = "select distinct p.barname " +
							"from plays p join music m on p.song = m.title " +
							"where p.song IN ( " +
								"select title " +
						    	"from music where ";

				if(genre != null){
					queryStr += "m.genre in " + genreList + " ";
					if(artist != null)
						queryStr += "or ";
				}
				if(artist != null)
					queryStr += "m.artist in " + artistList + " ";
				
				queryStr += ")";


				ResultSet resultM = statement.executeQuery(queryStr);
				while(resultM.next()) {
					barsValidMusic += "'" + resultM.getString(1) + "',";
				}
				barsValidMusic += "null)";

				//ADD MUSIC FACTOR TO MAIN QUERY
				mainQuery += "barname in " + barsValidMusic;
				factorCount -= 1;
				if(factorCount > 0)
					mainQuery += " and ";

				resultM.close();			
			}
			/*if("true".equals(cares_about_fights)) {
				
				String fight = request.getParameter("fights");
				queryStr = "select barname, count(severity) from fights where severity = '"+fight+"'"+
						" group by barname order by count(severity) desc limit 5";
				ResultSet resultF = statement.executeQuery(squerySr);
			}*/
			if(cares_about_price) {

				int price = Integer.parseInt(request.getParameter("maxPrice"));
				queryStr = "select distinct barname from sells where price < " + "'"+price+"'";
				ResultSet resultP = statement.executeQuery(queryStr);

				String barsValidPrice = "(";

				//CREATE LIST OF BARS THAT SELL ANY DRINKS AT LESS THAN THE MAX PRICE
				while(resultP.next()){
					barsValidPrice += "'" + resultP.getString(1) + "',";
				}
				barsValidPrice += "null)";
				
				//ADD PRICE FACTOR TO MAIN QUERY
				mainQuery += "barname in " + barsValidPrice;
				factorCount -= 1;
				if(factorCount > 0)
					mainQuery += " and ";

				resultP.close();
			}
			if(cares_about_brand) {
				
				String[] brands = request.getParameterValues("drinkshere");
				ResultSet resultB = null;

				String brandsList = "(";
				String barsValidBrands = "(";

				//CREATE LIST OF BRANDS FOR SQL TO USE
				if(brands != null) {
					for(int i = 0; i < brands.length; i++){
						brandsList += "'" + brands[i] + "'";
						if(i+1 < brands.length)
							brandsList += ",";
						else
						brandsList += ")";
					}
				}
				else{
					out.print("Drinks Available selected, but no Brands specified.");
					return;
				}

				queryStr = "select distinct barname from sells where brand in " + brandsList;
				resultB = statement.executeQuery(queryStr);

				while(resultB.next()) {
					barsValidBrands += "'" + resultB.getString(1) + "',";
				}
				barsValidBrands += "null)";

				mainQuery += "barname in " + barsValidBrands;
				factorCount -= 1;
				if(factorCount > 0)
					out.print("Something went wrong...");

				resultB.close();
			}

			ResultSet resultMain = statement.executeQuery(mainQuery);
		%>

		<table class="table table-striped">
		    <thead>
		      <tr>
		        <th>Bar</th>
		        <th>City</th>
		        <th>State</th>
		      </tr>
		    </thead>
		    <tbody>

			<%while(resultMain.next()){ %>
		      <tr>
		        <td><%=resultMain.getString("barname")%></td>
		        <td><%=resultMain.getString("city")%></td>
		        <td><%=resultMain.getString("state")%></td>
		      </tr>
		    <% } %>

			</tbody>
			</table>
				
		<%		
			//CLOSE CONNECTIONS
			statement.close();
			connection.close();
		} catch (SQLException e) {
			out.print("Nothing fit your preferences :'(");
			out.println(e);
		}
	%>

<form action="discover.jsp" method="get">
<button type="submit">Try again?</button>
</form>
</div></div>
<br>
</body>
</html>