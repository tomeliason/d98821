<HTML>
<HEAD><TITLE>Shopping Page</TITLE></HEAD>

<BODY>
<%@ page import="com.servlets.shoppingCartItem" %>
<%@ page import="java.util.*" %>
<% System.out.println("within viewshoppingcart.jsp"); %>

<CENTER>
	<%@ include file="pages/includes/DWRHeader1.jspf" %>
<BR/><BR/>


<%
	Vector scitems = (Vector) session.getAttribute("cart");
	if (scitems == null)
	{
		out.print("Vector was null");
		out.print("Nothing in shopping cart");
	} else {
		out.print("Vector was not null");
		Enumeration e = scitems.elements();
		while (e.hasMoreElements())
		{
			shoppingCartItem item = (shoppingCartItem) e.nextElement();
			out.print(item.getName());
		}
	}


%>


<BR/>

<A HREF="./welcome.jsp">Back To The Home Page</A>
<BR/>
</CENTER>
<BR/>
<%@ include file="pages/includes/DWRFooter1.jspf" %>
</BODY>
</HTML>