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
	<script src="http://d3js.org/d3.v3.min.js"></script>
	<script src="https://unpkg.com/mathjs/dist/math.min.js"></script>
	<script type="text/javascript" src="//code.jquery.com/jquery-1.6.4.js"></script>
	<title>TCC</title>
	<script>var total = new Array();</script>
</head>

<body>

<sql:setDataSource var="jbdc" driver="org.postgresql.Driver"
		url="jdbc:postgresql://127.0.0.1:5433/ItemBank"
		user="User" password="test" />
		
			<sql:query var="selected" dataSource="${jbdc}">
				select * from items where itemid in (<c:out value="${param.itemarray}" escapeXml="false" />);
			</sql:query>


			<c:forEach items="${selected.rows}" var="items">
				<c:out value="${items.itemid}" />
				<c:out value="${items.a}" />
				<c:out value="${items.b}" />
				<c:out value="${items.c}" />
				<br>
				<script >
					var array = new Array();
					var i=-3.0;
					var e=0;
					do{
						array[e]=${items.c}+((1-${items.c})/(1+math.exp(-${items.a}*(i-(${items.b})))));
						<%--document.write(${items.c}+((1-${items.c})/(1+math.exp(-${items.a}*(i-(${items.b}))))));--%>
						<%--document.write(array[e]);--%>
						if(!isNaN(total[e]))
							{ total[e] +=array[e];}
						else
							{ total[e]=array[e];}
						i=i+.1;
						e=e+1;
						
					}
					while(i<3.1)
					document.write(total[0]);
				</script>
			<br>
			</c:forEach>
			
		
			<script>
			
			var count="${fn:length(selected.rows)}";
			<%--var average= new Array();--%>
			<%--document.write(count);--%>
			
			for(var i = 0, length = total.length; i < length; i++){
			    <%--average[i] = total[i]/count;--%>
			    document.write(total[i]);
			}
			</script>
<script>
<%--var i=-3.0;
do{
	document.write(i.toFixed(1),"\n");
	i=i+.1;
	
}
while(i<3.1)
--%>

</script>
			

<div id="graph"></div>
<script id="csv" type="text/csv"> theta, height <br>	
<%-- 
<script id="csv" type="text/csv">theta,height
1470,38
1480,127
1490,251
1500,418
1510,577
1520,807
1530,1045
1540,1309
1550,1531
1560,1486
1570,2064
1580,2708
1590,2978
1600,3996
1610,4795
1620,5669
1630,6338
1640,19484
1650,13334
1660,12345
1670,12941
1680,20374
1690,19223
1700,22237
1710,25119
1720,21649
1730,21557
1740,23197
1750,27204
1760,32464
1770,40050
1780,47610
1790,75900
1800,10856
1810,2
1820,3
1830,1
1870,1
1880,1
1900,1</script>
	<script>renderChart();</script>
	--%>
  </body>
</html>