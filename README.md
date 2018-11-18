# JDSports-public

A collection of programs I created for JD Sports.

This public repository only contains the projects' README files.

* All programs:
  * securely handle credentials, (see JDSCredentials)
    * only usable by logged-in; authorized users
  * include clear prompts and status messages
  * have progress bars when appropriate
  * are compiled into portable EXE files
  * are written in Python
    * except for AddressPaster, which is written in AutoHotKey


## Quick Descriptions:
* [WalmartRefunder](https://github.com/Patricol/JDSports-public/tree/master/WalmartRefunder#walmartrefunder)
  * Automatically emails price protection (partial refund) requests to Walmart.
* [AddressPaster](https://github.com/Patricol/JDSports-public/tree/master/AddressPaster#address-paster)
  * A hotkey-controlled program that quickly copies and pastes shipping addresses from and into forms on many different websites; handling formatting conversion etc.
* [UploadTrackingData](https://github.com/Patricol/JDSports-public/tree/master/UploadTrackingData#uploadtrackingdata)
  * Automatically uploads shipping fulfillment information requested by Amazon; matching orders with shipping confirmation emails we receive from the wholesalers.
* [ProductIDConverter](https://github.com/Patricol/JDSports-public/tree/master/ProductIDConverter#productidconverter)
  * Quickly converts between UPCs, ASINs (Amazon's product identifier,) and WalmartIDs.
* [PullData4IDs](https://github.com/Patricol/JDSports-public/tree/master/PullData4IDs#pulldata4ids)
  * Given an Excel sheet that includes a column of UPCs; adds columns with detailed information about the products, pulled from various APIs.
* [Stock Checker](https://github.com/Patricol/JDSports-public/tree/master/Stock%20Checker#stock-checker) (Unmaintained)
  * Regularly checks the stock status of a given set of UPCs and/or URLs across a variety of different retailers, using APIs when available and web scraping otherwise.
* [AutoOrderer](https://github.com/Patricol/JDSports-public/tree/master/AutoOrderer#autoorderer) (WIP)
  * Flexible program to automatically order products from websites; even ones without relevant APIs.
* [AmazonWalmartData](https://github.com/Patricol/JDSports-public/tree/master/AmazonWalmartData#amazonwalmartdata)
  * Given a set of ASINs and/or WalmartIDs, fills an Excel sheet with detailed information about both Walmart and Amazon listings for those products; including our own listings.
* [WalmartTitleSearch](https://github.com/Patricol/JDSports-public/tree/master/WalmartTitleSearch#walmarttitlesearch)
  * Exports detailed information (from multiple APIs) about Walmart products that match a given search query.
* [Authorize](https://github.com/Patricol/JDSports-public/tree/master/Security#authorize)
  * Authorize computers/user-accounts so they can use other programs that require API keys; prompts user to login to Google accounts.
* [UploadCredential](https://github.com/Patricol/JDSports-public/tree/master/Security#uploadcredential)
  * Upload new API keys for use by all programs.
* [RefreshEXEs](https://github.com/Patricol/JDSports-public/tree/master/RefreshEXEs#refreshexes)
  * Handles all the overhead surrounding compiling Python code into portable executable files.
* [Modules](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jDSModules)
  * Handle all general functionality; allowing the main programs to be very simple.
  * [Security](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#security)
    * [JDSAuthorize](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsauthorize)
      * Provides a powerful interface for requesting and storing Google Cloud OAuth2 credentials for any combinations of accounts and scopes.
    * [JDSCredentials](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdscredentials)
      * Handles automatic encryption+upload and download+decryption of securely stored and synchronized files, strings, and arbitrary python objects.
    * [JDSKMS](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdskms)
      * Google Cloud KMS Integration
    * [JDSStorage](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsstorage)
      * Google Cloud Storage Integration
  * [Merchant APIs](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#merchant-apis)
    * [JDSMWSAPI](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsmwsapi)
      * Integrates with Amazon's MWS API.
    * [JDSPAAPI](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdspaapi)
      * Integrates with Amazon's Product Advertising API.
    * [JDSWalmartAPI](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdswalmartapi)
      * Integrates with Walmart's API.
    * [JDSKinseysAPI](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdskinseysapi)
      * Integrates with Kinsey's API.
  * [Communication](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#communication)
    * [JDSEmails](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsemails)
      * Integrates with Gmail's API.
    * [JDSEmailTypes](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsemailtypes)
      * Contains a hierarchy of classes for processing and interpreting emails.
    * [JDSTwilio](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdstwilio)
      * Integrates with Twilio's API.
  * [Misc](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#misc)
    * [JDSBasic](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsbasic)
      * Set of basic functions used by many of my programs.
    * [JDSTools](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdstools)
      * Set of custom functions to analyze unfamiliar objects received from libraries and APIs.
    * [JDSProductDataClass](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#jdsproductdataclass) (WIP)
      * Unify how API data is requested and returned.