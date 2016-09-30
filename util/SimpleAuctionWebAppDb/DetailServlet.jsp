<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>${auction.title}</title>
  </head>
  <body>
    <jsp:include page="/templates/header.jsp"/>
    <c:if test="${not empty message}">
      <h3>${message}</h3>
    </c:if>

    <h1>${auction.title}</h1>
    <c:url var="ImageUrl" value="/AuctionImageServlet">
      <c:param name="imageId" value="${auction.imageId}"/>
    </c:url>

    <img src="${ImageUrl}" style="float: left"/>

    <p>${auction.description}</p>

    <table>
      <tr>
        <td>Condition:</td>
        <td>${auction.condition}</td>
      </tr>
      <tr>
        <td>Status:</td>
        <td>${auction.status}</td>
      </tr>
    </table>
    <br>
    <table>
      <thead>
        <tr>
          <th>Current Price:</th>
          <th>Next bid:</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>$<fmt:formatNumber value="${auction.currPrice}" pattern="#.##"/></td>
          <td>$<fmt:formatNumber value="${auction.currPrice + auction.increment}" pattern="#.##"/></td>
        </tr>
      </tbody>
    </table>
    <c:url value="/BidServlet" var="bidSvltURL"/>
    <form action="${bidSvltURL}" method="POST">
      <table>
        <tr>
          <td>Your bid:</td>
          <td>
            <fmt:formatNumber value="${auction.currPrice + auction.increment}" pattern="#.##" var="suggestedPrice"/>
            $
            <input type="text" name="bidAmount" value="${suggestedPrice}">
            <input type="hidden" name="id" value="${auction.auctionId}"/>
          </td>
          <td>
            <input type="submit" value="bid">
          </td>
        </tr>
      </table>
    </form>
    <table>
      <tr>
        <td>
          <c:url value="/ListServlet" var="listURL"/>
          <a href="${listURL}">Back to auction list</a>
        </td>
      </tr>
      <tr>
        <td>
          <c:url var="createAuctionUrl" value="/createAuction.jsp"/>
          <a href="${createAuctionUrl}">Create auction</a>
        </td>
      </tr>
    </table>
    <c:if test="${auction.bids != null}">
      <table>
        <thead>
          <tr>
            <th colspan="3">Bid details</th>
          </tr>
          <tr>
            <th>Date</th>
            <th>Amount</th>
            <th>User</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="bid" items="${auction.bids}">
            <tr>
              <td><fmt:formatDate value="${bid.bidTime}"/></td>
              <td>$<fmt:formatNumber value="${bid.amount}" pattern="#.##"/></td>
              <td>${bid.bidder}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>
    <c:url var="indexUrl" value="/"/><a href="${indexUrl}">Go Home</a><br>
  </body>
</html>
