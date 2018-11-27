<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--  prefix is basically "library" -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!--  ?Driver too -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>


<html>
<head>

<script src="http://d3js.org/d3.v3.min.js"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.6.4.js"></script>
<script type="text/javascript">
$(window).load(function(){
$("input[type=checkbox]").change(function () {
    var 
        $this = $(this),
        i = $this.closest('tr').index(), // i =index of array of row elements
        //works but doesn't put it back at the front which is what the if statement did i think
        $target = $('#wizard2'); //default target object
    
        if (!this.checked) { //when made to be unchecked do this
            $target = $('#wizard1'); 
        	//alert($this.closest('tr').index());
        } else {				 //when checked do this 
            $this.data('idx', i); //make idx equal element
            //alert($this.closest('tr').index());
            //alert($target.find('tr'));
        }


      
        
        
        var $targetable = $target.find('tbody');
        if ($targetable.length) { //if object already has one element
            $target.find('tr:eq(' + $this.data('idx') + ')').before($this.closest('tr'));
        } else {
            $target.append($this.closest('tr'));
           // alert($colArray);
        }
        var colArray = $('#wizard2 td:nth-child(1)').map(function(){ //appears to work getting 1st "child" value
        	return "'"+$(this).text()+"'";									//array of E000001,E000002 etc
        }).get();
        $('#itemarray').val(colArray); //assign to itemarray html
});
		
});
</script>
</head>
<body>


	
<div class="Container">
<div id="image" class="Header" >
<script >

var width = 600,
    height = 467,
    radius = Math.min(width, height) / 2;

var x = d3.scale.linear()
    .range([0, 2 * Math.PI]);

var y = d3.scale.linear()
    .range([0, radius]);

var color = d3.scale.linear().domain([1,40])
.interpolate(d3.interpolateHcl)
.range([d3.rgb("#0000FF"), d3.rgb('#B22222')]);

var svg = d3.select("#image").append("svg")
    .attr("width", width)
    .attr("height", height)
    .append("g")
    .attr("transform", "translate(" + width / 2 + "," + (height / 2 ) + ")");



var partition = d3.layout.partition()
    .value(function(d) { return d.size; });

var arc = d3.svg.arc()
    .startAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x))); })
    .endAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx))); })
    .innerRadius(function(d) { return Math.max(0, y(d.y)); })
    .outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });

d3.json("Test_JSON2.txt", function(error, root) {
  var g = svg.selectAll("g")
      .data(partition.nodes(root))
    .enter().append("g");

  //debugger;
  
  var path = g.append("path")
    .attr("d", arc)
    //.style("fill", function(d) { return color((d.children ? d : d.parent).name); })
    .style("fill", function(d) { return color((d.children ? d : d.parent).code); })
    .on("click", click);

  var text = g.append("text")
    .attr("transform", function(d) { return "rotate(" + computeTextRotation(d) + ")"; })
    .attr("x", function(d) { return y(d.y); })
    .attr("dx", "6") // margin
    .attr("dy", ".35em") // vertical-align
    .text(function(d) { return d.name; });

  function click(d) {
    // fade out all text elements
    text.transition().attr("opacity", 0);

    path.transition()
      .duration(750)
      .attrTween("d", arcTween(d))
      .each("end", function(e, i) {
          // check if the animated element's data e lies within the visible angle span given in d
          if (e.x >= d.x && e.x < (d.x + d.dx)) {
            // get a selection of the associated text element
            var arcText = d3.select(this.parentNode).select("text");
            // fade in the text element and recalculate positions
            arcText.transition().duration(450)
              .attr("opacity", 1)
              .attr("transform", function() { return "rotate(" + computeTextRotation(e) + ")" })
              .attr("x", function(d) { return y(d.y); });
          }
      });
  }
});

d3.select(self.frameElement).style("height", height + "px");

// Interpolate the scales!
function arcTween(d) {
  var xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
      yd = d3.interpolate(y.domain(), [d.y, 1]),
      yr = d3.interpolate(y.range(), [d.y ? 20 : 0, radius]);
  return function(d, i) {
    return i
        ? function(t) { return arc(d); }
        : function(t) { x.domain(xd(t)); y.domain(yd(t)).range(yr(t)); return arc(d); };
  };
}

function computeTextRotation(d) {
  return (x(d.x + d.dx/2) - Math.PI/2) / Math.PI *180;
}

</script>
</div>
<sql:setDataSource var="jbdc" driver="org.postgresql.Driver"
		url="jdbc:postgresql://127.0.0.1:5433/ItemBank"
		user="User" password="test" />
<%--
<sql:query var="ItemID" dataSource="${jbdc}">
	select a, b, c from items where itemid in ?
	<sql:param value="${colArray}"/>
</sql:query>
 --%>
<div>
					
<br>
</div>


	<sql:query var="ItemID" dataSource="${jbdc}">
	SELECT *, concat(subject,'.',grade,'.',domain,'.',standard) as content, 
		ROUND(a,3) as a,
		ROUND(b,3) as b,
		ROUND(c,2) as c,
		ROUND(pval,3) as pval,
		ROUND(ptbs,3) as ptbs from items limit 20;
	</sql:query>

		</div>


				<table border="1" style="display:inline-table" class="inline" >
					<thead>
						<tr>
							<th>ID</th> <!-- th is table header cell	 -->
							<th>pval</th>
							<th>ptbs</th>
							<th>A param</th>
							<th>B param</th>
							<th>C param</th>
							<th>Content</th>					
						</tr>
					</thead>
					<tbody id="wizard1">		        
		            <c:forEach items="${ItemID.rows}" var="result3">
		        	    <tr> <!-- tr=table row -->
						<td><input type="checkbox" id="${result3.itemid}" /><c:out value="${result3.itemid}" /></td>
						<td><c:out value="${result3.pval}" /></td>
						<td><c:out value="${result3.ptbs}" /></td>
						<td><c:out value="${result3.a}" /></td>
						<td><c:out value="${result3.b}" /></td>
						<td><c:out value="${result3.c}" /></td>
						<td><c:out value="${result3.content}" /></td>
						</tr>	
					</c:forEach>	    
				    </tbody>
				</table>

				<table border="1" style="display:inline-table" class="inline">
					<thead>
						<tr >
							<th>Selected items</th>
						</tr>	
					</thead>
					<tbody id="wizard2">
						
					</tbody>
				</table>
			
<form id=submit action="ShowTCC.jsp" method="post" target="_blank" style="display:inline">
	<input type="hidden" id="itemarray" value="" name="itemarray"/>
    <input type="submit" id="button" value="submit items" />
</form>

</body>
</html>
