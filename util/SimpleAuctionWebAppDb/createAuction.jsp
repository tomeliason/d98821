<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <c:url value="/res/styles.css" var="stylesURL"/>
    <link rel="stylesheet" href="${stylesURL}" type="text/css"> 
    <title>Create Auction</title>
  </head>
  <body>
    <jsp:include page="/templates/header.jsp"/>
    <h1>Create auction</h1>
    <c:url value="/CreateAuctionServlet" var="createURL" />
    <form action="${createURL}" enctype="multipart/form-data" method="post">
      <table>
        <tr>
          <td>Auction title:</td>
          <td><input type="text" name="auctionTitle"></td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><input type="text" name="auctionDescription"></td>
        </tr>
        <tr>
          <td>Start price:</td>
          <td><input type="text" name="auctionStartPrice" value="10.0"></td>
        </tr>

        <tr>
          <td>Image:</td>
          <td><input type="file" name="imageFile"><br>
            <select name="contentType">
              <option value="image/jpeg">Image JPEG</option>
              <option value="image/gif">Image GIF</option>
            </select>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td><input type="submit" value="Create"></td>
        </tr>
      </table>
    </form>

    <c:url var="indexUrl" value="/"/><a href="${indexUrl}">Go Home</a><br>
    <c:url value="/ListServlet" var="listURL"/>
    <a href="${listURL}">Back to auction list</a>

  </body>
</html>
