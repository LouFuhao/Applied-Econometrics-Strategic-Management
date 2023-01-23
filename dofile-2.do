use "\\tsclient\(VMFR)untitled folder 5\RHS_w1_abc.dta"
append using "\\tsclient\(VMFR)untitled folder 5\RHS_w1_d.dta" "\\tsclient\(VMFR)untitled folder 5\CHIP2007_income_and_expenditure_20150408.dta"

* Clean Data
gen married =a07
replace married=0 if a07>1
gen migration = a29
replace migration=0 if a29>3
replace migration=0 if a29<3
gen withinsurance = a18
replace withinsurance=0 if a18>=4
gen goodhealth = a13
replace goodhealth=0 if a13>1
gen badhealth =a13
replace badhealth=0 if a13<2
replace badhealth=0 if badhealth==.
gen stoc = b02
replace stoc=0 if b02<10
replace stoc=0 if stoc==.
replace a08=0 if a08==.
rename a08 numbchi

* Define Variables
gen totalexp = exp1+exp2+exp3+exp4+exp5+exp6+exp7+exp8

replace totalexp=0 if totalexp==.
replace income_net=0 if income_net==.
gen totalincome=totalexp+income_net
gen savingr=(totalincome-totalexp)/totalincome
replace savingr=0 if savingr==.
global xlist migration married withinsurance goodhealth badhealth stoc numbchi 

* Descriptive Statistics
sum savingr $xlist

* OLS regression
reg savingr $xlist, robust

* Instrument Varaible
ivregress 2sls savingr married numbchi stoc withinsurance badhealth  (migration = goodhealth ), r first
estat endogenous

