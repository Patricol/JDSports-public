# JDSModules
* All of these securely handle credentials.

## Security

### JDSAuthorize
* Provides a powerful interface for requesting and storing Google Cloud OAuth2 credentials for any combinations of accounts and scopes.
* Handles OAuth2 flow; opening a browser tab to prompt the user to login.
* Also provides preset combinations of scopes; making it easier to request all permissions required for a certain task.

### JDSCredentials
* Handles automatic encryption+upload and download+decryption of securely stored and synchronized files, strings, and arbitrary python objects.
  * Trivially simple interface; needs only the name of the data, (and, if uploading, the data itself.)
  * Primarily used for API keys and related secrets.
* Takes the OAuth2 credentials created by Authorize/JDSAuthorize and uses them to connect to Google Cloud servers.
  * Returns appropriate errors if the credentials are invalid in any way.
  * Note that users are given the smallest set of permissions needed.
* Uses JDSKMS for encryption/decryption and JDSStorage for upload/download.
* Access management policies set online allow for quick addition and removal of authorized accounts without requiring updating or redistributing any programs.
* Allows for simple redistribution of new API keys; just by uploading them.
  * Which is also restricted to specific authorized users; as defined in the online console.
* Secrets are never saved on the device's storage during this process.
  * Each program requests any required credentials when they start; keeping those credentials in memory.

### JDSKMS
* Google Cloud KMS Integration
* Used to securely encrypt and decrypt credentials and other secrets.
  * Can handle files, strings, and arbitrary python objects.

### JDSStorage
* Google Cloud Storage Integration
* Enables uploading, downloading, and enumerating data.
* Because that data is encrypted (by JDSKMS) before upload, it uniformly handles files, strings, and arbitrary python objects.


## Merchant APIs
* All of them:
  * Handle API errors.
  * Construct efficient API requests; batching as much as possible.
  * Handle missing data.
  * Provide optional progress bars and other UI feedback.
  * Have data classes that:
    * Have flexible getters.
    * Are trivial to update with new data.
  * Have standard tests that can be run to verify they are functioning as expected.

### JDSMWSAPI
* Integrates with Amazon's MWS API.
* Pulls information about Amazon products.
  * Checks the (formatting) validity of ASINs and UPCs.
  * Processes and adds results from individual types of API calls.
    * Only makes the API calls that are necessary to get the required/requested data.
      * Many different API requests are needed to get all data that this module can handle.
  * Includes methods that infer extra information about the product based on multiple stored fields or API responses.
  * Includes methods to output basic preset combinations of data; simplifying other programs.
* Downloads information about orders we have received from customers.
  * Including reports with:
    * all unshipped orders
    * all orders in last X days
  * Reports can be exported to files.
  * Handles data provided for both shipped and unshipped orders.
  * Formats addresses.
* Uploads information about orders we have received from customers.
  * Submit reports with required information filled in.
  * Ensure report was received correctly
* Converts UPCs to ASINs.
* Others mentioned [above](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#merchant-apis).

### JDSPAAPI
* Integrates with Amazon's Product Advertising API.
* Used for a few things unavaliable in the MWS API.
  * Converts ASINs to UPCs.
  * Determines whether Amazon itself is a seller for a product; and what their price is.
  * Pulls Best Seller Rankings for categories.
    * Can search through bestselling products.
* Others mentioned [above](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#merchant-apis).

### JDSWalmartAPI
* Integrates with Walmart's API.
* Pulls information about Walmart products.
  * Includes methods that infer extra information about the product based on multiple stored fields.
* Given WalmartIDs or UPCs, can return
  * all product information as instances of the appropriate class
  * specifically requested fields as lists of strings etc.
* ID Conversion
  * WalmartIDs to UPCs
  * UPCs to WalmartIDs
* Search API
  * Submits search queries and processes their results.
* Others mentioned [above](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#merchant-apis).

### JDSKinseysAPI
* Integrates with Kinsey's API.
* Pulls information about Kinsey's Products.
* Others mentioned [above](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#merchant-apis).


## Communication

### JDSEmails
* Integrates with Gmail.
* Searches emails; returning ones that match the query.
  * Return as either message IDs, or instances of any requested class from JDSEmailTypes.
  * Possible to set a maximum number to return; speeding up the process when only a certain number are needed.
* Sends emails.
* Handles API errors and throttling etc.

### JDSEmailTypes
* Contains a hierarchy of classes for processing and interpreting emails.
* It is designed so that all of the things that can be broken when a sender changes the formatting of their emails are:
  * in one place
    * meaning both in this file, and in their own dedicated classes; in extremely simple functions
  * as simple as possible to understand, edit, and test
    * They rely almost entirely on regular expressions, which are easy to edit and test while being extremely flexible.
    * They subclass eachother and a base class that provides powerful tools to greatly simplify the process of pulling information out of the email's body.
* Useful details provided with the metadata are processed and saved for every email.
* Besides the base class, each public class:
  * is for a different type of email
    * These types can be thought of a different combinations of purposes and senders.
      * Purposes:
        * Shipping Confirmation
        * Order Confirmations
        * Partial Refund Requests
        * etc.
      * Senders:
        * Walmart
        * Toys R Us (RIP)
        * Others' APIs
        * Us
        * etc.
  * provides the search string required to find every email of that type (and no others)
  * has a different set of information it pulls and provides from the body of its emails
* Unsuccessful pulls are handled.

### JDSTwilio
* Integrates with Twilio to enable text message notifications for certain programs; like the Stock Checker.


## Misc

### JDSBasic
* Set of basic functions used by many of my programs.
* Examples:
  * testing files are writeable or not in use
  * prompting yes/no
  * exit prompts
  * error prompts

### JDSTools
* Set of custom functions to analyze unfamiliar objects received from libraries and APIs.

### JDSProductDataClass
* Initial work to unify how API data is requested and returned; so that other code can be streamlined and made even more flexible.
* Functions, but is not yet used by other programs or modules.

This repository only contains README files and some portions of [WalmartRefunder](https://github.com/Patricol/JDSports-public/tree/master/WalmartRefunder#walmartrefunder) and [AddressPaster](https://github.com/Patricol/JDSports-public/tree/master/AddressPaster#address-paster) approved (by JD Sports) for public release.
