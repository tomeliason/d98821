<HTML>
<HEAD><TITLE>Staplerz Office Supplies Store</TITLE></HEAD>


<BODY>

<% System.out.println("within browsestore.jsp"); %>

<table>
<tr><td align="left"><%@ include file="pages/includes/DWRHeader1.jspf" %></td></tr>
<tr><td><CENTER><b><h3>Welcome to the Shopping Cart Store</h3></b></CENTER></td>
<tr><td>&nbsp;</td><tr>
<tr align="left"><td><b>Select the categories to browse</b></A></td><tr>
</tr>
</table>

<FORM NAME="categories" ACTION="./browsecategories" METHOD="POST">

<TABLE width="670" ALIGN="left" BGCOLOR="wheat">
	<TR><TD WIDTH="45%" ALIGN="right"><INPUT TYPE="checkbox" NAME="boxWriting" VALUE="writing"></TD>
		<TD WIDTH="55%">Writing Utensils</TD>
	</TR>
	<TR><TD ALIGN="right"><INPUT TYPE="checkbox" NAME="boxFurniture" VALUE="furniture"></TD>
		<TD>Furniture</TD>
	</TR>
	<TR><TD ALIGN="right"><INPUT TYPE="checkbox" NAME="boxPaper" VALUE="paper"></TD>
		<TD>Paper</TD>
	</TR>
	<TR><TD COLSPAN="2" ALIGN="center">
		<INPUT TYPE="submit" NAME="btnSubmit" VALUE="Retrieve Items"></TD>
	</TR>

</TABLE>
</FORM>

<BR>
<%@ include file="pages/includes/DWRFooter1.jspf" %>
</BODY>
</HTML>