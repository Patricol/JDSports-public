# Address Paster

## Impact
* "75% time saved per order. Saves 1-2 hours per person per day and up to 10 hours depending on volume every day. Also drastically reduced fulfillment errors and human errors which has probably saved $3,000 since we started using it [six months ago]."​

## Functionality
* A hotkey-controlled program that quickly copies and pastes shipping addresses from and into forms on many different websites; handling formatting conversion etc.
* Complete with a help menu and debug options.
  * The help menu is shown in the image below.
    * When an address is copied; the help menu updates to show how AddressPaster has interpreted the address.
  * Allows reconfiguring the delay between actions for debugging or use on slower computers.
* Fills in any required website-specific static information.
* Handles elements like radio buttons and drop down lists; in addition to the basics.
* Handles splitting, converting, and formatting addresses, names, and phone numbers without using external libraries.
* Provides visual feedback (splash text) when a macro finishes running.
* Supported websites can be seen in the image below.
  * Additionally; these are implemented but disabled by request:
    * Toys R Us (RIP)
    * CollectionsEtc
* Very maintainable and flexible.
  * Website-specific routines are generally one function call per required field. (Ignoring Tab key usage.)
    * All of the heavy lifting is handled in reusable/website-independent functions.
* Written in AutoHotkey.
* Repository also includes:
  * Saved copies of relevant webpages; for testing.
  * Custom simple HTML pages that behave the same way as the websites' address forms; to simplify testing.

![help_menu](https://raw.githubusercontent.com/Patricol/JDSports-public/master/AddressPaster/AddressPaster%20Help.png)

This repository only contains README files and some portions of [WalmartRefunder](https://github.com/Patricol/JDSports-public/tree/master/WalmartRefunder#walmartrefunder) and [AddressPaster](https://github.com/Patricol/JDSports-public/tree/master/AddressPaster#address-paster) approved (by JD Sports) for public release.
