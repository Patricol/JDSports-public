# AmazonWalmartData

## Impact
"Same as Product ID Converter. (Tough to translate as doing this manually would take forever.) Saves 5-10 hours per week. When used in conjunction with Product ID Converter, profits increased 20-30%."

## Function
* Given a set of ASINs and/or WalmartIDs, fills an Excel sheet with detailed information about both Walmart and Amazon listings for those products.
  * Including information about our own listings for the products.
* Updates data in-place when re-run on an output Excel sheet.
  * Allows for easy use of formulas etc.
* Also properly handles the addition or removal of products from the sheet.

Pulled data includes:
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
* Walmart:
  * WalmartID (if not given)
  * Product Title/Name
  * Price
  * Stock
  * Sold by Marketplace Seller
  * Number of Reviews
  * Shipping Cost
  * Free Shipping over 35
* General:
  * Manufacturer
  * Brand
  * Part Number
  * Model
  * Weight
