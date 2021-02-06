************************************************************************
*** This is a do file to accompany the discussion on bivariate regression.  It uses an example of a hypothetical baseball player's statistics over 22 seasons.
***Data required: baseball.dta
***
************************************************************************
clear all
cd "C:\Users\mujta\Downloads\Stata-MP-16.0-20201020T175446Z-001\Stata-MP-16.0\files"
log using Afzal_S1_lab9, replace
use "baseball.dta"

* Produce a scatterplot of walks and bat_avg to "eyeball" a relationship.
twoway scatter walks bat_avg

twoway scatter walks bat_avg, xtitle("Batting Average") ytitle("Number of Walks")
*corelation
pwcorr  walks bat_avg, sig


* Run a regression of walks on batting average.  Since we are using batting average to predict the number of walks someone will have, we use the command 
* "regress" then our dependent variable, "walks" then our independent variable, "bat_avg".
set linesize 132
regress walks bat_avg

* Notice that we can interpret almost everything in this table.  First, we attempt some hypothesis tests.  Remember that our null hypothesis is always that
* beta = 0, or that the slope is zero. In other words, X has no effect on Y.  First, look at the 
* t-statistic.  In order for us to reject the null, the absolute value of the calculated t statistic (in the case of bat_avg, 4.89 must exceed the critical
* value.  We find the critical value with two pieces of information.  First, the degrees of freedom, which is the number of observations minus the number of 
* estimated parameters (n-k), or 22 - 2 (the intercept and the beta).  Second, we need the level of statistical significance.  Usually it is 95%, but we could
* also want more confidence and try 99%.  We look up in the back of the book to find a critical t statistic of 2.086.  Since abs(4.89) >= 2.086, we can reject
* the null at the 95% confidence level and conclude that batting average has a statistically significant effect on walks in the population.  Looking at the 
* p-values and confidence intervals gives us the same inference.  Since the p-value is lower than 0.05 (we could pick a different p-value, as long as it was 
* low), we can conclude that there is less than a 5% chance (.05) that the results we see here are due to random chance.  Moreover, since the 95% confidence
* interval does not include 0 (590 to 1467), we know that there is less than 5% chance that the true population beta = 0.  We can interpret the y-intercept 
* in the same manner.  The only difference is that the null is alpha = 0, or that the regression line passes through the origin (point 0,0).  Alternatively,
* it tests the null hypothesis that the value of Y = 0 when X = 0.  This is usually not too helpful.  The final thing we can look at is the R-squared statistic.
* This gives us the percentage of variation in the dependent variable (in this case, walks) that is explained by variation in the independent variable (in this
* case, batting average).  It ranges from 0 (meaning very little explanatory power, or goodness of fit) to 1 (meaning very high explanatory power).  So what
* makes a "good" R-squared?  It depends on what you are trying to find.  If you want a model that will predict Y the best, then you are looking for a high
* R-squared (close to 1).  If you are only concerned about seeing whether an X affects Y in the population, then you are less concerned with predictive power
* (and thus the size of the R-squared).  In these cases, you will probably be happy with a smaller R-squared.  

* Let's do that same scatterplot but with the regression line drawn on it.  The command for this is "lfit".  
twoway (scatter walks bat_avg) (lfit walks bat_avg), xtitle("Batting Average") ytitle("Number of Walks")

* Notice that neither the intercept nor the slope is easily seen on this figure.  This is because of the range of values for both.  For example, the x variable
* (batting average) ranges from 0.223 to 0.37.  Notice that it never increases by 1-unit, so interpreting the slope as "a 1-unit change" may be a little weird.
* Additionally, the intercept never actually crosses the y-axis.  In other words, we never actually see (in our sample) the value of walks when batting average
* equals zero.  Because the range of the X variable does not realistically include 0 or 1, we are getting weird predictions of our dependent variable.  For 
* example, a person with a batting average of 0 is expected to have -191 walks.  This is impossible.  Alternatively, a 1-unit increase in batting average
* would mean that a person has more hits than at-bats, which is impossible.  For a 1-unit increase in batting average, the number of walks increases by 
* 1029.  A more helpful activity is to calculate the predicted number of walks for a given batting average.  Remember that the formula for the predicted Y is:
* Yhat = alpha_hat + (beta_hat*X).  Let's calculate the predicted number of walks when the player has a batting average of 0.30.  Simply plug in the values:
* We will use the "display" command, which basically works as a calculator.

display -191.4333 + 1029.044*0.300

* Or, you can use the nifty returned values in Stata.  To get the coefficients (b) for each coefficient, type "_b" and the name of the coefficients in 
* brackets [].  In the case of batting average, we type "_b[bat_avg]".  We could access the standard error in that way too, by typing "_se[bat_avg]".
display _b[_cons] + (_b[bat_avg]*0.300)

* With a 0.300 batting average, our model predicts that the player will have about 117 walks.  To find out the predicted Y is for a different value of X, 
* simply change the value of X in the formula.

* Let's assume that our hypothetical baseball player is Barry Bonds.  Allegedly, he used steroids in the BALCO scandal from 2001-2003.  We will test
* whether his batting statistics were significantly improved during those three years.  To do so, we create a dummy variable named "balco" that is coded
* as 1 during the three years he "allegedly" took steroids (2001-2003), and 0 otherwise.  

* GENERATING DUMMY VARIABLES
* First, create the dummy variable.  We will generate a new variable called "balco" and will code it as 1 if the year is between 2001 and 2003.  Otherwise
* we'll code it at 0.  The "if" command let's me specify the years in which balco occurred.  The "&" means "and" and the "|" means "or".  
* Always check the variable in the data editor to make sure that it was created correctly.
generate balco = 1 if year>=2001 & year <=2003
*
replace balco = 0 if year<2001 | year>2003

* Let's create a Balco variable to measure a permanent structural change.
generate balco_2 = 1 if year>=2001
replace balco_2 = 0 if year<2001

* We could just as well generate the balco variable using the observation number in the data set.  Stata denotes this by _n.  First, we drop balco because
* we are going to generate it a different way.
drop balco
generate balco = 1 if _n>=16 & _n<=18
replace balco = 0 if _n<16 | _n>18

* If we had multiple categories of the variable, then we would have to generate multiple dummy variables.  Say we wanted to create a dummy variable
* for a specific state or country.  If we had the state name as a variable, called "state_name", we could use the following code: 
* generate Canada = 1 if state_name=="Canada"
* replace Canada = 0 if state_name~="Canada"
* We put Canada in quotes because it is a string variable.  

* We will first see if steroids helped batting average.
regress bat_avg balco

* Now, test for a permanent structural change by replacing the Balco (temporary) with the Balco_2 (permanent).
* This theorizes that he will have a higher batting average after taking steroids, even though the Balco scandal ended in 2003.
regress bat_avg balco_2

* This provides support for the temporary structural change, as not only is the coefficent for balco greater than balco_2, but also balco_2 is not 
* statistically significant at the 95% confidence level (because the p-value > 0.05).

* You now should be able to interpret most of this model.  Notice that the coefficient (slope) is about 0.06 and statistically significant.  Keep in mind
* the difference between statistical significance and substantive significance.  We know that it is statistically significant (because of t-statistic,
* p-value and confidence intervals), but is it substantively significant?  Does it produce a meaningful increase?  Maybe.  A 0.06 increase in a batting 
* average may not seem like much, but for some players it would help a lot.  This shows that you have to interpret the substantive significance as well
* as the statistical significance.  

* Now, we regress home runs on steroid usage.  Notice that the R-squared is 0.3367.  This means that 33.67% of the variance in home runs is directly
* explained by his "alleged" steroid usage.
regress hr balco

* Now, we regress the ratio of at bats per home run on steroid usage.  Remember to take into account the range of values for both the independent and 
* dependent variables.  In this case, a smaller value means fewer at bats needed before he hits a home run.  In this case, we would hypothesize a negative
* relationship (as balco goes up, at bats per home run decrease).  
regress hr_ab balco

* PREDICTED VALUES
* We can easily predict how many at bats per home run Bonds had when on steroids and not on steroids.  Remember the formula: Yhat = alpha_hat + beta_hat*X

* When not on steroids (balco = 0)
display 15.37895 + (-7.378947*0)

* When on steroids (balco = 1)
display 15.37895 + (-7.378947*1)

* Using the returned values commands:
display _b[_cons] + (_b[balco]*0)

display _b[_cons] + (_b[balco]*1)

* When on steroids, Bonds will only take about 8 at bats to hit a home run--when not on steroids, it takes him about 15 at bats to hit a home run.  Notice
* that the difference between these two predicted values (about -7.4) is also the coefficient for balco.  This is only the case in a bivariate regression
* when the independent variable is a dummy variable.  

* If we had multiple independent variables in our model, we would use the same sort of concept.  The only difference is that we would have to include 
* the coeffiicents for each of the IVs, in addition to the values that we're holding them to.  In this regression, we regress at bats per home run
* on our balco dummy variable, weight, age and on base percentage.
regress hr_ab balco  wt age on_base_pct

* Let's calculate the predicted value of at bats per home run if he is on steroids (balco=1), he is 30 (age=30), he weighs 230 lbs (wt=230), and his 
* on base percentage is 0.500 (on_base_pct=.500).  First, let's input the values ourselves.
display 3.369523 + (-4.742798*1) + (-1.350804*30) + (0.3131048*230) + (-22.20459*0.500)

* Now, let's use the easier way.  The model predicts that, given the scenario we specified, that he will hit 1 home run every 19 at bats.
display _b[_cons] + (_b[balco]*1) + (_b[age]*30) + (_b[wt]*230) + (_b[on_base_pct]*0.500)

* For the second scenario, we will assume a younger, lighter and less steroid-y Barry Bonds.  This predicts 1 home run every 25 at bats.  
display _b[_cons] + (_b[balco]*0) + (_b[age]*20) + (_b[wt]*190) + (_b[on_base_pct]*0.500)




