<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>Auction List</title>
  </head>
  <body>
    <jsp:include page="/templates/header.jsp"/>
    <h1>Auctions</h1>
    <c:if test="${not empty message}">
      <h3>${message}</h3>
    </c:if>
    <table>
      <thead>
        <tr>
          <td>&nbsp;</td>
          <td>Auction Name</td>
          <td>Current bid</td>
          <td>Highest bidder</td>
          <td>Seller</td>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="auction" items="${allAuctions}">
          <tr>
            <td>
              <c:url var="thumbnailUrl" value="/AuctionImageServlet">
                <c:param name="imageId" value="${auction.imageId}"/>
                <c:param name="mode" value="thumb"/>
              </c:url>
              <img src="${thumbnailUrl}"/>
            </td>
            <td>
              <c:url value="/DetailServlet" var="detailServletUrl">
                <c:param name="id" value="${auction.auctionId}"/>
              </c:url>
              <a href="${detailServletUrl}">${auction.title}</a>
            </td>
            <td style="text-align: right">
              $<fmt:formatNumber value="${auction.currPrice}" pattern="#.##"/>
            </td>
            <td>
              ${auction.highestBidder}
            </td>
            <td>
              ${auction.seller}
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
    <c:url var="indexUrl" value="/"/><a href="${indexUrl}">Go Home</a><br>
    <c:url var="createAuctionUrl" value="/createAuction.jsp"/>
    <a href="${createAuctionUrl}">Create auction</a>
  </body>
</html>
