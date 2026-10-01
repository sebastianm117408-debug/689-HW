//Sebastian Molnar
//Econ 689 Problem Set 4 
clear all
set more off
capture log close 
cd "C:\Users\sebas\OneDrive - Texas A&M University\econ689_data\ps04"
log using "ps04_sebastianmolnar.log", text replace
//problem 1 - Generate the data and estimate the full regression
set seed 2026
set obs 500
generate x2=rnormal(1,1)
generate v=rnormal(0,1)
generate x1=.7*x2+v
generate u=rnormal(0,2)
generate y=5+3*x1-2*x2+u
summarize y x1 x2 
regress y x1 x2 
scalar b1_full=_b[x1]
display b1_full
//Problem 2: Verify the FWL Theorem 
regress y x2
predict y_resid, residuals 
regress x1 x2
predict x1_resid, residuals
//Graph of Residuals 
twoway (scatter y_resid x1_resid)(lfit y_resid x1_resid), title("relationship after controlling for x2")xtitle("x1 residuals")ytitle("y residuals") 
regress y_resid x1_resid, noconstant 
scalar b1_fwl=_b[x1_resid]
display "full regression: " b1_full
display "FWL coefficent: " b1_fwl
display "difference: " b1_full-b1_fwl
log close 
