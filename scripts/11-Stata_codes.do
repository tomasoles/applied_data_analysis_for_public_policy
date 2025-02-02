//do-file for "Transformations and Influential observations"
cd "~/AppliedDataAnalysisForPublicPolicy/scripts/datasets"

* Load the dataset
use Critical_issues.dta, clear

* Plot a histogram of GDP per capita with a normal curve overlay
histogram GDPperCapita, normal

* Summarize GDP per capita with detailed statistics
summarize GDPperCapita, detail

* Generate graphical ladder plots for transformation suggestions
gladder GDPperCapita

* Generate transformations to reduce skewness
* Squaring GDP per capita to reduce negative skew
generate transformedGDP = GDPperCapita^2

* Inverting GDP per capita to reduce positive skew
generate transformedGDP = GDPperCapita^-1

* Log-transform GDP per capita to reduce positive skew
generate lnGDP = ln(GDPperCapita)
summarize lnGDP, detail

* Generate natural log transformation of Foreign Direct Investment (FDI)
* Add a constant to handle negative values
generate FDItest = FDI + 84662791823
generate lnFDI = ln(FDItest)

* Reverse transformation for negatively skewed FDI
* Ensure smallest value becomes 1 before log transformation
generate FDIreverse = 340065000001 - FDI

* Log-transform the reversed FDI variable
generate lnFDIreverse = ln(FDIreverse)

* Compare transformations using graphical methods
gladder GDPperCapita

* Perform an OLS regression of GDP per capita on log-transformed FDI
regress GDPperCapita lnFDI

* Predict fitted values from the OLS regression
predict GDPhat1

* Label the fitted value variable
label variable GDPhat1 "OLS regression"

* Generate and plot residuals
predict res, residual
histogram res

* Check for heteroscedasticity using a residual-versus-fitted plot
rvfplot

* Identify influential observations using a scatter plot with fitted line
graph twoway (scatter GDPperCapita lnFDI, mlabel(ccode)) (lfit GDPperCapita lnFDI, mlabel(ccode))

* Calculate Cook's distance for identifying influential observations
predict cooksd, cooksd
sort cooksd
browse ccode cooksd

* Perform robust regression to mitigate outlier effects
rreg GDPperCapita lnFDI

* Predict fitted values from the robust regression
predict GDPhat2

* Label the fitted value variable
label variable GDPhat2 "robust regression"

* Compare OLS and robust regression fitted values graphically
graph twoway scatter GDPperCapita GDPhat1 GDPhat2 lnFDI, mlabel(ccode)


