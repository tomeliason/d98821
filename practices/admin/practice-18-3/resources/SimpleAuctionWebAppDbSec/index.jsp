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

    <h2 style="text-align: center"><c:url var="listAuctionUrl" value="/ListServlet"/><a href="${listAuctionUrl}">View Auction List</a></h2>
    <h2 style="text-align: center"><c:url var="createAuctionUrl" value="/createAuction.jsp"/><a href="${createAuctionUrl}">Create Auction</a></h2>
    <h2 style="text-align: center"><c:url var="setupUrl" value="/setup.jsp"/><a href="${setupUrl}">Create Default Data</a></h2>

    This project requires setting up security:
    <div style="border: 1px gray solid;">
      <h3>Create Users and Groups in WebLogic:</h3>
      <ul>
        <li>AuctionUsers</li>
        <li>AuctionCreators</li>
      </ul>
      Create users and assign the groups to the users to add permissions in the application. (Script Provided)
    </div>

    <p>This project requires a database.</p>
  </body>
</html>
