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
table (district) (treatment) if turnout_tot_rate >= 0.75, ///
	nototals statistic(mean turnout_fem_rate) nformat(%6.3f mean)
ttest turnout_fem_rate if turnout_tot_rate >= 0.75, by(treatment) 
// Comment: Even though there exists a difference of approx 0.19 pp., the null 
// hypothesis of the t-test suggests that there is no statistical difference (at
// 5% significance level) in the avg turnout rate for females in treatment and 
// control groups (note that this could also be seen by the small t which is //
// less than 1.96.).

* 13. Graph
gen turnout_male_rate = turnout_male/registered_male 
graph bar (mean) turnout_fem_rate turnout_male_rate turnout_tot_rate, over(treatment) ///
	yvaroptions(relabel(1 "Females" 2 "Males" 3 "Total")) ///
	blabel(total, pos(outsise) format(%3.2f)) ///
	title("Average Female, Male and Total average turnout rates") ///
	subtitle("by treatment status") ///
	ytit("Percent (%)")
export graph ""
   

