
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.model;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;

public class Image implements Serializable {

  private static final long serialVersionUID = 1L;
  private int imageId;
  private byte[] content;
  private String contentType;  // needed for MIME type

  public Image() {
  }

  public Image(int imageId, byte[] content, String contentType) {
    this.imageId = imageId;
    this.content = content;
    this.contentType = contentType;
  }

  public int getImageId() {
    return imageId;
  }

  public void setImageId(int imageId) {
    this.imageId = imageId;
  }

  public byte[] getContent() {
    return content;
  }

  public void setContent(byte[] content) {
    this.content = content;
  }

  public String getContentType() {
    return contentType;
  }

  public void setContentType(String contentType) {
    this.contentType = contentType;
  }

  public InputStream getInputStream() {
    return new ByteArrayInputStream(content);
  }

  public OutputStream getOutputStream() {
    return new ByteArrayOutputStream() {
      @Override
      public void close() throws IOException {
        super.close();
        content = toByteArray();
      }
    };
  }
}