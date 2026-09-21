clear all
set more off
cd "c:\users\sebas\econ689\ps03"
capture log close 
log using "ps03_sebastian_molnar.log", text replace
// problem 1: Generate the Data
set seed 2026
set obs 500
gen x1=rnormal(2,1)
gen v=rnormal(0,1)
gen x2 = .5*x1+v
gen u=rnormal(0,2)
gen y=3 + 2*x1 - x2 + u
summarize y x1 x2 
twoway (scatter y x1)(lfit y x1),title("y versus x1") xtitle("x1") ytitle("y")
twoway (scatter y x2)(lfit y x2),title("Y versus x2")xtitle("x2")ytitle("y")
//Problem 2: Verify orthogonality of the residuals
regress y x1 x2
predict yhat, xb
predict ehat, residuals
gen x1_ehat=x1*ehat
summarize x1_ehat
display "sum of x1 times residuals" = r(sum)
gen x2_ehat=x2*ehat
summarize x2_ehat
display "sum of x2 times residuals"=r(sum)
twoway (scatter ehat x1)(lfit ehat x1), yline(0)title("residuals vs x1")xtitle("x1")ytitle("residuals")
twoway (scatter ehat x2)(lfit ehat x2),yline(0)title("residuals versus x2")xtitle(x2)ytitle("residuals")
//Problem 3: Verify the residual properties associated with the intercept
sum ehat 
display "sum of residuals" = r(sum)
display "mean of residuals"= r(mean)
summarize yhat
histogram ehat, xline(0)title("OLS residuals")xtitle("residual")ytitle("frequency") frequency
// Problem 4: Verify the Prediction at the average observation
summarize x1
scalar mean_x1=r(mean)
summarize x2
scalar mean_x2=r(mean)
summarize y
scalar mean_y=r(mean)
scalar yhat_at_means = _b[_cons]+_b[x1]*mean_x1+_b[x2]*mean_x2
display "predicted y sample means"=yhat_at_means
display "sample mean of y"=mean_y
//AI disclosure: used ai/google to help look up commands and input the right dictaton as to not run into errors 
log close 