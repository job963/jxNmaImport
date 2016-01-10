#jxAdminLog#

OXID eShop Admin Extension for Updating Articles by an Import File


## Setup ##

1. Unzip the complete file with all the folder structures and upload the content of the folder copy_this to the root folder of your shop.
2. After this navigate in the admin backend of the shop to _Extensions_ - _Modules_. Select the module _jxUpdate_ and click on `Activate`.

  
## Screenshots ##

#### Overview of found products ####
![Object History Log](https://github.com/job963/jxUpdate/raw/master/docs/img/found-products.png)

#### Settings ####
![Full Log Report](https://github.com/job963/jxUpdate/raw/master/docs/img/settings-en.png)

## Example Import Files ##

#### Import for simple Deactivation ####
    oxartnum
    3503
    1302
    400-03
  
#### Import for Price Update ####
    oxartnum;oxbprice;oxprice
    3503;15.5;29.75
    3504;12.5;24.75
    400-01;3.5;7.75


**A detailed manual you'll find [here](https://github.com/job963/jxUpdate/blob/master/docs/help.md).**