<HTML>
<HEAD><TITLE>Shopping Page</TITLE></HEAD>

<BODY>

<% System.out.println("within shoppingcart.jsp"); %>

<table>
<tr><td align="left"><%@ include file="pages/includes/DWRHeader1.jspf" %></td></tr>
<tr><td><CENTER><b><h3>Shopping Cart Store</h3></b></CENTER></td></tr>
</table>
<BR>


<TABLE WIDTH='670' BGCOLOR="wheat">
	<TR><TD COLSPAN="3" ALIGN="center">Writing Supplies</TD></TR>
	<TR><TD>box of 12 pens (black)</TD>
		<TD>4.99</TD>
		<TD><A HREF="./addtocart?item=box%20of%2012%20pens%20(black)&price=4.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>box of 12 pens (blue)</TD>
		<TD>4.99</TD>
		<TD><A HREF="./addtocart?item=box%20of%2012%20pens%20(blue)&price=4.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>box of 12 pens (red)</TD>
		<TD>4.99</TD>
		<TD><A HREF="./addtocart?item=box%20of%2012%20pens%20(red)&price=4.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>3 mechanical pencils</TD>
		<TD>8.99</TD>
		<TD><A HREF="./addtocart?item=3%20mechanical%20pencils&price=8.99">Add to shopping cart</A></TD>
	</TR>
</TABLE>
<BR>


<TABLE WIDTH='670' BGCOLOR="wheat">
	<TR><TD COLSPAN="3" ALIGN="center">Paper Supplies</TD></TR>
	<TR><TD>package of 500 sheets multipurpose paper</TD>
		<TD>6.99</TD>
		<TD><A HREF="./addtocart?item=package%20of%20500%20sheets%20of%20multipurpose%20paper&price=6.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>package of 5 legal pads</TD>
		<TD>15.99</TD>
		<TD><A HREF="./addtocart?item=package%20of%205%20legal%20pads&price=15.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>100 Post-It notes</TD>
		<TD>7.99</TD>
		<TD><A HREF="./addtocart?item=100%20Post-It%20notes&price=7.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>1 subject notebook</TD>
		<TD>7.99</TD>
		<TD><A HREF="./addtocart?item=1%20subject%20notebook&price=7.99">Add to shopping cart</A></TD>
	</TR>
</TABLE>
<BR>


<TABLE WIDTH='670' BGCOLOR="wheat">
	<TR><TD COLSPAN="3" ALIGN="center">Furniture Supplies</TD></TR>
	<TR><TD>corner computer desk</TD>
		<TD>199.99</TD>
		<TD><A HREF="./addtocart?item=corner%20computer%20desk&price=199.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>adjustable chair</TD>
		<TD>99.99</TD>
		<TD><A HREF="./addtocart?item=adjustable%20chair&price=99.99">Add to shopping cart</A></TD>
	</TR>
	<TR><TD>leather adjustable chair</TD>
		<TD>139.99</TD>
		<TD><A HREF="./addtocart?item=leather%20adjustable%20chair&price=139.99">Add to shopping cart</A></TD>
	</TR>

</TABLE>
<BR>
<table>
<tr align="center"><td><A HREF="./welcome.jsp">Back To The Home Page</A></td></tr>
</table>
<BR>

<BR>
<%@ include file="pages/includes/DWRFooter1.jspf" %>
</BODY>
</HTML>