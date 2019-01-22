# Security

See the security module [README section](https://github.com/Patricol/JDSports-public/tree/master/JDSModules#security) for more info.

## Authorize
* Used to authorize computers/user-accounts so they can use other programs that require API keys.
* Requests the specific account+scope combinations of OAuth2 credentials required to run all of the programs.
  * Prompts the user to login to different accounts as needed; opens browser tabs to the appropriate login prompts.
* Tells the user when all authorizations are up to date.

## UploadCredential
* Upload new API keys for use by all programs.
* Uses JDSCredentials to allow for simple uploading of new API keys or other secrets.
  * Only authorized users can do this.

This repository only contains README files and some portions of [WalmartRefunder](https://github.com/Patricol/JDSports-public/tree/master/WalmartRefunder#walmartrefunder) and [AddressPaster](https://github.com/Patricol/JDSports-public/tree/master/AddressPaster#address-paster) approved (by JD Sports) for public release.
