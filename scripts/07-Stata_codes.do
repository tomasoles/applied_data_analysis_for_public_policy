//do-file for "Multiple regression"
cd "~/AppliedDataAnalysisForPublicPolicy/scripts"

use datasets/present.dta,clear 

//set cformat %9.1f
//set sformat %7.4f
//set pformat %4.3f

reg Present_Value Attractiveness Kindness Age // estimates the multiple regression
reg Present_Value Attractiveness Kindness Age, beta // "beta" asks for fully standardised coefficients

egen z_Present_Value = std(Present_Value) //standardises "Present_Value"
egen z_Attractiveness = std(Attractiveness) //standardises "Attractiveness"
egen z_Kindness = std(Kindness) //standardises "Kindness"
egen z_Age = std(Age) //standardises "Age" 

reg z_Present_Value z_Attractiveness z_Kindness z_Age //estimates the model with standardised variables
test z_Attractiveness = z_Kindness //compares equality of two standardised coefficients
test z_Attractiveness = z_Age //compares equality of two standardised coefficients
test z_Kindness = z_Age //compares equality of two standardised coefficients

pcorr Present_Value Attractiveness Kindness Age //provides semipartial corr squared 

/*to obtain semipartial corr squared and some other useful statistics, you can
also use the following*/
reg Present_Value Attractiveness Kindness Age // estimates the multiple regression
ssc install regcoef // to install the user-written package
regcoef //developed by Mehmetoglu (one of the authors)

reg  Present_Value Attractiveness Kindness Age, level(90) //to obtain 90% CI for the coefficients

reg Present_Value Attractiveness Kindness Age // estimates the multiple regression 
margins, at(Attractiveness=7 Kindness=7 Age=50) //computes predicted mean-Y at chosen values

reg Present_Value Attractiveness Kindness Age // estimates the multiple regression
margins, at(Attractiveness=(1(1)7)) atmeans // computes predicted mean-Y at different values of Attractivenees while setting the mean for the remaning predictors

/*run all of the below to present the regression results publication-ready table*/   
reg Present_Value Attractiveness Kindness Age
estimates store my_regression
estadd beta 
esttab my_regression, title (Regression Model) nonumber ///
  mlabel(Results) ///
  cells(b(star fmt(2)) ci(par) beta(par))  ///
  stats(N p r2 r2_a rmse, ///
      labels("Number of observations" ///
      "Model significance" "R-square" ///
      "Adjusted R-square" "Residual standard deviation")) ///
  varwidth(30) legend 

/*to export it to word, you slightly modify the above coding as follows*/ 
reg Present_Value Attractiveness Kindness Age
estimates store my_regression
estadd beta 
esttab using my_regression.rtf , title (Regression Model) nonumber ///
  mlabel(Results) ///
  cells(b(star fmt(2)) ci(par) beta(par))  ///
  stats(N p r2 r2_a rmse, ///
      labels("Number of observations" ///
      "Model significance" "R-square" ///
      "Adjusted R-square" "Residual standard deviation")) ///
  varwidth(30) legend 





 
