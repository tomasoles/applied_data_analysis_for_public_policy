//do-file for "Introduction to Stata"
cd "/Users/tomasoles/Library/CloudStorage/Dropbox/Teaching/AppliedDataAnalysisForPublicPolicy/scripts"
/*codes in figure 2.2*/
sysuse auto,clear
sum price mpg headroom weight
reg price mpg headroom weight
vif
reg price mpg headroom weight turn displacement ///
length gear_ratio

/*codes in figure 2.3*/
log using "~/AppliedDataAnalysisForPublicPolicy/log/my_first_log.log", replace
sum price mpg headroom weight turn displacement 
log close

use datasets/workout1,clear
describe v03 v04
describe using workout1
codebook v03
browse v01 v02 v03 v04, nolabel
edit v01 v02 v03 v04, nolabel
list v01 v02 v03 v04, nolabel
misstable sum v01 v02 v03 v04 

/*recode examples, not based on a dataset*/
recode var1 (-999=.) or recode var1 -999=.     
recode _all (-999=.) or recode * (-999=.)
mvdecode _all, mv(-999) or mvdecode *, mv(-999)
mvencode _all, mv(-999) or mvencode *, mv(-999)
 
/*back to using the workout1 dataset*/
use datasets/workout1,clear
recode v04 (1/3=1) (4/6=2) (7/9=3)   

/*inputting new data for the replace command*/ 
clear
input str10 exammark mark
"" 93
"" 92
"" 83
"" 76
end
replace exammark="very good" if mark>90
replace exammark="good" if mark<90

/*back to using the workout1 dataset*/
use datasets/workout1,clear
rename v03 Education
rename Education, lower
rename education, upper
rename *, upper
rename *, lower

/*hypothetical examples on gen command*/
gen age2=age^2 	//Age squared
gen id=_n	//numbers observations
gen loghours=log(hours)	//Log of hours
gen pdollar=price/6 	//Price (in Norwegian currency) turned into dollars
gen agecar=2015-year	//The age of car in 2015

/*back to using the workout1 dataset*/
use datasets/workout1,clear
/*generate a new variable using gen and recode*/
recode v04 (1/3=1) (4/6=2) (7/9=3), gen(inccat)  
tab inccat

/*generate a new variable using gen and replace*/
gen inccat2=.
replace inccat2=1 if (v04<=3)
replace inccat2=2 if (v04>=4) & (v04<=6)
replace inccat2=3 if (v04>=7) & (v04<.)
tab inccat2

/*inputting data manually for the egen command use*/
clear
input var1 var2 var3 var4
4 . 2 1
3 2 3 .
5 3 5 3
4 4 4 3 
5 5 5 5
end
gen avg=(var1+var2+var3+var4)/4
list
egen avg2=rowmean(var1 var2 var3 var4)
list
egen zvar1=std(var1)

/*inputting new data manually*/
clear
input var1 var2 var3 var4
4 . 2 1
3 2 3 .
5 3 5 3
4 4 4 . 
5 5 5 5
end
egen tot=rowtotal(var1 var2 var3 var4)
list

/*inputting new data manually*/
clear
input var1 var2 var3 var4
4 . . 1
3 2 3 .
. 3 . .
4 4 4 . 
5 5 5 5
end
list
egen nonmiss=rownonmiss(var1 var2 var3 var4)
list
drop nonmiss
egen rmiss=rowmiss(var1 var2 var3 var4)
list

/*hypothetical example showing encode and decode*/
clear
encode var1, gen(var1_num)
list, nol
decode var1_num, gen(var2)
list

/*back to using the workout1 dataset*/
use datasets/workout1,clear
keep v01 v02 v03 v04
use datasets/workout1,clear
drop v01 v02 v03 v04

/*hypothetical example showing encode and decode*/
drop in 13
drop in 10/12
drop if missing(var5)
drop if missing (var6, var7)
keep if !missing(var4)

/*back to using the workout1 dataset*/
use datasets/workout1,clear
/*gen and labelling*/
gen inccat2=.
replace inccat2=1 if (v04<=3)
replace inccat2=2 if (v04>=4) & (v04<=6)
replace inccat2=3 if (v04>=7) & (v04<.)
label define labinc 1"low income" 2"medium income" 3"high income"
label values inccat2 labinc
tab inccat2

/*hypothetical example showing labelling values of several variables */
label define lablikert 1"disagree" 6"agree" 
label values var1-var5 lablikert

/*back to using the workout1 dataset*/
use datasets/workout1,clear
encode v07, gen(v07_num) //turns v07 into numeric
/*shows frequency distributions*/
tab v07_num
fre v07_num
hist v07_num, discrete percent addlabel xlabel(1/2, valuelabel noticks)
graph pie, over(v07_num) plabel(_all percent)

/*open a Stata installed dataset*/
sysuse auto,clear
/*summary statistics*/
sum price
sum price, d
mean price
tabstat price weight length, stats(mean sd range count) by(foreign)
tabstat price weight length, stats(mean sd range count) by(foreign) col(stats) nototal
tab foreign rep78, sum(mpg)

/*open a Stata installed dataset*/
sysuse nlsw88,clear
hist wage, frequency 
replace race=. if race==3 //category 3 set to missing
graph box wage, by(race)

/*inputting new data manually*/
clear
input id data var1 var2
1 1 3 2
2 1 4 3
3 1 5 1 
end
save dataset1,replace
clear
input id data var1 var2
4 2 3 1
5 2 5 3
6 2 5 4
end
save dataset2,replace
clear
/*appending data*/
append using dataset1 dataset2,gen(dataset3)
save dataset3
list,sep(0)

/*inputting new data manually*/
clear
input id v1_14 v2_14
1 3 5
2 4 5
3 2 3
4 1 2
5 1 2
end
save data14,replace
clear
input id v1_15 v2_15
1 4 5
2 5 5
3 3 4
4 2 3
5 2 3
end
save data15,replace
clear
/*merging data*/
use data14,clear
merge 1:1 id using data15
save data1415,replace 
drop _merge // drops this variable 
list, sep(0)


/*reshape from wide to long*/
use data1415,clear //we use the data from above since it is in a wide format
drop _merge
list
reshape long v1_ v2_ , i(id) j(year)
list









