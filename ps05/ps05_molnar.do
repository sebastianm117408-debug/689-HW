//PS05 HW
// Sebastian Molnar
clear all
set more off
capture log close
global storage: env storage
global projects: env projects
global dataready "$storage/econ689_data/ps01/data"
global code "$projects/econ689/ps05"
global output "$code/output"
capture mkdir "$code"
capture mkdir "$output"
log using "$output/ps05_molnar.log", text replace
use "$dataready/card.dta", clear 
// Problem 2: The SSR form of the F test in the card data
use "$dataready/card.dta", clear 
regress lwage educ exper expersq black south smsa smsa66 ///
reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669
//unrestricted SSr and residual degrees of freedom
scalar SSR_u = e(rss)
scalar df_u = e(df_r)
display "unrestricted SSR = " SSR_u
display "N-K = " df_u
// 2.b
test reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669
//save results for part c 
scalar F_test = r(F)
scalar p_test = r(p)
// 2.c
regress lwage educ exper expersq black south smsa smsa66
scalar SSR_r=e(rss)
scalar F_SSR = ((SSR_r-SSR_u)/8)/(SSR_u/df_u)
display "Restricted SSR=" SSR_r
display "F from FFR formuala=" F_SSR
display "F from test command= " F_test
// Problem 3. a
clear 
set seed 2026
set obs 500
// variables 
generate x1 = rnormal(0,1)
generate v = rnormal(0,1)
generate x2 = .5*x1+v
generate x3 = rnormal(1,1)
generate u = rnormal(0,2)
generate y=1+x1+.5*x2-.5*x3+u 
summarize x1 v x2 x3 u y 
regress y x1 x2 x3 
// 3.b
test (x1=1)(x2+x3=0)
scalar F_test3=r(F)
scalar p_test3=r(p)
// 3.c
matrix b = e(b)
matrix V = e(V)
matrix R = (1,0,0,0 \ 0,1,1,0)
matrix r = (1\0)
matrix d = R*b' - r
matrix W = d' * invsym(R*V*R')*d
scalar F_matrix = W[1,1]/2
display "F from matrices= " F_matrix
display "F from test command = " F_test3
log close