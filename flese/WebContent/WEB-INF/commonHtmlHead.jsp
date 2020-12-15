<%@page import="urls.ServerAndAppUrls"%>
<%@page import="auxiliar.Dates"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// This sets the app path for all the application.
	ServerAndAppUrls.getAppUrl(request);
%>

<!DOCTYPE html>
<!-- beginning of commonHtmlHead -->
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>FleSe: Flexible Searches in Databases</title>

<link rel="stylesheet" type="text/css" href="js_and_css/style.css" />
<link rel="stylesheet" type="text/css"
	href="js_and_css/jquery-ui-1.10.3.custom.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

<script type="text/javascript" src="js_and_css/ba-debug.js"></script>
<script type="text/javascript" src="js_and_css/ba-debug-init.js"></script>
<script type="text/javascript" src="js_and_css/jquery-1.11.0.js"></script>
<script type="text/javascript" src="js_and_css/jquery-ui-1.10.4.js"></script>
<!-- <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script> -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

<script type="text/javascript" src="js_and_css/clientSoftware.js"></script>
<script type="text/javascript" src="js_and_css/highcharts-all-3.0.9.js"></script>
<script type="text/javascript"
	src="js_and_css/auxiliarJS.jsp?date=<%=Dates.getStringOfCurrentDate()%>"></script>
<script type="text/javascript"
	src="js_and_css/answersJS.jsp?date=<%=Dates.getStringOfCurrentDate()%>"></script>
<script type="text/javascript"
	src="js_and_css/fuzzificationsJS.jsp?date=<%=Dates.getStringOfCurrentDate()%>"></script>
<script type="text/javascript"
	src="js_and_css/filesJS.jsp?date=<%=Dates.getStringOfCurrentDate()%>"></script>
<script type="text/javascript"
	src="js_and_css/ontologiesJS.jsp?date=<%=Dates.getStringOfCurrentDate()%>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.6/popper.min.js"></script>
	
<script type="text/javascript"
	src="js_and_css/main.js"></script>
	
</head>
<!-- end of commonHtmlHead -->