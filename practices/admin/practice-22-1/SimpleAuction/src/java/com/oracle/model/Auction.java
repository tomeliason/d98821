
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

public class Auction implements Serializable {

  private static final long serialVersionUID = 1L;
  private int auctionId;
  private int imageId;
  private String title;
  private String description;
  private String seller;
  private String highestBidder;
  private float currPrice;
  private float increment;
  private AuctionStatus status = AuctionStatus.ACTIVE;
  private ItemCondition condition = ItemCondition.NEW;
  private Collection<Bid> bids;
  //private int version;

  public Auction() {
  }

  public Auction(int auctionId, String seller) {
    this.auctionId = auctionId;
    this.seller = seller;
  }

  public Auction(String seller) {
    this.seller = seller;
    this.highestBidder = seller;
  }

  public Auction withValues(float currPrice, float increment, AuctionStatus status) {
    this.currPrice = currPrice;
    this.increment = increment;
    this.status = status;
    return this;
  }

  public Auction withItemValues(String title, String description, ItemCondition condition, int imageId) {
    this.description = description;
    this.condition = condition;
    this.imageId = imageId;
    this.title = title;
    return this;
  }

  public int getAuctionId() {
    return auctionId;
  }

  public void setAuctionId(int auctionId) {
    this.auctionId = auctionId;
  }

  public String getSeller() {
    return seller;
  }

  public void setSeller(String seller) {
    this.seller = seller;
  }

  public float getCurrPrice() {
    return currPrice;
  }

  public void setCurrPrice(float currPrice) {
    this.currPrice = currPrice;
  }

  public float getIncrement() {
    return increment;
  }

  public void setIncrement(float increment) {
    this.increment = increment;
  }

  public AuctionStatus getStatus() {
    return status;
  }

  public void setStatus(AuctionStatus status) {
    this.status = status;
  }

  public void addBid(Bid bid) {
    if (bids == null) {
      bids = new ArrayList<Bid>();
    }
    bids.add(bid);
  }

  public int getNumBids() {
    if (bids == null) {
      return 0;
    }
    return bids.size();
  }

  public int getImageId() {
    return imageId;
  }

  public void setImageId(int imageId) {
    this.imageId = imageId;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public ItemCondition getCondition() {
    return condition;
  }

  public void setCondition(ItemCondition condition) {
    this.condition = condition;
  }

  public String getHighestBidder() {
    return highestBidder;
  }

  public void setHighestBidder(String highestBidder) {
    this.highestBidder = highestBidder;
  }

  public Collection<Bid> getBids() {
    return bids;
  }

}