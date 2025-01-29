//do-file for "Visualization in Stata (II)"

cd "~/AppliedDataAnalysisForPublicPolicy/scripts"


*** Line Graphs
/* inspect the data to get a better idea about the data types */
use "https://dss.princeton.edu/training/wdipol.dta", clear


browse
describe
summarize

/* generate a line graph for the variables unemp unempf unempm for the United States */

line unemp unempf unempm year if country=="United States", legend(cols(2))
graph export eda_1.pdf, as(pdf) replace

/*the graph does not look good, let's check the variables more carefully */

summarize unemp unempf unempm

/* we see each of the variables contains 0% unemployment rates, let us remove zeros for each variable to get a nicer-looking graph*/

replace unemp=. if unemp==0
replace unempf=. if unempf==0
replace unempm=. if unempm==0

/* stata now gives us a better-looking graph */

line unemp unempf unempm year if country=="United States", legend(cols(2))
graph export eda_2.pdf, as(pdf) replace

/*let's add a legend, line pattern, y-axis title, and graph title to make the graph more beautiful */

line unemp unempf unempm year if country=="United States", ///
	title("Unemployment rate in the US, 1980-2012") ///
	legend(label(1 "Total") label(2 "Females") label(3 "Males")) ///
	lpattern(solid dash dash_dot) ///
	ytitle("Percentage")
graph export eda_3.pdf, as(pdf) replace
	
/* we can present the above graph by connecting the lines and adding symbols (circle, diamond, square, etc.) to the lines */
twoway connected unemp unempf unempm year if country=="United States", ///
	title("Unemployment rate in the US, 1980-2012") ///
	legend(label(1 "Total") label(2 "Females") label(3 "Males")) ///
	msymbol(circle diamond square) ///
	ytitle("Percentage")
graph export eda_4.pdf, as(pdf) replace

	
/* we can use stata's two-way connected command to create separate line graphs for a selected set of countries */
twoway connected unemp year if country=="United States" | ///
	country=="United Kingdom" | ///
	country=="Australia" | ///
	country=="Qatar", ///
	by(country, title("Unemployment Rate")) ///
	msymbol(circle_hollow)
graph export eda_5.pdf, as(pdf) replace

/* we can present lines for each country above in a single graph */
twoway (connected unemp year if country=="United States", msymbol(	diamond_hollow)) ///
	(connected unemp year if country=="United Kingdom", msymbol(triangle_hollow)) ///
	(connected unemp year if country=="Australia", msymbol(square_hollow)) ///
	(connected unemp year if country=="Qatar", ///
	title("Unemployment Rate") ///
	msymbol(circle_hollow) ///
	legend(label(1 "USA") label(2 "UK") label(3 "Australia") label(4 "Qatar")))
graph export eda_6.pdf, as(pdf) replace

	

/*let's now generate a similar graph for the variable gdppc */
twoway connected gdppc year if gdppc>40000, by(country) msymbol(diamond)
graph export eda_7.pdf, as(pdf) replace


/*we can add more than one line in each of the graphs of a panel graph. Let us create two new variables, gdppc_mean and gdppc_median */
bysort year: egen gdppc_mean=mean(gdppc)
bysort year: egen gdppc_median=median(gdppc)

/*let's now generate line graphs for the variables gdppc_mean and gdppc_median for selected countries */


twoway connected gdppc gdppc_mean year if country=="United States" | ///
	country=="United Kingdom" | ///
	country=="Australia" | ///
	country=="Qatar", ///
	by(country, title("GDP pc (PPP, 2005=100)")) ///
	legend(label(1 "GDP-PC") label(2 "Mean GDP-PC")) ///
	msymbol(circle_hollow)
graph export eda_8.pdf, as(pdf) replace

	
/* declare the dataset as a panel data */
xtset country year

/*running the codes gives us an error message as the country variable is strings. To assign numeric values to the string variable country */
encode country, gen(country1)

/* again, declare the dataset as a panel data and plot */
xtset country1 year
xtline gdppc if gdppc>35000, overlay ///
title(Per Capita GDP for the Richest Countries) 
graph export eda_9.pdf, as(pdf) replace

*** Bar graphs
use "https://dss.princeton.edu/training/wdipol.dta", clear

/* create a horizontal bar graph for the variable gdppc for each country in the dataset */ 

graph hbar (mean) gdppc, over(country, sort(1) descending label(labsize(*0.50)))
graph export eda_10.pdf, as(pdf) replace


/* country names in the graph are unclear, to make the graph clearer, we may keep the countries with a mean per capita GDP greater than $18,000 */
graph hbar (mean) gdppc if gdppc>18000, ///
	over(country, sort(1) descending label(labsize(*0.7))) ///
	bar(1, color(ebblue))  
graph export eda_11.pdf, as(pdf) replace

/* for the countries with per capita GDP less than $1500*/
graph hbar (mean) gdppc if gdppc<1500, ///
	over(country, sort(1) descending label(labsize(*0.6))) ///
	bar(1, color(ebblue))
