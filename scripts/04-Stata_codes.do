//do-file for "Visualization in Stata"

cd "~/AppliedDataAnalysisForPublicPolicy/scripts"

* Replicating Anscombe’s quartet
clear
set obs 111
generate x = _n
generate y1 = 10 + x
generate y2 = 20 - x
generate y3 = 15 + mod(x, 3)
generate y4 = cond(x <= 5, 10 + x, 20 - x)
list

* Summarize the data
summarize x y1 y2 y3 y4
* Correlation between variables
correlate x y1 y2 y3 y4


* Plotting the data
twoway (scatter y1 x, msymbol(o)) ///
	(scatter y2 x, msymbol(x)) ///
	(scatter y3 x, msymbol(+) color(red)) ///
	(scatter y4 x, msymbol(T)), legend(on)
	
	
* Histogram of age at first kiss
clear
input age_kiss
1
1
14 
14 
15 
16 
17 
18 
13 
13 
18 
19 
20 
15 
14 
16 
18 
17
end

histogram age_kiss, bin(5) frequency ///
	title("Age at First Kiss") xlabel(0(5)20) xtitle("Age at First Kiss")
	
	
	
	
* Histogram of Facebook visits
clear
input fb_visits
2 
4 
6 
8 
10 
12 
1 
3 
5 
7 
9 
11 
150 
170
end

histogram fb_visits, bin(6) frequency ///
title("Facebook Visits per Day") xlabel(0(20)170) xtitle("Facebook Visits/Day")



* Summarize Palmer Penguins dataset
clear
use datasets/penguins.dta, clear
summarize flipper_length_mm body_mass_g bill_length_mm bill_depth_mm

* Scatter plot of penguin bill dimensions by species
twoway (scatter bill_length_mm bill_depth_mm if species == "Adelie", msymbol(o) ///
	mcolor(blue) lcolor(blue)) ///
	(scatter bill_length_mm bill_depth_mm if species == "Chinstrap", ///
	msymbol(o) mcolor(red)) ///
	(scatter bill_length_mm bill_depth_mm if species == "Gentoo", ///
	msymbol(o) mcolor(green)), ///
	legend(off) title("Penguin Bill Dimensions") ytitle("Bill Depth") xtitle("Bill Lenght")

	
* Load Lending Club dataset
use datasets/loans.dta, clear 

* Peek at the data
list loan_amount interest_rate term grade state annual_income ///
homeownership debt_to_income in 1/10

* Histogram of loan amounts
histogram loan_amount, bin(20) frequency ///
	title("Loan Amounts in Lending Club Data") 
	
	
* Histogram with binwidth of $1000
histogram loan_amount, bin(40) frequency ///
 title("Loan Amounts with Smaller Binwidth")

* Histogram with binwidth of $5000
histogram loan_amount, bin(8) frequency ///
 title("Loan Amounts with Larger Binwidth")
 
* Box plot of interest rates
graph box interest_rate, title("Interest Rates") ///
 ylabel(0(5)30)
 
* Encode categorical (ordered/ordinal) variable 
encode grade, gen(grade_en)

* Box plot of interest rates by grade
graph box interest_rate, title("Interest Rates over Grades") ylabel(0(5)30) ///
	over(grade_en)
	
* Scatter plot of debt-to-income vs. interest rate
label variable interest_rate "Interest rate"
label variable debt_to_income "Debt to Income Ratio"

twoway (scatter interest_rate debt_to_income, msymbol(o)) ///
 , title("Debt-to-Income vs. Interest Rate")
 
* Scatter plot of debt-to-income vs. interest rate with regression line
twoway (scatter interest_rate debt_to_income, msymbol(o)) ///
       (lfit interest_rate debt_to_income, lcolor(black) lwidth(medium)) ///
       , title("Debt-to-Income vs. Interest Rate") ///
       legend(order(1 "Data points" 2 "Regression line"))

* Violin plot 
ssc install vioplot
vioplot loan_amount, over(grade) title("Loan Amount over Grades")

* Time series (make your graphs beautiful (using palettes))
ssc install palettes, replace
ssc install colrspace, replace

graph query, scheme

sysuse uslifeexp, clear

line le_wfemale le_wmale le_bfemale le_bmale year, ytitle(Life expectancy)

line le_wfemale le_wmale le_bfemale le_bmale year, ytitle(Life expectancy) ///
	scheme(plotplainblind)

