//do-file for "Regression diagnostics"
cd "~/AppliedDataAnalysisForPublicPolicy/scripts"

//use datasets/ESS5GBdiagnostics.dta


// Model assumptions
quietly regress trstlgl age woman political_interest religious
linktest															// linktest for specification error

quietly regress trstlgl age woman political_interest religious
estat ovtest																// ovtest for omitted variables

// Curvilinearity
lowess trstlgl age, nograph gen(yhatlowess)							// predicts value of regression
line yhatlowess age, sort											// graph bivariate relationship

regress trstlgl c.age##c.age woman political_interest religious		// regression including squared term

margins, at(age=(15(1)98))
marginsplot, noci													// marginsplot

regress trstlgl c.age##c.age##i.woman political_interest religious		// regression including squared term and interaction effect

margins, at (age=(15(1)98) woman=(0 1))
marginsplot, noci													// marginsplot


lowess happy age, nograph gen(yhatlowess2)							// predicts value of regression
line yhatlowess2 age, sort 											// graph bivariate relationship

regress happy c.age##c.age##c.age woman political_interest religious leftright		//curvilinear effect with two bends

margins, at(age=(15(1)98))
marginsplot, noci													// marginsplot

// Curvilinearity and dummy variables
regress edagegb woman religious leftright

regress edagegb woman religious c.lrscale##c.lrscale
margins, at(lrscale=(0(1)10))
marginsplot, noci

generate Dleft = (lrscale < 3) if !missing(lrscale)
generate Dcentre = (lrscale > 2 & lrscale < 8) if !missing(lrscale)
generate Dright = (lrscale > 7) if !missing(lrscale)

regress edagegb woman religious Dleft Dright 


//Multicollienarity
quietly regress trstlgl age woman political_interest religious
estat vif																	// variance inflation factor and tolarance
estat vce																	// variance-covariance matrix


//Homoskedasticity

quietly regress trstlgl age woman political_interest religious
rvfplot																// produces plot of teh predicted values versus the residuals
estat hettest																// Breusch-Pagan / Cook-Weisberg test for heteroskedasticity


//Uncorrelated errors
//use datasets/Durbin_Watson.dta

tsset year															// time-sets the data	
regress FDI GDPperCapita GDPGrowth incidence
estat dwatson														// produces Durbin-Watson statistic


//Robust regression 
//use datasets/Robust_regression.dta

regress GDPperCapita lnFDI				//OLS regression
predict GDPhat1							//saving predicted values from OLS regression
label variable GDPhat1 "OLS regression" 
predict res, residual					//predicting residuals from OLS regression
hist res								//histogram of residuals
rvfplot									//produces rvfplot to check for heteroskedasticity 
graph twoway (scatter GDPperCapita lnFDI, mlabel(ccode)) (lfit GDPperCapita lnFDI, mlabel(ccode))		//graphing linear relationship, including country labels
predict cooksd, cooksd
sort cooksd
browse ccode cooksd						//investigating Cook's distance values

rreg GDPperCapita lnFDI					//robust regression

predict GDPhat2							//saving predicted values from robust regression
label variable GDPhat2 "robust regression"
graph twoway scatter GDPperCapita GDPhat1 GDPhat2 lnFDI, mlabel(ccode)		//graphing OLS- and robust regression lines


//Uncorrelated errors
//use datasets/Durbin_Watson.dta 

tsset year												//time sets the data
quietly regress FDI GDPperCapita GDPGrowth incidence 
estat dwatson											//Durbin-Watson test for autocorrelation


//Normally distributed errors
//use datasets/ESS5GBdiagnostics.dta

quietly regress trstlgl age woman political_interest religious
predict res, residual												// saves residuals as a variable

hist res, normal													// histogram of residuals, displaying normal curve
summarize res, detail
sktest res															// skewness/kurtosis test for normality


//Influential observations
//use Influential_units.dta

quietly regress lnFDI GDPperCapita GDPGrowth incidence ethfrac
predict h if e(sample), hat											// saves hat statistic as a variable
graph box h, mark (1, mlab(ccode))									// produces box plot of hat statistic, labeling cases


regress lnFDI GDPperCapita GDPGrowth incidence ethfrac
regress lnFDI GDPperCapita GDPGrowth incidence ethfrac if ccode!="NOR"	// regression excluding potentially influential observation


quietly regress lnFDI GDPperCapita GDPGrowth incidence ethfrac
dfbeta GDPperCapita GDPGrowth incidence ethfrac						// saves DFBETA values as variables
graph box _dfbeta_1 _dfbeta_2 _dfbeta_3 _dfbeta_4, marker(1, mlab(ccode)) marker(2, mlab(ccode)) marker(3, mlab(ccode)) marker(4, mlab(ccode))  // produces box plot of DFBETA statistic, labeling cases

quietly regress lnFDI GDPperCapita GDPGrowth incidence ethfrac
predict cooksd if e(sample), cooksd									// saves Cook's distance as a variable
graph box cooksd, mark(1, mlab(ccode))								// produces box plot of Cook's D, labeling cases
browse ccode cooksd if cooksd > 0.029 & e(sample)					// lets you inspect influential cases


//Regcheck
//use datasets/ESS5GBdiagnostics 
ssc install regcheck												// installs the regcheck programme
quietly regress trstlgl age woman political_interest religious
regcheck															// runs regcheck





