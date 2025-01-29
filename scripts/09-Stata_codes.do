//do-file for "Interaction effects using regression"
cd "~/AppliedDataAnalysisForPublicPolicy/scripts"

use datasets/workout.dta,clear //need to move "workout.dta" to your current directory 

//generating a product/interaction term using Stata
gen healthage=health*age
//and then estimating the interaction model
reg whours health age healthage
//alternatively
reg whours c.health c.age c.health#c.age
//alternatively and even further shortened command
reg whours c.health##c.age

//interaction between a continuous predictor and a continuous moderator
reg whours c.health c.age c.health#c.age 
//estimating slope on health at different values of educ
margins, dydx(health) at(age=(16(10)76))
//visualise the interaction effect
margins, at(health=(1(1)6) age=(16(10)76)) 
marginsplot, noci x(health) recast(line)

//interaction between a continuous predictor and a dummy moderator
reg whours c.age i.gender c.age#i.gender
//estimating the slope on age for two genders by typing either of the following two commands 
margins, dydx(age) at(gender=(0 1))
margins gender, dydx(age)
//visualise the interaction effect
margins, at(age=(20(10)60) gender=(0 1)) 
marginsplot, noci x(age) recast(line)

//interaction between a dummy predictor and a dummy moderator
reg whours i.gender i.marital i.gender#i.marital
//estimating the slope on gender for singles and married
margins, dydx(gender) at(marital=(0 1))
//visualising the interaction effect
margins, at(gender=(0 1) marital=(0 1))
marginsplot, noci x(gender) recast(line)

//interaction between a continuous predictor and a polytomous moderator 
reg whours c.age i.educ c.age#i.educ
//estimating the slope on age at different values of educ by typing either of the following commands
margins, dydx(age) at(educ=(1 2 3))
margins educ, dydx(age)
//visualising the interaction effect
margins, at(age=(20(10)60) educ=(1 2 3))
marginsplot, noci x(age) recast(line)
//testing the overall of significance of the polytomous variables
//by typing either of the following two commands
test (2.educ#c.age 3.educ#c.age)
testparm i.educ#c.age





