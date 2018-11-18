# WalmartTitleSearch
* Exports detailed information about Walmart products that match a given search query.
  * Also pulls information from Amazon about the same products; by converting the product IDs.


Pulled data includes:
* Walmart:
  * WalmartID
  * Product Title/Name
  * Price
  * Stock
  * Shipping Cost
  * Free Shipping over 35
* Amazon:
  * ASIN (if not given)
  * Product Title/Name
  * Our listing of the product:
    * Our Stock
    * Our Price
    * Our Fulfillment Method
  * Prices:
    * Buy Box
    * Lowest AFN
    * Lowest MFN
    * Lowest Used - Like New Amazon Fulfilled
  * Number of Listings
  * Sales Rank
* General:
  * UPC
  * Manufacturer
  * Brand
  * Part Number
  * Model
  * Weight
