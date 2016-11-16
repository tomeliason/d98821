
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.servlets;

import com.oracle.model.Auction;
import com.oracle.model.Bid;
import com.oracle.model.Image;
import com.oracle.sampleData.AuctionData;
import com.oracle.sampleData.AuctionDataSet;
import com.oracle.services.AuctionService;
import com.oracle.services.ImageService;
import java.io.IOException;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SetupServlet", urlPatterns = {"/SetupServlet"})
public class SetupServlet extends HttpServlet {

  private static final long serialVersionUID = 1L;
  
  @Inject
  private AuctionService auctionService;
  @Inject
  private ImageService imageService;

  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    AuctionDataSet dataSet = new AuctionDataSet();
    for (AuctionData data : dataSet.getDataList()) {
      if (data.getImage() != null) {
        Image savedImage = imageService.addImage(data.getImage());
        data.setImage(savedImage);
      }
      Auction savedAuction = auctionService.addAuction(data.getAuction());
      data.setAuction(savedAuction);
      for (Bid bid : data.getBids()) {
        auctionService.bid(data.getAuction().getAuctionId(), bid.getBidder(), bid.getAmount());
      }
    }
    request.getRequestDispatcher("/setupComplete.jsp").forward(request, response);
  }

  // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
  /**
   * Handles the HTTP
   * <code>GET</code> method.
   *
   * @param request servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException if an I/O error occurs
   */
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    processRequest(request, response);
  }

  /**
   * Handles the HTTP
   * <code>POST</code> method.
   *
   * @param request servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException if an I/O error occurs
   */
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    processRequest(request, response);
  }

  /**
   * Returns a short description of the servlet.
   *
   * @return a String containing servlet description
   */
  @Override
  public String getServletInfo() {
    return "Short description";
  }// </editor-fold>
}
