
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

@WebServlet(name = "DetailServlet", urlPatterns = {"/DetailServlet"})
public class DetailServlet extends HttpServlet {

  private static final long serialVersionUID = 1L;

  @Inject
  private AuctionService auctionService;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    request.setAttribute("auction", auctionService.findAuctionById(id));
    request.getRequestDispatcher("/DetailServlet.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    doGet(req, resp);
  }
}
