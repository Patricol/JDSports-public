# UploadTrackingData

* Used to automatically upload shipping fulfillment information requested by Amazon; by matching the orders in their request with order confirmation emails we receive from the wholesalers.
* Allows the user to save a local copy of the matches if they desire to do so.
* Alerts the user with details if any order confirmation email:
  * does not correspond to an Amazon order
  * was formatted such that the required information could not be pulled

## History
Likely remove this history after the initial commit. References using the old names of the programs are still around; this makes it easier to figure out what they were.
* Has fully replaced the first set of programs I worked on for JDS; back in July 2014.
  * Outlook Email Downloader, A simple VBA script that automatically saved text file copies of incoming messages that matched given criteria.
    * Later replaced by PullEmails, which still created the text files but pulled from the Gmail API instead.
  * TXT2XLSX, which extracted information (addresses, prices, tracking numbers, shipping carriers, etc.) from shipping confirmation emails from Walmart and Toys R Us (RIP,) putting them into an Excel sheet.
  * Autofill, which found matches between two sets of shipping addresses, combining the unmatched emails file output by TXT2XLSX with a file provided by Amazon.
