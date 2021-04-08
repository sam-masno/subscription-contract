const SubscriptionService = artifacts.require("SubscriptionService");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("SubscriptionService", function (/* accounts */) {
  let service;
  beforeEach(async () => {
    service = await SubscriptionService.new();
  })

});
