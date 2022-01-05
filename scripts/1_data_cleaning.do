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

////////////////////////////////////////////////////////////////////////////////
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

* 4. Create unique ID 
bys town_id: gen group_id = _n
tostring group_id, format(%03.0f) replace 
gen unique_id = string(town_id) + group_id	// create as a string 
destring unique_id, replace 				// to numeric 
drop group_id
sort unique_id 
isid unique_id // sanity check 

* 5. Identify missing data (tabmiss command is also useful)
codebook _all , mv 
mvdecode registered_total registered_male registered_female, mv(-999=. \ -998=.)

* 6. Create a dummy for each town_id (can also se done with tab and gen option) 
tab town_id, gen(dummy_town)

* 7. Label variables 
order unique_id 
lab var unique_id "Unique ID (up to 6 digits)"
lab var town_id   "Town id (up to 3 digits)"
lab var turnout_total  "Total turnout (cont.)"
lab var turnout_male   "Total turnout for males (cont.)"
lab var turnout_female "Total turnout for females (cont.)"
lab var registered_total  "Total registered (cont.)"
lab var registered_male   "Total registered males (cont.)"
lab var registered_female "Total registered females (cont.)"
lab def treat 0 "Untreated" 1 "Treated"
lab def treatph 1 "1st T phase" 2 "2nd T phase"
lab val treatment treat 
lab val treatment_phase treatph 
lab var treatment "Intervention variable (binary)"
lab var treatment_phase "Phase of the treatment (binary)"
lab var take_up "Take-up (binary)"
lab var district "District (encoded name)"

compress 
save "$analysis_data_path\data_to_analyze", replace 
