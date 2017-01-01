# jxUpdate Manual

## Introduction

jxUpdate allows to update any number of existing articles of a shop at once by importing a CSV file.

## How it works
CSV files are containing usually multiple columns and rows, like an Excel table.

The first column contains the identification value, the text or values which let the module identify the individual product. The following columns are containing the update values. A csv file can have multiple update columns.

The first line (row) of the csv file contains the definition of the database fields, which should be updated. If the name of column is empty, this column will be ignored on import.  
The following lines are containing the update data.

## Examples

#### Import file for a simple deactivation
    oxartnum
    3503
    1302
    400-03
  
#### Import file for updating the EANs
    oxartnum,oxean
    3503,4010281030821
    3504,3057640349263
    400-01,5449000017888
  
#### Import file for updating the buy and sell price
    oxartnum;oxbprice;oxprice
    3503;15.5;29.75
    3504;12.5;24.75
    400-01;3.5;7.75
  
#### Import file for updating the buy price (with enclosure character)
    "oxartnum","oxbprice"
    "3503","15.5"
    "3504","12.5"
    "400-01","3.5"

## Possible Database Fields

For the update you can use the following database fields

* **OXACTIVE** - Active/Inactive  
0 = Deactivated  
1 = Activated
* **OXEAN** - EAN Number
* **OXDISTEAN** - Manufacturer EAN Number
* **OXPRICE** - Selling prices
* **OXBPRICE** - Purchase price
* **OXTPRICE** - RRP price
* **OXSTOCK** - Stock amount
* **OXSTOCKFLAG** - Stock flag  
1 = Standard  
2 = If out of Stock, offline  
3 = If out of Stock, not orderable  
4 = External Storehouse
* **OXDELIVERY** - Available on (format _YYYY-MM-DD_)
* **OXMINDELTIME** - Minimum delivery time
* **OXMAXDELTIME** - Maximum delivery time
* **OXDELTIMEUNIT** - Unit of delivery time  
DAY = days  
WEEK = weeks  
MONTH = months
* **OXREMINDACTIVE** - Reminder e-mail, if stock amount is lower than _OXREMINDAMOUNT_
* **OXREMINDAMOUNT** - Reminder e-mail threshold
* **OXSTOCKTEXT_ _n_** - In stock message, for language no. _n_ 
* **OXNOSTOCKTEXT_ _n_** - Out of stock message, for language no. _n_ 

## Settings

The way of updating the products and importing the data can be setup under _Extensions_ - _Module_ - _jxUpdate_ - _Settings_.  
![Settings](https://github.com/job963/jxUpdate/raw/master/docs/img/settings-en.png)

#### Delimiter Character
The database fields / columns in the csv file can be separated by three different characters (comma, semicolon or tabulator). This helps to avoid using delimiter character which are part of the database fields and will be misunderstood as delimiter sign.

#### Enclosure Character
Using an enclosure character allows to use the delimiter character also inside of the the database fields. The enclosure character must surround each column.

#### Identification Field
The values of this columns will be compared with several fields of the product set. 
Actually the following fields are supported: _product number_, _manufacturer product number_, _EAN_ and _manufacturer EAN_

#### Compare Mode
The values of the _Identification Field_ column can be compared by using the following modes: _equal_, _begins with_, _ends with_ oder _contains_

**Examples:**  
equal: 123 = 123  
begins with: 123XYZ = 123  
ends with: ABC123 = 123  
contains: ABC123XYZ = 123

#### Include deactivated products
This option sets up, if deactivated products will be processed by the update or not.