global INPUT "/Maestría UdeSA/Materias UdeSA/Herramientas computacionales/3. Scrapping/Tarea"

** Datos zipcode
edit
* Paste ZIP from https://www.zipcodestogo.com/Maryland/
drop zipcodemap
bys city: gen n=_n
keep if n==1
drop n
compress
save "$INPUT/MD_zipcodes.dta", replace

** Datos crimen que bajamos de socrata
import delimited "$INPUT/out/crime.csv",clear
keep if year==2015
drop id crime_rate
split name, p(,)
encode name2, gen(state_n)
keep if state_n==2
drop state_n
compress
save "$INPUT/MD_crime.dta", replace

** Merge
use "$INPUT/MD_crime.dta", clear
ren name1 city
merge m:1 city using "$INPUT/MD_zipcodes.dta"
keep if _m==3

** Bajar shapefile y buscar este ID
gen ID=.
replace ID=1	 if county=="Allegany"
replace ID=2	 if county=="Anne Arundel"
replace ID=24	 if county=="Baltimore City"
replace ID=3	 if county=="Baltimore"
replace ID=4	 if county=="Calvert"
replace ID=5	 if county=="Caroline"
replace ID=6	 if county=="Carroll"
replace ID=7	 if county=="Cecil"
replace ID=8	 if county=="Charles"
replace ID=9	 if county=="Dorchester"
replace ID=10	 if county=="Frederick"
replace ID=11	 if county=="Garrett"
replace ID=12	 if county=="Harford"
replace ID=13	 if county=="Howard"
replace ID=14	 if county=="Kent"
replace ID=15	 if county=="Montgomery"
replace ID=16	 if county=="Prince Georges"
replace ID=17	 if county=="Queen Annes"
replace ID=19	 if county=="Somerset"
replace ID=18	 if county=="Saint Marys"
replace ID=20	 if county=="Talbot"
replace ID=21	 if county=="Washington"
replace ID=22	 if county=="Wicomico"
replace ID=23	 if county=="Worcester"

gen incident=subinstr(incident_parent_type, " ", "",.)
drop incident_parent_type
bys county year month incident: egen n_crime=sum(crime_count)
drop name city
bys county: egen zip_m=median(zipc)
bys county year month incident: gen n=_n
keep if n==1

drop n 
replace incident="BreakingnEntering" if incident=="Breaking&Entering"
* Para obtener zipcodes para bajar datos weather
levelsof zip_m
save "$INPUT/MD_crime_2015.dta", replace

use "$INPUT/MD_crime_2015.dta", clear
local crimes "Assault BreakingnEntering Robbery Theft"

local y 0
foreach c of local crimes {
	local y=`y'+1
	use "$INPUT/MD_crime_2015.dta", clear
	keep if incident=="`c'"
	ren n_crime `c'
	tempfile f`y'
	save `f`y''
}

use "$INPUT/MD_crime_2015.dta", clear
bys county year month: gen n=_n
keep if n==1
forv z=1/4 {
	merge 1:1 county year month using `f`z'', nogen
}
drop incident
recode Assault BreakingnEntering Robbery Theft (.=0)
save "$INPUT/MD_crime_2015_wide.dta",replace

**
cd "$INPUT/out/weather"
local manyfiles : dir . files "*.csv"
display `"`manyfiles'"'

tempfile manydatasets

foreach file of local manyfiles {
	import delimited "$INPUT/out/weather/`file'", clear 
	split date, p(-)
	bys date_time2: egen prec_mean=mean(prec)
	keep if date_time3=="01"
	ren location zip_m
	capture append using "`manydatasets'"
	drop maxtempc mintempc totalsnow_cm sunhour uvindex moon_illumination moonrise moonset sunrise sunset dewpointc feelslikec heatindexc windchillc windgustkmph cloudcover humidity pressure tempc visibility winddirdegree windspeedkmph precipmm
	save "`manydatasets'", replace
}

drop date_time3 date_time
ren date_time2 mm
destring mm, gen(month)
ren date_time1 yyyy
destring yyyy, gen(year)
merge m:1 month year zip_m using "$INPUT/MD_crime_2015_wide.dta"
keep if _m==3
drop _m
export delimited "$INPUT/MD_crime_prep.csv", replace