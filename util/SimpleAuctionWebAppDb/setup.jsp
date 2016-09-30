<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>Setup</title>
  </head>
  <body>
    <p>This will create the default data.</p>
    <p>Do you want to continue?</p>

    <h2 style="text-align: center"><c:url var="indexUrl" value="/"/><a href="${indexUrl}">No, Go back</a></h2>
    <h2 style="text-align: center"><c:url var="setupUrl" value="/SetupServlet"/><a href="${setupUrl}">Yes, Create Default Data</a></h2>

  </body>
</html>
