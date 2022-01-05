/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
File:				2.0_descriptive_statistics.do
Author: 			Carlos Marena 
Email:				carlosmarena1995@gmail.com
Date: 				05/01/2022
Short Description:  This do-file .... 
					Note that each observation represent a polling booth. 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

////////////////////////////////////////////////////////////////////////////////

use "$analysis_data_path\data_to_analyze", clear 

* 9. Average turnout total rate 
gen turnout_tot_rate = turnout_total/registered_total  
summ turnout_tot_rate, detail // the avg turnout total rate is aprox. 57% 
count if turnout_tot_rate == `r(max)' // 20 recorded 1 as a turnout total rate 

* 10. Tabulate treatment phase by treatment 
tab treatment treatment_phase, row // seems that phase is balanced within treatment 

* 11. Tabulate .. (Warning: Syntax assume you have Stata v17)
gen turnout_fem_rate = turnout_female/registered_female
table (district) if turnout_tot_rate >= 0.75, statistic(mean turnout_fem_rate)

* 12. Are there differences? 