graph export eda_12.pdf, as(pdf) replace

/* we can compare mean per capita GDP with the median per capita GDP for the countries with gdppc>18000. */

graph hbar (mean) gdppc (median) gdppc if gdppc>18000, ///
	over(country, sort(1) descending label(labsize(*0.8))) ///
	legend(label(1 "GDPpc (mean)") label(2 "GDPpc (median)")) ///
	bar(1) ///
	bar(2)
graph export eda_13.pdf, as(pdf) replace

*** Box plots 
use "https://dss.princeton.edu/training/wdipol.dta", clear

/* create a basic boxplot for the variable gdppc */
graph hbox gdppc
graph export eda_14.pdf, as(pdf) replace

/* we see lots of outliers when gdppc is greater than 40,000, we can set the maximum value for gdppc to get a better idea about the min, max, median, and quartile values */

graph hbox gdppc if gdppc <40000
graph export eda_15.pdf, as(pdf) replace


/* we will now create a boxplot for the variable gdppc with respect to a categorical variable. Let us recode the polity2 variable and make a categorical variable regime  based on it. currently, polity2 ranges between -10 and 10. we will create the regime variable with three categories by defining autocracy with a score of -10 and -6, anocracy with a score of -5 and 6, and democracy with a score of 7 to 10. */

tab polity2
recode polity2 (-10/-6=1 "Autocracy") ///
	(-5/6=2 "Anocracy") ///
	(7/10=3 "Democracy") ///
	(else=.), ///
	gen(regime) label(polity_rec)


/* inspect the newly created regime variable */

tab regime
tab regime, nolabel 
tab country regime 
tab country regime, row

/* we can generate a boxplot for gdppc with respect to the categorical variable regime */
graph box gdppc, over(regime) yline(9482.966) ///
	title("Regime Type and Per capita GDP")
graph export eda_16.pdf, as(pdf) replace

/* we can create the above graph with the horizontal boxplot */
graph box gdppc, over(regime) horizontal yline(9482.966) ///
	title("Regime Type and Per capita GDP") 
graph export eda_17.pdf, as(pdf) replace
	
/* we can create a boxplot for two numerical variables (gdppc and trade) with respect to a categorical variable (regime). change the scales of the variables gdppc and trade by taking logs, which would provide a nicer boxplot */

gen log_gdppc = log(gdppc)
gen log_trade = log(trade)
graph box log_gdppc log_trade, over(regime)  ///
	title("Regime Type, Per capita GDP, and International Trade") 
graph export eda_18.pdf, as(pdf) replace
	
*** Scatterplots 
/* let's create a basic scatterplot for the variables export and import */
use "https://dss.princeton.edu/training/wdipol.dta", clear
scatter import export
graph export eda_19.pdf, as(pdf) replace

/* we will add a line graph fitting the export and import values. We also add some codes to make the graph more informative and beautiful */
scatter import export, title("Export and Import") ytitle("Import (const 2005 USD)") xtitle("Export (const 2005 USD)") mcolor(navy) || lfit import export, legend(off) 
graph export eda_20.pdf, as(pdf) replace

/* mention the names of the outlier countries */
twoway (scatter import export, title("Export and Import") ytitle("Imports") xtitle("Exports")) ///
	(scatter import export if export>1000000, mlabel(country) legend(off)) ///
	(lfit import export, note("Constant values, 2005, millions US$"))
graph export eda_21.pdf, as(pdf) replace

*** Histograpms with density plots
/* let's start with a simple histogram showing the probability density of the continuous variable unemployment*/

use "https://dss.princeton.edu/training/wdipol.dta", clear
hist unemp
hist gdppc

/* we will get better-looking histogram for the variable gdppc if you report fraction instead of density in the y-axis */
hist gdppc, fraction
graph export eda_22.pdf, as(pdf) replace


/* we can also report frequency in the y-axis */
hist gdppc, frequency 
graph export eda_22.pdf, as(pdf) replace

/* to add a density curve in the histogram */
hist gdppc, kdensity
graph export eda_23.pdf, as(pdf) replace

/* to add a normal curve with the density curve */
hist gdppc, kdensity normal

/* we can add a title, and set the width and the color of the bin */
hist gdppc, fraction kdensity normal width(10000) ///
	title("Per Capita GDP") ///
	color(teal) 
graph export eda_24.pdf, as(pdf) replace

/* we can get histograms for gdppc for a group of countries in a single graph */
hist gdppc if country=="United States" | country=="United Kingdom" | country=="Germany" | country=="France", bin(10) by(country) ///
color(teal)
graph export eda_25.pdf, as(pdf) replace

/* we can create a twoway histogram, which is helpful to compare statistics for two groups or countries */
twoway hist gdppc if country=="United States", bin(10) || ///
    hist gdppc if country=="United Kingdom", bin(10) ///
    fcolor(none) lcolor(red) legend(label(1 "USA") label(2 "UK"))
graph export eda_26.pdf, as(pdf) replace

