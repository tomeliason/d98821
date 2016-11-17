
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.servlets;

import com.oracle.services.AuctionService;
import java.io.IOException;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BidServlet", urlPatterns = {"/BidServlet"})
public class BidServlet extends HttpServlet {

  private static final long serialVersionUID = 1L;
  
  @Inject
  private AuctionService auctionService;

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String auctionUser = (String) request.getSession().getAttribute("auctionUser");
    if (auctionUser == null) {
      response.sendError(HttpServletResponse.SC_FORBIDDEN);
      return;
    }
    if (request.getParameter("id") == null) {
      response.sendRedirect(getServletContext().getContextPath() + "/ListServlet");
      return;
    }

    int auctionId = Integer.parseInt(request.getParameter("id"));
    float bidAmount = Float.parseFloat(request.getParameter("bidAmount"));
    if (request.authenticate(response) && request.isUserInRole("user")) {
      String result = auctionService.bid(auctionId, auctionUser, bidAmount);
      request.setAttribute("message", result);
    } else {
      request.setAttribute("message", "User not authorized.");
    }
    request.getRequestDispatcher("/DetailServlet").forward(request, response);
  }
}
