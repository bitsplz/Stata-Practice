
********CODE LAB  3: this do file is about tests for single variables
* Use the gss data as before (from Lab2)

clear all 
cd "C:\Users\mujta\Downloads\Stata-MP-16.0-20201020T175446Z-001\Stata-MP-16.0\files"
log using Afzal_S1_lab8, replace
use "gss2002" 

*			***Task1: testing mean hypothesis: sinlgle t test
* I am curious about the number of hours 
* people watch TV. A study says that the average citizen watches 2 hours of TV
* I want to see if this is true given this data 

*Variable: tvhours

***Task 1. Estimate the population mean 
mean tvhours


*Q. what abour the median? 
tab tvhours
*check skew
hist tvhours
*** Task 2. Test whether our estimate is statistically significant, given the above information (are the other studies right?)
	*Note: for a single mean t test,the null hypothesis assumes that the the comaprison value and popualiton mean are same 
	* Alternative assumes they are different

*Q: Write down the null and alt hypotheses
*Ho:mean=2
*Ha:mean!=2
* Q. Can you make a statement about the above WITHOUT using a test?

mean tvhours 
*see confidence itnervals 
ci means tvhours


* Ok- now testing 
ttest tvhours =2 
*changing ci level
ttest tvhours =2,level(90)
* what is different? 
	*interpreting Ha < 2 (left tail test)
	*If the population mean is 2, then the probability of drawing a sample 
	*with a mean of 2.98 or less, given the number of observations we have and 
	*the standard deviation we observe, is 1 (i.e. it is very very likely). 
	* can not reject the null in favor of Ha
	*In other words, if the true mean is 2, we can be pretty sure we will observe this sample mean 
	*i.e. the mean is 2 rather than less than 2

	
		*interpreting Ha > 2 (right tail test)
	*If the population mean is 2, then the probability of drawing a sample 
	*with a mean of 2.98 or more, given the number of observations we have and 
	*the standard deviation we observe, is 0 (i.e. it is very very onlikely). 
	* can reject the null in favor of Ha
     * i.e. the mean is > 2 rather than 2 (different from hypothesised value)
	 
*Q Interpret two tailed test  	 

