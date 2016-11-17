
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.services.impl;

import com.oracle.model.Auction;
import com.oracle.model.Bid;
import com.oracle.services.AuctionService;
import com.oracle.util.AuctionUtil;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
//import java.util.logging.Logger;
import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class AuctionServiceImpl implements AuctionService {

  //private static final Logger LOG = Logger.getLogger(AuctionServiceImpl.class.getName());
  private final Map<Integer, Auction> auctions;
  private final Map<Integer, Bid> bids;
  private int currentAuctionId = 100;
  private int currentBidId = 10;

  public AuctionServiceImpl() {
    auctions = new HashMap<Integer, Auction>();
    bids = new HashMap<Integer, Bid>();
  }

  @Override
  public List<Auction> getAllAuctions() {
    return new ArrayList<Auction>(auctions.values());
  }

  @Override
  public Auction addAuction(Auction auction) {
    int id = currentAuctionId;
    currentAuctionId++;
    auction.setAuctionId(id);
    auctions.put(id, auction);
    return auction;
  }

  @Override
  public Auction findAuctionById(int auctionId) {
    return auctions.get(auctionId);
  }

  @Override
  public Auction updateAuction(Auction auction) {
    auctions.put(auction.getAuctionId(), auction);
    return auction;
  }

  @Override
  public String bid(int auctionId, String bidder, float bidAmount) {
    int id = currentBidId;
    currentBidId++;
    Auction auction = findAuctionById(auctionId);
    if (bidder.equals(auction.getHighestBidder())) {
      //same bidder, errror.
      return "Bid failed, You cannot bid when you are the highest bidder.";
    }
    if (bidAmount < auction.getCurrPrice() + auction.getIncrement()) {
      // not enough $ - error
      return "Bid failed, You cannot bid less than the next bid.";
    }
    auction.setHighestBidder(bidder);
    auction.setCurrPrice(bidAmount);
    auction.setIncrement(AuctionUtil.defineIncrement(bidAmount));
    Bid bid = new Bid(id, bidder, auction, bidAmount, new Date());
    auction.addBid(bid);
    bids.put(id, bid);
	updateAuction(auction);
    return "Bid Successful";
  }
}