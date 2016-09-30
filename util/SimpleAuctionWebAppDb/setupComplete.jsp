<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>Setup Complete</title>
  </head>
  <body>
    <h1>Setup Complete!</h1>

    <h2 style="text-align: center"><c:url var="indexUrl" value="/"/><a href="${indexUrl}">Go Home</a></h2>

  </body>
</html>
