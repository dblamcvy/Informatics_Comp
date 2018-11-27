<!--Ensures Username isn't blank and password matches submits to jsp version  -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--  prefix is basically "library" -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!--  ?Driver too -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="style.css">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<script src="http://d3js.org/d3.v4.min.js"></script>
	<script src="https://unpkg.com/mathjs/dist/math.min.js"></script>
	<script type="text/javascript" src="//code.jquery.com/jquery-1.6.4.js"></script>
	<title>TCC</title>
	<script>var ptotal = new Array();
			var itotal = new Array();
	</script>
</head>

<body>
<div id="graph" >

<sql:setDataSource var="jbdc" driver="org.postgresql.Driver"
		url="jdbc:postgresql://127.0.0.1:5433/ItemBank"
		user="User" password="test" />
		
			<sql:query var="selected" dataSource="${jbdc}">
					SELECT *, concat(subject,'.',grade,'.',domain,'.',standard) as content, 
		ROUND(a,3) as a,
		ROUND(b,3) as b,
		ROUND(c,2) as c,
		ROUND(pval,3) as pval,
		ROUND(ptbs,3) as ptbs from items where itemid in (<c:out value="${param.itemarray}" escapeXml="false" />);
			</sql:query>


			<c:forEach items="${selected.rows}" var="items">
				<!--  
				<c:out value="${items.itemid}" />
				<c:out value="${items.a}" />
				<c:out value="${items.b}" />
				<c:out value="${items.c}" />
				-->
				<script >
					var prob = new Array();
					var info = new Array();
					var i=-3.0;
					var e=0;
					do{
						//array[e]=${items.c}+((1-${items.c})/(1+math.exp(-${items.a}*(i-(${items.b})))));
						prob[e]=${items.c}+((1-${items.c})*(math.exp(${items.a}*(i-(${items.b}))))/(1+math.exp(${items.a}*(i-(${items.b})))));
						info[e]=math.pow(${items.a},2)*((1-prob[e])/prob[e])*math.pow(((prob[e]-${items.c})/(1-${items.c})),2);
						<%--document.write(${items.c}+((1-${items.c})/(1+math.exp(-${items.a}*(i-(${items.b}))))));--%>
						<%--document.write(array[e]);--%>
						if(!isNaN(ptotal[e]))
							{ ptotal[e] +=prob[e]; itotal[e] +=info[e];}
						else
							{ ptotal[e]=prob[e];}
						i=i+.1;
						e=e+1;
						
					}
					while(i<3.1)
					//document.write(total[0]);
				</script>
			
			</c:forEach>
			

	
			<script>
			var TCC = {
				    test: []
				};
			
			var count="${fn:length(selected.rows)}";
			<%--var average= new Array();--%>
			<%--document.write(count);--%>
			var theta = -3;
			for(var i = 0, length = ptotal.length; i < length; i++){
			    <%--average[i] = total[i]/count;--%>
			    
			    TCC.test.push({ 
			        "theta" : theta,
			        "prob"       : ptotal[i]
			    });
			    
			    theta+=.1;
			}
			</script>
<script>
//document.write(JSON.stringify(TCC.test));
// set the dimensions and margins of the graph
var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

// parse the date / time
<%--var parseTime = d3.timeParse("%d-%b-%y");--%>

// set the ranges
var x = d3.scaleLinear().range([0, width]);
var y = d3.scaleLinear().range([height, 0]);

// define the line
var valueline = d3.line()
    .x(function(d) { return x(d.theta); })
    .y(function(d) { return y(d.prob); });

// append the svg obgect to the body of the page
// appends a 'group' element to 'svg'
// moves the 'group' element to the top left margin
var svg = d3.select("#graph").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");


  // format the data
  TCC.test.forEach(function(d) {
      d.theta = +d.theta;
      //document.write(d.prob,"<br>")
      d.prob = +d.prob;
  });

  // Scale the range of the data
  x.domain([-3,3]);
  y.domain([0, count]);

  // Add the valueline path.
  svg.append("path")
      .data([TCC.test])
      .attr("class", "line")
      .attr("d", valueline)
      .attr("stroke","blue")
      .attr("stroke-width", 5)
      .attr("fill","none");

  // Add the X Axis
  svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

  // Add the Y Axis
  svg.append("g").call(d3.axisLeft(y));
//add additional info on bottom right of graph svg?


</script>
	
	<div style= "overflow:auto; float:right; height:600px">
	<table border="1"  >
						<thead>
							<tr>
								<th>ID</th> <!-- th is table header cell	 -->
								<th>A param</th>
								<th>B param</th>
								<th>C param</th>
								<th>Content</th>			
							</tr>
						</thead>
		<tbody>
				<c:forEach items="${selected.rows}" var="items">
					<tr>
					<td><c:out value="${items.itemid}" /></td>
					<td><c:out value="${items.a}" /></td>
					<td><c:out value="${items.b}" /></td>
					<td><c:out value="${items.c}" /></td>
					<td><c:out value="${items.content}" /></td>
					</tr>
				</c:forEach>
		</tbody>
	</table>
	</div>
</div>

  </body>
</html>