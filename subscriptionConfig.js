exports.subscribePeriod = 1000 * 60 * 60 * 24 * 30; // time in milliseconds that a user must renew. use 0 for one time subscription
// pass prices in as strings for conversion to wei in migration
exports.renewPriceInEth = ".5"; // price in eth a user must pay after current subscriptionPeriod has ended
exports.subscriptionPriceInEth = "1"; // price in eth for initial subscription
