# WalmartRefunder

* Automatically emails price protection (partial refund) requests to Walmart.
* Prioritizes highest value requests; often worth hundreds of dollars each.
* Tracks all eligible orders and the prices of all eligible purchased items.
* May send multiple requests per order; if the prices drop further than their value at the time of the last sent request.
* Configurable:
  * maximum number of emails to send per day
    * sent emails are spaced evenly throughout the day
  * minimum dollar value to justify a refund request
