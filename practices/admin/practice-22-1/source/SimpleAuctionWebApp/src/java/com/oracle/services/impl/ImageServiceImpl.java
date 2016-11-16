
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.services.impl;

import com.oracle.model.Image;
import com.oracle.services.ImageService;
import java.util.HashMap;
import java.util.Map;
//import java.util.logging.Logger;
import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ImageServiceImpl implements ImageService {

  //private static final Logger LOG = Logger.getLogger(ImageServiceImpl.class.getName());
  private int currentImageId;
  private final Map<Integer, Image> images;

  public ImageServiceImpl() {
    images = new HashMap<Integer, Image>();
  }

  @Override
  public Image findImageById(int imageId) {
    return images.get(imageId);
  }

  @Override
  public Image addImage(Image image) {
    int id = currentImageId;
    currentImageId++;
    image.setImageId(id);
    images.put(id, image);
    return image;
  }
}