# PullData4IDs

* Given an Excel sheet that includes a column of UPCs; adds columns with detailed information about the products, pulled from various APIs.
  * The UPC column can be any column; the program will find it.
  * The excel sheet can contain any arbitrary number of other columns with data; the program will append its columns after all other populated columns.
* APIs include Amazon, Walmart, and smaller additions like Kinsey's.
* Drag-and-drop functionality; just drag an excel sheet onto the executable.
* Subsequent runs of the program update the pulled information in the same columns; even if colums have been added or removed before or after the columns of pulled information.
* Saves partial progress if an unknown (and thus unhandled) error from one of the APIs halts execution.

This repository only contains README files and some portions of [WalmartRefunder](https://github.com/Patricol/JDSports-public/tree/master/WalmartRefunder#walmartrefunder) and [AddressPaster](https://github.com/Patricol/JDSports-public/tree/master/AddressPaster#address-paster) approved (by JD Sports) for public release.
