
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.sampleData;

import com.oracle.model.Auction;
import com.oracle.model.AuctionStatus;
import com.oracle.model.Image;
import com.oracle.model.ItemCondition;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class AuctionDataSet {

  private static final String JPEG = "image/jpeg";
  private final List<AuctionData> dataList = new ArrayList<AuctionData>();

  public AuctionDataSet() {
    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("cchurch")
            .withItemValues("Antique oak phone stand", "The beautiful antique phone stand could also serve as a small hall table. Mission style.", ItemCondition.USED, 0)
            .withValues(10.49f, 1.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("AntiquePhoneStand.jpg"), JPEG))
            .bid(100, "mheimer", 20.99f)
            .bid(100, "cchurch", 34.99f)
            .bid(100, "mheimer", 50.99f));

    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("tmcginn")
            .withItemValues("American Girl Doll - Beautiful - Please Look!", "This American Girl doll Just Like Me is in her original box with outfit and in excellent new condition.  She has long wavy blond hair, freckles, brown eyes and is gorgeous.  She was given as a gift, the box was opened only to discover that she is a duplicate gift.  She was never played with and needs a new owner.", ItemCondition.NEW, 0)
            .withValues(0.99f, 1.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("Doll.jpg"), JPEG)));

    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("mlindros")
            .withItemValues("Antique coffee grinder made in pine", "Wake up and smell the coffee with this perfectly functional coffee grinder remeniscent of quieter, more relaxed times.", ItemCondition.USED, 0)
            .withValues(51.00f, 10.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("AntiqueCoffeeGrinder.jpg"), JPEG)));

    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("mheimer")
            .withItemValues("Pewter Salt and Pepper Shakers", "Vintage Salt and Pepper shakers in good condition. Some slight scratches", ItemCondition.USED, 0)
            .withValues(1.00f, 1.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("SaltPepperShakers.jpg"), JPEG)));
    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("tmcginn")
            .withItemValues("BRAND NEW LIL'KINZ POLAR BEAR!", "Sealed tag and never used code. From a non-smoking, pet-free home.", ItemCondition.NEW, 0)
            .withValues(9.99f, 1.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("PolarBear.jpg"), JPEG)));
    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("pfernandez")
            .withItemValues("North Face Surge Backback", "NEW - we bought this backback for my son and he hated the color!", ItemCondition.NEW, 0)
            .withValues(9.99f, 1.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("Backpack.jpg"), JPEG)));
    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("cchurch")
            .withItemValues("Artisan horse sculpture with hand-painted details", "A true conversation starter!", ItemCondition.USED, 0)
            .withValues(19.99f, 1.00f, AuctionStatus.ACTIVE))
            .setImage(new Image(1, getPhoto("HorseSculpture.jpg"), JPEG)));
    dataList.add(
            new AuctionData()
            .setAuction(
            new Auction("mheimer")
            .withItemValues("HP Printer - not working - parts", "Broken HP printer - may have salvageble parts - sorry no picture available", ItemCondition.PARTS, 0)
            .withValues(9.99f, 1.00f, AuctionStatus.ACTIVE)));
  }

  public List<AuctionData> getDataList() {
    return dataList;
  }

  private byte[] getPhoto(String filePath) {
    InputStream inputStream = null;
    ByteArrayOutputStream outputStream = null;
    try {
      inputStream = getClass().getResourceAsStream(filePath);
      outputStream = new ByteArrayOutputStream();
      byte[] buffer = new byte[1024];
      int read;
      while ((read = inputStream.read(buffer, 0, buffer.length)) >= 0) {
        outputStream.write(buffer, 0, read);
      }
      outputStream.flush();
      return outputStream.toByteArray();
    } catch (Exception i) {
      System.err.println("Exception loading photo:" + filePath + " : " + i.getClass().getName() + " Message: " + i.getMessage());
    } finally {
      try {
        inputStream.close();
      } catch (Exception e) {
        System.err.println("Error closing stream" + e);
      }
      try {
        outputStream.close();
      } catch (Exception e) {
        System.err.println("Error closing stream" + e);
      }
    }
    return null;
  }
}
