<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>Auctions</title>
  </head>
  <body>
    <jsp:include page="/templates/header.jsp"/>
    <h1>Welcome to the Auction application</h1>
    <c:url value="/UpdateUserServlet" var="updateUserURL" />
    <form action="${updateUserURL}" method="POST">
      User:
      <input type="text" value="${auctionUser}" name="user"/>
      <input type="submit" value="update"/>
    </form>

    <h2 style="text-align: center"><c:url var="listAuctionUrl" value="/ListServlet"/><a href="${listAuctionUrl}">View Auction List</a></h2>
    <h2 style="text-align: center"><c:url var="createAuctionUrl" value="/createAuction.jsp"/><a href="${createAuctionUrl}">Create Auction</a></h2>
    <h2 style="text-align: center"><c:url var="setupUrl" value="/setup.jsp"/><a href="${setupUrl}">Create Default Data</a></h2>

    <p>This project requires a database.</p>

  </body>
</html>
