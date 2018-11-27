<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Article Info</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<h1>Team_A Database Project:</h1>

	<ul>
		<li><a  href="index.jsp">Home</a></li>
<!-- 		<li><a href="login.html">Login</a></li>
		<li><a href="logout.jsp">Logout</a> -->
		<c:if test="${empty sessionScope.USER}">
		  <li style="float:right"><a href="login.jsp">Login</a></li>
		  <li style="float:right"><a href="Register.jsp">Register</a></li>
		</c:if>
		<c:if test="${not empty sessionScope.USER}">
		  <li style="float:right"><a href="logout.jsp">Logout</a></li>
		  <li ><a href="profile_page.jsp">Profile</a></li>
		</c:if>

	</ul>
	<sql:setDataSource var="jbdc" driver="org.postgresql.Driver"
		url="jdbc:postgresql://neuromancer.icts.uiowa.edu/institutional_repository"
		user="team_a" password="arctic1992" />


	<sql:query var="pmid_title" dataSource="${jbdc}">
	 select title from medline.article where pmid=<%=request.getParameter("pmid")%>;
	</sql:query>

	<c:forEach items="${pmid_title.rows}" var="result">
		<h3>${result.title}</h3>
	</c:forEach>
	<h4>
		PMID:<%=request.getParameter("pmid")%></h4>

	<sql:query var="pmid_lead" dataSource="${jbdc}">
	 select last_name,fore_name from medline.author where pmid=<%=request.getParameter("pmid")%> and seqnum=1;
	</sql:query>

	<h4>Lead Author</h4>

	<c:forEach items="${pmid_lead.rows}" var="result">
		<a
			href="Author_Page.jsp?fore_name=${result.fore_name}&last_name=${result.last_name}">
			${result.last_name}, ${result.fore_name}</a>
		<br />
	</c:forEach>

	<sql:query var="pmid_co" dataSource="${jbdc}">
	 select last_name,fore_name from medline.author where pmid=<%=request.getParameter("pmid")%> and seqnum!=1;
	</sql:query>

	<h4>Co-Authors</h4>

	<c:forEach items="${pmid_co.rows}" var="result">
		<a
			href="Author_Page.jsp?fore_name=${result.fore_name}&last_name=${result.last_name}">
			${result.last_name}, ${result.fore_name}</a>
		<br />
	</c:forEach>

	<sql:query var="pmid_journal" dataSource="${jbdc}">
	 select title, volume, issue, pub_month, pub_year from medline.journal where pmid=<%=request.getParameter("pmid")%>;
	</sql:query>

	<h4>Journal Information</h4>
		<c:forEach items="${pmid_journal.rows}" var="result">
		<c:out value=" Title: ${result.title}" />
		<br/>
		<c:out value="Volume(Issue): ${result.volume}" />
		<c:out value="(${result.issue})" />
		<br/>
		<c:out value="Publication Date: ${result.pub_month}, " />
		<c:out value="${result.pub_year}" />
		<br />
	</c:forEach>
	

	<sql:query var="pmid_key" dataSource="${jbdc}">
	 select keyword from medline.keyword where pmid=<%=request.getParameter("pmid")%>;
	</sql:query>

	<h4>Keywords:</h4>

	<c:forEach items="${pmid_key.rows}" var="result">
		<a href="Keyword_Page.jsp?k_name=${result.keyword}">
			${result.keyword}</a>
		<br />
	</c:forEach>
	
		<sql:query var="pmid_inst" dataSource="${jbdc}">
	 select label from medline.affiliation where pmid=<%=request.getParameter("pmid")%>;
	</sql:query>

	<h4>Affiliation:</h4>
		<c:forEach items="${pmid_inst.rows}" var="result">
		<a href="Institution_Page.jsp?i_name=${result.label}">
			${result.label}</a>
		<br />
	</c:forEach>

</body>
</html>