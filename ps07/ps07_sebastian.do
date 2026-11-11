clear all 
set more off 
// Enviromental variables 
local storage: environment storage 
local projects: environment projects 
//data and outputs 
global data "`storage'/econ689_data/ps01/data"
global output "`storage'/econ689_data/ps07/output"
// folders
capture mkdir "`storage'/econ689_data/ps07"
capture mkdir "$output"
//text log 
capture log close 
log using "$output/ps07_sebastian.log", text replace 
//data set 
use "$data/card.dta", clear 
//question 2 
// Part A
reg lwage educ exper expersq black south smsa 
//standard error of the education coefficient 
scalar se_classical = _se[educ]
// OLS with Huber-White 
reg lwage educ exper expersq black south smsa, vce(robust)
//save robust standard error of education coefficeint 
scalar se_robust = _se[educ]
//show standard errors
display "SE of educ= " se_classical
display "Robust SE of educ = " se_robust
// Part B
// creating 1966 region variable 
generate region66 = .
forvalues j = 1/9 {
	replace region66= `j' if reg66`j'==1
	}
tabulate region66, missing 
// estimate wage equation with clustered standard errors 
reg lwage educ exper expersq black south smsa, vce(cluster region66)
scalar C=e(N_clust)
scalar se_cluster_educ = _se[educ]
scalar se_cluster_south = _se[south]
display "number of clusters" = C
display "residual degrees of freedom= " e(df_r)
display "clustered SE of educ = " se_cluster_educ
display "clustered SE of south = " se_cluster_south
// confidence interval by hand (95%)
scalar t_critical = invttail(C-1,.025)
scalar ci_lower = _b[educ] - t_critical * se_cluster_educ
scalar ci_upper = _b[educ] + t_critical * se_cluster_educ
display "crit t value = " t_critical
display "95% CI lower bound = " ci_lower
display "95% CI upper bound = " ci_upper 
// verify using stata
lincom educ, level(95)
display "robust SE of educ = " se_robust 
display "clustered SE of educ = " se_cluster_educ
// Part C
// Re-estimate with robust standard errors 
reg lwage educ exper expersq black south smsa, vce(robust)
scalar theta_hat = -_b[exper]/(2*_b[expersq])
nlcom (theta: -_b[exper]/(2*_b[expersq]))
matrix delta_V=r(V)
scalar se_delta = sqrt(delta_V[1,1])
// test is peak occurs at 20 experience 
testnl -_b[exper]/(2*_b[expersq])= 20
test exper + 40*expersq=0
// Part D
bootstrap b_educ=_b[educ] tp=(-_b[exper]/(2*_b[expersq])), reps (1000) seed(689 ) saving ("$output/ps07_boot.dta", replace): reg lwage educ exper expersq black south smsa 
// compare bootstrap stnadard errors
display "bootstrap SE of educ = " _se[b_educ]
display "robust SE of educ = " se_robust
display "boostrap SE of theta = " _se[tp]
display "delta-method SE of theta = " se_delta
preserve 
use "$output/ps07_boot.dta", clear 
summarize tp, meanonly 
scalar theta_boot_mean = r(mean)
//shift bootstrap so it mean equals 20
generate theta_null = tp - theta_boot_mean + 20
generate extreme = abs(theta_null-20) >= abs(theta_hat-20) if !missing(theta_null)
summarize extreme, meanonly 
scalar p_boot = r(mean)
display "bootstrap p-value for theta=20: " p_boot 	
restore 
log close 