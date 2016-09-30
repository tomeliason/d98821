<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>User Required</title>
  </head>
  <body>
    <jsp:include page="/templates/header.jsp"/>
    <h1>User Required, Log In in the homepage.</h1>
    <c:url var="indexUrl" value="/"/><a href="${indexUrl}">Go Home</a><br>
  </body>
</html>
