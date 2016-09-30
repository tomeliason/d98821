<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- This is set by a filter!. -->
<c:if test="${not empty auctionUser}">
  <div style="text-align: right">
    User: <b>${auctionUser}</b>
    <c:url value="/LogoutServlet" var="URLLogout"/>
    <a href="${URLLogout}">LOGOUT</a>
  </div>
</c:if>
