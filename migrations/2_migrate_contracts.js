const SubscriptionService = artifacts.require("SubscriptionService");
const { renewPriceInEth, subscriptionPriceInEth, subscribePeriod } = require('../subscriptionConfig.js');

module.exports = async function (deployer, network, accounts) {
  const { toWei } = web3.utils;
  let [zero] = accounts
  await deployer.deploy(SubscriptionService, zero, toWei(subscriptionPriceInEth), toWei(renewPriceInEth), subscribePeriod);
};