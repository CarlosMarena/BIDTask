/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
File:				1_data_cleaning.do
Author: 			Carlos Marena 
Email:				carlosmarena1995@gmail.com
Date: 				05/01/2022
Short Description:  This do-file .... 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

////////////////////////////////////////////////////////////////////////////////
* 1. Import and convert files 
import excel "$raw_data_path\Data for Analysis Test.xlsx", firstrow clear 
compress 
save "$raw_data_path\Data for Analysis Test.dta" , replace 
 
import excel "$raw_data_path\Town Names for Analysis Test.xlsx", firstrow clear 
ren (TownID TownName) (town_id town_name) // homogenize names 
compress 
save "$raw_data_path\Town Names for Analysis Test.dta" , replace

* 2. Merge 
use "$raw_data_path\Data for Analysis Test", clear 
codebook town_id // 51 missings out of 7021 obs 
keep if !mi(town_id) // drop irrelevant towns 
cap isid town_id // in master data file town_id does not uniquely identify obs 

merge m:1 town_id using "$raw_data_path\Town Names for Analysis Test", nogen keep(3)

* 3. Encode district variable 
encode district, gen(distr2)
drop district 
ren distr2 district 

* 4. Create ID 
gen unique_id = 