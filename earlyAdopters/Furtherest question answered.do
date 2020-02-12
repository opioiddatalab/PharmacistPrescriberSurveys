// Early adopter analysis for IPCE abstract
//

cd "/Users/nabarun/Dropbox/Projects/P1 Surveys"
clear all
set more off

use prescriberky

di "Exclude non-controlled substance prescribers and incomplete surveys:"
keep if contr_sub==1
distinct record_id

di "Check within early adopters:"
gen early=0
    la var early "Enjoys novel prescribing"
        replace early = 1 if early_adopt___1==1 | early_adopt___3==1 | early_adopt___4==1
            tab early

foreach x of varlist _all {
rename `x' zz`x'
} 
rename zz* v#, renumber
    rename v1 id
		rename v106 early
        gen incomplete=regexm(lower(v3),"not completed")
            * Drop free text strings
                drop v2 v4 v3 v12 v13 v21 v33 v63 v65 v73 v81 v82 v98 v101 v104

reshape long v, i(id)
    drop if v==. & _j!=2
        drop if inlist(v,0,1,2)

bysort id: egen last = max(_j) 
    drop _j v 

duplicates drop

di "Describe length of completeness among incomplete surveys:"
tab last if incomplete==1

di "Look at distribution within early prescribers:"
tab last if incomplete==1 & early==1
