// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SubscriptionService {
  address private admin;
  
  struct status { // management info for each subscription
    bool joined;
    uint exp;
    uint totalPeriods;
  }
  
  mapping (address => status) subscribers; // map subscription status to a subscribers address
  uint subscribePrice; // price in wei for first signup
  uint renewPrice; // price for follow on subscriptions after users subscriptionBlock ends
  uint subscribePeriod; // time in milliseconds for a subscription block before it expires

  constructor(address _admin, uint _subscribePrice, uint _renewPrice, uint _subscribePeriod) public {
    admin = _admin;
    subscribePrice = _subscribePrice; // all prices in wei
    renewPrice = _renewPrice;
    subscribePeriod = _subscribePeriod; // must be in milliseconds
  }

  event NewSubscriber(address _subscriber, uint _from, uint _until);
  event Renewal(address _subscriber, uint _from, uint _until);
  // subscribes a new user, emits newsubscriber event
  function subscribe() public payable {
    // check if ever joined, if so they must renew
    require(subscribers[msg.sender].joined == false, "You have already subscribed, please renew");
    // check if under or overpaying
    require(msg.value >= subscribePrice, "Insufficient payment");
    require(msg.value == subscribePrice, "Overpayment not accepted");
    // map a new status object to addres
    uint exp = block.timestamp + subscribePeriod;
    status memory newSubscriber = status(true, exp, 1);
    subscribers[msg.sender] = newSubscriber;
    emit NewSubscriber(msg.sender, block.timestamp, exp);
  }

  function isSubscribed() public view returns(bool) {
    require(subscribers[msg.sender].exp > block.timestamp, "Not subscribed or subscription expired");
    return true;
  }

  // renew a users whose exp date has passed
  function renew() public payable {
    require(subscribers[msg.sender].exp < block.timestamp, "Your subscription is still current");
    require(msg.value >= subscribePrice, "Insufficient payment");
    require(msg.value == subscribePrice, "Overpayment not accepted");
    uint exp = block.timestamp + subscribePeriod;
    subscribers[msg.sender].exp = exp;
    subscribers[msg.sender].totalPeriods = subscribers[msg.sender].totalPeriods + 1;
    emit Renewal(msg.sender, block.timestamp, exp);
  }

}
