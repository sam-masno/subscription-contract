const SubscriptionService = artifacts.require("SubscriptionService");
const { renewPriceInEth, subscriptionPriceInEth, subscribePeriod } = require('../subscriptionConfig.js');

contract("SubscriptionService", function (accounts) {
  let [zero, one, two, three, four] = accounts;
  const { toWei, fromWei } = web3.utils;
  const subPrice = toWei(subscriptionPriceInEth);
  const renewPrice = toWei(renewPriceInEth)
  let service;
  beforeEach(async () => {
    service = await SubscriptionService.new(zero, subPrice, renewPrice, subscribePeriod);
  });

  it("subscribes a new user", async () => {
    const { logs: { '0': { args } } } = await service.subscribe({from: one, value: subPrice } );
    const isSubscribed = await service.isSubscribed({from: one});
    expect(isSubscribed).to.equal(true);
    expect(args._subscriber).to.equal(one);
  });

  it("does not allow underpayment or overpayment", async () => {
    const overPay = toWei(`${new Number(subscriptionPriceInEth) * 2}`);
    const underPay = toWei(`${new Number(subscriptionPriceInEth) / 2}`);

    const over = await service.subscribe({from: one, value: overPay}).catch(() => false);
    const under = await service.subscribe({from: one, value: underPay}).catch(() => false);

    expect(over).to.equal(false);
    expect(under).to.equal(false);
  });

  it("rejects unsubscribed users", async () => {
    const err = await service.isSubscribed({from: three}).catch(() => false);
    expect(err).to.equal(false);
  })

});
