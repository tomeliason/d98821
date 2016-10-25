<HTML>
<HEAD><TITLE>Home Page</TITLE></HEAD>

<BODY>

<% System.out.println("within welcome.jsp"); %>

<table>
<tr><td align="left"><%@ include file="pages/includes/DWRHeader1.jspf" %></td></tr>
<tr><td><CENTER><b><h3>Welcome to the Shopping Cart Store</h3></b></CENTER></td>
<tr><td>&nbsp;</td><tr>
<tr align="center"><td><A HREF='browsestore.jsp'>Browse Store</A></td><tr>
<tr align="center"><td><A HREF='shopping.jsp'>Go Shopping</A></td><tr>
<tr align="center"><td><A HREF='./viewshoppingcart'>View Shopping Cart</A></td><tr>
</table>
<BR>
<%@ include file="pages/includes/DWRFooter1.jspf" %>
</BODY>
</HTML>