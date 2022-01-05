/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
File:				2.1_regessions.do
Author: 			Carlos Marena 
Email:				carlosmarena1995@gmail.com
Date: 				05/01/2022
Short Description:  This do-file .... 
					Note that each observation represent a polling booth. 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
use "$analysis_data_path\data_to_analyze", clear 

///////////////////////////////////PART 3////////////////////////////////////
* 15. 
table treatment , statistic(mean turnout_total) 
* 16. 
summ turnout_total
* 17. 
collect clear 
collect create Part3 
collect _r_b _r_se,                    	///
        name(Part3)                 	///
        tag(model[(1)])                	///
        : areg turnout_total treatment registered_total, a(town_id)
collect layout (colname#result) (model[(1)]), name(Part3)
collect get: areg turnout_total treatment registered_total, a(town_id)
collect layout (colname) (result[r(s2) _r_b _r_se])
collect export "$output_path\table1.docx", replace 
* 18. In word 

///////////////////////////////////PART 4////////////////////////////////////
* 19. In word
* 20. * Weak instruments Test - Exactly identified model
global controls registered_total i.town_id 
quietly ivregress 2sls turnout_total (treatment = take_up) $controls, vce(robust)
estat firststage, forcenonrobust all  
* 22. Relative to 18 
ivregress 2sls turnout_total (treatment = take_up) $controls, vce(robust)
