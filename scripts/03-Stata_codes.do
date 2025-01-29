
//do-file for "Introduction to Statistics in Stata"
cd "~/AppliedDataAnalysisForPublicPolicy/scripts"

*Univariate descriptive statistics 

/* open stata-installed data */
sysuse nlsw88, clear

/* basic summary statistics */
summarize wage hours

/* detailed statistics with percentiles */
summarize wage, detail

/*open stata-installed data*/
sysuse nlsw88, clear


/* frequency table for categorical variables */
tabulate race
tabulate industry, sort

/* percentiles and quartiles */
centile wage, centile(25 50 75)

/* histogram for wage */
histogram wage, bin(20) normal


/* test for skewness and kurtosis */
sktest wage

/* boxplot for wage */
graph box wage


/*back to using the workout1 dataset*/

use datasets/workout1,clear
encode v07, gen(v07_num) //turns v07 into numeric
/*shows frequency distributions*/
tab v07_num
fre v07_num
hist v07_num, discrete percent addlabel xlabel(1/2, valuelabel noticks)
graph pie, over(v07_num) plabel(_all percent)


/*open a stata-installed dataset*/
sysuse auto,clear

/*summary statistics*/
sum price
sum price, d
mean price
tabstat price weight length, stats(mean sd range count) by(foreign)
tabstat price weight length, stats(mean sd range count) by(foreign) col(stats) nototal
tab foreign rep78, sum(mpg) 



*Bivariate inferential statistics
/*correlation analysis*/
pwcorr wage ttl_exp, star(0.05) obs
corr wage ttl_exp

/*independent t-test*/
ttest wage, by(collgrad)
ttest wage, by(collgrad) unequal
sdtest wage, by(collgrad)

/*anova*/
tab race, sum(wage)
anova wage race

/*pairwise comparisons*/
pwcompare race, pveffects

/*chi-square test*/
tab union collgrad, col chi2
