
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
import com.oracle.model.Image;
import com.oracle.services.AuctionService;
import com.oracle.services.ImageService;
import com.oracle.util.AuctionUtil;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "CreateAuctionServlet", urlPatterns = {"/CreateAuctionServlet"})
@MultipartConfig
public class CreateAuctionServlet extends HttpServlet {

  private static final long serialVersionUID = 1L;
  
  @Inject
  private ImageService imageService;
  @Inject
  private AuctionService auctionService;

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String auctionUser = (String) request.getSession().getAttribute("auctionUser");
    if (auctionUser == null) {
      response.sendError(HttpServletResponse.SC_FORBIDDEN);
      return;
    }
    
    //imageFile
    Part part = request.getPart("imageFile");

    Image image = new Image();
    OutputStream out = image.getOutputStream();
    InputStream in = part.getInputStream();

    byte buffer[] = new byte[4048];
    int bytesRead;
    while ((bytesRead = in.read(buffer)) > 0) {
      out.write(buffer, 0, bytesRead);
    }
    in.close();
    out.close();

    image.setContentType(request.getParameter("contentType"));

    imageService.addImage(image);

    String auctionTitle = request.getParameter("auctionTitle");
    String auctionDescription = request.getParameter("auctionDescription");

    Auction auction = new Auction();
    auction.setTitle(auctionTitle);
    auction.setDescription(auctionDescription);
    auction.setImageId(image.getImageId());
    float price = Float.parseFloat(request.getParameter("auctionStartPrice"));
    auction.setCurrPrice(price);
    auction.setIncrement(AuctionUtil.defineIncrement(price));
    auction.setHighestBidder(auctionUser);
    auction.setSeller(auctionUser);

    auctionService.addAuction(auction);
    request.setAttribute("message", "Auction created");
    request.getRequestDispatcher("/ListServlet").forward(request, response);
  }
}
