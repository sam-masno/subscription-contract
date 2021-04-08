// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SubscriptionService {
  address private admin;
  struct status {
    bool joined;
    bool current;
    uint date;
    uint totalPeriods;
  }
  mapping (address => status) subscribers;
  uint subscribePrice; // price in wei for first signup
  uint renewPrice; // price for follow on subscriptions after users subscriptionBlock ends
  uint subscribePeriod; // time in milliseconds for a subscription block before it expires

  constructor(uint _subscribePrice, uint _renewPrice, uint _subscribePeriod) public {
    admin = msg.sender;
    subscribePrice = _subscribePrice;
    renewPrice = _renewPrice;
    subscribePeriod = _subscribePeriod;
  }
  
  function subscribe() public payable {
    require(subscribers[msg.sender].joined == false, "You have already subscribed, please renew");
    require(msg.value <= subscribePrice, "Insufficient payment");
    require(msg.value == subscribePrice, "Overpayment not accepted");

  }
}
