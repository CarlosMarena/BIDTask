/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
File:				0_run.do
Author: 			Carlos Marena 
Email:				carlosmarena1995@gmail.com
Date: 				05/01/2022
Short Description:  This do-file .... 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
////////////////////////////////////////////////////////////////////////////////
* 1. Set absolute and relative paths 
// Absolute path (change where your project is located)
global absolute_path "C:\Users\HP\Documents\GitHub\BIDTask"

// Relative paths 
global data_path 		"$absolute_path\data"
global raw_data_path 	"$data_path\raw_data"
global temp_path 		"$absolute_path\temp"

global script_path 		"$absolute_path\scripts"
global output_path 		"$absolute_path\output" 
global log_path 		"$absolute_path\logs"

global stata_packages_path "$absolute_path\stata_packages"

cd "$absolute_path"

* 2. Set options (uncomment if needed)

// Download raw data (0 for no; 1 for yes)
global downloads 1

// Build dataset used in analysis (0 for no; 1 for yes)
// global build_data 0

// Use restricted data (0 for no; 1 for yes)
// global restricted_access 0 

// Run very slow parts of the analysis code 
// global slow_code 0

// Deprecated code (keep this set to 0)
// global deprecated 0

////////////////////////////////////////////////////////////////////////////////
* 3. Use included packages 
cap adopath - PERSONAL 
cap adopath - PLUS 
cap adopath - SITE
cap adopath - OLDPLACE 
adopath + "stata_packages"
net set ado "stata_packages"

// Download user written packages 
if $downloads == 1{
	// scc install something , replace 
	 ssc install blindschemes, replace
	// ssc install coefplot, replace
}

////////////////////////////////////////////////////////////////////////////////
* 4. Other settings 
// Version 
version 17 

// Close any open log files 
cap log close 

// Clear Mem
clear all 

// Set Date 
global date = subinstr("$S_DATE", " ", "-", .)

// Specify screen width for log files 
set linesize 250

// Set font type 
graph set window fontface "Roboto"

// Set graph scheme
set scheme plotplainblind

// Allow to roll down the screen 
set more off 

// Drop all matrices and scalars 
matrix drop _all 
scalar drop _all 

////////////////////////////////////////////////////////////////////////////////
* 5. Run the do.files 
// do $script_path\1.script_1.do