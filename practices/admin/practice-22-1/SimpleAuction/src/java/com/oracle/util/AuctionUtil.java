
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.util;

import java.awt.Graphics2D;
import static java.awt.RenderingHints.KEY_INTERPOLATION;
import static java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.imageio.ImageIO;

public final class AuctionUtil {

  public static float defineIncrement(float price) {
    // For current price less than $50, the increment is $1
    // For price between 50 and 1000, increment is $10
    // For prices over 1000, the increment is $100
    float increment = 1.00f;
    if (price > 50.00f && price < 1000.00f) {
      increment = 10.00f;
    } else if (price > 1000.00f) {
      increment = 100.00f;
    }
    return increment;
  }

  public static boolean canResize(String mimeType) {
    for (String supportedType : ImageIO.getWriterMIMETypes()) {
      if (supportedType.equalsIgnoreCase(mimeType)) {
        return true;
      }
    }
    return false;
  }

  public static void resize(int maxSize, InputStream in, OutputStream out, String mimeType) throws IOException {
    BufferedImage originalImage = ImageIO.read(in);
    int newWidth, newHeight;
    if (originalImage.getWidth() <= maxSize && originalImage.getHeight() <= maxSize) {
      newWidth = originalImage.getWidth();
      newHeight = originalImage.getHeight();
    } else if (originalImage.getWidth() > originalImage.getHeight()) {
      newWidth = maxSize;
      newHeight = newWidth * originalImage.getHeight() / originalImage.getWidth();
    } else {
      newHeight = maxSize;
      newWidth = newHeight * originalImage.getWidth() / originalImage.getHeight();
    }
    int imgType = originalImage.getType();
    BufferedImage newImage = new BufferedImage(newWidth, newHeight, imgType);
    Graphics2D g2d = (Graphics2D) newImage.getGraphics();
    g2d.setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC);
    g2d.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
    g2d.dispose();
    String shortType = mimeType.replaceFirst("image/", "");
    ImageIO.write(newImage, shortType, out);
  }
}