***************************************
**Task 3: Figure out whats going on
hist tvhours
**can you make this variable continuous? 
*Q generate log of the variable 
*Q get rid of outliers (just a demonstration 

	**lets try something 
	** generate a new variable that is the log of tvhours 
gen log_tv=log(tvhours)	
**try this: 
hist log_tv
ttest log_tv =1

gen tvhours2 = .
replace tvhours2 = tvhours if tvhours <= 5
tab tvhours2
mean tvhours2
*mean goes down as outliers eliminated directly
sum tvhours2
*see the kurtosis + skewness 
ttest tvhours2 =2

***Confidence itnervals: mean
ci means tvhours 
ci means tvhours2

***test of sig: proporiton needs to be categorical
*for a BINARY variable
* what is the proportion of hispanic respondents 
proportion hispanic

*check if its binary
tab hispanic
*********************************************************
*********************************************************
				*Label lessom (this is for aesthetics - not Stats) 

*are these labels or values....
*look at the data browser (click on it)
help label

		**understand two kinds of labels- variable and values
				tab tvhours2
				*give this a label- no.of tv hr (variable label)
				label variable tvhours2 "no. of tv hrs"
				*I want to give  the 1 to 5 numbers values
				*STEP 1: define value label and call it something
				*YOU NEED TO COMPELTE THIS CODE
				label define foo 0 "freaky" 1 "good" 2 "ok.." 3 "too much" 4"no.." 5 "get a job"
				*Step 2: attach the above to the var
				label values tvhours2 foo  
				*check
				des tvhours2
label list foo
des compuse
label list COMPUSE
**back to class
*see value label and variable label
label list hispanic 
des hispanic
*^  does not work because it needs the variable label not name
label list HISPANIC
				* test:
prtest hispanic=0.25

***ok this was easy, but another one
*Q. Friend says most people end up being Aries, like 40 percent. Test this
*what is different? 
tab zodiac
*null hypothesised
*Ho: Pi/Prop=0.4
*Ha: Pi/Prop<0.4
prtest zodiac =0.4
*^gives error
*what to do?
*generate a bianry variable for Aries
gen Aries=.
replace Aries =0 if zodiac==1
replace Aries =1 if zodiac>1
tab Aries
**Awesome 
				*Q can you give 0 and 1 value labels yes and no?
				label variable Aries "Is the person's zodiac Aries"
				label define foo2 0 "No" 1 "Yes"
				*Step 2: attach the above to the var
				label values Aries foo2  
				*check
				des Aries
				label list foo2
				**now you can do proportion test
prtest Aries=0.04


***Confidence itnervals: proporiton

*for a BINARY variable
* what is the proportion of hispanic respondents 
proportion hispanic
* for more than two categories
proportion zodiac

*****VISUALIZATION 

* We can change the number of bins with the "bin(#)" option.  
* To produce fewer bins, type "bin(10)"
histogram age, bin(20)

* To produce a kernel density plot, which is a way of looking 
* at a smoothed version of the histogram, use the "twoway 
* kdensity" command.
* is this a normally distributed variable? See the distribution
twoway kdensity zodiac
twoway kdensity tvhours
* To add titles to the graph, we use the title(""), 
* xtitle(""), and ytitle("").  
twoway kdensity age, title("Kernel Density Plot of Age") xtitle("Age of Person") ytitle("Density")

* We can also examine the rank statistics with a box-whisker 
* plot.  The command for this is "graph box" and then the 
* variable name, "age".
* This tells us where the median, 25%, 75%, 1% and 99% 
* percentiles are.  Since there are no additional dots, there 
* are no values below the 1st and 99th.
* see the positive skew? The bigger 'whisker' on top
graph box age
graph box tvhours
* to produce multiple box-whisker plots on one graph 
* (for the different values of zodiac), use the over option.
graph box age, over(tvhours) 

* to rename a variable, use the "rename" command.  Let's say 
* the old variable name is zodiac and you want to change it to 
* "sign"
rename zodiac sign

* if you wanted to change the label of the variable, use the 
* "label var" command.  Simply put the "label var" then the 
* name of the variable,
* and then whatever you want to change the label to.  
label var age "Age of the Respondent"

******************************************
*** bivariate hypothesis tests (comparing between groups) : difference of means test 
******************************************
****Difference of means for two groups: (DV= qual, IV= quant 
* grass
* cont var: age
tab age grass
**hmmmm
*just looking 
graph box age, over(grass) 
* We're expecting that there will be a statistically significant difference in support for legalizaiton between young and old 
*Bad ideas: 
tab age grass
tab grass age
*ttest:
ttest age, by(grass)
* this command shows the means and variances for each group (young and old).   
* It is important to note that the null hypothesis is that the difference between these groups is equal to zero, or that there is 
* no difference in age for support of legalizaiton.  It tests three different alternative hypotheses.  



* Do this for at least two other varibales of your choice (keep age)



*proportions groups

*for variables (both binary):
prtest hispanic=born
*****ARGH
****how do I check this? 


*****fix 
gen born2= born
replace born2 =0 if born==2
replace born2 =1 if born==1
tab born2
*do the test now
prtest hispanic=born2

***for sub smaples (within a variable(
* are hispanic Rs more likely to be born outside?
*DV: Born outside, IV = hispanic 
*what are the two proportions you are comparing? 
**some way to see this?
*(IV DV)
 tab hispanic born2, col

 *Test: 
*seeing if there is a difference between born IN COUNTRY for hispanic and non hispanic 
prtest born2, by(hispanic)
*alt hyp1: hispanic who are born in country prop is > non-hispanic born in country
* alt 3: non-hispanic born in country > hispanic born in country 

*(try reversing to see)
***this is messy- come back to this later 

log close 
**(next up: lab4v1) 

