
// ------------------------------------------------------------------------
// -- DISCLAIMER:
// --    This script is provided for educational purposes only. It is NOT
// --    supported by Oracle World Wide Technical Support.
// --    The script has been tested and appears to work as intended.
// --    You should always run new scripts on a test instance initially.
// --
// ------------------------------------------------------------------------

package com.oracle.services;

import com.oracle.model.Auction;
import java.util.List;

public interface AuctionService {

  List<Auction> getAllAuctions();

  Auction findAuctionById(int auctionId);

  Auction addAuction(Auction auction);

  Auction updateAuction(Auction auction);

  String bid(int auctionId, String user, float bidAmount);
}
