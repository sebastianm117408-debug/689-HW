*ECON 689 — Problem Set 1
*Name: Sebastian Molnar
clear all
set more off
capture log close
global projects: env projects
global storage : env storage
global dataready "$storage/econ689_data/ps01/data"
global code      "$projects/econ689/ps01"
global output    "$projects/econ689/ps01/output"
capture mkdir "$storage/econ689_data"
capture mkdir "$storage/econ689_data/ps01"
capture mkdir "$dataready"
capture mkdir "$code"
capture mkdir "$output"
log using "$output/ps01_sebastianmolnar.log", text replace
display "$storage"
display "$projects"
display "$dataready"
display "$code"
display "$output"
*Problem 2 - Generate data and estimate OLS regressions
set seed 68901
set obs 500
generate v=rnormal(8,2.5)
generate study_hours=max(0,v)
generate w=rnormal(3,.45)
generate prior_gpa=min(4,max(0,w))
generate u=rnormal(0,5)
generate exam_score=45+2.5*study_hours+6*prior_gpa+u
summarize study_hours prior_gpa exam_score
regress exam_score study_hours
predict fitted_exam, xb
predict residual_exam, residuals
summarize residual_exam
regress exam_score study_hours prior_gpa
save "$dataready/ps01_simulated_data.dta", replace
confirm file "$dataready/ps01_simulated_data.dta"
display "simulated dataset found"
*problem 3 - Card's schooling and earnings data
use "$dataready/card.dta", clear
describe lwage educ exper expersq black south smsa nearc4
summarize lwage educ exper expersq black south smsa nearc4
regress lwage educ
display .0520942*100
display 100*(exp(.0520942)-1)
regress lwage educ exper expersq black south smsa
display .074009-.0520942
capture drop fitted_log_wage residual_log_wage
predict fitted_log_wage, xb
predict residual_log_wage, residuals
summarize residual_log_wage
regress educ nearc4
log close 