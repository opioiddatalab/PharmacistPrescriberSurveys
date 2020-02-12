// Early adopter analysis for IPCE abstract
//

cd "/Users/nabarun/Dropbox/Projects/P1 Surveys"
clear all
set more off

frame create pharm
frame pharm: use pharmacistky

frame create docs
frame docs: use prescriberky

frame dir

frame change docs

//	Excclude non-controlled substance prescribers and incomplete surveys
keep if contr_sub==1
	* n=206 deleted
keep if physician_survey_complete==2
	* n=142 deleted
	
//	Create variables for early adopters

foreach var of varlist early_adopt* {
tab `var'
}

gen earliest=0
	la var earliest "Self-identified early adopters"
		replace earliest = 1 if early_adopt___1==1
			tab earliest
		
gen early=0
	la var early "Possible early prescribing enjoyment"
		replace early = 1 if early_adopt___1==1 | early_adopt___3==1 | early_adopt___4==1
			tab early

//	Create composite variables for ADF prescribing

local adfs "embeda hysinglaer morphabonder xtampzaer oxycontin"
foreach i of local adfs {
	gen any`i'=0
		replace any`i'=1 if inlist(`i',2,3,4,5)
			order any`i', a(`i')
				tab any`i'
					la var any`i' "Any reported prescribing of `i'"
}

gen anyadf=0
	replace anyadf=1 if anyembeda==1 | anyhysinglaer==1 | anymorphabond==1 | anyxtampzaer==1 | anyoxycontin==1
		la var anyadf "Any ADF prescribing"
			tab anyadf

gen anynotocadf=0
	replace anynotocadf=1 if anyembeda==1 | anyhysinglaer==1 | anymorphabond==1 | anyxtampzaer==1
		la var anyadf "Any non-OxyContin ADF prescribing"
			tab anynotocadf


	
// Innovative nature of abuse-deterrence mechanisms `innovate'
tab innovate early

// How do the medical specialties of early prescribers compare to not early prescribers?


//	Are early prescribers more likely to use risk stratification tools?
	
	* Dichotomoize screening tool use
	gen screener = 0
		replace screener = 1 if riskstrat!=. | othrriskstrat!=""
			la var screener "Dichotomized risk stratification tool use (constructed)"
			
			

tab screener early, col m
cc screener early
	* 32% early versus 24% not early, x2 1.8, p=0.17
	
