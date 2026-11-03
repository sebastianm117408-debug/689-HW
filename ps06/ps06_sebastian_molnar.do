// Problem Set 6
clear all
set more off
capture log close 
local storage: environment storage
local projects: environment projects 
display "storage = `storage'"
display "projects = `projects'"
capture mkdir "`storage'/econ689_data/ps06"
log using "`storage'/econ689_data/ps06/ps06_sebastian_molnar.txt", text replace
use "`storage'/econ689_data/ps01/data/card.dta", clear
// Problem 3 - B
// Part i 
regress lwage educ exper expersq 
scalar SSR_r=e(rss)
scalar N = e(N)
generate byte ps06_sample = e(sample)
// Part ii
regress lwage educ exper expersq if ps06_sample & south == 0 
scalar SSR_1 = e(rss)
regress lwage educ exper expersq if ps06_sample & south == 1
scalar SSR_2 = e(rss)
scalar SSR_u = SSR_1 + SSR_2
// PArt iii
scalar j=4
scalar df_u= N-8
scalar F_ssr=((SSR_r-SSR_u)/j)/(SSR_u/df_u)
scalar p_ssr=Ftail(j,df_u,F_ssr)
scalar list SSR_r SSR_1 SSR_2 df_u F_ssr p_ssr
// Problem 3 - C
generate double south_educ = south*educ
generate double south_exper = south*exper
generate double south_expersq = south*expersq
regress lwage educ exper expersq south south_educ south_exper south_expersq if ps06_sample
scalar SSR_interacted = e(rss)
scalar list SSR_interacted SSR_u
test south south_educ south_exper south_expersq
scalar F_joint = r(F)
scalar list F_joint F_ssr
log close 

