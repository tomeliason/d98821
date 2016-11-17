
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.servlets;

import com.oracle.model.Image;
import com.oracle.services.ImageService;
import com.oracle.util.AuctionUtil;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AuctionImageServlet", urlPatterns = {"/AuctionImageServlet"})
public class AuctionImageServlet extends HttpServlet {

  private static final long serialVersionUID = 1L;

  @Inject
  private ImageService imageService;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    int imageId = Integer.parseInt(request.getParameter("imageId"));
    Image image = imageService.findImageById(imageId);
    if (image == null) {
      return;
    }
    response.setContentType(image.getContentType());
    OutputStream out = response.getOutputStream();
    InputStream in = image.getInputStream();
    if ("thumb".equals(request.getParameter("mode"))) {
      AuctionUtil.resize(64, in, out, image.getContentType());
    } else {
      byte[] buffer = new byte[1024];
      int readBytes;
      while ((readBytes = in.read(buffer)) > 0) {
        out.write(buffer, 0, readBytes);
      }
    }
    in.close();
    out.close();
  }
}
