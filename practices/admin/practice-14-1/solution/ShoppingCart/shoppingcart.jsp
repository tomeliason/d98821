<HTML>
<HEAD><TITLE>Shopping Page</TITLE></HEAD>

<BODY>
<%@ page import="com.servlets.*" %>
<%@ page import="java.util.*" %>
<% System.out.println("within shoppingcart.jsp"); %>

<table>
<tr><td align="left"><%@ include file="pages/includes/DWRHeader1.jspf" %></td></tr>
<tr><td><CENTER><b><h3>Shopping Cart Store</h3></b></CENTER></td></tr>
</table><BR>


<%
	Vector scitems = (Vector) session.getAttribute("cart");
	String name = request.getParameter("item");
	String price = request.getParameter("price");

	shoppingCartItem newItem = new shoppingCartItem();
	newItem.setName(name);
	newItem.setPrice(price);

	if (scitems == null)
	{
		out.print("Vector null<BR>added new element<BR>" + name);
		scitems = new Vector();
		scitems.addElement(newItem);
		session.setAttribute("cart", scitems);
	} else {
		out.print("Vector was not null<BR>added new element<BR>" + name);
		scitems.addElement(newItem);
		session.setAttribute("cart", scitems);
	}

%>


<BR>

<A HREF="./welcome.jsp">Back To The Home Page</A>
<BR>
</CENTER>
<BR>
<%@ include file="pages/includes/DWRFooter1.jspf" %>
</BODY>
</HTML>