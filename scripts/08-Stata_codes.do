//do-file for "Dummy-variable regression"
cd "~/AppliedDataAnalysisForPublicPolicy/scripts"

use datasets/flat2.dta,clear 

set cformat %9.1f
set sformat %7.4f
set pformat %4.3f

codebook location

//one way to create a set of dummy variables 
generate centre = 0
replace centre=1 if location==1
generate south = 0
replace south=1 if location==2 
generate west = 0
replace west=1 if location==3 
generate east= 0
replace east=1 if location==4   

//a more effective way of creating a set of dummy variables
tabulate location, generate(d_location)  

//we regress flat prices on location consisting four categories
reg flat_price i.location

//to see the baselevel we type and then run the regression 
set showbaselevels on, permanently

//we can easily change the reference group by typing either of the below
reg flat_price ib(2).location
reg flat_price b2.location

//regression with one dummy variable by typing 
use datasets/flat2.dta,clear 
generate centre = 0
replace centre=1 if location==1
reg flat_price centre
//More effectively, we can instead type either of the below two
reg flat_price i(1).location
reg flat_price i1.location
//If you want to compare the second category with the rest
reg flat_price i(2).location
reg flat_price i2.location

//regression with a dummy and a covariate
reg flat_price centre floor_size
//estimated mean-Y at 0 and 1 of centre
margins, at(centre=(0 1))

//regression with more than one dummy variable
reg flat_price i.location
//re-estimation by changing the reference group
reg flat_price ib(2).location, noheader
reg flat_price ib(3).location, noheader

//linear combination of coefficients 
lincom _b[3.location]- _b[2.location]
lincom _b[4.location]- _b[2.location]
lincom _b[4.location]- _b[3.location] 

//as an alternative to re-estimation/linear combination
pwcompare location, effects
//pairwise comparison with adjustment
pwcompare location, effects mcompare(scheffe)

//regression with more than one dummy variable and a covariate
reg flat_price i.location floor_size
//estimated mean-Y by typing either of the below two commands
margins, at(location=(1 2 3 4)) noatlegend 
margins location, noatlegend

//regression with two separate sets of dummy variables
reg flat_price i.location i.energy_efficiency
//the joint significance of the coefficients
testparm i.location
testparm i.energy_efficiency   







