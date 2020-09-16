<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Adding new booze...</title>
</head>
<body onload="setDynamicBackground()">
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">B.arguest.</a>
    </div>
    <ul class="nav navbar-nav">
      <li><a href="${pageContext.request.contextPath}/discover.jsp">Discover.</a></li>
      <li><a href="${pageContext.request.contextPath}/fightme.jsp">Music and fights.</a></li>
      <li><a href="${pageContext.request.contextPath}/updateus.jsp"">Keep us updated.</a></li>
      <li><a class="active" href="#">Custom queries.</a></li>
      <li><a href="${pageContext.request.contextPath}/writeup.jsp">For the grader.</a></li>
    </ul>
  </div>
</nav>

<div class="container">
<div class="col" id="rcorners" style="padding:15px">
	<%
	try {

		String connectionURL = "jdbc:mysql://cs336projecy.cmpiv3as1lzd.us-east-1.rds.amazonaws.com/barguest";

		Connection connection = null;
		Statement statement = null;
		ResultSet rs = null;
        ResultSetMetaData metadata = null;
		
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		connection = DriverManager.getConnection(connectionURL, "master", "adminadmin");
		statement = connection.createStatement();

		//GET ORIGINAL COUNT OF BOOZE & BARS
		String str = "SELECT COUNT(*) as cnt FROM booze";
		ResultSet result = statement.executeQuery(str);
		result.next();
		int countBooze = result.getInt("cnt");

		//GET PARAMETERS FROM UPDATEUS.JSP
		String newBar = request.getParameter("newBarName");
		String newBooze = request.getParameter("newBoozeName");
		float newBoozePrice = Float.valueOf(request.getParameter("newBoozePrice"));

		//MAKE INSERT STATEMENT
		String insert = "INSERT INTO sells(barname, brand, price)"
				+ "VALUES (?, ?, ?)";
		PreparedStatement ps = connection.prepareStatement(insert);

		//ADD PARAMETERS
		ps.setString(1, newBar);
		ps.setString(2, newBooze);
		ps.setFloat(3, newBoozePrice);

		//RUN QUERY
		ps.executeUpdate();

		//GET NEW COUNTS OF BOOZE & BARS
		str = "SELECT COUNT(*) as cnt FROM booze";
		result = statement.executeQuery(str);
		result.next();
		System.out.println("Here I am!");
		int countBoozeNew = result.getInt("cnt");
		System.out.println(countBoozeNew);


		//COMPARE COUNTS
		int updateBooze = (countBooze != countBoozeNew) ? 1 : 0;
		out.println(updateBooze);

		out.print("insert succeeded");
		statement.close();
		connection.close();
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
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